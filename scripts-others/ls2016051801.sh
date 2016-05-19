#!/bin/bash

# Notes
# - dicomread, 000001.IMA.gz


caselist=/home/jkonishi/caselists/caselist20160518.txt

cat ${caselist} | while read line; do
#    echo ${line}
#    ls -d1 /projects/schiz/3Tdata/case${line}/raw/*SER*
#    ls -d1 /projects/schiz/3Tdata/case${line}/raw/*SER*/000001.IMA.gz
    ls -1 /projects/schiz/3Tdata/case${line}/raw/000005.SER/000001.IMA.gz
    ls -1 /projects/schiz/3Tdata/case${line}/raw/000006.SER/000001.IMA.gz
done
