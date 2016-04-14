#!/bin/bash

### !!!This is under construction!!!

echo "default.cc_FW.do is running"

case=${2##*/}
echo "case : ${case}"
dirscripts=scripts

source SetUpData.sh
#cat SetUpData.sh

#echo "ccdivroi : ${ccdivroi}"

#echo "${dirscripts}/tractography_cc.sh -i ${dwifile} -m ${maskfile} -l ${ccdivroi} -t ${ccroi} -o ${ccroi_outdir} -c ${case}"
#${dirscripts}/tractography_cc.sh -i ${dwifile} -m ${maskfile} -l ${ccdivroi} -t ${ccroi} -o ${ccroi_outdir} -c ${case}
echo "${dirscripts}/selectroiccfromWBT.sh -i ${wholebraintract} -l ${roiccdiv} -o ${roicc_outdir} -t ${roicc_tract_head}"
${dirscripts}/selectroiccfromWBT.sh -i ${wholebraintract} -l ${roiccdiv} -o ${roicc_outdir} -t ${roicc_tract_head}


 
