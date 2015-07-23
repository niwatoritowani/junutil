#!/bin/bash

case=$2    # $2 is ${case}, $3 is ${case}.t1w-realign-brain.nrrd

T1=$(eval echo $(<config/REALIGN_T1))
t1nii=/tmp/$(basename $T1).nii.gz
t1brainnii=/tmp/${case}.t1w-realign-brain.nii.gz

ConvertBetweenFileFormats $T1 $t1nii

bet ${t1nii} ${t1brainnii} -m -f 0.50
ConvertbetweenFileFormats ${t1brainnii} ${3}
rm $t1nii ${t1brainnii}
