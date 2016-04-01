#!/bin/bash

# calculate diffusion values in a vtk file and output as a file
# usage: $0 [case id]

base=/rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/2015-delre-corpuscallosum
case=$1
source ${base}/SetUp.sh

[ -d ${casedir} ] || mkdir ${casedir}
[ -d ${roiccdir} ] || mkdir ${roiccdir}
[ -d ${roicc_outdir} ] || mkdir ${roicc_outdir}

cmd="
/projects/schiz/software/slicer/Slicer-4.5.0-1-linux-amd64/Slicer \\
    --launch /projects/schiz/software/slicer/Slicer-4.5.0-1-linux-amd64/lib/Slicer-4.5/cli-modules/FiberTractMeasurements \\
    --format Row_Hierarchy \\
    --outputfile ${roicc_measured} \\
    --inputdirectory ${roicc_outdir} \\
    --inputtype Fibers_File_Folder
"
echo "${cmd}"
eval "${cmd}"



