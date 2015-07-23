#!/bin/bash -eu

if [ -d $1 ]; then
    echo "$1 already exists, delete it if you would like to recompute it"
    exit 1
fi

case=$(basename $2)
source SetUpData_pipeline.sh

redo-ifchange $fs_t1

if [ -f config/NOSKULLSTRIP ]; then
    scripts/fs.sh -f -i $fs_t1 -o $1
else
    scripts/fs.sh -f -s -i $fs_t1 -o $1
fi
