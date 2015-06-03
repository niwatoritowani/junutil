#!/bin/bash 

usage() {
    echo "Usage: $0 [-h] [-i caseID] [-o [nothing] or _run1] [-w 1 or 2 or dwi for T1 T2] [-sn DWI series number]"
    exit 0
}

operation=""
seriesnumber=""
while getopts hi:o:w:sn: OPTION; do
    case $OPTION in
        h) usage ;;
        i) caseid=$OPTARG ;;
        o) operation=$OPTARG ;;
        w) mriweighting=$OPTARG ;;
        sn) serisnumber=$OPTARG ;;
    esac
done

if [[ ! -n "${caseid}" ]]; then
    echo "You must input -i caseID."; exit 1
fi

if [[ "${mriweighting}" != 1 && "${mriweighting}" != 2 && "${mriweighting}" != "dwi" ]]; then
    echo "You must input -w 1 or 2 or dwi."; exit 1
fi

projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}

if [[ ! -e "${casedir}" ]]; then
    echo " ${casedir} does not exist. "; exit 1
fi

if [[ ${mriweighting} = 1 ]]; then
    newdir=strct/orig-space
    partofname=t${mriweighting}w${operation}
    if [[ -e ${casedir}/T${mriweighting}${operation} ]]; then
        originaldicomdirname=T${mriweighting}${operation}
    else
        echo "original dicom directory doesn't exist."; exit 1
    fi
    cmdD2N="ConvertBetweenFileFormats ${caseid}-${partofname}-dicom ${caseid}-${partofname}.nrrd"
    if [[ ! -e ${casedir}/strct ]]; then mkdir ${casedir}/strct; fi
elif [[ ${mriweighting} = 2 ]]; then
    newdir=strct/orig-space
    partofname=t${mriweighting}w
    if [[ -e ${casedir}/T${mriweighting} ]]; then
        originaldicomdirname=T${mriweighting}
    elif [[ -e ${casedir}/T${mriweighting}W ]]; then
        originaldicomdirname=T${mriweighting}W
    else
        echo "original dicom directory doesn't exist."; exit 1
    fi
    cmdD2N="ConvertBetweenFileFormats ${caseid}-${partofname}-dicom ${caseid}-${partofname}.nrrd"
    if [[ ! -e ${casedir}/strct ]]; then mkdir ${casedir}/strct; fi
elif [[ ${mriweighting} = "dwi" ]]; then
    newdir=diff-jun
    partofname=${mriweighting}
    if [[ -e "${casedir}/raw/${caseid}-dwi" ]]; then
        originaldicomdirname="raw/${caseid}-dwi"
    else
        echo "original dicom directory doesn't exist."; exit 1
    fi
    cmdD2N="DWIConvert --inputDicomDirectory  ${caseid}-${partofname}-dicom --outputVolume ${caseid}-${partofname}.nrrd"
fi

if [[ -d "${casedir}/${newdir}/${partofname}-dicom" ]]; then
    echo " ${newdir}/${partofname}-dicom directory is already exists. "; exit 1
fi

if [[ -d "${casedir}/${newdir}/${caseid}-${partofname}-dicom" ]]; then
    echo " ${newdir}/${caseid}-${partofname}-dicom directory is already exists. "; exit 1
fi

command=$(basename $0)
echo "start ${command}" | tee /tmp/log.log
echo "
caseid is ${caseid}
mriweighting is ${mriweighting}
operation is ${operation}, partofname is ${partofname}
original dicom directory name is ${originaldicomdirname}
serisnumber is ${seriesnumber}
" | tee -a /tmp/log.log

# set cmdcp

if [[ -n ${seriesnumber} ]]; then 
    seriesnumberf=$(printf "%09d" ${seriesnumber});
    cmdcp="cp ${originaldicomdirname}/*-${seriesnumberf}-*.dcm.gz ${newdir}/${caseid}-${partofname}-dicom"
    else cmdcp="cp ${originaldicomdirname}/*.dcm.gz ${newdir}/${caseid}-${partofname}-dicom"
fi

cmd="cd ${casedir};
mkdir ${newdir};
mkdir ${newdir}/${caseid}-${partofname}-dicom;
${cmdcp};
gunzip ${newdir}/${caseid}-${partofname}-dicom/*.dcm.gz;
cd ${newdir};
${cmdD2N};
axis_align_nrrd.py --infile ${caseid}-${partofname}.nrrd --outfile ${caseid}-${partofname}-x.nrrd;
center.py -i ${caseid}-${partofname}-x.nrrd -o ${caseid}-${partofname}-xc.nrrd;"

echo "$cmd" "\n" 2>&1 | tee -a /tmp/log.log 
eval $cmd 2>&1 | tee -a /tmp/log.log

mv /tmp/log.log ${casedir}/${newdir}/${caseid}-${partofname}-${command}.log


