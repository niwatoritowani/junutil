#!/bin/bash
projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome

# IFS=$'\n'
# awk 'NR > 1 {if ( $2 == 0) print $10}' ${projectdir}/caselist_jun2.txt | \
#     sort -R | awk 'NR < 6{print}' > temporaryfile1
# awk 'NR > 1 {if ( $2 == 1) print $10}' ${projectdir}/caselist_jun2.txt | \
#     sort -R | awk 'NR < 6{print}' >> temporaryfile1
# sort -R temporaryfile1 > temporaryfile2



input1=${projectdir}/caselist_jun2.txt
input2=${projectdir}/caselist_qualitycontrol.txt
awk '{print $1 " " $2}' ${input1} > temporaryfile1
awk '{print $1 " " $6}' ${input2} > temporaryfile2
# # fields: id group qc
join temporaryfile1 temporaryfile2 > temporaryfile3
 
awk 'NR > 1 {if ( $2 == 0 && $3 == "Good" ) print $0}' temporaryfile3 | \
     sort -R | awk 'NR < 7{print $1}' > temporaryfile4
awk 'NR > 1 {if ( $2 == 1 && $3 == "Good" ) print $0}' temporaryfile3 | \
    sort -R | awk 'NR < 7{print $1}' >> temporaryfile4
sort temporaryfile4 > temporaryfile5


