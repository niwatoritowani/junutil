#!/bin/bash

### !!!This file is under construction!!! ###

usage() {
    echo "output tracts and measure them"
    echo "Usage: [input]"
    exit 0
}

while getopts hi:m:l:t:o:c: OPTION; do
    case $OPTION in
        "h") usage ; exit 1;;
        "i") dwifile=$OPTARG ;;
        "m") maskfile=$OPTARG ;;
        "l") ccdivroi=$OPTARG ;;
        "t") ccroi=$OPTARG ;;
        "o") outputdir=$OPTARG ;;
        "c") case=$OPTARG ;;
    esac
done
#echo "ccdivroi : ${ccdivroi}  (in tractography.sh)"
#echo "outputdir: ${outputdir}"
echo "case: ${case}"

# set variables
#logfile=${logdir}/${case}.cc_FW.log
logfile=${outputdir}/log    # There would be 

# start logging
_tmplog=$(mktemp).log
#echo "_tmplog $_tmplog"
exec &> >(tee "$_tmplog")  # pipe stderr and stdout to logfile as well as console
#echo 'exec &> >(tee "$_tmplog")'  # pipe stderr and stdout to logfile as well as console

# create whole corpus callosum ROI if it does not exist
# create binary image data where greater than intensity 0 
# (any label has any intensity other than 0).
# and save by \"unu save\"
if [[ ! -e ${ccroi} ]]; then
    echo "${ccroi} does not exist"
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

pushd ${outputdir} > /dev/null
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

functractography ${ccroi} 1 ${outputdir}/${case}-cc-ukf.vtk
functractography ${ccdivroi} 241 ${outputdir}/${case}-cc-div1-ukf.vtk
functractography ${ccdivroi} 242 ${outputdir}/${case}-cc-div2-ukf.vtk
functractography ${ccdivroi} 243 ${outputdir}/${case}-cc-div3-ukf.vtk
functractography ${ccdivroi} 244 ${outputdir}/${case}-cc-div4-ukf.vtk
functractography ${ccdivroi} 245 ${outputdir}/${case}-cc-div5-ukf.vtk


# stop logging
# echo "_tmplog ${_tmplog}"
#[[ -d ${logdir} ]] || mkdir ${logdir}
#echo "cp $_tmplog ${logfile}"
cp $_tmplog ${logfile}

