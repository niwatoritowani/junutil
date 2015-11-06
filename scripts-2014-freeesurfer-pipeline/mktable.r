# merge tables
# for comparing elisabetta's table, freesurfer-pipeline and /projects/schiz/3Tdata
# You can use this script after sorce SetUpData_env_PNL.r, SetUpData_table.r

data.subj3=read.table("/projects/pnl/3Tdata/freesurfer-pipeline/subjects3/caselist/caselist_freesurfer.txt")
data.subj3[["caseid"]]=substr(data.subj3$V1,1,5)
data.subj3[["subj3table"]]=1
data1[["elitable"]]=1
data1[["caseid"]]=data1$caseid2
data1[["orderelitable"]]=c(1:nrow(data1))
data.merge=merge(data1,data.subj3,by.x="caseid",by.y="caseid",all=T)
data.merge=data.merge[,c("caseid","elitable","orderelitable","subj3table")]
data.merge=data.merge[order(data.merge$orderelitable),]

# delete cases with D in caseid (I think they represent diffusion data.)
data.merge2=data.merge[-grep("D",data.merge$caseid),]

# delete cases which are not listed in elisabetta's table
data.merge3=data.merge2[!is.na(data.merge2$elitable),]

# delete cases with four digital id
data.merge4=data.merge3[grep(".....",data.merge3$caseid),]

# delete cases of which caseis start by 00
data.merge5=data.merge4[-grep("00...",data.merge4$caseid),]

# sort data by case-id
data.mege6=data.merge5[order(data.merge5$caseid),]

# delete data listed in subject3 table
data.merge7=data.merge6[is.na(data.merge6$subj3table),]


# bash, search in /projects/schiz/3Tdata, 
# cat tmp | while read f; do ls case$f/strct/align-space/*-t1w-realign.nrrd; done | sort | tail -27 | sed 's/case.*space\///g'

