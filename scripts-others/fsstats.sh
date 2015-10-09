#!/bin/bash

# set variables

source /home/jkonishi/junutil/util.sh
projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
caselist=${projectdir}/caselist/caselist_freesurfer2.txt
freesurfersettings=SetUpFreeSurfer.csh
cases=($(cat ${caselist}))
for i in $(seq 0 $(expr ${#cases[@]} - 1)); do
    fscases[i]=${cases[i]}/strct/${cases[i]}.freesurfer
done

# start running program

startlogging

tcsh ${freesurfersettings}

asegstats2table --subjects ${fscases[@]} --meas volume --tablefile aseg_stats.txt --skip
aparcstats2table --subjects ${fscases[@]} --hemi rh --meas volume --tablefile aparc_stats_rh_volume.txt --skip
aparcstats2table --subjects ${fscases[@]} --hemi lh --meas volume --tablefile aparc_stats_lh_volume.txt --skip

stoplogging $0.log

