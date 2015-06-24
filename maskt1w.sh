#!/bin/bash
usage() {
    echo "$0 [case id] [operation: nothing or _rn1]"
}

# set variables

caseid=$1
projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}
mriweighting=t1w
operation=$2
partofname=${mriweighting}${operation}
realigndir=${casedir}/strct_jun/align-space
realignt1root=${realigndir}/${caseid}-${partofname}-realign
betroot=${realigndir}/${caseid}-${partofname}-realign-brain
betmaskroot=${realigndir}/${caseid}-${partofname}-realign-brain_mask
# # bet script will output ${caseid}-${partofname}-realign-brain_mask.nii.gz

# if ${caseid}-t1w_run1-realign.nrrd exists, create a symbolic link.

if [[ ! -e ${realigndir}/${caseid}-t1w-realign.nrrd ]]; then
    if [[ -e ${realigndir}/${caseid}-t1w_run1-realign.nrrd ]]; then
        ln -s ${realigndir}/${caseid}-t1w_run1-realign.nrrd ${realigndir}/${caseid}-t1w_run1-realign.nrrd
    fi
fi

# run script and create log file in current directory

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
