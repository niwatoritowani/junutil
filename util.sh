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

scrubcolors() {
    sed -i "s/[[:cntrl:]]\[[0-9;]*m//g" $1
}

log() {
    local log_text="$1"
    echo -e "${log_text}" >&2;
    return 0;
}

run() {
    log "$*"
    eval "$@"
}


# End logging section
#-------------------------------------

startlogging() {
    _tmplog=$(mktemp).log
    exec &> >(tee "$_tmplog")  # pipe stderr and stdout to logfile as well as console
}

stoplogging() {
    cp $_tmplog $1
    scrubcolors $1
}

#-----memo-----


#----------------------------------
