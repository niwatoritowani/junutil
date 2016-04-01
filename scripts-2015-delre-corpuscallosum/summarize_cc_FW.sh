#!/bin/bash

# summarize measured diffusion value table into a file
# usage : $0

# todo
# - the items in the first row of the output file shoud be more shorter

base=/projects/schiz/3Tprojects/2015-delre-corpuscallosum
source ${base}/scripts/SetUpData.sh
[ -d ${base}/stats ] || mkdir ${base}/stats

echo "caselist : ${caselist}"
cases=($(cat ${caselist}))
echo "cases: ${cases[@]}"
caseid=${cases}
source ${base}/scripts/SetUpData.sh
echo "output file : ${cc_FW_summary}"
echo "output table header from : ${cc_FW_measured}"

line=$(head -n 1 ${cc_FW_measured} | tail -n 1 )    # output the 1st line
items=($(echo "${line}"))    # substitute as an array
items=(${items[@]##*/})    # delete directory
items=(${items[@]#*${caseid}-})    # delete case id
line=$(echo "${items[*]}" | tr ' ' '\t')    # output separated by tab
echo -e "tract\t${line}" > ${cc_FW_summary}
echo -e "the 1st raw : tract\t${line}" 

line=$(head -n 2 ${cc_FW_measured} | tail -n 1)
echo -e "caseid\t${line}" >> ${cc_FW_summary}
echo -e "the 2nd row : caseid\t${line}"

for caseid in ${cases[@]}; do
    source ${base}/scripts/SetUpData.sh
    line=$(head -n 3  ${cc_FW_measured} | tail -n 1)
    echo -e "${caseid}\t${line}" >> ${cc_FW_summary}
#    echo -e "data row : ${caseid}\t${line}"
done
