### !!!This file is under construction!!!

# SetUpData

base=$(readlink -m ${BASH_SOURCE[0]})   # read directory of this file even this file is calle by source or bash
# If we use '$0', it means this file when it called by bash, and the calling file when it called by source. 
# "source SetUpData.sh" is witten in default do files. 
base=${base%/*}
caselist=$base/caselist

# SetUpData_config

# SetUpData_pipeline

# depend on project and case
casedir=/projects/schiz/3Tdata/case${case}
caseprojdir=${casedir}/projects/2015-delre-corpuscallosum
ccdivroi=${caseprojdir}/${case}-cc-div-roi.nrrd
ccroi=${caseprojdir}/${case}-cc-roi.nrrd
#outputdir=${caseprojdir}/${case}.cc_FW
ccroi_outdir=${caseprojdir}/${case}.cc_FW

if [[ ! -d ${casedir} ]]; then echo "${casedir} does not exist"; exit 1; fi
if [[ ! -d ${caseprojdir} ]]; then echo "${caseprojdir} does not exist"; exit 1; fi

# check and set dwi file name and diffusion mask file name
if [[ -e ${casedir}/diff/${case}-dwi-filt-Ed.nhdr ]]; then
    dwifile="${casedir}/diff/${case}-dwi-filt-Ed.nhdr"
elif [[ -e ${casedir}/diff/${case}-dwi-Ed.nhdr ]]; then
    dwifile="${casedir}/diff/${case}-dwi-Ed.nhdr"
else
    echo "dwi file does not exist"; exit 1
fi

if [[ -e ${casedir}/diff/Tensor_mask-${case}-dwi-filt-Ed_AvGradient-edited.nhdr ]]; then
    maskfile="${casedir}/diff/Tensor_mask-${case}-dwi-filt-Ed_AvGradient-edited.nhdr"
elif [[ -e ${casedir}/diff/Tensor_mask-${case}-dwi-Ed_AvGradient-edited.nhd ]]; then
    maskfile="${casedir}/diff/Tensor_mask-${case}-dwi-Ed_AvGradient-edited.nhd"
else
    echo "dwi file does not exist"; exit 1
fi

echo "set dwifile ${dwifile}"
echo "set maskfile ${maskfile}"


#roicc_outdir=${outputdir}
measured=${caseprojdir}/${case}.cc_FW_measured.txt
logdir=${caseprojdir}/log

cc_FW_measured=${measured}
cc_FW_summary=${base}/stats/cc_FW_measured_summary.txt  # depend on project
caselist=${base}/caselist/caselist.20160401.txt # depend on project

# depend on project and case and script

SCRIPT=$(readlink -m "$(type -p $0)")
SCRIPTDIR=$(dirname "$SCRIPT")
SCRIPT_NAME=$(readlink -m "$0")
SCRIPT_NAME=${SCRIPT_NAME##*/}

logfile=${logdir}/${case}.${SCRIPT_NAME}.log
