#!/bin/bash

echo "the anterior position is" $1 "voxel"
echo "the posterior position is" $2 "voxel"
length=$(expr $2 - $1 + 1 )
echo "length is" ${length} "voxels"
places=(0 2 6 8 9 12)
echo "each anterior position (relative value) is" ${places[@]}

for i in 0 1 2 3 4 5; do
    places[i]=$(echo $1 ${places[i]} $length | \
        awk '{printf("%d",$1+int($2*$3/12+0.5))}'
    )
done
echo "each anterior position is" ${places[@]} "voxel"
