#!/bin/bash -eu

# copy training files from PNL PC to ERISOne

fromdir=/rfanfs/pnl-zorro/projects/mclean/filtered_spgr
todir=/PHShome/jk318/2015-otani/fsoutputs
caselist_training_brains=${todir}/      # ???
caselist_training_masks=${todir}/       # ??? 

brains=""; masks=""
while read f < [trainig_brains]; do
    brains="${brains} jkonishi@170.223.221.158:${f}"
done
while read f < [trainig_masks]; do
    masks=${masks} jkonishi@170.223.221.158:${f}"
done
rsync -auv -e ssh \
    brains masks ${todir}/trainings # OK? into the same directory

