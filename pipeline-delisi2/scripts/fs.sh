#!/bin/sh

usage()
{
    cat << EOF
Usage:

    `basename $0` [-h] [-s] -i <t1> [-o <output_folder>]

Runs freesurfer 5.3 on <t1>

Options:
-h          help
-i  <t1>    t1 image in nifti or nrrd format (nrrd, nhdr, nii, nii.gz)
-s          tells freesurfer to skull strip the t1
-f          force a re-run even if a subject folder already exists
-o  <output_folder>  (default: <t1>-freesurfer)
EOF
}

function ext
{
    EXT1=$(echo $1 | rev | cut -d. -f1 | rev)
    EXT2=$(echo $1 | rev | cut -d. -f1-2 | rev)
    if [ $EXT2 == "nii.gz" ]; then
        echo $EXT2
    else
        echo $EXT1
    fi
}

function scriptdir
{
   # finds real path to this script
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do  # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"  # if $SOURCE was a relative symlink, we need to resolve it relative to the
                                                      # path where the symlink file was located
    done
    echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}


noskullstrip="-noskullstrip"
force=0
while getopts "hi:sfo:" OPTION; do
    case $OPTION in
        h) 
            usage
            exit 1
            ;;
        i) 
            t1=$OPTARG
            ;;
        s) 
            noskullstrip=""
            ;;
        f) 
            force=1
            ;;
        o) 
            output_folder=$OPTARG
            ;;
    esac
done

if [[ ! -n "$t1" ]]; then
    usage
    exit 1
fi

EXT=$(ext $t1)
filenamebase=$(echo $(basename $t1) | sed "s/\.$EXT//")
if [[ ! $EXT == "nii" || ! $EXT == "nii.gz" ]]; then
    tmpnii=/tmp/$filenamebase.nii.gz
    ConvertBetweenFileFormats $t1 $tmpnii
    t1=$tmpnii
fi
case=$filenamebase

if [[ ! -n "$output_folder" ]]; then 
    output_folder="."
fi

export FREESURFER_HOME=$(<$(scriptdir)/../config/FREESURFER_HOME)

echo "* setting freesurfer 'case' to be name of input T1: '$case'"

if [ -d $FREESURFER_HOME/subjects/$case ]; then
    if [ ! $force ]; then
        echo "* Stop: freesurfer needs to write to" 
        echo "$FREESURFER_HOME/subjects/$case/" 
        echo "but this directory already exists. Delete it first and then re-run the script."
        exit 1
    else
        rm -rf "$FREESURFER_HOME/subjects/$case/"
    fi
fi

cmd="source $FREESURFER_HOME/SetUpFreeSurfer.sh; 
    recon-all -s $case -i $t1 -autorecon1 $noskullstrip && 
    cp $FREESURFER_HOME/subjects/$case/mri/T1.mgz $FREESURFER_HOME/subjects/$case/mri/brainmask.mgz && 
    recon-all -autorecon2 -subjid $case && 
    recon-all -autorecon3 -subjid $case  &&
    mv $FREESURFER_HOME/subjects/$case $output_folder
    "

echo $cmd
eval $cmd
