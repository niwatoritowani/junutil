#!/bin/bash -eu

caselist=caselist
awk '{print $1}' $caselist | grep -w "$1" || echo "$1" >> $caselist

tmp=$(date +%Y%m%d%H%M%S.%N)
logfile=$1.log.${tmp}    # in case it is mentioned in cmd
exec &> >(tee -a ${logfile}) # output 1 and 2 into terminal and file

case=$1
out=${case}.t1atlasmask.nrrd
cmd="
    command \
        input t1w-realign trainingt1list trainingmasklist \
        output probabilitymap \
        >> ${logfile} 2>&1
    command \
        input probabilitymap \
        output ${out} \
        >> ${logfile} 2>&1
"
if [ -e $out ]; then
    echo "$out exist"
else
    echo "$cmd"
    eval "$cmd"
fi
echo "$(date)"
