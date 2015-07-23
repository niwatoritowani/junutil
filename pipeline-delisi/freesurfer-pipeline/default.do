case=$(basename $2)    # excuted as redo DELISHI_HM_0503
if [[ ! $case =~ ^[A-Z,a-z,_,0-9]+$ ]]; then
    echo "Trying to interpret $case as a case id, but not valid"
    exit 1
fi

redo-ifchange $2.freesurfer
