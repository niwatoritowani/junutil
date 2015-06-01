#!/bin/bash

caseid=$1
# filename=$(basename ${fullpath})    # such as 00000-dwi.nrrd
# filebasename=${filename%\.*}        # such as 00000-dwi
# seriesnumber=
# seriesnumberf=00000
# dicomread *-${seriesnumberf}-000001.dcm | grep -e 'Series Description' -e '(0028, 0010) Rows'
dicomread *-*-000001.dcm | grep -e 'Series Description' -e '(0028, 0010) Rows' # 


# (0020, 0011) Series Number                       IS: '15'
# rm *-000016-*
# rm *-000017-*
# rm *-000018-*
# cd ..
# DWIConvert --inputDicomDirectory  321100307-dwi-dicom --outputVolume 321100307-dwi.nrrd
# #DWIConvert --inputDicomDirectory  321100307-dwi-dicom --outputVolume ${caseid}-${partofname}.nrrd

