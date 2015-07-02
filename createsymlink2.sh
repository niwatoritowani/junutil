#!/bin/bash -eu

caseid=$1
hemi=$2

# usage: $0 [caseid] [hemi(lh or rh)]
# ## create files in current directory
# cd inter-rater directory

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


casedir=/projects/schiz/ra/melissa/Thesis_Project/StriaDTI/FEschiz_stria/${hemi}_stria/${caseid}
#     ${hemi} is lh or rh
     diffusion_mask="${casedir}/Otsu Threshold Mask.nrrd"
     DTI_baseline="${casedir}/Output Baseline Volume.nrrd"
     DTI_header="${casedir}/Output DTI Volume.nhdr"
     DTI_data="${casedir}/Output DTI Volume.raw.gz"
#     ROI=${casedir}"/Output Baseline Volume-label.nrrd"
#     slicer_scene=${casedir}/"SlicerScene1.mrml"
# DWI_nhdr="/projects/schiz/3Tdata/case${caseid}/diff/${caseid}-dwi-Ed.nhdr"

interraterdir=/projects/schiz/ra/melissa/Thesis_Project/interraterreliability
cd ${interraterdir}

if [ ! -e ${hemi}_stria ]; then
    mkdir ${hemi}_stria
fi
if [ ! -e ${hemi}_stria/${caseid} ]; then
    mkdir ${hemi}_stria/${caseid}
fi


outputdir=${hemi}_stria/${caseid}


cmd="
ln -s \"${diffusion_mask}\" \"${outputdir}/Otsu Threshold Mask.nrrd\"
ln -s \"${DTI_baseline}\" \"${outputdir}/Output Baseline Volume.nrrd\"
ln -s \"${DTI_header}\" \"${outputdir}/Output DTI volume.nhdr\"
ln -s \"${DTI_data}\" \"${outputdir}/Output DTI Volume.raw.gz\"
"
echo "${cmd}"
eval "${cmd}"

