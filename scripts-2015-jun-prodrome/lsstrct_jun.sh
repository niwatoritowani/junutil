#!/bin/bash

lines=$(awk '{print $12}' /projects/schiz/3Tprojects/2015-jun-prodrome/caselist_jun2_blind.txt)
for line in $lines; do
    echo "$line"
    ls $line/strct_jun
    echo "---"
done

# # thinkig more simple script
#list=caselistfile
#awk '{print $12}' $list | while read case ;do
#    echo "${case}"
#    ls ${case}/strct_jun
#    echo "---"
#done

