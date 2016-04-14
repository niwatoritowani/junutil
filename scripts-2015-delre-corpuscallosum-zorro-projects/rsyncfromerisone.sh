#!/bin/bash



# trial

# copy whole-brain-tract to here/subjects-directory
#rsync -av -e ssh jk318@erisone.partners.org:/data/pnl/3Tdata-ukf/01106 subjects

SCRIPT=$(readlink -m ${BASH_SOURCE[0]})   # read directory of this file even this file is calle by source or bash
# If we use '$0', it means this file when it called by bash, and the calling file when it called by source 
# (the latter is the same as writting the code of called file into the calling file). 
# "source SetUpData.sh" is witten in default do files. 
SCRIPTDIR=${SCRIPT%/*}


caselist=../caselists/caselist.txt
echo -n "rsync -av -e ssh "
cat ${caselist} | while read line; do
    echo -n "jk318@erisone.partners.org:/data/pnl/3Tdata-ukf/${line} "
done
echo -n "subjects"
echo ""

