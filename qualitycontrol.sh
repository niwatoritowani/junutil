#!/bin/bash

#source setvar_local
caseid=$1
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}
origspacedir=${casedir}/strct_jun/orig-space
#echo "${origspacedir}/${caseid}-t1w-xc.nrrd"
if [[ -e ${origspacedir}/${caseid}-t1w-xc.nrrd ]]; then operation=""
elif [[ -e ${origspacedir}/${caseid}-t1w_run1-xc.nrrd ]]; then operation="_run1"
else echo "${caseid}-t1w-xc.nrrd or -t1w_run1-xc.nrrd don't exist"; exit 1; fi  
t1xc=${origspacedir}/${caseid}-t1w${operation}-xc.nrrd
s4=/projects/schiz/software/slicer/Slicer-4.3.1-2014-01-12-linux-amd64/Slicer
#s4 is aliased to /projects/schiz/software/slicer/Slicer-4.3.1-2014-01-12-linux-amd64/Slicer
#echo "projectdir is ${projectdir}"


echo "s4 ${t1xc}"
cmd="${s4} ${t1xc}"
echo "${cmd}"
eval "${cmd}"

