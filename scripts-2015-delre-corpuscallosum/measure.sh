#!/bin/bash

# calculate diffusion values in a vtk file and output as a file
# usage: $0 [case id]

base=/projects/schiz/3Tprojects/2015-delre-corpuscallosum
case=$1
source ${base}/scripts/SetUp.sh

[ -d ${roicc_outdir} ] || echo "no input"; exit 1

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

