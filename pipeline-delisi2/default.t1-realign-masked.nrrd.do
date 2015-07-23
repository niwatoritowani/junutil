#!/bin/bash -eu

case=$(basename $2)
source SetUpData_pipeline.sh

redo-ifchange $maskalign

unu 3op ifelse $maskalign $t1align -w 1 0 | unu save -e gzip -f nrrd -o $3
