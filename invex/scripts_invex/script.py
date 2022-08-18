########### PART I ####
# Execute bash scripts
########################
import subprocess
subprocess.call(['sh', './requirements_sem.sh'])
subprocess.call(['./composicion_carteras_sem.sh'], shell=True)
subprocess.call(['./total_carteras_sem.sh'], shell=True)

subprocess.call(['sh', './requirements_mensual.sh'])
subprocess.call(['./composicion_carteras_mensual.sh'], shell=True)
subprocess.call(['./total_carteras_mensual.sh'], shell=True)


########### PART II ####
# Reading the data the scrappers produced
########################
import pandas as pd
from datetime import datetime


### Read the data as csv
# with the headers im assigning
header1=['asset_key','publication_date','rating','total_portfolio','var_fixed','var_avg']
header2=['asset_key','publication_date','value_type','issuer','serie','rating','market_import','percentage']

summary_montly = pd.read_csv('carteras_invex_mensual.txt', sep=" ", names=header1,decimal=',')
summary_weekly = pd.read_csv('carteras_invex_sem.txt', sep=" ", names=header1,decimal=',')
holdings_montly = pd.read_csv('composicion_invex_mensual.txt', sep=" ", names=header2,decimal=',')
holdings_weekly = pd.read_csv('composicion_invex_sem.txt', sep=" ", names=header2,decimal=',')

### Add an id column 
holdings_montly["id"]=holdings_montly["asset_key"]+holdings_montly["issuer"]+holdings_montly["serie"]+holdings_montly["publication_date"]+holdings_montly["percentage"]
holdings_weekly["id"]=holdings_weekly["asset_key"]+holdings_weekly["issuer"]+holdings_weekly["serie"]+holdings_weekly["publication_date"]+holdings_montly["percentage"]

summary_montly["id"]=summary_montly["asset_key"]+summary_montly["publication_date"]
summary_weekly["id"]=summary_weekly["asset_key"]+summary_weekly["publication_date"]



########### PART III ####
# Data transformation
########################

def date_convert(date_to_convert):
     return datetime.strptime(date_to_convert, '%d/%m/%Y').strftime('%Y-%m-%d')   
def wallet_cleaner(df):
    df["total_portfolio"]=df["total_portfolio"].replace(',','', regex=True)
    df["var_fixed"]=df["var_fixed"].replace('%','', regex=True)
    df["var_avg"]=df["var_avg"].replace('%','', regex=True)
    df['publication_date'] = df['publication_date'].apply(date_convert)
    df=df.drop_duplicates()
    return df 

def composition_cleaner(df):
    df["market_import"]=df["market_import"].replace(',','', regex=True)
    df["percentage"]=df["percentage"].replace('%','', regex=True)
    df['publication_date'] = df['publication_date'].apply(date_convert)
    df=df.drop_duplicates()

    return df 
    
summary_montly=wallet_cleaner(summary_montly)
summary_weekly=wallet_cleaner(summary_weekly)
holdings_montly=composition_cleaner(holdings_montly)
holdings_weekly=composition_cleaner(holdings_weekly)


########### PART IV ####
# Conection with the DB
########################
import yaml
config_file = open('config.yaml', 'r')
config = yaml.safe_load(config_file)


#Connection
import mysql.connector
client = mysql.connector.connect(**config['connection'])
cursor = client.cursor()

########### PART IV ####
# CREATE DATABASE and TABLES
########################

#### Create DB and Tables

with open('sql/create_db.sql') as ddl:
    cursor.execute(ddl.read())
with open('sql/create_portfolio_summary_weekly.sql') as ddl:
    cursor.execute(ddl.read())
with open('sql/create_portfolio_summary_monthly.sql') as ddl:
    cursor.execute(ddl.read())
with open('sql/create_portfolio_holdings_weekly.sql') as ddl:
    cursor.execute(ddl.read())
with open('sql/create_portfolio_holdings_monthly.sql') as ddl:
    cursor.execute(ddl.read())


########### PART IV ####
# UPLOAD TABLES
########################

# Then i created some methods to upload the entries one by one in order to reduce errors.

def list_of_tuples(df):
    
    all_values = []
    
    for k in range(df.shape[0]):
        temp = df.iloc[k]
        temp = temp.astype(str)
        temp = tuple(temp)
        all_values.append(temp)
        
    return all_values

values1 = list_of_tuples(summary_weekly)
for value in values1:
    with open('sql/insert_portfolio_summary_weekly.sql') as dml:
        try:
            cursor.execute(dml.read(), value)
            dml.close()
        except mysql.connector.IntegrityError as err:
            print("Something went wrong: {insert_portfolio_summary_montly failed}".format(err))
            dml.close()
            pass

values2 = list_of_tuples(summary_montly)
for value in values2:
    with open('sql/insert_portfolio_summary_monthly.sql') as dml:
        try:
            cursor.execute(dml.read(), value)
            dml.close()
        except mysql.connector.IntegrityError as err:
            print("Something went wrong: {insert_portfolio_summary_montly failed}".format(err))
            dml.close()
            pass
        
values3 = list_of_tuples(holdings_weekly)
for value in values3:
    with open('sql/insert_portfolio_holdings_weekly.sql') as dml:
        try:
            cursor.execute(dml.read(), value)
            dml.close()
        except mysql.connector.IntegrityError as err:
            print("Something went wrong: {insert_portfolio_holdings_weekly failed}".format(err))
            dml.close()
            pass

values4 = list_of_tuples(holdings_montly)

for value in values4:
    with open('sql/insert_portfolio_holdings_monthly.sql') as dml:
        try:
            cursor.execute(dml.read(), value)
            dml.close()
        except mysql.connector.IntegrityError as err:
            print("Something went wrong: {insert_portfolio_holdings_monthly failed}".format(err))
            dml.close()
            pass

client.commit()
