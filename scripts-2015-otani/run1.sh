#!/bin/bash -eu

case=$1
caselist=caselist_jun
grep "$1" $caselist || echo "$1" >> $caselist
tmp=$(date +%Y%m%d%H%M%S.%N)
exec &> >(tee $1.log.${tmp})

out=${case}
cmd="
rsync -av -e ssh \
    jkonishi@170.223.221.158:/rfanfs/pnl-zorro/projects/mclean/filtered_spgr/${case}/${case}.nhdr \
    jkonishi@170.223.221.158:/rfanfs/pnl-zorro/projects/mclean/filtered_spgr/${case}/${case}.raw.gz \
    .
fs.sh -i ${case}.nhdr -o /PHShome/jk318/2015-otani/fsoutputs -s &
"

if [ -e $out ]; then 
    echo "$out exist"
else 
    echo "$cmd"
    eval "$cmd"
fi
echo "$(date)"
echo "Done"
