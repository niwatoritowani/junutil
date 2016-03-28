#!/bin/bash



# shoud be written in SetUp.sh or do files
base=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/2015-delre-corpuscallosum
case=$1
wholebraintract=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/FE_MI_Analysis/VTKs_FES/${case}.ukf_2T_FW.vtk
fs2bse=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/FE_MI_Analysis/FS2BSE_FES/${case}_wmparc-inbse.nii.gz
query=/projects/schiz/software/LabPython/tract_querier/queries/intrust_query.qry
filenamehead=${case}_wmqlcc
outdir=${base}/subjects/${case}

# if outdir does not exist, create outdir

cmd="tract_querier -t ${wholebraintract} -a ${fs2bse} -q ${query} -o ${outdir}/${filenamehead} --query_selection=cc,cc_1,cc_2,cc_3,cc_4,cc_5,cc_6,cc_7"
echo "${cmd}"
eval "${cmd}"
