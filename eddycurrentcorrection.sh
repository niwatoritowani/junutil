#!/bin/bash

caseid=$1
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}
partofname=dwi
newdir=diff-jun

cd ${casedir}
cd ${newdir}
cmd="
dwiPipeline-nofilt-savexfm.py ${caseid}-${partofname}-xc.nrrd ${caseid}-${partofname}-Ed.nhdr
"
command=$(basename $0)
echo -e "$cmd" "\n" 2>&1 | tee -a /tmp/log.log
eval $cmd 2>&1 | tee -a /tmp/log.log

mv /tmp/log.log ${casedir}/${newdir}/${caseid}-${partofname}-${command}.log



