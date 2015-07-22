#!/bin/bash

function usage {
cat <<EOF
Usage:
    $(basename $0) <input_img> <transform.xfm> <realign_t1> <output_img>
EOF
}

if [ $# != 4 ]; then
    usage
    exit 0
fi

torealign=$1
xfm=$2
realignt1=$3
output=$4

nii=/tmp/$(basename $torealign).nii.gz
nii_out=/tmp/$(basename $output).nii.gz

ConvertBetweenFileFormats $torealign $nii > /dev/null
#fslswapdim $nii LR AP SI $nii > /dev/null 
fslswapdim $nii RL AP SI $nii > /dev/null  # T2 mask Scan Order is Saggital LR, this line is not necessary
realignt1nii=$realignt1.nii.gz
ConvertBetweenFileFormats $realignt1 $realignt1nii > /dev/null
#fslswapdim $realignt1nii LR AP SI $realignt1nii > /dev/null 
#fslswapdim $realignt1nii RL AP SI $realignt1nii > /dev/null
flirt -in $nii -ref $realignt1nii -applyxfm -init $xfm -interp nearestneighbour -o $nii_out
ConvertBetweenFileFormats $nii_out $output > /dev/null && \
rm $nii $nii_out $realignt1nii
