#!/bin/bash

# Notes
# - /home/jkonishi/caselists/tmp20160518.txt

#filelist=/home/jkonishi/caselists/tmp20160518.txt
filelist=/home/jkonishi/caselists/ls2016051801_output.txt

cat ${filelist} | while read line; do
    echo "----------------${line}--------------"
    dicomread ${line} | grep "Series Description"
done
