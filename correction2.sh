#!/bin/bash

usage() {
    echo "$0 caseid [operation]"
    echo "operation : nothing or _run1 or _run2"
}

caseid=$1
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}
dir=centeredbycenterpy
operation=$2
#partofname=${mriweights}${operation}

workingdir=${casedir}/strct/orig-space
cmd="
if [ ! -e ${workingdir} ]; then exit 1; fi
cd ${workingdir}
mkdir ${dir}
if [ ! -e ${caseid}-t1w${operation}-xc.nrrd ]; then exit 1; fi
if [ ! -e ${caseid}-t2w-xc.nrrd ]; then exit 1; fi
mv ${caseid}-t1w${operation}-xc.nrrd ${dir}
mv ${caseid}-t2w-xc.nrrd ${dir}
/home/jkonishi/junutil/center_jun.py -i ${caseid}-t1w${operation}-x.nrrd -o ${caseid}-t1w${operation}-xc.nrrd
/home/jkonishi/junutil/center_jun.py -i ${caseid}-t2w-x.nrrd -o ${caseid}-t2w-xc.nrrd
"
scriptname=$(basename $0)
timestamps=$(date +%Y%m%d%H%M%S)
timestampm=$(date +%Y%m%d%H%M)
logfilename=${scriptname}${timestampm}.log
logfile=${workingdir}/${logfilename}
#echo "${cmd}" | tee ${logfile}
#eval "${cmd}" 2>&1 | tee -a ${logfile}

workingdir=${casedir}/diff-jun
cmd="
if [ ! -e ${workingdir} ]; then exit 1; fi
cd ${workingdir}
mkdir ${dir}
if [ ! -e  ${caseid}-dwi-xc.nrrd ]; then exit 1; fi
mv ${caseid}-dwi-xc.nrrd ${dir}
/home/jkonishi/junutil/center_jun.py -i ${caseid}-dwi-x.nrrd -o ${caseid}-dwi-xc.nrrd
"

logfile=${workingdir}/${logfilename}
echo "${cmd}" | tee ${logfile}
eval "${cmd}" 2>&1 | tee -a ${logfile}


#function cidpon() {
#/home/jkonishi/junutil/center_jun.py -1 $1-$2-x.nrrd -o $1-$2-xc.nrrd
#}
#function cmdlog() {
#echo "$1" | tee $2
#eval "$1" 2>&1 | tee -a $2
#}
