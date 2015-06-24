#!/bin/bash -eu

# # In a script 
# sourcedir=$(dirname $(readlink -f $0))
# export PATH=$PATH:${sourcedir}
# source ${sourcedir}/util.sh

sourcescriptname=$(basename $(readlink -f "$0"))
if [ -z "${scriptdir}" ]; then
    scriptdir=$(dirname "$0")
fi

#--------------------------------------
# Begin help section

HELP=""
HELP_TEXT=""

usage() {
    retcode=${1:-0}
    if [ -n "$HELP" ]; then
        echo -e "${HELP}";
    elif [ -n "${HELP_TEXT}" ]; then
        echo -e "${HELP_TEXT}"
    else
        echo ""
    fi
    exit ${retcode};
}

# End help section
#--------------------------------------

#--------------------------------------
# Begin logging section

#cmdlog() {
#    echo "$1" | tee -a $2
#    eval "$1" 2>&1 | tee -a $2
#}

#-----editing-----
log() {}

run() {
    log "$@"
    eval "$@"
}
#-----end editing-----

# End logging section
#-------------------------------------

