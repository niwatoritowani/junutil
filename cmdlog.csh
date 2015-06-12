#!/bin/tcsh
set cmd = $1
set log = $2
echo "${cmd}" | tee -a ${log} | tcsh |& tee -a ${log}

# error message
# set: Variable name must begin with a letter.
#
