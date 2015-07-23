case=$2
REALIGN_T1=$(eval echo $(<config/REALIGN_T1))
MASK=$case.mask-realign.nrrd

redo-ifchange $MASK

unu 3op ifelse $MASK $REALIGN_T1 -w 1 0 | unu save -e gzip -f nrrd -o $3
