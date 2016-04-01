#!/bin/bash

usage() {
    echo "output tracts and measure them"
    echo "Usage: $0 [case ID]"
    exit 0
}

while getopts h OPTION; do
    case $OPTION in
        h) usage ;;
    esac
done

# start logging
_tmplog=$(mktemp).log
#echo "_tmplog $_tmplog"
exec &> >(tee "$_tmplog")  # pipe stderr and stdout to logfile as well as console
#echo 'exec &> >(tee "$_tmplog")'  # pipe stderr and stdout to logfile as well as console

# set variables
caseid=$1
casedir=/projects/schiz/3Tdata/case${caseid}
caseprojdir=${casedir}/projects/2015-delre-corpuscallosum
ccdivroi=${caseprojdir}/${caseid}-cc-div-roi.nrrd
ccroi=${caseprojdir}/${caseid}-cc-roi.nrrd
outputdir=${caseprojdir}/${caseid}.cc_FW
logdir=${caseprojdir}/log
logfile=${logdir}/${caseid}.cc_FW.log

if [[ ! -d ${casedir} ]]; then echo "${casedir} does not exist"; exit 1; fi
if [[ ! -d ${caseprojdir} ]]; then echo "${caseprojdir} does not exist"; exit 1; fi

# check and set dwi file name and diffusion mask file name
if [[ -e ${casedir}/diff/${caseid}-dwi-filt-Ed.nhdr ]]; then
    dwifile="${casedir}/diff/${caseid}-dwi-filt-Ed.nhdr"
elif [[ -e ${casedir}/diff/${caseid}-dwi-Ed.nhdr ]]; then
    dwifile="${casedir}/diff/${caseid}-dwi-Ed.nhdr"
else
    echo "dwi file does not exist"; exit 1
fi

if [[ -e ${casedir}/diff/Tensor_mask-${caseid}-dwi-filt-Ed_AvGradient-edited.nhdr ]]; then
    maskfile="${casedir}/diff/Tensor_mask-${caseid}-dwi-filt-Ed_AvGradient-edited.nhdr"
elif [[ -e ${casedir}/diff/Tensor_mask-${caseid}-dwi-Ed_AvGradient-edited.nhd ]]; then
    maskfile="${casedir}/diff/Tensor_mask-${caseid}-dwi-Ed_AvGradient-edited.nhd"
else
    echo "dwi file does not exist"; exit 1
fi

echo "set dwifile ${dwifile}"
echo "set maskfile ${maskfile}"

# create whole corpus callosum ROI if it does not exist
# create binary image data where greater than intensity 0 
# (any label has any intensity other than 0).
# and save by \"unu save\"
if [[ ! -e ${ccroi} ]]; then
    unu 2op gt ${ccdivroi} 0 | unu save -e gzip -f nrrd -o ${ccroi}
    echo "create ${ccroi}"
else
    echo "${ccroi} already exists"
fi

# create output directory if it does not exist and move to the directory
if [ -d ${outputdir} ]; then
    echo "${outputdir} already exists."; exit 1
else
    mkdir ${outputdir}
fi

pushd ${outputdir}
echo "move to ${outputdir}"

# set tractgraphy option
tractographyoption="\
    --recordTensors \
    --freeWater \
    --recordFreeWater"
echo "tractographyoption ${tractographyoption}"

# run UKFTractography
functractography() {
    if [[ -e $3 ]]; then 
        echo "$3 already exists" 
    else
        cmdtractography="UKFTractography \\
            --dwiFile ${dwifile} \\
            --maskFile ${maskfile} \\
            --seedsFile $1 \\
            --labels $2 \\
            --tracts $3 \\
            ${tractographyoption}"
        echo "${cmdtractography}"
        eval "${cmdtractography}"
    fi
}

functractography ${caseprojdir}/${caseid}-cc-roi.nrrd 1 ${outputdir}/${caseid}-cc-ukf.vtk
functractography ${caseprojdir}/${caseid}-cc-div-roi.nrrd 241 ${outputdir}/${caseid}-cc-div1-ukf.vtk
functractography ${caseprojdir}/${caseid}-cc-div-roi.nrrd 242 ${outputdir}/${caseid}-cc-div2-ukf.vtk
functractography ${caseprojdir}/${caseid}-cc-div-roi.nrrd 243 ${outputdir}/${caseid}-cc-div3-ukf.vtk
functractography ${caseprojdir}/${caseid}-cc-div-roi.nrrd 244 ${outputdir}/${caseid}-cc-div4-ukf.vtk
functractography ${caseprojdir}/${caseid}-cc-div-roi.nrrd 245 ${outputdir}/${caseid}-cc-div5-ukf.vtk

# # measure tracts
# cmd="measureTracts.py \
#     -i ${caseid}-cc-ukf.vtk \
#         ${caseid}-cc-div1-ukf.vtk \
#         ${caseid}-cc-div2-ukf.vtk \
#         ${caseid}-cc-div3-ukf.vtk \
#         ${caseid}-cc-div4-ukf.vtk \
#         ${caseid}-cc-div5-ukf.vtk \
#     -o ${caseid}-cc-ukf-values.csv"
# echo "${cmd}"
# eval "${cmd}"
# echo "measureTracts.py is done"

# # log
# scriptname=$(basename $0)
# logfilename=${scriptname}.log
# echo "${cmd}" | tee ${logfilename}
# eval "${cmd}" 2>&1 | tee -a ${logfilename}

# stop logging
# echo "_tmplog ${_tmplog}"
[[ -d ${logdir} ]] || mkdir ${logdir}
echo "cp $_tmplog ${logfile}"
cp $_tmplog ${logfile}

