#!/bin/bash -eu

# usage: $0 [caseid] [hemi(lh or rh)]
# cd inter-rater directory and create files

caseid=$1
hemi=$2

# original files
# in /projects/schiz/ra/melissa/Thesis_Project/StriaDTI/FEschiz_stria/${hemi}_stria/${caseid}
#     ${hemi} is lh or rh
#     diffusion_mask : Otsu Threshold Mask.nrrd
#     baseline       : Output Baseline Volume.nrrd
#     DTI_header     : Output DTI Volume.nhdr
#     DTI_data       : Output DTI Volume.raw.gz
#     ROI            : Output Baseline Volume-label.nrrd
#     slicer_scene   : SlicerScene1.mrml
# DWI_nhdr : /projects/schiz/3Tdata/case${caseid}/diff/${caseid}-dwi-Ed.nhdr

# set case directory and original data path
casedir=/projects/schiz/ra/melissa/Thesis_Project/StriaDTI/FEschiz_stria/${hemi}_stria/${caseid}
#     - ${hemi} is lh or rh
diffusion_mask="${casedir}/Otsu Threshold Mask.nrrd"
DTI_baseline="${casedir}/Output Baseline Volume.nrrd"
DTI_header="${casedir}/Output DTI Volume.nhdr"
DTI_data="${casedir}/Output DTI Volume.raw.gz"
# ROI=${casedir}"/Output Baseline Volume-label.nrrd"
#     - do not create copy because I will create new file
# slicer_scene=${casedir}/"SlicerScene1.mrml"
#    -  do not create copy
# DWI_nhdr="/projects/schiz/3Tdata/case${caseid}/diff/${caseid}-dwi-Ed.nhdr"
#    - do not create copy because not needed

# set inter-rater directory and move to the directory
interraterdir=/projects/schiz/ra/melissa/Thesis_Project/interraterreliability
cd ${interraterdir}

# create data directory if they don't exist
if [ ! -e ${hemi}_stria ]; then
    mkdir ${hemi}_stria
fi
if [ ! -e ${hemi}_stria/${caseid} ]; then
    mkdir ${hemi}_stria/${caseid}
fi

# set output directory
outputdir=${hemi}_stria/${caseid}

# create symbolic link in output directory
cmd="
ln -s \"${diffusion_mask}\" \"${outputdir}/Otsu Threshold Mask.nrrd\"
ln -s \"${DTI_baseline}\" \"${outputdir}/Output Baseline Volume.nrrd\"
ln -s \"${DTI_header}\" \"${outputdir}/Output DTI volume.nhdr\"
ln -s \"${DTI_data}\" \"${outputdir}/Output DTI Volume.raw.gz\"
"

# output command text and run command
echo "${cmd}"
eval "${cmd}"

