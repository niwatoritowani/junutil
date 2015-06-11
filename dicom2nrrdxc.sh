#!/bin/bash 

usage() {
    echo "Usage: $0 [-h] [-i caseID] [-w t1w or t2w or dwi for T1 T2] [-s DWI series number]"
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
    [[ "${mriweighting}" != "t1w" ]] && [[ "${mriweighting}" != "t2w" ]] && [[ "${mriweighting}" != "dwi" ]]; then
    usage
fi

projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}

if [[ ! -e "${casedir}" ]]; then
    echo " ${casedir} does not exist. "; exit 1
fi

# set newdir, partofname, originaldicomdirname and cmdD2N

if [[ ${mriweighting} = "t1w" ]]; then
    if [[ -e ${casedir}/T1_run1 ]]; then
        operation=_run1
    elif [[ -e ${casedir}/T1 ]]; then
        operation=""
    else
        echo "original dicom directory doesn't exist."; exit 1
    fi
    originaldicomdirname=T1${operation}
    newdirname=strct_jun/orig-space
    partofname=${mriweighting}${operation}
    cmdD2N="ConvertBetweenFileFormats ${caseid}-${partofname}-dicom ${caseid}-${partofname}.nrrd"
    if [[ ! -e ${casedir}/strct_jun ]]; then mkdir ${casedir}/strct_jun; fi
elif [[ ${mriweighting} = "t2w" ]]; then
    if [[ -e ${casedir}/T2 ]]; then
        originaldicomdirname=T2
    elif [[ -e ${casedir}/T2W ]]; then
        originaldicomdirname=T2W
    else
        echo "original dicom directory doesn't exist."; exit 1
    fi
    newdirname=strct_jun/orig-space
    partofname=t2w
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
elif [[ -d "${newdir}/${caseid}-${partofname}-dicom" ]]; then
    echo " ${newdir}/${caseid}-${partofname}-dicom directory is already exists. "; exit 1
fi

# set cmdcp

if [[ -n ${seriesnumber} ]]; then 
    seriesnumberf=$(printf "%06d" ${seriesnumber});
    cmdcp="cp ${originaldicomdir}/*-${seriesnumberf}-*.dcm.gz ${newdir}/${caseid}-${partofname}-dicom"
else
    cmdcp="cp ${originaldicomdir}/*.dcm.gz ${newdir}/${caseid}-${partofname}-dicom"
fi

# show variables and run script

command=$(basename $0)
logfilename=${caseid}-${partofname}-${command}.log
echo "start ${command}" | tee /tmp/${logfilename}
echo "
caseid is ${caseid}
mriweighting is ${mriweighting}
operation is ${operation}, partofname is ${partofname}
original dicom directory is ${originaldicomdir}
serisnumber is ${seriesnumber} -> ${seriesnumberf}
" | tee -a /tmp/${logfilename}

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
echo "$cmd" | tee -a /tmp/${logfilename} 
eval "$cmd" 2>&1 | tee -a /tmp/${logfilename}
mv /tmp/${logfilename} ${newdir}/${logfilename}


