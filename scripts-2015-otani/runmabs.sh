#!/bin/bash

# run at /rfanfs/pnl-zorro/projects/mclean/filtered_spgr
# usage example: ./rumabs.sh caseG20

case=$1
cd /rfanfs/pnl-zorro/projects/mclean/filtered_spgr

mainANTSAtlasWeightedOutputProbability \
    ${case}/align-space/${case}-t1w-realign.nrrd \
    ${case}/align-space/${case}-mabs.nrrd \
    trainigt1list.txt \
    training_set && \
unu 2op gt ${case}/align-space/${case}-mabs.nrrd 50 | \
    unu save -e gzip -f nrrd -o ${case}/align-space/${case}_MABS_50.nrrd 
