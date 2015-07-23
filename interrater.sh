#!/bin/bash

# for the project 2015-melissa
# read caselist file
# case list file created in 2015/07/20
caselistdir="/projects/schiz/ra/melissa/Thesis_Project/interraterreliability"
cases=$(cat ${caselistdir}/caselist_calcinterrater.txt)    # separated by line break
outputdir=/projects/schiz/ra/melissa/Thesis_Project/interraterreliability

# measure tracts
# ${cases} expanded separated by space
measureTracts.py \
    -i ${cases}\
    -o ${outputdir}/results_calcinterrater.csv 

# read r script
# ? for example,  R -inputfile interrater.r

# ---------------------------------------------------------2015/07/23
# execute in terminal 

measureTracts.py \ 
    -i /projects/schiz/ra/melissa/Thesis_Project/interraterreliability/vtk_lh_stria/01099-lh-stria.vtk \
        /projects/schiz/ra/melissa/Thesis_Project/interraterreliability/vtk_lh_stria/01222-lh-stria.vtk \
        /projects/schiz/ra/melissa/Thesis_Project/interraterreliability/vtk_lh_stria/01373-lh-stria.vtk \
        /projects/schiz/ra/melissa/Thesis_Project/interraterreliability/vtk_rh_stria/01222-rh-stria.vtk \
        /projects/schiz/ra/melissa/Thesis_Project/interraterreliability/vtk_rh_stria/01362-rh-stria.vtk \
    -o results_20150723.csv

# ----------------------------------------------------------
