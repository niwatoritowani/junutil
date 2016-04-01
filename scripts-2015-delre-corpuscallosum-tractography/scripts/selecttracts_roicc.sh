#!/bin/bash

# select tracts from whole brain tract and activate the tracts
# usage : $0 [case id]


base=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/2015-delre-corpuscallosum
case=$1
source ${base}/SetUp.sh

[ -d ${casedir} ] || mkdir ${casedir}

[ -d ${roiccdir} ] || mkdir ${roiccdir}
cmd="
${base}/scripts/changeorigin.py \\
    -i ${roiccdiv} \\
    -o ${roiccdiv_moved_nrrd} \\
    -r ${fs2bse_nrrd} 
"
echo "${cmd}"
eval "${cmd}"

cmd="ConvertBetweenFileFormats ${roiccdiv_moved_nrrd} ${roiccdiv_moved}"
echo "${cmd}"
eval "${cmd}"

filenamehead=${roicc_tract_head}
outdir=${roicc_outdir}    # I dont know wheter we can use . or not. 

[ -d ${outdir} ] || mkdir ${outdir}

# without --query_selectio noption, create all tracts in the query file
cmd="
tract_querier \\
    -t ${wholebraintract} \\
    -a ${roiccdiv_moved} \\
    -q ${roicc_query} \\
    -o ${outdir}/${filenamehead}" 
echo "${cmd}"
eval "${cmd}"

activate_tensors.py ${outdir}/${filenamehead}_cc_1.vtk ${outdir}/${filenamehead}_cc_1.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc_2.vtk ${outdir}/${filenamehead}_cc_2.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc_3.vtk ${outdir}/${filenamehead}_cc_3.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc_4.vtk ${outdir}/${filenamehead}_cc_4.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc_5.vtk ${outdir}/${filenamehead}_cc_5.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc.vtk ${outdir}/${filenamehead}_cc.vtk




