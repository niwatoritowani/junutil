#!/bin/bash
case=$1
logfilename=${case}.log.$(date +%Y%m%d%H%M%S)    # name a log file case.log.yyyymmddhhmmss
cd /rfanfs/pnl-zorro/projects/mclean/filtered_spgr

# run at /rfanfs/pnl-zorro/projects/mclean/filtered_spgr
# \\ is expanded to \ by shell
cmd="
    mainANTSAtlasWeightedOutputProbability \\
        ${case}/align-space/${case}-t1w-realign.nrrd \\
        ${case}/align-space/${case}-mabs.nrrd \\
        trainigt1list.txt \\
        training_set && \\
    unu 2op gt ${case}/align-space/${case}-mabs.nrrd 50 | \\
        unu save -e gzip -f nrrd -o ${case}/align-space/${case}_MABS_50.nrrd
"
echo "${cmd}" | tee log/${logfilename}           # output command-description into log-file
eval "${cmd}" 2>&1 | tee -a log/${logfilename}   # output standard-and-standard-error-output into log-file
