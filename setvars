# set project directory
#     this settings will be in SetUpData.sh
#     the name should be base
#     but it is difficult when project directory and data directory are different.

projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
caseid=$1    #

# set data directory
#     this settigs is for setting path to each data
#     the structure should be ${base}/${case}
#     and ${base} will be set in SetUpData.sh

#casedir=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}
cd=/projects/schiz/3Tdata/PRODROMES/2015-jun-prodrome/${caseid}

# set path to each data
#     this settigns should be described in different file 
#         from SetUpData.sh and SetUpData_config.sh
#             SetUpData_config.sh includes FreeSurefer path or with/without manually-editing or ...

#mriweights=
#mriweighting=$2    # t1w or t2w or dwi
#w=$2    # t1w or t2w or dwi

operation=$3    # nothing or _run1 or _run2

#partofname=${mriweight}${operation}
pn=${mriweight}${operation}

# set script name
#     this settigns will be in SetUpData.sh

#scriptname=$(basename $0)
sn=$(basename $0)

# set strings which express the time of now

#timestamps=$(date +%Y%m%d%H%M%S)
ts=$(date +%Y%m%d%H%M%S)

#timestampm=$(date +%Y%m%d%H%M)
tm=$(date +%Y%m%d%H%M)

logfilename=${scriptname}${timestampm}.log
logfilename=${caseid}-${partofname}-${scriptname}.log
logfilename=${outputfilename}.log
logfile=${workingdir}/${logfilename}
logfile=${newdir}/${caseid}-${partofname}-${scriptname}.log

# path/to/dir/fileroot.ext
# file name or base name consists of file root and file extention.
# full path or absolute path consist of directory name and file name. 
# "path/to" is called base directory in git. 
# "dir/fileroot.ext" is called relative path. ? 
