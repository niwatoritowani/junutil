#!/bin/bash -eu

# usage : 
#    bash jun.sh [case ID] [&]
#    cat [caselist] | while read line; do bash jun.sh $line [&]; done (bash)
#    awk '{print $1}' | while read line; do bash jun.sh $line [&]; done (bash)

#set +e     # not needed?
caselist=caselist
awk '{print $1}' $caselist | grep -w "$1" || echo "$1" >> $caselist
#set -e    # not needed?

tmp=$(date +%Y%m%d%H%M%S.%N)
logfile=$1.log.${tmp}    # in case it is mentioned in cmd
# cp /dev/null ${logfile}    # if necessary, initialization 
exec &> >(tee -a ${logfile}) # add output-1-and-2 into terminal and file
# if without -a, output of >> ${logfile} comes after the exec output, Why?

case=$1
out=${case}/${case}.file
cmd="
    mkdir $case
    echo \"hello\" > $out 
    echo .  # comment
    echo \*
    foo=\"strings\"
    echo \$foo
    echo $(pwd)
    touch file1
    cp file1 \
        file2
    cp file1 \\
        file34
    touch ./file3
    ls >> ${logfile} 2>&1 # if output is long and you want to run background
        #  if without >> but >, overwrite logfile
"
# in the cmd expandeds are $ " \ * and not are . (then eval expand it into directory-name)
# \[linebreak] expanded into [space], \\ expanded into \, 
# * expanded into anyfiles
# \* expanded into \* and in eval expanded into * 
if [ -e $out ]; then
    echo "$out exist"
else
    echo "$cmd"
    eval "$cmd"
fi
echo "$(date)"


