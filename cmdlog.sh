#!/bin/bash
cmd=$1
log=$2
echo "${cmd}" | tee -a ${log} | bash 2>&1 | tee -a ${log}

