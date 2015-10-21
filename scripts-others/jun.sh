#!/bin/bash -eu

# usage : 
#    bash jun.sh [case ID] [&]
#    cat [caselist] | while read line; do bash jun.sh $line [&]; done (bash)
#    awk '{print $1}' | while read line; do bash jun.sh $line [&]; done (bash)

# -----------------------------------------------
# add ${case} to caselist if it is not yet listed
# -----------------------------------------------

#set +e     # not needed?
caselist=caselist
awk '{print $1}' $caselist | grep -w "$1" || echo "$1" >> $caselist
#set -e    # not needed?

# ---------------------------------
# set standard-output into log-file
# ---------------------------------

tmp=$(date +%Y%m%d%H%M%S.%N)
logfile=$1.log.${tmp}    # in case it is mentioned in cmd
# cp /dev/null ${logfile}    # if necessary, initialization 
exec &> >(tee -a ${logfile}) # add output-1-and-2 into terminal and file
# if without -a, output of >> ${logfile} comes after the exec output, Why?

# ----------------------------------------------
# echo and run commands if ${out} does not exist
# ----------------------------------------------

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
if [ -e $out ]; then
    echo "$out exist"
else
    echo "$cmd"
    eval "$cmd"
fi
echo "$(date)"

# --------------------------------------------------------------------------------------
# in the cmd some special characters are expanded, then will be expanded again in eval
# to be expanded     : $ " \ * 
# to be not expanded : . (then eval expand it into directory-name)
# \[linebreak] is expanded into [space], which means jointed lines in echo "$cmd"
# \\ is expanded into \, 
# *  is expanded into anyfiles
# \* is expanded into \* and in eval expanded into * 
# $variable  is expanded into the content of the $variable
# \$variable is expanded into $variable and in eval expanded into the content of the $variable
#
# - running in background
# If you want to run this script in background, and set output into a log file, 
# you can use in cmd for example "ls >> ${logfile} 2>&1", 
# and run this script in background entering in the terminal "jun.sh ... &".
# You should use >>, or use > resulting in overwriting the logfile.
# ---------------------------------------------------------------------------------------

