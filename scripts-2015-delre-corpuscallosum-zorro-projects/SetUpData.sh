
base=$(readlink -m ${BASH_SOURCE[0]})   # read directory of this file even this file is calle by source or bash
# If we use '$0', it means this file when it called by bash, and the calling file when it called by source 
# (the latter is the same as writting the code of called file into the calling file). 
# "source SetUpData.sh" is witten in default do files. 
base=${base%/*}
scriptsdir=${base}/scripts
caselistsdir=${base}/caselists
caselist=${caselistsdir}/caselist.txt

casedir=${base}/subjects/${case}

wholebraintract=${casedir}/${case}.ukf_2T_FW.vtk
# copied from erisone.partners.org:/data/pnl/3Tdata-ukf/${case}/${case}.ukf_2T_FW.vtk
roiccdiv=/projects/schiz/3Tdata/case${case}/projects/2015-delre-corpuscallosum/${case}-cc-div-roi.nrrd

fsindwi_fssubjectdir=${casedir}/${case}.fs2bse
###? fs2bse1mm=${fsindwi_fssubjectdir}/${case}/wmparc-inbse1mm.nii.gz
fsindwi=${casedir}/${case}.fsindwi.nrrd 
# $outputdir/wmparc-in-bse-1mm.nrrd is name-changed to fsindwi
roicc1mm=${casedir}/${case}.roicc1mm.nrrd
roiccfs=${casedir}/${case}.roiccfsl

roicc_query=${scriptsdir}/roicc_query.qry
roicc_outdir=${casedir}/${case}.roicc
roicc_tract_head=${case}_ukf_2T_FW_roicc    # This shoud not include "."
roicc_measured=${casedir}/${case}.roicc_measured.txt
roicc_summarize_measured=${base}/stats/roicc_summarize_measured.txt

roiccfs_query=${scriptsdir}/roiccfs_query.qry
roiccfs_outdir=${casedir}/${case}.roiccfs
roiccfs_tract_head=${case}_ukf_2T_FW_roiccfs    # This shoud not include "."
roiccfs_measured=${casedir}/${case}.roiccfs_measured.txt
roiccfs_summarize_measured=${base}/stats/roiccfs_summarize_measured.txt

wmql7cc_query=
wmql7cc_outdir=${casedir}/${case}.wmql7cc
wmql7cc_tract_head=${case}_ukf_2T_FW_wmql7cc
wmql7cc_measured=${casedir}/${case}.wmql7cc_measured.txt
wmql7cc_summarize_measured=${base}/stats/wmql7cc_summarize_measured.txt

wmql5cc_query=
wmql5cc_outdir=${casedir}/${case}.wmql5cc
wmql5cc_tract_head=${case}_ukf_2T_FW_wmql5cc
wmql5cc_measured=${casedir}/${case}.wmql5cc_measured.txt
wmql5cc_summarize_measured=${base}/stats/wmql5cc_summarize_measured.txt


