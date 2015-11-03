#!/bin/bash -eu

# create t1atlasmask.nrrd from target-t1w and training-file-list in PNL PC

case=$1
basedir=/rfanfs/pnl-zorro/projects/mclean/filtered_spgr/
target_structural_scan=${basedir}/        # ${case}.t1w-realign.nrrd
output_mask=${basedir}/                   # ${case}.t1mabs.nrrd
caselist_training_brains=${basedir}/      # ???
caselist_training_masks=${basedir}/       # ??? 

mainANTSAtlasWeightedOutputProbability \
  ${target_structural_scan} \
  ${output_mask} \
  ${caselist_training_brains} \
  ${caselist_training_masks} 
unu 2op gt ${output_mask} 50 | unu save -e gzip -f nrrd -o ${output_mask} 

# bash run2.1.sh case00199 > case00199.log 2>&1 &
# next step: edit manually ${case}.t1atlasmask.nrrd into ${case}.t1atlasmask-edr.nrrd
