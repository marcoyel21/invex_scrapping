#!/bin/bash

################################
#      II. List URLS       #
################################

# In the same fashion i create the lists of pdfs to extract

declare -a ListaPDFS=(

"https://invex.com/getmedia/4f76e237-58a1-40af-bfff-d7645993ba00/IM_INVEXCP?ext=.pdf",
"https://invex.com/getmedia/ce22da94-7252-45ad-98b9-8f686906127b/IM_INVEXMP?ext=.pdf",
"https://invex.com/getmedia/b1901ad2-1de6-4eb9-863a-f5cafd2e1a9c/IM_INVEXLP?ext=.pdf",

"https://invex.com/getmedia/be362fe0-23e2-4bc5-8fa1-a4765801b198/IM_INVEXMX?ext=.pdf",
"https://invex.com/getmedia/3d677327-1aa4-4ce8-90d3-fb03a027ee54/IM_INVEXTK?ext=.pdf",
"https://invex.com/getmedia/2c962bdb-f49c-4731-817b-c6197c5739f2/IM_INVEXCR?ext=.pdf",
"https://invex.com/getmedia/37db7fc7-d1c1-46fc-adc1-1b9846dc5aa3/IM_INVEXIN?ext=.pdf",

"https://invex.com/getmedia/3c78226f-59d5-41da-ae44-17a94b872c77/IM_INVEXCO?ext=.pdf")

################################
#      III. Extraccion         #
################################

for val in ${ListaPDFS[@]}; do


## I extract the pdf from the web

curl -o sourcedoc.pdf $val


## Then i extract the content of the pdf file and send it to a file

pdftotext -layout sourcedoc.pdf file.txt


##  Then i hunt the exact data

# Name of the fund
sed -n '1p' file.txt | grep -Po '[A-Z]*'  >> carteras_invex_m.txt

# Month and year
sed -n '4p' file.txt | grep -Po '[0-9].*' >> carteras_invex_m.txt

# Rating
sed -n '5p' file.txt  | grep -q "CALI" && (sed -n '5p' file.txt  | grep -Po 'CALIFICACION: \K.*' >> carteras_invex_m.txt ) || (echo "sin_calif" >> carteras_invex_m.txt)

# Total value
grep -v -e '^$' file.txt | tail -n 20| sed -n -e '/CARTERA TOTAL/,/Valor en Riesgo/ p; /Valor en Riesgo/q'|head -n 3 | grep -Po 'CARTERA TOTAL: *\K[0-9].* ' >> carteras_invex_m.txt

#e Var stablished
grep -v -e '^$' file.txt | tail -n 20| sed -n -e '/CARTERA TOTAL/,/Valor en Riesgo/ p; /Valor en Riesgo/q'|head -n 3 | grep -Po 'ESTABLECIDO: *\K[0-9].*' | sed 's/ //g' >> carteras_invex_m.txt

# Vas average
grep -v -e '^$' file.txt | tail -n 20| sed -n -e '/CARTERA TOTAL/,/Valor en Riesgo/ p; /Valor en Riesgo/q'|head -n 3 | grep -Po 'OBSERVADO PROMEDIO: *\K[0-9].*' | sed 's/ //g' >> carteras_invex_m.txt

################################
#      IV. Saving.            #
################################
done

cat carteras_invex_m.txt | awk '{print}' ORS=' '|  tr -s ' '| xargs -n 6 > carteras_invex_mensual.txt
rm carteras_invex_m.txt






