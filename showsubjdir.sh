#!/bin/bash
CASELIST=$(awk 'NR > 1 {print $8}' caselist_jun2_blind.txt)
for subject in ${CASELIST[*]}; do
    echo "[$subject]"
    ls /projects/schiz/3Tdata/PRODROMES/${subject}
done
