
cmdlog() {
    echo "$1" | tee -a $2
    eval "$1" 2>&1 | tee -a $2
}

