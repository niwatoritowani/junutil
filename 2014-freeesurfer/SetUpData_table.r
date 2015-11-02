# todo 
# - change commands in demographic table

# demographictable, fsstatfile.aseg, fsstatfile.lh, fsstatfile.rh, 
# are need to be set 

merge.tbl <- function(fsstatfile,datax){
    data4=read.table(fsstatfile,header=TRUE)
    data4[["caseid2"]]=striplit(data4[[1]],".")[1]     # column 1 shoud be freesurfer subject ID
    names.field=names(data4)
    names.field.num=names(data4)[sapply(data4,is.numeric)] # the coordinate is an example
    names.field.num.r=paste("r.",names.field.num,sep="")
    datay=merge(datax,data4,by.x="caseid2",by.y="caseid2",all=TRUE)
    datay$ICV=datay$EstimatedTotalIntraCranialVol    # change field name to be handled more easily, shoud be in other place
    n=length(names.field.num.r)
    for ( i in 1:n) {
        datay[[names.field.num.r[i]]]=datay[[names.field.num[i]]]/datay[["ICV"]]
    }
    list(datay,names.field.num,names.field.num.r)  # we need to output field name
}

# demographic table
data1=read.xlsx(demographictable,sheetName="eli chronics",header=TRUE)
data1=subset(data1,! is.na(New.Case.#))
data1[["caseid2"]]=data1[["New.Case.#"]]    # no need to change
#data1$SEX=as.factor(data1$SEX)    # change into class:factor
#data1=subset(data1,! is.na(SEX))    # exclude rows which don't have SEX data
#data1$SEX2=as.character(data1$SEX);mask=(data1$SEX2=="0");data1$SEX2[mask]="M";data1$SEX2[!mask]="F";data1$SEX2=as.factor(data1$SEX2)
#data1$GROUPSEX=as.factor(paste(data1$GROUP,as.character(data1$SEX2),sep=""))

# fiels:
#     Diagnosis: SZ NC
#     Time : 1 2 3 " " (within subject factor)
#     Scan.Other.Sub.# : (subject number)

# aseg
datax=data1    # substitute input-data into datax
list.aseg=merge.tbl(fsstatfile.aseg,datax)
datay=list.aseg[[1]]
datay$Bil.Lateral.Ventricle=
    datay$Right.Lateral.Ventricle+datay$Left.Lateral.Ventricle    # summarize lt rt into bilateral
datay$r.Bil.Lateral.Ventricle=
    datay$r.Right.Lateral.Ventricle+datay$r.Left.Lateral.Ventricle    # summarize lt rt into bilateral

# rh
datax=datay
list.rh=merge.tbl(fsstatfile.rh,datax)
# lh
datax=list.rh[[1]]
list.lh=merge.tbl(fsstatfile.lh,datax)
# data table and field list
datay=list.lh[[1]]
names.field=c(list.aseg[[2]],list.rh[[2]],list.lh[[2]])
names.field.r=c(list.aseg[[3]],list.rh[[3]],list.lh[[3]])

regions=c("CC_Anterior", "CC_Mid_Anterior", "CC_Central", "CC_Mid_Posterior", "CC_Posterior")
regions2=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle","Bil.Lateral.Ventricle","X3rd.Ventricle")
#regions3=c("Bil.Lateral.Ventricle","X3rd.Ventricle")
regions4=c("r.CC_Anterior", "r.CC_Mid_Anterior", "r.CC_Central", "r.CC_Mid_Posterior", "r.CC_Posterior", "r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle","r.Bil.Lateral.Ventricle","r.X3rd.Ventricle")
demographics1=c("GROUP","AGE","SEX")
parameters1=c("SOCFXC","ROLEFX")
parameters2=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
parameters_sip=c("SIP1SEV","SIP1SEV","SIP1SEV","SIP1SEV","SIP5SEV")
parameters_sin=c("SIN1SEV","SIN1SEV","SIN1SEV","SIN1SEV","SIN1SEV","SIN6SEV")
parameters_sid=c("SID1SEV","SID1SEV","SID1SEV","SID4SEV")
parameters_sig=c("SIG1SEV","SIG1SEV","SIG1SEV","SIG4SEV")
parameters_si=c(parameters_sip,parameters_sin,parameters_sid,parameters_sig)
