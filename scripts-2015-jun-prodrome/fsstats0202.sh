#!/bin/bash

# todo
# befor running this script, need to `source SetUpFreesurfer.csh` in the terminal, Why? 

# set variables

source /home/jkonishi/junutil/util.sh
projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
caselist=${projectdir}/caselist/caselist_freesurfer2.txt
freesurfersettings=SetUpFreeSurfer.csh
cases=($(cat ${caselist}))
for i in $(seq 0 $(expr ${#cases[@]} - 1)); do
    fscases[i]=${cases[i]}/strct/${cases[i]}.freesurfer.edited
done

# start running program

startlogging

#tcsh ${freesurfersettings}    # This does not work well. Why? 

## ran by fsstats02.sh 
# run asegstats2table --subjects ${fscases[@]} --meas volume --tablefile edited.aseg_stats.txt --skip
# run aparcstats2table --subjects ${fscases[@]} --hemi rh --meas volume --tablefile edited.aparc_stats_rh_volume.txt --skip
# run aparcstats2table --subjects ${fscases[@]} --hemi lh --meas volume --tablefile edited.aparc_stats_lh_volume.txt --skip

# new stats file created by this script
run aparcstats2table --subjects ${fscases[@]} --hemi rh --meas area --tablefile edited.aparc_stats_rh_area.txt --skip
run aparcstats2table --subjects ${fscases[@]} --hemi lh --meas area --tablefile edited.aparc_stats_lh_area.txt --skip
run aparcstats2table --subjects ${fscases[@]} --hemi rh --meas thickness --tablefile edited.aparc_stats_rh_thickness.txt --skip
run aparcstats2table --subjects ${fscases[@]} --hemi lh --meas thickness --tablefile edited.aparc_stats_lh_thickness.txt --skip
run aparcstats2table --subjects ${fscases[@]} --hemi rh --meas volume --parc aparc.a2009s --tablefile edited.aparc.a2009s_stats_rh_volume.txt --skip
run aparcstats2table --subjects ${fscases[@]} --hemi lh --meas volume --parc aparc.a2009s --tablefile edited.aparc.a2009s_stats_lh_volume.txt --skip
run aparcstats2table --subjects ${fscases[@]} --hemi rh --meas area --parc aparc.a2009s --tablefile edited.aparc.a2009s_stats_rh_area.txt --skip
run aparcstats2table --subjects ${fscases[@]} --hemi lh --meas area --parc aparc.a2009s --tablefile edited.aparc.a2009s_stats_lh_area.txt --skip
run aparcstats2table --subjects ${fscases[@]} --hemi rh --meas thickness --parc aparc.a2009s --tablefile edited.aparc.a2009s_stats_rh_thickness.txt --skip
run aparcstats2table --subjects ${fscases[@]} --hemi lh --meas thickness --parc aparc.a2009s --tablefile edited.aparc.a2009s_stats_lh_thickness.txt --skip

#echo ${fscases[@]}

stoplogging $0.log

# Notes
# -p PARC, --parc=PARC parcellation.. default is aparc ( alt aparc.a2009s) -m MEAS, --measure=MEAS
#    measure: default is area ( alt volume, thickness, thicknessstd, meancurv, gauscurv, foldind, curvind) 
#
# -p aparc
#     -m area      : edited.aparc_stats_?h_area.txt
#     -m volume    : edited.aparc_stats_?h_volume.txt
#     -m thickness : edited.aparc_stats_?h_thickness.txt
# -p aparc.a2009s  
#     -m area      : edited.aparc.a2009s_stats_?h_area.txt
#     -m volume    : edited.aparc.a2009s_stats_?h_volume.txt
#     -m thickness : edited.aparc.a2009s_stats_?h_thickness.txt
#
#
#

