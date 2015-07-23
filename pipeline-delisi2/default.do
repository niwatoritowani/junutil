#!/bin/bash -eu

# ----------------
echo "\$0 : $0"
echo "\$1 : $1"
echo "\$2 : $2"
echo "\$3 : $3"
echo "pwd : `pwd`"
echo "\${BASH_SOURCE[0]} : ${BASH_SOURCE[0]}"
echo "\$(readlink -m \${BASH_SOURCE[0]}) : $(readlink -m ${BASH_SOURCE[0]})"


# ----------------

case=$(basename $2)
if [[ ! $case =~ ^[A-Z,a-z,_,0-9]+$ ]]; then
    echo "Trying to interpret $case as a case id, but not valid"
    exit 1
fi

source SetUpData_pipeline.sh

redo-ifchange $fs
