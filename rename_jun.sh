#!/bin/bash

cmd="
mv $1/strct $1/strct_jun
mv $1/diff-jun $1/diff_jun
ls $1
"
echo "$cmd"
eval "$cmd"
