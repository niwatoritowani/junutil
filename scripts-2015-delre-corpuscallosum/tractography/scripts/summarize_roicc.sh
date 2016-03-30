#!/bin/bash

base=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/2015-delre-corpuscallosum
source ${base}/SetUp.sh

echo "caselist : ${caselist}"
cases=($(cat ${caselist}))
case=${cases}
source ${base}/SetUp.sh
echo "output table header from : ${roicc_measured}"
echo "output file : ${roicc_summarize_measured}"
line=$(head -n 1 ${roicc_measured} | tail -n 1 )
echo -e "tract\t${line}" > ${roicc_summarize_measured}
line=$(head -n 2 ${roicc_measured} | tail -n 1)
echo -e "caseid\t${line}" >> ${roicc_summarize_measured}

for case in ${cases[@]}; do
    source ${base}/SetUp.sh
    line=$(head -n 3  ${roicc_measured} | tail -n 1)
    echo -e "${case}\t${line}" >> ${roicc_summarize_measured}
done
