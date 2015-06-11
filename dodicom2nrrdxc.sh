#!/bin/bash
arg1=$1;arg2=$2
usage() {
    echo "Usage: $0 <case ID> [series number of DWI]"
    echo "case ID is $arg1"
    echo "series number of DWI is $arg2"
}

usage
cmd="
/home/jkonishi/junutil/dicom2nrrdxc.sh -i $1 -w t1w
/home/jkonishi/junutil/dicom2nrrdxc.sh -i $1 -w t2w
/home/jkonishi/junutil/dicom2nrrdxc.sh -i $1 -w dwi -s $2
"
echo "$cmd"
eval "$cmd"
