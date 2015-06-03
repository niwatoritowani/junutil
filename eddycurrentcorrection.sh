#!/bin/bash

usage() {
    echo "$0 caseid"
    echo ""
}

caseid=$1
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}
partofname=dwi
newdir=${casedir}/diff-jun

cmd="
cd ${newdir}
dwiPipeline-nofilt-savexfm.py ${caseid}-${partofname}-xc.nrrd ${caseid}-${partofname}-Ed.nhdr
"
scriptname=$(basename $0)
timestamps=$(date +%Y%m%d%H%M%S)
timestampm=$(date +%Y%m%d%H%M)
logfilename=${scriptname}${timestampm}.log

echo -e "$cmd" "\n" 2>&1 | tee /tmp/log.log
eval "$cmd" 2>&1 | tee -a /tmp/log.log

mv /tmp/log.log ${newdir}/${caseid}-${partofname}-${scriptname}.log



