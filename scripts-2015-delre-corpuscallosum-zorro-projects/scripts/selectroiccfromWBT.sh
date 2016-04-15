#!/bin/bash

### !!!This file is under construction!!! ###

usage() {
    echo "output tracts and measure them"
    echo "Usage: [input]"
    exit 0
}

SCRIPT=$(readlink -m ${BASH_SOURCE[0]})   # read directory of this file even this file is calle by source or bash
# If we use '$0', it means this file when it called by bash, and the calling file when it called by source 
# (the latter is the same as writting the code of called file into the calling file). 
# "source SetUpData.sh" is witten in default do files. 
SCRIPTDIR=${SCRIPT%/*}

while getopts hi:l:o:t: OPTION; do
    case $OPTION in
        "h") usage ; exit 1;;
        "i") wholebraintract=$OPTARG ;;
        "l") roiccdiv=$OPTARG ;;
        "o") roicc_outdir=$OPTARG ;;
        "t") roicc_tract_head=$OPTARG ;;
    esac
done
#echo "ccdivroi : ${ccdivroi}  (in tractography.sh)"
#echo "outputdir: ${outputdir}"

# set variables
#logfile=${logdir}/${case}.cc_FW.log
logfile=${roicc_outdir}/${roicc_tract_head}.log    # There would be 

# start logging

_tmplog=$(mktemp).log
echo "_tmplog $_tmplog"
exec &> >(tee "$_tmplog")  # pipe stderr and stdout to logfile as well as console
echo 'exec &> >(tee "$_tmplog")'  # pipe stderr and stdout to logfile as well as console

[ -d ${casedir} ] || mkdir ${casedir}

# tract_querier needs nifti format as a label map

base() {
    filename=${1##*/}
    if [[ $filename == *.gz ]]; then
        echo ${filename%.*.gz}
    else
        echo ${filename%.*}
    fi
}

if [[ ${roiccdiv} != *nii || ${roiccdiv} != *nii.gz ]]; then
    tmpnii=/tmp/$(base "${roiccdiv}").nii.gz
    echo "label map is nrrd, convert to nifti: '$tmpnii'"
    ConvertBetweenFileFormats ${roiccdiv} $tmpnii
    echo "ConvertBetweenFileFormats ${roiccdiv} $tmpnii"
    roiccdiv=$tmpnii
    echo "roiccdiv=$tmpnii"
fi


filenamehead=${roicc_tract_head}
outdir=${roicc_outdir}    # I dont know wheter we can use . or not. 
roicc_query=${SCRIPTDIR}/roicc_query.qry

[ -d ${roicc_outdir} ] || mkdir ${roicc_outdir}

# without --query_selectio noption, create all tracts in the query file
cmd="
tract_querier \\
    -t ${wholebraintract} \\
    -a ${roiccdiv} \\
    -q ${roicc_query} \\
    -o ${outdir}/${filenamehead}"
echo "${cmd}"
eval "${cmd}"

cmd="
activate_tensors.py ${outdir}/${filenamehead}_cc_1.vtk ${outdir}/${filenamehead}_cc_1.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc_2.vtk ${outdir}/${filenamehead}_cc_2.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc_3.vtk ${outdir}/${filenamehead}_cc_3.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc_4.vtk ${outdir}/${filenamehead}_cc_4.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc_5.vtk ${outdir}/${filenamehead}_cc_5.vtk
activate_tensors.py ${outdir}/${filenamehead}_cc.vtk ${outdir}/${filenamehead}_cc.vtk
"

echo "${cmd}"
eval "${cmd}"


# stop logging
# echo "_tmplog ${_tmplog}"
#[[ -d ${logdir} ]] || mkdir ${logdir}
echo "cp $_tmplog ${logfile}"
cp $_tmplog ${logfile}

