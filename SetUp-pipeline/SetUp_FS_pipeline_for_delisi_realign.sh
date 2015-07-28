#!/bin/bash

NEW_DIR=/rfanfs/pnl-a/pnl/Collaborators/Delisi
NEW_PPL_DIR=${NEW_DIR}/pipelines-realign
ORG_FS_DIR=/projects/pnl/3Tdata/freesurfer-pipeline
ORG_PPL_DIR=/projects/schiz/3Tprojects/2014-delre-masking/pipelines

# freesurfer-pipeline（copy from ${ORG_FS_DIR} to ${NEW_PPL_DIR}）
# - realign-edrmasks-pipeline (copy from ${ORG_PPL_DIR} to ${NEW_PPL_DIR})
# - - realign-pipeline (copy from ${ORG_PPL_DIR} to ${NEW_PPL_DIR})
#
# This script is located in ${NEW_DIR} 
#
# You can create a new nemed pipeline directory, 
# by changing the name of "${NEW_PPL_DIR}". 
# 
# Changes should be made 
# in realign-edrmasks-pipeline/default.mask-realign.nrrd.do
#   change in line 6: 
#       redo-ifchange $XFM $STRUCTURAL
#       -> redo-ifchange $XFM # $STRUCTURAL
# in realign-pipeline/default.xfm.do
#   change in line 5:
#       redo-ifchange config/REALIGN_T1 config/T2 $T1 $T2
#       -> #redo-ifchange config/REALIGN_T1 config/T2 $T1 $T2
#

if [ -d ${NEW_PPL_DIR} ]; then
    echo "${NEW_PPL_DIR} already exists, delete it if you would like to recompute it"
    exit 1
fi

mkdir ${NEW_PPL_DIR}
cd ${NEW_PPL_DIR}
mkdir freesurfer-pipeline
mkdir realign-edrmasks-pipeline
mkdir realign-pipeline

#[freesurfer-pipeline]
cd ${NEW_PPL_DIR}/freesurfer-pipeline
#copy necessary files
cp ${ORG_FS_DIR}/default.do .
cp ${ORG_FS_DIR}/default.freesurfer.do .
mkdir config
mkdir scripts
cp ${ORG_FS_DIR}/scripts/fs.sh scripts/fs.sh
cp ${ORG_FS_DIR}/scripts/mask.sh scripts/mask.sh
#[config/FREESURFER_HOME]
echo -n /projects/schiz/ra/eli/freesurfer5.3 > config/FREESURFER_HOME
#[config/T1S_FILEPATTERN]
echo -n ${NEW_PPL_DIR}/realign-edrmasks-pipeline/\$case.t1-realign-masked.nrrd > config/T1S_FILEPATTERN
# #[config/NONSKULLSTRIP] set nonskulstrip. Thiis file does not exist in ${ORG_FS_DIR}.
# echo -n > config/NONSKULLSTRIP

#[realign-edrmasks-pipeline]
cd ${NEW_PPL_DIR}/realign-edrmasks-pipeline
#copy necessary files
cp ${ORG_PPL_DIR}/realign-edrmasks-pipeline/default.mask-realign.nrrd.do .
cp ${ORG_PPL_DIR}/realign-edrmasks-pipeline/default.t1-realign-masked.nrrd.do .
mkdir scripts
mkdir config
cp ${ORG_PPL_DIR}/realign-edrmasks-pipeline/scripts/applyxfm.sh scripts/applyxfm.sh
#[config/XFM]
echo -n ${NEW_PPL_DIR}/realign-pipeline/\$case.xfm > config/XFM
#[config/STRUCTURAL]
echo -n	${NEW_DIR}/masks-fromcluster/\$case.atlasmask.thresh50-edr.nrrd > config/STRUCTURAL
#[config/REALIGN_T1]
echo -n ${NEW_DIR}/\$case/align-space/\$case-t1w-realign.nrrd > config/REALIGN_T1

#[realign-pipeline]
cd ${NEW_PPL_DIR}/realign-pipeline
#copy necessary files
cp ${ORG_PPL_DIR}/realign-pipeline/default.xfm.do .
mkdir config
#[config/REALIGN_T1]
echo -n ${NEW_DIR}/\$case/align-space/\$case-t1w-realign.nrrd > config/REALIGN_T1
#[config/T2]
echo -n ${NEW_DIR}/dicom_to_nifti/data/\$case/T2/\$case-T2.nrrd > config/T2
