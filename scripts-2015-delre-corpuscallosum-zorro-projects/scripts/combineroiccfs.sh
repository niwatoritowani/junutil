#!/bin/bash

# These file name are temporary. not yet decided. 
# casedir=${base}/subjects/${case}
# fsindwi=${casedir}/${case}.fsindwi.nrrd    
# roicc1mm=${casedir}/${case}.roicc1mm.nrrd
# roiccfs=${casedir}/${case}.roiccfsl

unu 2op if ${roicc1mm} ${fsindwi} | unu save -e gzip -f nrrd -o ${roiccfs}

