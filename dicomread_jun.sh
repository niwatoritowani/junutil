#!/bin/bash

caseid=$1
projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}

# filename=$(basename ${fullpath})    # such as 00000-dwi.nrrd
# filebasename=${filename%\.*}        # such as 00000-dwi

cd ${casedir}
originaldicomdirname="raw/${caseid}-dwi"
cd ${originaldicomdirname}
ls *-*-000001.dcm.gz
dicomread *-*-000001.dcm.gz | grep \
-e '(0008, 103e) Series Description' \
-e '(0028, 0010) Rows' \
-e '(0020, 0011) Series Number' \
-e '(0028, 0011) Columns' \
-e '(0051, 100c) [Unknown]' 


# seriesnumber=15
# seriesnumberf=$(printf "%0d" ${seriesnumber})
# partofname=dwi
# cd ${casedir}
# mkdir diff-jun
# mkdir diff-jun/${caseid}-${partofname}-dicom
# cp raw/${caseid}-dwi/*-${seriesnumberf}-*.dcm.gz diff-jun/${caseid}-${partofname}-dicom
# gunzip diff-jun/${caseid}-${partofname}-dicom/*.dcm.gz
# 


