#!/bin/bash

caseid=$1
projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}
# filename=$(basename ${fullpath})    # such as 00000-dwi.nrrd
# filebasename=${filename%\.*}        # such as 00000-dwi
originaldicomdir=${casedir}/raw/${caseid}-dwi

cd ${originaldicomdir}
ls *-*-000001.dcm.gz
dicomread *-*-000001.dcm.gz | grep \
-e '(0008, 103e) Series Description' \
-e '(0020, 0011) Series Number' \
-e '(0028, 0010) Rows' \
-e '(0028, 0011) Columns' \
-e '(0051, 100c) [Unknown]' 




