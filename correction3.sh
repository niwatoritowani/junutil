#!/bin/bash

caseid=$1

cd /projects/schiz/3Tdata/case${caseid}/projects/2015-delre-corpuscallosum

mkdir olddata
mv ${caseid}-cc-roi.nrrd ${caseid}-cc-ukf-values.csv tractographyandmeasure.sh.log without-freeWater olddata


