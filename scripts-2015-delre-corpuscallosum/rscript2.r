projectdir="/projects/schiz/3Tprojects/2015-delre-corpuscallosum"
filename1="caselist_FESZ_jun_blind.txt"
filename2="caselist/CIDAR_DATABASE_Scans_with_Genotyping_10-31-15_elisabetta.xlsx"

library(xlsx)
library(knitr)
setwd(projectdir)

data1=read.table(filename1,header=TRUE)
data1[["caseid4"]]=paste("0",as.character(data1$caseID),sep="")
data1[["PCtable"]]=TRUE

data2=read.xlsx(filename2,sheetName="eli edited for FE-HVFE",header=FALSE)
data2[["X4"]]=as.character(data2[["X4"]])
data2[["caseid3"]]=data2[["X4"]]    # no need to change
data2[["caseid2"]]=substr(data2[["X4"]],5,nchar(data2[["X4"]]))    # no need to change
data2[["DWIexist"]][grep("D",data2$caseid2)]=TRUE
data2[["elitable"]]=TRUE
data2[["Time"]]=data2$X3
data2[["subject"]]=data2$X1

data2.dwi=data2[grep("D",data2$caseid2),]
data2.dwi[["caseid4"]]=substr(data2.dwi[["caseid2"]],2,nchar(data2.dwi[["caseid2"]]))

datamerged=merge(data1,data2.dwi,by.x="caseid4",by.y="caseid4",all=TRUE)
datamerged.subset=datamerged[,c("caseid4","ROI","elitable","PCtable","subject","Time")]
datamerged.subset=datamerged.subset[order(datamerged.subset$Time),]
datamerged.subset=datamerged.subset[order(datamerged.subset$subject),]
kable(datamerged.subset)
write.csv(datamerged.subset,file="caselist/datamerged.subset.csv",quote=FALSE)

# cd /projects/schiz/3Tprojects/2015-delre-corpuscallosum/caselist
# awk 'BEGIN{FS=","};NR>1{if($3!="Checked"){print $2}}' datamerged.subset.csv > caselist.`dateS`
# caselist.20151112122201
# cd /projects/schiz/3Tdata
# bash
# cat /projects/schiz/3Tprojects/2015-delre-corpuscallosum/caselist/caselist.20151112122201 | while read f; do ls case$f/diff/$f-dwi-filt-Ed.nhdr; done
# cat /projects/schiz/3Tprojects/2015-delre-corpuscallosum/caselist/caselist.20151112122201 | while read f; do ls case$f/diff/$f-dwi-Ed.nhdr; done
# cat /projects/schiz/3Tprojects/2015-delre-corpuscallosum/caselist/caselist.20151112122201 | while read f; do ls case$f/diff/$f-dwi-filt-Ed.nhdr; done | sort | cut -c5-9 > dwifiltedfound.`dateS`
# cat /projects/schiz/3Tprojects/2015-delre-corpuscallosum/caselist/caselist.20151112122201 | while read f; do ls case$f/diff/$f-dwi-Ed.nhdr; done | sort | cut -c5-9 > dwiedfound.`dateS`
# 20151112122516
# exit # from bash
# mv dwifiltedfound.20151112122516 dwiedfound.20151112122516 /projects/schiz/3Tprojects/2015-delre-corpuscallosum/caselist
# cd /projects/schiz/3Tprojects/2015-delre-corpuscallosum/caselist

filename3="caselist/dwifiltedfound.20151112122516"
filename4="caselist/dwiedfound.20151112122516"
data3=read.table(filename3)
data4=read.table(filename4)
data3[["caseid4"]]=paste("0",as.character(data3[,1]),sep="")
data3[["dwifiltedfound"]]=TRUE

data4[["caseid4"]]=paste("0",as.character(data4[,1]),sep="")
data4[["dwiedfound"]]=TRUE

datamerged2=merge(datamerged.subset,data3,by.x="caseid4",by.y="caseid4",all=TRUE)

datamerged3=merge(datamerged2,data4,by.x="caseid4",by.y="caseid4",all=TRUE)
datamerged3.subset=datamerged3[,c(1,2,3,4,5,6,8,10)]
datamerged3.subset=datamerged3.subset[order(datamerged3.subset$subject,datamerged3.subset$Time),]


write.csv(datamerged3.subset,file="caselist/datamerged3.subset.csv",quote=FALSE,na="")
# correct mistakes by vim,  CHecked and Chenked were to be Checked


