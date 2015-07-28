#!/bin/bash

NEW_DIR=/rfanfs/pnl-a/pnl/Collaborators/Delisi
NEW_PPL_DIR=${NEW_DIR}/pipelines
ORG_FS_DIR=/projects/pnl/3Tdata/freesurfer-pipeline
ORG_PPL_DIR=/projects/schiz/3Tprojects/2014-delre-masking/pipelines

# freesurfer-pipeline（newly copy from ${ORG_FS_DIR} to ${NEW_PPL_DIR}/freesurfer-pipeline）
# - realign-edrmasks-pipeline (newly copy to ${NEW_PPL_DIR}/realign-edrmasks-pipeline)
# - - realign-pipeline (newly copy to ${NEW_PPL_DIR}/realign-pipeline)
#
# This script is located in ${NEW_DIR} 
#

mkdir ${NEW_DIR}/pipelines
cd ${NEW_DIR}/pipelines
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
echo -n ${NEW_DIR}/pipelines/realign-edrmasks-pipeline/\$case.t1-realign-masked.nrrd
# #[config/NONSKULLSTRIP] set nonskulstrip
# echo -n > config/NONSKULLSTRIP

#[realign-edrmasks-pipeline]
cd ${NEW_PPL_DIR}/realign-edrmasks-pipeline
#copy necessary files
cp ${ORG_PPL_DIR}/realign-edrmasks-pipeline/default.mask-realign.nrrd.do .
cp ${ORG_PPL_DIR}/realign-edrmasks-pipeline/default.t1-realign-masked.nrrd.do .
mkdir scripts
mkdir config
cp -r ${ORG_PPL_DIR}/realign-edrmasks-pipeline/scripts/applyxfm.sh scripts/applyxfm.sh
#[config/XFM]
echo -n ${NEW_PPL_DIR}/realign-pipeline/\$case.xfm > config/XFM
#[config/STRUCTURAL]
echo -n	${NEW_DIR}/masks-fromcluster/\$case.atlasmask.thresh50-edr.nrrd > config/STRUCTURAL
#[config/REALIGN_T1]
echo -n ${NEW_DIR}/dicom_to_nifti/data/\$case/T1/\$case-T1.nrrd > config/REALIGN_T1

#[realign-pipeline]
cd ${NEW_PPL_DIR}/realign-pipeline
#copy necessary files
cp ${ORG_PPL_DIR}/realign-pipeline/default.xfm.do .
mkdir config
#[config/REALIGN_T1]
echo -n ${NEW_DIR}/dicom_to_nifti/data/\$case/T1/\$case-T1.nrrd > config/REALIGN_T1
#[config/T2]
echo -n ${NEW_DIR}/dicom_to_nifti/data/\$case/T2/\$case-T2.nrrd > config/T2

