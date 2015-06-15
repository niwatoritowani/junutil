

# project=2015-delisi
# projectdir=/rfanfs/pnl-a/pnl/Collaborators/Delisi
# statdir=${projectdir}/stat
# statdir=/rfanfs/pnl-a/pnl/Collaborators/Delisi/pipelines-realign/test_stats
# fsstatdir=/rfanfs/pnl-a/pnl/Collaborators/Delisi/pipelines-realign/test_stats
fsstatfile="/rfanfs/pnl-a/pnl/Collaborators/Delisi/pipelines-realign/test_stats/delisi_aseg_stats.txt"
# setwd() sets working directory, list.files() shows files in current directory, 

#install.packages("xlsx", dep=T) 
library(xlsx)
data1=read.xlsx("LandR_demographics_MRI.xlsx",1,header=TRUE)
# MRI_ID is 0000, Dx is CON or GHR, AGE, 

data4=read.table(print(fsstatfile),header=TRUE)
# Measure:volume is turened to Measure.volume and is DELISI_HM_0403.freesurfer

# substring(object,start,end) index starts from 1 not 0
data4[["caseid2"]]=substring(data4[["Measure.volume"]],11,14)

# data5=merge(data3,data4,by.x="MRI_ID",by.y="caseid2",all=TRUE)
data5=merge(data1,data4,by.x="MRI_ID",by.y="caseid2",all=TRUE)


result1=lm(CC_Posterior~Dx+AGE,data=data5)
summary(result1)

# CC_Posterior	CC_Mid_Posterior	CC_Central	CC_Mid_Anterior	CC_Anterior	
# CC_Posterior is numeric? Dx is factor? AGE is numeric? 
# check by mode(), or is.numeric(), is.factor(), change by as.numeric(), as.factor()

