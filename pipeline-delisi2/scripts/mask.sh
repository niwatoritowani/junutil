#!/bin/bash

if [[ $1 == "-h" || $1 == "--help" || -z "$1" ]]; then
    echo "Usage" 
    echo
    echo "   mask.sh <img> <mask> <out>"
    echo
    echo "Masks <img> with <mask>.  Both must be in either nrrd or nifti format."
    exit 0
fi

img=$1
mask=$2
out=$3

isnrrd()
{
    EXT=${1##*.}
    [[ $EXT == "nrrd" || $EXT == "nhdr" ]]
}

isnifti()
{
    EXT=${1#*.}
    [[ $EXT == "nii" || $EXT == "nii.gz" ]]
}

if  isnrrd $img && isnrrd $mask; then
    unu 3op ifelse $mask $img -w 1 0 | unu save -e gzip -f nrrd -o $out
elif isnifti $img && isnifti $mask; then
    echo "Assuming label number in the mask is 1, if not the result will be wrong!"
    fslmaths $img -mul $mask $out
else
    echo $img 
    echo $mask 
    echo "must be in same format, either nrrd/nhdr or nii/nii.gz"
fi
