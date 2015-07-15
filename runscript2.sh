#!/bin/bash
# script name runscript2.sh

usage() {
    echo "Usage: $0 [caselist file] [output directoryname under caseproject directory]"
    exit 0
}

while getopts h OPTION; do
    case $OPTION in
        h) usage ;;
    esac
done

# set variables
caselist=$1    # file name
echo "set caselist ${caselist}"
script="/projects/schiz/3Tprojects/2015-delre-corpuscallosum/tractographyandmeasure3.sh"
echo "set script ${script}"

# set 
cases=$(cat ${caselist})    # caseid separated by line break
echo "set cases from caselist"

# for case in ${cases}; do    # variable cases is expanded separated by space (because of bash)
# #    cmd="$(echo \"${script}\")"" ""${case}"
# #    eval "${cmd}"
#     /projects/schiz/3Tprojects/2015-delre-corpuscallosum/tractographyandmeasure.sh ${case}
# done

for caseid in ${cases}; do    # variable cases is expanded separated by space (because of bash)
    
    # check whether case project directory exist
    casedir=/projects/schiz/3Tdata/case${caseid}
    echo "set casedir ${casedir}"
    if [[ ! -d ${casedir} ]]; then echo "${casedir} does not exist"; exit 1; fi
    
    caseprojdir=${casedir}/projects/2015-delre-corpuscallosum
    echo "set caseprojdir ${caseprojdir}"
    if [[ ! -d ${caseprojdir} ]]; then echo "${caseprojdir} does not exist"; exit 1; fi
    
    # set output directory
    outputdir=${caseprojdir}/$2
    if [[ -e ${outputdir} ]]; then
        mkdir ${outputdir}
        echo "make directory outputdir ${outputdir}"
    else 
        echo "${outputdir} already exists and output directory is set to the directory"
    fi

    echo "run ${script} for ${caseid}"
    cmd="${script} ${caseid} ${2}"
    scriptname=$(basename ${script})
    logfilename=${scriptname}.log
    logfile=${outputdir}/${logfilename}
    if [[ -e ${logfile} ]]; then echo "${logfile} already exists"; exit 1; fi
    echo "${cmd}" | tee ${logfile}
    eval "${cmd}" 2>&1 | tee -a ${logfile}
    echo "done"
done

