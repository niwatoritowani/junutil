#!/bin/bash -eu

# usage : 
#    bash jun.sh [case ID] [&]
#    cat [caselist] | while read line; do bash jun.sh $line [&]; done (bash)
#    awk '{print $1}' [caselist] | while read line; do bash jun.sh $line [&]; done (bash)

# set variables

case=$1
caselist=caselist

# add ${case} to ${caselist} if it is not yet listed

add2list() {
    #set +e     # not needed?
    awk '{print $1}' $caselist | grep -w "${case}" || echo "${case}}" >> $caselist
    #set -e    # not needed?
}

# set standard-output into log-file

startlog() {
    tmp=$(date +%Y%m%d%H%M%S.%N)
    logfile=$1.log.${tmp}    # in case it is mentioned in cmd
    # cp /dev/null ${logfile}    # if necessary, initialization 
    exec &> >(tee -a ${logfile}) # add output-1-and-2 into terminal and file
    # if without -a, output of >> ${logfile} comes after the exec output, Why?
}

# echo and run commands if ${out} does not exist

check_out() {
    if [ -e $1 ]; then
        echo "$1 exist."
        echo "exit"
        echo "$(date)"
        exit 1
}

echoeval() {
    echo "$*"
    eval "$@"
    echo "Done"
    echo "$(date)"
}

# --------
# execute
# --------

add2list
startlog ${case}
out=${case}/${case}.file
cmd="
    echo \"hello\" > $out 
    ls >> ${logfile} 2>&1 # if output is long and you want to run background
        #  if without >> but >, overwrite logfile
"
check_out "${out}"
echoeval "$cmd"

# --------------------------------------------------------------------------------------
# in the cmd some special characters are expanded by shell, then will be expanded again in eval
# if you want stronger supression on expansion, you can use '' quotation
# supressed by ""    : [space] [linebreak] *
# to be expanded     : $ " \  
# to be not expanded : . (This is not expanded but the file name which means current directory)
# \[linebreak] is expanded into [space], which means jointed lines in echo "$cmd"
# \\ is expanded into \, 
# *  is expanded into * and in eval expanded into anyfiles (why in "" ?)
# \* is expanded into \* and in eval expanded into * (why \ is not in "" ?) 
# $variable  is expanded into the content of the $variable
# \$variable is expanded into $variable and in eval expanded into the content of the $variable
#
# - running in background
# If you want to run this script in background, and set output into a log file, 
# you can use in cmd for example "ls >> ${logfile} 2>&1", 
# and run this script in background entering in the terminal "jun.sh ... &".
# You should use >>, or use > resulting in overwriting the logfile.
# ---------------------------------------------------------------------------------------

