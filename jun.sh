#!/bin/bash -eu

case=$1
caselist=caselist

set +e 
[ grep "$1" $caselist ] || echo "$1" >> $caselist
set -e
tmp=$(date +%Y%m%d%H%M%S.%N)
exec &> >(tee $1.log."${tmp}")
$out=${case}/${case}.file
cmd="
mkdir $case
echo "hello" > $out
"

if [ -e $out ]; then
    echo "$out exist"
elif
    echo "$cmd"
    eval "$cmd"
fi
echo "$(date)"
echo "Done"
