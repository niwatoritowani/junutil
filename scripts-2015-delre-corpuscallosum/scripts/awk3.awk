BEGIN {
    print "This file is excuted by"
    print "\"awk -f awk2.awk InputTextFile.txt\""
}
NR == 1 {
    print "Fields in this file are"
    print $0
    print NF
}



## All records have data in their 1st and 2nd fields. 
## The records have either Yes or nothing in their 3rd fields. 
## If the record has Yes, it will not be changed,  
## and If the record han nothing, 3rd field is filled with NA, 
## to fill something all fields. 

#BEGIN {
#	outputfile = "caselist_jun.txt"
#}
#NR == 1 {
#	print $0 > outputfile
#}
#NR >1 {
#	if ($3 == "Yes") {
#		print $0 > outputfile
#	} else {
#		print $0 " NA" > outputfile
#	}
#}


## Add new field (originally there is 3 fields in it.) 

#BEGIN {
#	outputfile = "caselist_jun.txt"
#}
#{
#	printf("%-20s %-10s %-10s %-10s %-10s \n", $1, $2, $3, "NA", "NA") > outputfile
#}


## Add new field (originally there is 5 fields in it.) 

#BEGIN {
#	outputfile = "caselist_jun.txt"
#}
#{
#	printf("%-20s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5, "NA") > outputfile
#}

## reconstruct the caselist_FESZ_jun.txt

#BEGIN {
#	outputfile = "caselist_FESZ_jun.txt"
#}
#NR == 1 {
#	printf("%-8s %-6s %-6s %-8s %-10s\n", "caseID", "time1", "time2", "time1ID", $4) > outputfile
#}
#NR > 1 {
#    printf("%-8s %-6s %-6s %-8s %-10s\n%-8s %-6s %-6s %-8s %-10s\n", \
#        $2, "TRUE", "FALSE", $2, $4, \
#        $3, "FALSE", "TRUE", $2, $5) > outputfile
#}

## extrac the fiels ... caseID and OneTensorWholeBrainTractography
#
#BEGIN {outputfile = "caselist_FESZ_jun_blind.txt"}
#{printf("%-8s %-10s\n", $1, $5) > outputfile}

#BEGIN {outputfile = "caselist_FESZ_jun_blind.txt"}
#NR == 1 {printf("%-8s %-22s %-8s %-8s\n", $1, $2, "ROI", "negROI") > outputfile}
#NR > 1 {printf("%-8s %-22s %-8s %-8s\n", $1, $2, "NA", "NA") >> outputfile}

#BEGIN {outputfile = "caselist_FESZ_jun_blind.txt"}
#NR == 1 {printf("%-8s %-22s %-8s %-8s %-10s %-12s\n", $1, $2, $3, $4, "2twithFW", "2twithoutFW") \
#    > outputfile}
#NR > 1 {printf("%-8s %-22s %-8s %-8s %-10s %-12s\n", $1, $2, $3, $4, "NA", "NA") \
#    >> outputfile}

BEGIN {outputfile = "caselist_FESZ_jun_blind.txt"}
NR == 1 {printf("%-8s %-22s %-8s %-8s %-10s %-12s %-12s\n",$1,$2,$3,$4,$5,$6,"memo") \
    > outputfile}
NR > 1 {printf("%-8s %-22s %-8s %-8s %-10s %-12s %-12s\n", $1, $2, $3, $4,$5,$6, "NA") \
    >> outputfile}

#BEGIN {outputfile = "caselist_jun.txt"}
#BEGIN {printf("%-10s %-6s %-6s %-6s\n","subjID","t1w","t2w","dwi") > outputfile}
#{printf("%-10s %-6s %-6s %-6s\n",$1,"NA","NA","NA") >> outputfile}

#BEGIN{ FS=","}
#{ printf("%-14s %-3s %-3s %-8s %-4s %-4s %-3s %-4s %-14s %-20s %-10s\n", \
#    $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,"memo") > "caselist_jun2.txt"  }

#{ printf("%-14s %-8s %-4s %-4s %-3s %-8s %-14s %-20s %-10s\n", \
#    $1,$4,$5,$6,$7,"NA",$9,$10,"memo") > "caselist_jun2_blind.txt"  }

#{ printf("%-14s %-4s %-4s %-3s %-8s %-8s %-14s %-20s %-10s\n", \
#    $1,$3,$4,$5,$6,$2,$7,$8,$9) > "caselist_jun2_blind.txt"   }
