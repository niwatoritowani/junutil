#!/bin/bash
IFS=$'\n'
awk 'NR > 1 {if ( $2 == 0) print $10}' /projects/schiz/3Tprojects/2015-jun-prodrome/caselist_jun2.txt | \
    sort -R | awk 'NR < 6{print}' > temporaryfile1
awk 'NR > 1 {if ( $2 == 1) print $10}' /projects/schiz/3Tprojects/2015-jun-prodrome/caselist_jun2.txt | \
    sort -R | awk 'NR < 6{print}' >> temporaryfile1
sort -R temporaryfile1 > temporaryfile2




