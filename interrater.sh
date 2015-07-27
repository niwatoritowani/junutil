#!/bin/bash

# for the project 2015-melissa
# read caselist file
# case list file created in 2015/07/20
caselistdir="/projects/schiz/ra/melissa/Thesis_Project/interraterreliability"
cases=$(cat ${caselistdir}/caselist_calcinterrater20150727.txt)    # separated by line break
outputdir=/projects/schiz/ra/melissa/Thesis_Project/interraterreliability

# measure tracts
# ${cases} expanded separated by space
measureTracts.py \
    -i ${cases}\
    -o ${outputdir}/results_calcinterrater201507271333.csv 

# read r script
# ? for example,  R -inputfile interrater.r

