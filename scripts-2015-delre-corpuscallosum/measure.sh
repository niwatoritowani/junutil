#!/bin/bash

# calculate diffusion values in a vtk file and output as a file
# usage: $0 [case id]

# start logging
_tmplog=$(mktemp).log
exec &> >(tee "$_tmplog")  # pipe stderr and stdout to logfile as well as console

# set variables
base=/projects/schiz/3Tprojects/2015-delre-corpuscallosum
caseid=$1
echo "SetUpData file  ${base}/scripts/SetUpData.sh"
source ${base}/scripts/SetUpData.sh

echo "roicc_outdir ${roicc_outdir}"
if [ ! -d ${roicc_outdir} ]; then 
    echo "no input"; exit 1
fi

cmd="
/projects/schiz/software/slicer/Slicer-4.5.0-1-linux-amd64/Slicer \\
    --launch /projects/schiz/software/slicer/Slicer-4.5.0-1-linux-amd64/lib/Slicer-4.5/cli-modules/FiberTractMeasurements \\
    --format Row_Hierarchy \\
    --outputfile ${measured} \\
    --inputdirectory ${roicc_outdir} \\
    --inputtype Fibers_File_Folder
"
echo "${cmd}"
eval "${cmd}"


# stop logging
[[ -d ${logdir} ]] || mkdir ${logdir}
echo "cp $_tmplog ${logfile}"
cp $_tmplog ${logfile}

