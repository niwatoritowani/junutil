#!/bin/bash -eu

# todo
# we don't have to use & in cmd, but shoud use when run this script

caselist=caselist_jun
awk '{print $1}' $caselist | grep -w "$1" || echo "$1" >> $caselist

tmp=$(date +%Y%m%d%H%M%S.%N)
logfile=$1.log.${tmp}
exec &> >(tee -a ${logfile})

case=$1
outdir="/PHShome/jk318/2015-otani/fsoutputs"
out=${outdir}/${case}
cmd="
    rsync -auv -e ssh \\
        jkonishi@170.223.221.158:/rfanfs/pnl-zorro/projects/mclean/filtered_spgr/${case}/${case}.nhdr \\
        jkonishi@170.223.221.158:/rfanfs/pnl-zorro/projects/mclean/filtered_spgr/${case}/${case}.raw.gz \\
        .
    fs.sh -i ${case}.nhdr -o ${outdir} -s >> ${logfile} 2>&1 
"
if [ -e $out ]; then
    echo "$out exist"
else
    echo "$cmd"
    eval "$cmd"
fi
echo "$(date)"
