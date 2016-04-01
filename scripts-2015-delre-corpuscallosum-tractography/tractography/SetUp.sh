# variables depend on project

#base=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/2015-delre-corpuscallosum
scrdir=${base}/scripts
caselist=${base}/caselist.txt


# variables depend on case

#case=$1
casedir=${base}/subjects/${case}

wholebraintract=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/FE_MI_Analysis/VTKs_FES/${case}.ukf_2T_FW.vtk
fs2bse=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/FE_MI_Analysis/FS2BSE_FES/${case}_wmparc-inbse.nii.gz
fs2bse_nrrd=/rfanfs/pnl-zorro/projects/Cidar_johanna/Registration/FH/${case}_wmparc-inbse.nrrd

roiccdiv=/projects/schiz/3Tdata/case${case}/projects/2015-delre-corpuscallosum/${case}-cc-div-roi.nrrd

roiccdir=${base}/subjects/${case}/label
roiccdiv_moved_nrrd=${roiccdir}/${case}-cc-div-roi_moved.nrrd
roiccdiv_moved=${roiccdir}/${case}-cc-div-roi_moved.nii.gz


roicc_outdir=${base}/subjects/${case}/${case}.roicc    # I dont know wheter we can use "." or not. 

wmqlcc_query=/projects/schiz/software/LabPython/tract_querier/queries/intrust_query.qry
roicc_query=${base}/scripts/roicc_query.qry
wmqlcc_tract_head=${case}_wmqlcc
roicc_tract_head=${case}_roicc

roicc_measured=${roicc_outdir}/${case}.roicc_measured.txt

roicc_summarize_measured=${base}/stats/roicc_summarize_measured.txt
