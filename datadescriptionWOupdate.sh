#!/bin/bash

# update remote datadescription

cmd="pushd ~/projects"
echo "${cmd}"; eval "${cmd}"
cmd="rsync -avu --copy-unsafe-links datadescription/ datadescription_copy"
echo "${cmd}"; eval "${cmd}"
#pushd datadescription_copy
#git add .
#git commit -m "update"
#git push origin master
#popd
cmd="popd"
echo "${cmd}"; eval "${cmd}"
