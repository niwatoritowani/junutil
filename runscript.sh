#!/bin/bash


caselist=$1
#script="$2"
cases=$(cat ${caselist})


for case in ${cases}; do
#    cmd="$(echo \"${script}\")"" ""${case}"
#    eval "${cmd}"
    /projects/schiz/3Tprojects/2015-delre-corpuscallosum/tractographyandmeasure.sh ${case}
done

