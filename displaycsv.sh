#!/bin/bash
# Usage: display.sh InputFile FieldNumber FieldWidth [OutputFile]
inputfilename="$1"
x1=""; x2=""
for i in $(seq 1 $2); do
    x1="${x1}""%-${3}s "
    x2="${x2}"",\$${i}"
done
if [[ -n $4 ]]; then
    outputfilename="$4"
else outputfilename="outputfile.txt"
fi
awk 'BEGIN{FS=","}{printf("'"${x1}"'\n"'"${x2}"')}' \
    ${inputfilename} \
    > ${outputfilename}

