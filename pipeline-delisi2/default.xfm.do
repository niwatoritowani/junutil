#!/bin/bash -eu

case=$(basename $2)
source SetUpData_pipeline.sh

T1=${strct}/${case}.t1w-realign.brain.nrrd
T2=${scrct}/${case}.t2w.brain.nrrd

redo-ifchange $T1 $T2

t1nii=/tmp/$(basename $T1).nii.gz
t2nii=/tmp/$(basename $T2).nii.gz
t2realign=${strct}/$2.t2w.brain.realign.nrrd

ConvertBetweenFileFormats $T1 $t1nii
ConvertBetweenFileFormats $T2 $t2nii
#fslswapdim $t1nii LR AP SI $t1nii >/dev/null || true 
#fslswapdim $t1nii RL AP SI $t1nii >/dev/null || true
#fslswapdim $t2nii LR AP SI $t2nii >/dev/null || true
fslswapdim $t2nii RL AP SI $t2nii >/dev/null || true  # T2 Scan Order is Sagittal LR
flirt -dof 6 -in $t2nii -ref $t1nii -omat $3 -o $t2realign.nii.gz && \
ConvertBetweenFileFormats $t2realign.nii.gz $t2realign && \
rm $t2nii $t1nii $t2realign.nii.gz
