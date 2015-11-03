#!/bin/bash -eu


# copy t1w-realign.nrrd from PNL PC to ERISOne

# todo
# - differetiate training-file-list in between PNL and ERISOne by name

case=$1
fromdir=/rfanfs/pnl-zorro/projects/mclean/filtered_spgr
todir=/PHShome/jk318/2015-otani/fsoutputs

caselist=caselist_jun
awk '{print $1}' $caselist | grep -w "$1" || echo "$1" >> $caselist

tmp=$(date +%Y%m%d%H%M%S.%N)
logfile=$1.log.${tmp}
exec &> >(tee -a ${logfile})

cmd="
    if [ ! -e ${todir}/align-space ]; then mkdir -p ${todir}/align-space; fi
    rsync -auv -e ssh \\
        jkonishi@170.223.221.158:${fromdir}/${case}/align-space/${case}.t1w-realign.nrrd \\
        ${todir}/${case}/align-space
"
if [ -e $out ]; then
    echo "$out exist"
else
    echo "$cmd"
    eval "$cmd"
fi
echo "$(date)"

# we don't have to use & in cmd, but shoud use when run this script
