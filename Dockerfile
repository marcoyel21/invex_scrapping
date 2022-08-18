
########################
# PART 1: Environment.##
########################
# First of all i need to use an Ubuntu machine with a copy of all the scripts i made.
#Ubuntu libraries
FROM ubuntu:20.04
COPY . scrappers

# Then i need to add the 2 libraries im using: proppler and curl
RUN apt update && apt upgrade -y
RUN apt-get install sudo
RUN sudo apt-get install -y poppler-utils
RUN sudo apt-get install -y curl

# Then i need Python installed
# Note: its easier to integrate python scripts in production environment than R scripts due to the stability, lightness and ease to use of the python lenguage.
RUN apt install -y python3.9
RUN apt install -y python3-pip
# Then i install the python requirements
RUN pip3 install -r scrappers/scripts/requirements_py.txt

#######################
# PARTE 2: SCRAPPERS.##
#######################

# Extraction

WORKDIR ../scrappers/scripts

# I need to make each sh script executable
# Weekly
RUN chmod +x requirements_sem.sh
RUN chmod +x composicion_carteras_sem.sh
RUN chmod +x total_carteras_sem.sh
# Monthly
RUN chmod +x requirements_mensual.sh
RUN chmod +x composicion_carteras_mensual.sh
RUN chmod +x total_carteras_mensual.sh

# Scrappers requirements (URLS and context information)
RUN ./requirements_sem.sh
RUN ./requirements_mensual.sh

############################
# PARTE 3: CMD Executable. ##
############################

# Then i use the command CMD that indicates that when this container is invoqued it will run the script.py unless you assign other command.

CMD python3 script.py


