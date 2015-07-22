case=$2    # ${case}, $3 is ${case}.t1w-realign.brain.nrrd

T1=$(eval echo $(<config/REALIGN_T1))
t1nii=/tmp/$(basename $T1).nii.gz
t1brainnii=${case}.t1w.brain.nii.gz

ConvertBetweenFileFormats $T1 $t1nii

bet ${t1nii} ${t1brainnii} -m -f 0.50
ConvertbetweenFileFormats ${t1brain} ${3}
rm $t1nii ${t1brainnii}

