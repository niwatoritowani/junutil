#!/bin/bash -eu

# usage: redo [method] to create methods/${methods}/${methodd}.sumvtk.csv in ${projectdir}
# for example, redo [free-water] in {projectdir}
# executed by redo-ifchange ${projectdir}/methods/${method}/stat/${method}.sumvtk.csv in ${projectdir}
# which may mean that cd ${projectdir}/${method}/stat; redo-ifchange ${method}.sumvtk.csv
# $1 is ${method}.sumvtk.csv, $2 is ${method}, $3 is ... or they may include full path

## set variables

projectdir=/projects/schiz/3Tprojects/2015-delre-corpuscallosum

method=$(basename $2)
# # I did not create ${mthod}.data directory yet
# file pattern of the data with freewater
# method=""
# file pattern of the data without freewater
method="without-freewater"

methoddir=${projectdir}/methods/${method}

## output data

outputfile=$3
# we may have to change $3 to outputfile=${methoddir}/stat/$3

if [[ -f "${outputfile}" ]]; then
    echo "'${outputfile}' exists and is out of date, delete it if you want to recompute it."
    exit 0
fi

## input data

# caselist data shoud be in ${methoddir}
caselist=${methoddir}/caselist.txt
cases=($(cat ${caselist}))   # array

# caseprojectdir=/projects/schiz/3Tdata/case\${caseid}/projects/2015-delre-corpuscallosum/${method}.data
# for caseid in caselist; do
#     eval caseprojectdir=${caseprojectdir}
#     redo-ifchange ${caseprojectdir}/${method}.data
# done
# # I did not create ${mthod}.data directory yet

# inputfilepattern=/projects/schiz/3Tdata/case\${caseid}/projects/2015-delre-corpuscallosum/${method}.data/\${caseid}-cc-ukf-values.csv
# # I did not create ${mthod}.data directory yet
inputfilepattern=/projects/schiz/3Tdata/case\${caseid}/projects/2015-delre-corpuscallosum/${method}/\${caseid}-cc-ukf-values.csv

## run script

# only for the first case to create the field names
caseid=${cases} # substitute the first component of the array
eval inputfile=${inputfilepattern}
awk -v outputfile=${outputfile} '
    BEGIN{
        FS=","
    }
    NR == 1 {    
        printf("caseID,") >> outputfile
        tractlist="cc-all cc-div1 cc-div2 cc-div3 cc-div4 cc-div5"
        split(tractlist, tracts, " ")
        for (i=1;i<=length(tracts);i++) {
            printf("%s-%s,%s-%s,%s-%s,%s-%s,%s-%s,", 
                tracts[i], $9, tracts[i], $22, tracts[i], $26, tracts[i], $30, tracts[i], $34 \
                ) >> outputfile
        }
    }
    END {
        printf("\n") >>  outputfile
    }' ${inputfile}

# enter each values in one line per each case
for caseid in ${cases[@]}; do
    # substitute caseid
    eval inputfile=${inputfilepattern}
    awk -v outputfile=${outputfile} -v caseid=$caseid '
        BEGIN{
            FS=","
            printf("%s,", caseid) >> outputfile
        }
        NR > 1 {    
            printf("%s,%s,%s,%s,%s,", $9, $22, $26, $30, $34) >> outputfile
        }
        END {
            printf("\n") >>  outputfile
        }' ${inputfile}
done


