# set variables

# variables depend on project

#base=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/2015-delre-corpuscallosum
scriptdir=${base}/scripts
caselist=${base}/caselist.txt


# variables depend on case

# input data

wholebraintract=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/FE_MI_Analysis/VTKs_FES/${case}.ukf_2T_FW.vtk
fs2bse=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/FE_MI_Analysis/FS2BSE_FES/${case}_wmparc-inbse.nii.gz
fs2bse_nrrd=/rfanfs/pnl-zorro/projects/Cidar_johanna/Registration/FH/${case}_wmparc-inbse.nrrd
roiccdiv=/projects/schiz/3Tdata/case${case}/projects/2015-delre-corpuscallosum/${case}-cc-div-roi.nrrd
#bse=/rfanfs/pnl-zorro/projects/Cidar_johanna/Registration/output_folder${case}/${case}-bse.nrrd   

# each case output

casedir=${base}/subjects/${case}

# moved label map

#roiccdir=${base}/subjects/${case}/label
roiccdir=${casedr}/label

roiccdiv_moved_nrrd=${roiccdir}/${case}-cc-div-roi_moved.nrrd
roiccdiv_moved=${roiccdir}/${case}-cc-div-roi_moved.nii.gz

# tract

#roicc_outdir=${base}/subjects/${case}/${case}.roicc    # I dont know wheter we can use "." or not. 
roicc_outdir=${casedir}/${case}.roicc    # I dont know wheter we can use "." or not. 
wmqlcc_outdir=${casedir}/${case}.wmqlcc    # I dont know wheter we can use "." or not. 

#roicc_query=${base}/scripts/roicc_query.qry
roicc_query=${scriptdir}/roicc_query.qry
wmqlcc_query=/projects/schiz/software/LabPython/tract_querier/queries/intrust_query.qry
roicc_tract_head=${case}_roicc
wmqlcc_tract_head=${case}_wmqlcc

# measured in each subject

#roicc_measured=${roicc_outdir}/${case}.roicc_measured.txt
roicc_measured=${casedir}/${case}.roicc_measured.txt
wmqlcc_measured=${casedir}/${case}.wnqlcc_measured.txt

# measured in the project

roicc_summarize_measured=${base}/stats/roicc_summarize_measured.txt
wmqlcc_summarize_measured=${base}/stats/wmqlcc_summarize_measured.txt

