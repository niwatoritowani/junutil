#!/bin/bash

# update remote datadescription

pushd ~/projects
rsync -avu --copy-unsafe-links datadescription datadescription_copy
pushd datadescription_copy
git add .
git commit -m "update"
git push origin master
popd
popd
