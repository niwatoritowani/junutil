#!/bin/bash

dir_from=/rfanfs/pnl-zorro/projects/2015-delre-corpuscallosum
file_copied="readme.md
    scripts
    SetUpData.sh
    default.roicc.do
"
dir_to=/home/jkonishi/junutil/scripts-2015-delre-corpuscallosum-zorro-projects
pushd ${dir_from} 
pwd
cmd=$(echo rsync -avu ${file_copied} ${dir_to})    # delete line-break
echo ${cmd}
#eval ${cmd}

