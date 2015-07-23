#!/bin/bash -eu

case=$(basename $2)
if [[ ! $case =~ ^[A-Z,a-z,_,0-9]+$ ]]; then
    echo "Trying to interpret $case as a case id, but not valid"
    exit 1
fi

source SetUpData_pipeline.sh

redo-ifchange $fs
