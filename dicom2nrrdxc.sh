#!/bin/bash 

usage() {
    echo "Usage: $0 [-h] [-i caseID] [-w 1 or 2 or dwi for T1 T2] [-s DWI series number]"
    exit 0
}

operation=""
seriesnumber=""
while getopts hi:w:s: OPTION; do
    case $OPTION in
        h) usage ;;
        i) caseid=$OPTARG ;;
        w) mriweighting=$OPTARG ;;
        s) seriesnumber=$OPTARG ;;
    esac
done

if [[ -z "${caseid}" ]] || \
    [[ "${mriweighting}" != 1 ]] && [[ "${mriweighting}" != 2 ]] && [[ "${mriweighting}" != "dwi" ]]; then
    usage
fi

projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}

if [[ ! -e "${casedir}" ]]; then
    echo " ${casedir} does not exist. "; exit 1
fi

# set newdir, partofname, originaldicomdirname and cmdD2N

if [[ ${mriweighting} = 1 ]]; then
    if [[ -e ${casedir}/T${mriweighting}_run1 ]]; then
        operation=_run1
    elif [[ -e ${casedir}/T${mriweighting} ]]; then
        operation=""
    else
        echo "original dicom directory doesn't exist."; exit 1
    fi
    originaldicomdirname=T${mriweighting}${operation}
    newdirname=strct_jun/orig-space
    partofname=t${mriweighting}w${operation}
    cmdD2N="ConvertBetweenFileFormats ${caseid}-${partofname}-dicom ${caseid}-${partofname}.nrrd"
    if [[ ! -e ${casedir}/strct_jun ]]; then mkdir ${casedir}/strct_jun; fi
elif [[ ${mriweighting} = 2 ]]; then
    if [[ -e ${casedir}/T${mriweighting} ]]; then
        originaldicomdirname=T${mriweighting}
    elif [[ -e ${casedir}/T${mriweighting}W ]]; then
        originaldicomdirname=T${mriweighting}W
    else
        echo "original dicom directory doesn't exist."; exit 1
    fi
    newdirname=strct_jun/orig-space
    partofname=t${mriweighting}w
    cmdD2N="ConvertBetweenFileFormats ${caseid}-${partofname}-dicom ${caseid}-${partofname}.nrrd"
    if [[ ! -e ${casedir}/strct_jun ]]; then mkdir ${casedir}/strct_jun; fi
elif [[ ${mriweighting} = "dwi" ]]; then
    if [[ -e "${casedir}/raw/${caseid}-dwi" ]]; then
        originaldicomdirname="raw/${caseid}-dwi"
    else
        echo "original dicom directory doesn't exist."; exit 1
    fi
    newdirname=diff_jun
    partofname=${mriweighting}
    cmdD2N="DWIConvert --inputDicomDirectory  ${caseid}-${partofname}-dicom --outputVolume ${caseid}-${partofname}.nrrd"
fi

newdir=${casedir}/${newdirname}
originaldicomdir=${casedir}/${originaldicomdirname}

if [[ -d "${newdir}/${partofname}-dicom" ]]; then
    echo " ${newdir}/${partofname}-dicom directory is already exists. "; exit 1
fi

if [[ -d "${newdir}/${caseid}-${partofname}-dicom" ]]; then
    echo " ${newdir}/${caseid}-${partofname}-dicom directory is already exists. "; exit 1
fi

# set cmdcp

if [[ -n ${seriesnumber} ]]; then 
    seriesnumberf=$(printf "%09d" ${seriesnumber});
    cmdcp="cp ${originaldicomdir}/*-${seriesnumberf}-*.dcm.gz ${newdir}/${caseid}-${partofname}-dicom"
    else cmdcp="cp ${originaldicomdir}/*.dcm.gz ${newdir}/${caseid}-${partofname}-dicom"
fi

# show variables and run script

command=$(basename $0)
echo "start ${command}" | tee /tmp/log.log
echo "
caseid is ${caseid}
mriweighting is ${mriweighting}
operation is ${operation}, partofname is ${partofname}
original dicom directory is ${originaldicomdir}
serisnumber is ${seriesnumber} -> ${seriesnumberf}
" | tee -a /tmp/log.log

cmd="
cd ${casedir}
if [[ ! -e ${newdir} ]]; then mkdir ${newdir}; fi
mkdir ${newdir}/${caseid}-${partofname}-dicom
${cmdcp}
gunzip ${newdir}/${caseid}-${partofname}-dicom/*.dcm.gz
cd ${newdir}
${cmdD2N}
axis_align_nrrd.py --infile ${caseid}-${partofname}.nrrd --outfile ${caseid}-${partofname}-x.nrrd
/home/jkonishi/junutil/center_jun.py -i ${caseid}-${partofname}-x.nrrd -o ${caseid}-${partofname}-xc.nrrd
"
echo "$cmd" | tee -a /tmp/log.log 
eval "$cmd" 2>&1 | tee -a /tmp/log.log
mv /tmp/log.log ${newdir}/${caseid}-${partofname}-${command}.log


