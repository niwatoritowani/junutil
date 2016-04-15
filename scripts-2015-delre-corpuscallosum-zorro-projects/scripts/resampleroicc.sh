#!/bin/bash

# These file name are temporary. not yet decided. 
# casedir=${base}/subjects/${case}
# roiccdiv=/projects/schiz/3Tdata/case${case}/projects/2015-delre-corpuscallosum/${case}-cc-div-roi.nrrd
# fsindwi=${casedir}/${case}.fsindwi.nrrd    
# roicc1mm=${casedir}/${case}.roicc1mm.nrrd

#s4 --launch ResampleScalarVectorDWIVolume --Reference ${fsindwi} --interpolation nn ${roiccdiv} ${roicc1mm}
$ANTSPATH/antsApplyTransforms -d 3 -i ${roiccdiv} -o ${roicc1mm} -r "${fsindwi}" -n NearestNeighbor

