#!/bin/bash

base=/projects/pnl/3Tdata/freesurfer-pipeline

fspipelinedir=${base}
finaldir=${base}/FINAL_OUTPUT_FS_final_run_edr_for_analyses
subjdir=${base}/subjects3

caselist=${subjdir}/caselist/caselist_schiz3Tdata.txt
cases=($(cat ${caselist}))

for case in ${cases[@]}; do

    fspipelinedata=${base}/${case}.freesurfer
    fspipelinedata_edr=${base}/${case}.freesurfer-edr
    finaldata_edr=${finaldir}/${case}.freesurfer-edr
    subjdata_edr=${subjdir}/${case}.freesurfer-edr

    if [ -e ${finaldata_edr} ]; then
        echo "${case} : ln -s ${finaldata_edr} ${subjdata_edr}"
        ln -s ${finaldata_edr} ${subjdata_edr}
    elif [ -e ${fspipelinedata_edr} ]; then
        ln -s ${fspipelinedata_edr} ${subjdata_edr}
        echo "${case} : ln -s ${fspipelinedata_edr} ${subjdata_edr}"
    elif [ -e ${fspipelinedata} ]; then
        ln -s ${fspipelinedata} ${subjdata_edr}
        echo "${case} : ln -s ${fspipelinedata} ${subjdata_edr}"
    else
        echo "${case} : no data" 
    fi
done



