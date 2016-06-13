# demographictable, fsstatfile.aseg, fsstatfile.lh, fsstatfile.rh, 
# are need to be set 

merge.tbl <- function(data4,datax){
#    data4=read.table(fsstatfile,header=TRUE)
#    data4[["caseid2"]]=substring(data4[[1]],1,9)     # column 1 shoud be freesurfer subject ID
    names.field=names(data4)
    names.field.num=names(data4)[sapply(data4,is.numeric)] # the coordinate is an example
    names.field.num.r=paste("r.",names.field.num,sep="")
    datay=merge(datax,data4,by.x="caseid2",by.y="caseid2",all=TRUE)
    n=length(names.field.num.r)
    for ( i in 1:n) {
        datay[[names.field.num.r[i]]]=datay[[names.field.num[i]]]/datay[["ICV"]]
    }
    list(datay,names.field.num,names.field.num.r)  # we need to output field name
}

# demographic table
data1=read.xlsx(demographictable,sheetName="Full",header=TRUE)
data1=subset(data1,! is.na(Case..))
data1[["caseid2"]]=substring(data1[["Case.."]],1,9)
data1$SEX=as.factor(data1$SEX)    # change into class:factor
#data1=subset(data1,! is.na(SEX))    # exclude rows which don't have SEX data
data1$SEX2=as.character(data1$SEX);mask=(data1$SEX2=="0");data1$SEX2[mask]="M";data1$SEX2[!mask]="F";data1$SEX2=as.factor(data1$SEX2)
data1$GROUPSEX=as.factor(paste(data1$GROUP,as.character(data1$SEX2),sep=""))

# aseg
datax=read.table(fsstatfile.aseg,header=TRUE)
datax[["caseid2"]]=substring(datax[[1]],1,9)     # column 1 shoud be freesurfer subject ID
datax[["ICV"]]=datax$EstimatedTotalIntraCranialVol    # change field name to be handled more easily
datax[["Bil.Lateral.Ventricle"]]=datax$Right.Lateral.Ventricle+datax$Left.Lateral.Ventricle    # summarize lt rt into bilateral
datax[["Bil.Inf.Lat.Vent"]]=datax$Right.Inf.Lat.Vent+datax$Left.Inf.Lat.Vent
datax[["Bil.Amygdala"]]=datax$Right.Amygdala+datax$Left.Amygdala
datax[["Bil.Hippocampus"]]=datax$Right.Hippocampus+datax$Left.Hippocampus
datax[["xRight.Lateral.Ventricle"]]=datax$Right.Lateral.Ventricle+datax$Right.choroid.plexus
datax[["xLeft.Lateral.Ventricle"]]=datax$Left.Lateral.Ventricle+datax$Left.choroid.plexus
datax[["xBil.Lateral.Ventricle"]]=datax$xRight.Lateral.Ventricle+datax$xLeft.Lateral.Ventricle
datax[["Right.xLateral.Ventricle"]]=datax$Right.Lateral.Ventricle+datax$Right.choroid.plexus # 2016/05/25
datax[["Left.xLateral.Ventricle"]]=datax$Left.Lateral.Ventricle+datax$Left.choroid.plexus # 2016/05/25
datax[["Bil.xLateral.Ventricle"]]=datax$Right.xLateral.Ventricle+datax$Left.xLateral.Ventricle # 2016/05/25
datax[["CC_Total"]]=apply(datax[,c("CC_Anterior", "CC_Mid_Anterior", "CC_Central", "CC_Mid_Posterior", "CC_Posterior")],1,sum)
datax[["Right.LVTH"]]=datax$Right.Lateral.Ventricle+datax$Right.Inf.Lat.Vent # 2016/05/25
datax[["Left.LVTH"]]=datax$Left.Lateral.Ventricle+datax$Left.Inf.Lat.Vent # 2016/05/25
datax[["Bil.LVTH"]]=datax$Right.LVTH+datax$Left.LVTH # 2016/05/25
datax[["Right.HipAmyCom"]]=datax$Right.Amygdala+datax$Right.Hippocampus # 2016/05/25
datax[["Left.HipAmyCom"]]=datax$Left.Amygdala+datax$Left.Hippocampus # 2016/05/25
datax[["Bil.HipAmyCom"]]=datax$Right.HipAmyCom+datax$Left.HipAmyCom # 2016/05/25
data.aseg=datax
list.aseg=merge.tbl(data.aseg,data1)

# rh
datax=read.table(fsstatfile.rh,header=TRUE)
datax[["caseid2"]]=substring(datax[[1]],1,9)     # column 1 shoud be freesurfer subject ID
data.rh=datax
list.rh=merge.tbl(data.rh,list.aseg[[1]])
# lh
datax=read.table(fsstatfile.lh,header=TRUE)
datax[["caseid2"]]=substring(datax[[1]],1,9)     # column 1 shoud be freesurfer subject ID
data.lh=datax
list.lh=merge.tbl(data.lh,list.rh[[1]])
# data table and field list
datay=list.lh[[1]]
names.field=c(list.aseg[[2]],list.rh[[2]],list.lh[[2]])
names.field.r=c(list.aseg[[3]],list.rh[[3]],list.lh[[3]])
data.main=datay

# ----------------------------------
# exclude 4 cases
# ----------------------------------

datax=data.main
datax=subset(datax,caseid2!="321100112" & caseid2!="321100125" & caseid2!="321400280" & caseid2!="321400081")
data.ex4=datax

datax=data.main
datax=subset(datax,caseid2!="321400280" & caseid2!="321100112" & caseid2!="321400081")
data.ex3=datax

# -----------------
# delete NA
# -----------------

delna <- function(datax){
    datax=subset(datax,!is.na(SEX))
    datax=subset(datax,!is.na(CC_Mid_Anterior))
    datax
}
data.main.exna=delna(data.main)
data.ex3.exna=delna(data.ex3)

# --------------------------------
# variables
# --------------------------------

regions=c("CC_Anterior", "CC_Mid_Anterior", "CC_Central", "CC_Mid_Posterior", "CC_Posterior")
regions2=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle","Bil.Lateral.Ventricle","X3rd.Ventricle")
regions2x=c("xRight.Lateral.Ventricle","xLeft.Lateral.Ventricle","xBil.Lateral.Ventricle")
#regions3=c("Bil.Lateral.Ventricle","X3rd.Ventricle")
regions4=c("r.CC_Anterior", "r.CC_Mid_Anterior", "r.CC_Central", "r.CC_Mid_Posterior", "r.CC_Posterior", "r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle","r.Bil.Lateral.Ventricle","r.X3rd.Ventricle")
regions4x=c("r.xRight.Lateral.Ventricle","r.xLeft.Lateral.Ventricle","r.xBil.Lateral.Ventricle")
regions5=c("Left.Inf.Lat.Vent","Right.Inf.Lat.Vent")
regions5r=c("r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent")
demographics1=c("GROUP","AGE","SEX")
parameters1=c("SOCFXC","ROLEFX")
parameters2=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
parameters_sip=c("SIP1SEV","SIP1SEV","SIP1SEV","SIP1SEV","SIP5SEV")
parameters_sin=c("SIN1SEV","SIN1SEV","SIN1SEV","SIN1SEV","SIN1SEV","SIN6SEV")
parameters_sid=c("SID1SEV","SID1SEV","SID1SEV","SID4SEV")
parameters_sig=c("SIG1SEV","SIG1SEV","SIG1SEV","SIG4SEV")
parameters_si=c(parameters_sip,parameters_sin,parameters_sid,parameters_sig)

