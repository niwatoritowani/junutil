#!/bin/sh

SUBJECT_LIST=/projects/fmri/CAFLIP/DTI/PNLtbssPREP/caselist.txt

for subj in $(cat ${SUBJECT_LIST}) ; do

echo ${subj}

tend estim -fixneg -est wls -B kvp -knownB0 false -i /projects/fmri/CAFLIP/DTI/${subj}.dwi-Ed.nrrd | unu save -f nrrd -e gzip -o /projects/fmri/CAFLIP/DTI/${subj}-dti.nrrd

PNLTBSSprep --mask /projects/fmri/CAFLIP/DTI/${subj}.TENSORMASK-dwi-Ed.nrrd --tensor /projects/fmri/CAFLIP/DTI/PNLtbssPREP/${subj}-dti.nrrd --folder /projects/fmri/CAFLIP/DTI/postTBSSprep/ --name ${subj}

done
