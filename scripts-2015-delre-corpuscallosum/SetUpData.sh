# depend on project

# depend on project and case

casedir=/projects/schiz/3Tdata/case${caseid}
caseprojdir=${casedir}/projects/2015-delre-corpuscallosum
ccdivroi=${caseprojdir}/${caseid}-cc-div-roi.nrrd
ccroi=${caseprojdir}/${caseid}-cc-roi.nrrd
outputdir=${caseprojdir}/${caseid}.cc_FW


roicc_outdir=${outputdir}
measured=${caseprojdir}/${caseid}.cc_FW_measured.txt
logdir=${caseprojdir}/log

cc_FW_measured=${measured}
cc_FW_summary=${base}/stats/cc_FW_measured_summary.txt  # depend on project
caselist=${base}/caselist/caselist.20160401.txt # depend on project

# depend on project and case and script

SCRIPT=$(readlink -m "$(type -p $0)")
SCRIPTDIR=$(dirname "$SCRIPT")
SCRIPT_NAME=$(readlink -m "$0")
SCRIPT_NAME=${SCRIPT_NAME##*/}

logfile=${logdir}/${caseid}.${SCRIPT_NAME}.log
