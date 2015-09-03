#!/bin/bash 

SCRIPT_NAME=$(readlink -m "$0")
SCRIPT_NAME=${SCRIPT_NAME##*/}
if [ -z "${SCRIPTDIR-}" ]; then
    SCRIPTDIR=$(dirname "$0")
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
#    echo "$*" | tee -a $2
#    eval "$1" 2>&1 | tee -a $2
#}

#-----editing-----
log() {
    echo "$@"
}

run() {
    log "$@"
    eval "$@" 2>
}
#-----end editing-----

# End logging section
#-------------------------------------


#-----memo-----



# End memo section
#----------------------------------
