#!/bin/bash
IFS=$'\n'
subjID=($(awk 'NR > 1 {print $7}' /projects/schiz/3Tprojects/2015-jun-prodrome/caselist_jun2_blind.txt))
subjDir=($(awk 'NR > 1 {print $8}' /projects/schiz/3Tprojects/2015-jun-prodrome/caselist_jun2_blind.txt))
for i in $(seq 0 $(expr ${#subjID[*]} - 1)) ; do
    ln -s /projects/schiz/3Tdata/PRODROMES/${subjDir[i]} ${subjID[i]}
done
