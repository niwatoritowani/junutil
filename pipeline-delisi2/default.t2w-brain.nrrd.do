#!/bin/bash

case=$(basename $2)    # $2 is ${strct}/${case}, $3 is ${strct}/${case}.t2w-brain.nrrd 
source SetUpData_pipeline.sh

t2nii=/tmp/$(basename $t2).nii.gz
t2brainnii=${strct}/${case}.t2w-brain.nii.gz

ConvertBetweenFileFormats $t2 ${t2nii}

bet ${t2nii} ${t2brainnii} -m -f 0.50
ConvertbetweenFileFormats ${t2brainnii} ${3}
rm ${t2nii} ${t2brainnii}
