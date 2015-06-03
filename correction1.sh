#!/bin/bash

usage() {
    echo "$0 caseid [operation]"
    echo "operation : nothing or _run1 or _run2"
}

caseid=$1
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}
dir=centeredbycenterpy
operation=$2
partofname=${mriweights}${operation}

cmd="
cd ${casedir}
if [ ! -e strct/orig-space]; then exit 1; fi
cd strct/orig-space
mkdir ${dir}
if [ ! -e ${caseid}-t1w${operation}-xc.nrrd ]; then exit 1; fi
if [ ! -e ${caseid}-t2w-xc.nrrd ]; then exit 1; fi
mv ${caseid}-t1w${operation}-xc.nrrd ${dir}
mv ${caseid}-t2w-xc.nrrd ${dir}
center_image ${caseid}-t1w${operation}-x.nrrd ${caseid}-t1w${operation}-xc.nrrd
center_image ${caseid}-t2w-x.nrrd ${caseid}-t2w-xc.nrrd
# cd ${casedir}
# cd diff-jun
# mkdir ${dir}
# mv ${caseid}-dwi-xc.nrrd ${dir}
# center_image ${caseid}-dwi-x.nrrd ${caseid}-dwi-xc.nrrd
"
scriptname=$(basename $0)
timestamps=$(date +%Y%m%d%H%M%S)
timestampm=$(date +%Y%m%d%H%M)
logfilename=${scriptname}${timestampm}.log
echo "${cmd}" | tee ${logfilename}
eval "${cmd}" 2>&1 | tee -a ${logfilename}



