#!/bin/bash
caselist=$(awk 'NR > 1 {print $8}' caselist_jun2_blind.txt)
datadir=/projects/schiz/3Tdata/PRODROMES
for subjectid in ${caselist}; do
    echo "[$subjectid]"
    ls ${datadir}/${subjectid}
done
