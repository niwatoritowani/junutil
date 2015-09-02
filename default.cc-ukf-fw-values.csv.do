#!/bin/bash
# script name default.cc-ukf-fw-values.csv.do

# todo
#     caseid ... extract caseid from filename 

usage() {
msg= "
 usage
    redo ${case}/diff/${case}.cc-ukf-fw-values.csv
    $1 : ${case}.cc-ukf-fw-values.csv
    $2 : ${case}.cc-ukf-fw-values
    $3 : ${case}.cc-ukf-fw-values.csv (output)
"
    echo "${msg}"
    exit 0
}

while getopts h OPTION; do
    case $OPTION in
        h) usage ;;
    esac
done



# set variables
caseid=$2
    #echo "set caseid ${caseid}"
casedir=/projects/schiz/3Tdata/case${caseid}
    #echo "set casedir ${casedir}"
casediffdir=${casedir}/diff
    #echo "set casediffdir ${caseprojdir}"

if [[ ! -d ${casedir} ]]; then echo "${casedir} does not exist"; exit 1; fi
if [[ ! -d ${casediffdir} ]]; then echo "${caseprojdir} does not exist"; exit 1; fi

dwifile=${casediffdir}/${caseid}.dwi-epi.nhdr
maksfile=${casediffdir}/${caseid}-tensor-mask.nrrd

if [[ ! -e ${dwifile} ]]; then echo "${dwifile} does not exist"; exit 1; fi
if [[ ! -e ${maskfile} ]]; then echo "${maskfile} does not exist"; exit 1; fi

# create whole corpus callosum ROI if it does not exist
#     create binary image data where greater than intensity 0 
#     (any label has any intensity other than 0).
#     and save by \"unu save\"
ccroifile=${casediffdir}/${caseid}.cc-roi.nrrd
ccdivroifile=${casediffdir}/${caseid}.cc-div-roi.nrrd
if [[ ! -e ${ccroifile} ]]; then
    unu 2op gt ${ccdivroifile} 0 | unu save -e gzip -f nrrd -o ${ccroifile}
    echo "create ${ccroifile}"
fi

# create output directory if it does not exist and move to the directory
outputdir=${casediffdir}/freewater
if [[ ! -e ${outputdir} ]]; then
    mkdir ${outputdir}; cd ${outputdir}
    echo "make directory ${outputdir} and move to the directory"
else
    cd ${outputdir}
    echo "output directory ${outputdir} already exist and move to the directory"
fi

# set tractgraphy option
tractographyoption="--recordTensors --freeWater --recordFreeWater"
echo "tractographyoption ${tractographyoption}"

# set "cctract" and an array "ccdivtracts"
cctract=${caseid}.cc-ukf-fw.vkt
for i in 0 1 2 3 4; do
    j=$(expr ${i} + 1)
    ccdivtracts[i]=${caseid}.cc-div${j}-ukf-fw.vkt
done 

# run UKFTractography
functractography() {
    if [[ -e $3 ]]; then echo "$3 already exists"; exit 1; fi
    cmdtractography="UKFTractography \\
        --dwiFile ${dwifile} \\
        --maskFile ${maskfile} \\
        --seedsFile $1 \\
        --labels $2 \\
        --tracts $3 \\
        ${tractographyoption}"
    echo "${cmdtractography}"
    eval "${cmdtractography}"
    echo "UKFTractography is done"
}

functractography ${ccroifile} 1 ${cctract}
for i in 0 1 2 3 4; do
    j=$(expr ${1} + 1)
    functractography ${ccdivtracts} 24${j} ${ccdivfiles[i]}
done

# measure tracts
cmd="measureTracts.py \\
    -i ${cctract} \\
        ${ccdivtracts[@]} \\
    -o ${3}"
echo "${cmd}"
eval "${cmd}"
echo "measureTracts.py is done"

# # log
# scriptname=$(basename $0)
# logfilename=${scriptname}.log
# echo "${cmd}" | tee ${logfilename}
# eval "${cmd}" 2>&1 | tee -a ${logfilename}

