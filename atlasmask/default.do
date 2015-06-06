#!/bin/bash

case=$(basename $2)
if [[ ! $case =~ ^[A-Z,a-z,_,0-9]+$ ]]; then
    echo "Trying to interpret $case as a case id, but not valid"
    exit 1
fi

#if [ -f $2.atlasmask.thresh50.nrrd ]; then
#    echo "$2.atlasmask.thresh50.nrrd might be out of date but it exists so we won't rebuild it"
#    exit 0
#fi

redo-ifchange $2.atlasmask.thresh50.nrrd
