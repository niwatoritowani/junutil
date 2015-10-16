#!/bin/bash

case=$1
caselist=caselist

if [ ! -n grep "$1" $caselist ]; do
    echo "$1" >> $caselist
done

tmp=$(date +%M)

