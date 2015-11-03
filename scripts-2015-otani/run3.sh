#!/bin/bash -eu

# copy training t1s and training masks
# execute only 1 time

case=$1
fromdir=/rfanfs/pnl-zorro/projects/mclean/filtered_spgr
todir=/PHShome/jk318/2015-otani/fsoutputs
caselist_training_brains=${basedir}/      # ???
caselist_training_masks=${basedir}/       # ??? 

cmd="
    rsync -auv -e ssh \\
        jkonishi@170.223.221.158:${fromdir}/${caselist_training_brains} \\
        jkonishi@170.223.221.158:${fromdir}/${caselist_training_masks} \\
        ${todir}  # todo: set directory
"

echo "$cmd"
eval "$cmd"
