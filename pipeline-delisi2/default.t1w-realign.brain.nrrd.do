#!/bin/bash

case=$(basename $2)    # $2 is ${case}, $3 is ${case}.t1w-realign.brain.nrrd
source SetUpData_pipeline.sh

t1nii=/tmp/$(basename $t1align).nii.gz
t1brainnii=${case}.t1w-realign-brain.nii.gz

ConvertBetweenFileFormats $t1align $t1nii

bet ${t1nii} ${t1brainnii} -m -f 0.50
ConvertbetweenFileFormats ${t1brainnii} ${3}
rm $t1nii ${t1brainnii}
