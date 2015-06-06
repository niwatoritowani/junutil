#!/bin/bash -eu

# This script is made from 
# /projects/pnl/software/pnlutil/default.atlaslabelmap.nrrd.do 
# and editid. 

source util.sh

if [[ -f "$1" ]]; then
    echo "'$1' exists and is out of date, delete it if you want to recompute it."
    mv $1 $3
    exit 0
fi

case=${2##*/}
case=${case%%.*}

tmp=$(mktemp -d) && start_logging "$tmp/log" 
#inputvars="\
#    atlas_target \
#    atlas_trainingstructs \
#    atlas_traininglabels"
#checkset_local_SetUpData $inputvars
#redo_ifchange_vars $inputvars

#ATLASMSK_DIR=/rfanfs/pnl-a/pnl/Collaborators/Delisi/masks_fromcluster
DATA_DIR=/rfanfs/pnl-a/pnl/Collaborators/Delisi/dicom_to_nifti/data
atlas_trainingstructs=t2s.txt
atlas_traininglabels=masks.txt
atlas_target=${DATA_DIR}/${case}/T2/${case}-T2.nrrd

log "Make '$1'"
run mainANTSAtlasWeightedOutputProbability "$atlas_target" "$3" "$atlas_trainingstructs" "$atlas_traininglabels"
log "Threshold the mask at 50"
run unu 2op gt $3 50 | unu save -e gzip -f nrrd -o $3
log_success "Made '$1'"
mv "$tmp/log" "$1.log" && rm -rf "$tmp"
