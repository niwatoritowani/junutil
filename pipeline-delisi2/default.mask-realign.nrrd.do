#!/bin/bash

case=$(basename $2)
source SetUpData_pipeline.sh

redo-ifchange $xfm 

scripts/applyxfm.sh $t2atlasmask $xfm $t1align $3
