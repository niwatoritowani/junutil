#!/bin/bash
usage() {
    echo "$0 [case id] [operation: nothing or _rn1]"
}
caseid=$1
projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}
mriweight=t1w
operation=$2
partofname=${mriweight}${operation}
realigndir=${casedir}/strct_jun/align-space
realignt1root=${realigndir}/${caseid}-${partofname}-realign
betroot=${realigndir}/${caseid}-${partofname}-realign-brain
betmaskroot=${realigndir}/${caseid}-${partofname}-realign-brain_mask
# bet script will output ${caseid}-${partofname}-realign-brain_mask.nii.gz

cmd="
ConvertBetweenFileFormats ${realignt1root}.nrrd ${realignt1root}.nii.gz 
bet ${realignt1root}.nii.gz ${betroot}.nii.gz -m -f 0.50 -n
ConvertBetweenFileFormats ${betmaskroot}.nii.gz ${betmaskroot}.nrrd
rm ${realignt1root}.nii.gz
rm ${betmaskroot}.nii.gz
"
scriptname=$(basename $0)
logfilename=${scriptname}.log
echo "$cmd" | tee ${logfilename}
eval "$cmd" 2>&1 | tee -a ${logfilename}
