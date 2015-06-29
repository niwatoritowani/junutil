#!/bin/bash -eu

source util.sh

usage() {
    echo "Usage: $0 [-h] [-c caselist.txt] [-o outputfilename.csv]"
    exit 0
}

# The input caselist file is read in current working directory. 
# The outputfile is created in current working directory.

while getopts hc:o: OPTION; do
    case $OPTION in
        h) usage ;;
        c) caselist=$OPTARG ;;
        o) outputfile=$OPTARG ;;
    esac
done

#project=2015-delre-corpuscallosum

#outputfile=OutPutFileName.csv
if [[ -f "${outputfile}" ]]; then
    echo "'${outputfile}' exists and is out of date, delete it if you want to recompute it."
    exit 0
fi

#caselist=caselist.txt
cases=($(cat ${caselist}))

# # file pattern of the data with freewater correction
# inputfilepattern=/projects/schiz/3Tdata/case\${case}/projects/2015-delre-corpuscallosum/\${case}-cc-ukf-values.csv

# # file pattern of the data without freewater correnction
inputfilepattern=/projects/schiz/3Tdata/case\${case}/projects/2015-delre-corpuscallosum/without-freeWater/\${case}-cc-ukf-values.csv


# only for the first case to create the field names
case=${cases} # substitute the first component of the array
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
for case in ${cases[@]}; do
    # case=<subjID>
    eval inputfile=${inputfilepattern}
    awk -v outputfile=${outputfile} -v case=$case '
        BEGIN{
            FS=","
            printf("%s,", case) >> outputfile
        }
        NR > 1 {    
            printf("%s,%s,%s,%s,%s,", $9, $22, $26, $30, $34) >> outputfile
        }
        END {
            printf("\n") >>  outputfile
        }' ${inputfile}
done


