if [ -d $1 ]; then    # $1 is $case.freesurfer
    echo "$1 already exists, delete it if you would like to recompute it"
    exit 1
fi

BUILD_DIR=$(dirname $1)
T1S_FILEPATTERN=$(<config/T1S_FILEPATTERN)
case=$(basename $2)
T1=$(eval echo $T1S_FILEPATTERN)

redo-ifchange $T1

if [ -f config/MASKS ]; then
    MASKS=$(<config/MASKS)
    MASK=$(eval echo $MASKS)
    redo-ifchange $MASK
    mkdir -p masked_t1s_output
    EXT=${T1#*.}
    MASKED_T1="masked_t1s_output/$case-masked.$EXT"
    scripts/mask.sh $T1 $MASK $MASKED_T1
    scripts/fs.sh -f -i $MASKED_T1 -o $1
elif [ -f config/NOSKULLSTRIP ]; then
    scripts/fs.sh -f -i $T1 -o $1
else
    scripts/fs.sh -f -s -i $T1 -o $1
fi
