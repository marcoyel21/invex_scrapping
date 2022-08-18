#!/bin/bash

################################
#      II. List URLS          #
################################

# I create the lists of pdfs to extract

declare -a ListaPDFS=(

"https://invex.com/getmedia/4f76e237-58a1-40af-bfff-d7645993ba00/IM_INVEXCP?ext=.pdf",
"https://invex.com/getmedia/ce22da94-7252-45ad-98b9-8f686906127b/IM_INVEXMP?ext=.pdf",
"https://invex.com/getmedia/b1901ad2-1de6-4eb9-863a-f5cafd2e1a9c/IM_INVEXLP?ext=.pdf",

"https://invex.com/getmedia/be362fe0-23e2-4bc5-8fa1-a4765801b198/IM_INVEXMX?ext=.pdf",
"https://invex.com/getmedia/3d677327-1aa4-4ce8-90d3-fb03a027ee54/IM_INVEXTK?ext=.pdf",
"https://invex.com/getmedia/c384ef45-2fa9-403d-a3f5-17bced9e5a90/CARSEM_INVEXTK?ext=.pdf",
"https://invex.com/getmedia/2c962bdb-f49c-4731-817b-c6197c5739f2/IM_INVEXCR?ext=.pdf",
"https://invex.com/getmedia/37db7fc7-d1c1-46fc-adc1-1b9846dc5aa3/IM_INVEXIN?ext=.pdf",

"https://invex.com/getmedia/3c78226f-59d5-41da-ae44-17a94b872c77/IM_INVEXCO?ext=.pdf")

################################
#      III. Extraccion         #
################################

for val in ${ListaPDFS[@]}; do


## I extract the pdf from the web

curl -o sourcedoc.pdf $val


## Then i extract the content of the pdf and send it to file.txt

pdftotext -layout sourcedoc.pdf file.txt


## Then i will extract exact data with the use of regular expressions.
## Lets call this data hunting

# Fund name hunting
name=$(sed -n '1p' file.txt | grep -Po '[A-Z]*')

# Month and year hunting
date=$(sed -n '4p' file.txt | grep -Po '[0-9].*')

# Then i create a line with date and name
c="${name}   ${date}"

# Then i hunt the lines that start with the fund series,  this way im gathering all the data
grep -v -e '^$' file.txt | grep -P '^ *[A-Z0-9]{1,2} ' | awk -v prefix="$c" '{print prefix $0}' |  tr -s ' ' >> composicion_invex_m.txt

done

################################
#      III. Dump the data          #
################################

# Finally i send the data to a file i created.

cat composicion_invex_m.txt |  tr -s ' ' > composicion_invex_mensual_preliminar.txt
rm composicion_invex_m.txt
cat  composicion_invex_mensual_preliminar.txt | grep -P '.*[[:space:]].*[[:space:]].*[[:space:]].*[[:space:]].*[[:space:]].*[[:space:]].*[[:space:]].*'> composicion_invex_mensual.txt
rm composicion_invex_mensual_preliminar.txt

