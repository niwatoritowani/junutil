#!/bin/bash

### !!!This is under construction!!!

echo "default.cc_FW.do is running"

case=${2##*/}
echo "case : ${case}"
dirscripts=scripts

source SetUpData.sh

#echo "ccdivroi : ${ccdivroi}"

echo "${dirscripts}/tractography_cc.sh -i ${dwifile} -m ${maskfile} -l ${ccdivroi} -t ${ccroi} -o ${ccroi_outdir} -c ${case}"
${dirscripts}/tractography_cc.sh -i ${dwifile} -m ${maskfile} -l ${ccdivroi} -t ${ccroi} -o ${ccroi_outdir} -c ${case}


 
