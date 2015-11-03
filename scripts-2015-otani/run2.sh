#!/bin/bash -eu

case=$1
target_structural_scan=
output_mask=
caselist_training_brains=
caselist_training_masks=

# add case to caselist
caselist=caselist_jun
awk '{print $1}' $caselist | grep -w "$1" || echo "$1" >> $caselist

# log
tmp=$(date +%Y%m%d%H%M%S.%N)
logfile=$1.log.${tmp}    # in case it is mentioned in cmd
exec &> >(tee -a ${logfile}) # output 1 and 2 into terminal and file

# commands
out=${output_mask}
cmd="
    mainANTSAtlasWeightedOutputProbability \\
        ${target_structural_scan} \\
        ${output_mask} \\
        ${caselist_training_brains} \\
        ${caselist_training_masks} \\
        >> ${logfile} 2>&1
    unu 2op gt ${output_mask} 50 | unu save -e gzip -f nrrd -o ${output_mask} \\
        >> ${logfile} 2>&1
"
if [ -e $out ]; then
    echo "$out exist"
else
    echo "$cmd"
    eval "$cmd"
fi
echo "$(date)"

# reference
# - https://intweb.spl.harvard.edu/Atlas-masking
