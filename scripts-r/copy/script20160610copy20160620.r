library(foreign) # for read.spss
library(knitr)    # for kable

dataset.case=read.table("caselist.txt")
dataset.t1=read.spss("CIDAR_Clin Core_BL_112112ltrmg.sav",to.data.frame=TRUE)
dataset.t2=read.spss("CIDAR_Clin_All_FU_082313rmg.sav",to.data.frame=TRUE)

dataset.t2[["SOCFXC"]]=dataset.t2[["SocFxC"]] # change the name to be the same ans in dataset.t1
dataset.t2[["ROLEFX"]]=dataset.t2[["RoleFx"]] # change the name to be the same ans in dataset.t1

items=c("SOCFXC","ROLEFX","SIPTOT","SINTOT","SIDTOT","SIGTOT")
items.mean=paste(items,".mean",sep="")
items.t1=paste(items,".t1",sep="")
items.t2=paste(items,".t2",sep="")
items.diff.abs=paste(items,".diff.abs",sep="")
items.diff.prop=paste(items,".diff.prop",sep="")
items.diff.prop2=paste(items,".diff.prop2",sep="")
items.diff.perc=paste(items,".diff.perc",sep="")
items.diff.perc2=paste(items,".diff.perc2",sep="")
items.diff.prop3=paste(items,".diff.prop3",sep="")
items.diff.perc3=paste(items,".diff.perc3",sep="")

items.1=paste(items,".1",sep="")
items.1.mean=paste(items.1,".mean",sep="")
items.1.t1=paste(items.1,".t1",sep="")
items.1.t2=paste(items.1,".t2",sep="")
items.1.diff.abs=paste(items.1,".diff.abs",sep="")
items.1.diff.prop=paste(items.1,".diff.prop",sep="")
items.1.diff.prop2=paste(items.1,".diff.prop2",sep="")
items.1.diff.perc=paste(items.1,".diff.perc",sep="")
items.1.diff.perc2=paste(items.1,".diff.perc2",sep="")

names(dataset.t1)=paste(names(dataset.t1),".t1",sep="")
names(dataset.t2)=paste(names(dataset.t2),".t2",sep="")

# combine the two table with selected subjects
dataset.case[["caseid"]]=dataset.case[["V1"]]
dataset.t1[["caseid.t1"]]=gsub("-","",dataset.t1[["SUBJECT_ID.t1"]])
dataset.t1[["caseid.t1"]]=gsub(" ","",dataset.t1[["caseid.t1"]])
dataset.t2[["caseid.t2"]]=gsub("-","",dataset.t2[["Subject.t2"]])
dataset.t2[["caseid.t2"]]=gsub(" ","",dataset.t2[["caseid.t2"]])

dataset.tmp=merge(dataset.case,dataset.t1,by.x="caseid",by.y="caseid.t1",all.x=TRUE)
dataset.t1t2=merge(dataset.tmp,dataset.t2,by.x="caseid",by.y="caseid.t2",all.x=TRUE)

datax=dataset.t1t2
print(data.frame(line=1:dim(datax)[1],datax[c("caseid","GROUP.t1")])) # display

datax$GROUP.t1=factor(datax$GROUP.t1)    # delete factors which have no record
datax[["GROUP.t1"]]=factor(gsub(" ","",datax[["GROUP.t1"]]))

cat("calculate total scores\n")
datax[["SIPTOT.t1"]]=datax[["SIP1SEV.t1"]]+datax[["SIP2SEV.t1"]]+datax[["SIP3SEV.t1"]]+datax[["SIP4SEV.t1"]]+datax[["SIP5SEV.t1"]]
datax[["SINTOT.t1"]]=datax[["SIN1SEV.t1"]]+datax[["SIN2SEV.t1"]]+datax[["SIN3SEV.t1"]]+datax[["SIN4SEV.t1"]]+datax[["SIN5SEV.t1"]]+datax[["SIN6SEV.t1"]]
datax[["SIDTOT.t1"]]=datax[["SID1SEV.t1"]]+datax[["SID2SEV.t1"]]+datax[["SID3SEV.t1"]]+datax[["SID4SEV.t1"]]
datax[["SIGTOT.t1"]]=datax[["SIG1SEV.t1"]]+datax[["SIG2SEV.t1"]]+datax[["SIG3SEV.t1"]]+datax[["SIG4SEV.t1"]]
datax[["SIPTOT.t2"]]=datax[["SIP1SEV.t2"]]+datax[["SIP2SEV.t2"]]+datax[["SIP3SEV.t2"]]+datax[["SIP4SEV.t2"]]+datax[["SIP5SEV.t2"]]
datax[["SINTOT.t2"]]=datax[["SIN1SEV.t2"]]+datax[["SIN2SEV.t2"]]+datax[["SIN3SEV.t2"]]+datax[["SIN4SEV.t2"]]+datax[["SIN5SEV.t2"]]+datax[["SIN6SEV.t2"]]
datax[["SIDTOT.t2"]]=datax[["SID1SEV.t2"]]+datax[["SID2SEV.t2"]]+datax[["SID3SEV.t2"]]+datax[["SID4SEV.t2"]]
datax[["SIGTOT.t2"]]=datax[["SIG1SEV.t2"]]+datax[["SIG2SEV.t2"]]+datax[["SIG3SEV.t2"]]+datax[["SIG4SEV.t2"]]
datax[items.1.t1]=datax[items.t1]+1
datax[items.1.t2]=datax[items.t2]+1

cat("calculate inverval (days)\n")
pss2date <- function(x) as.Date(x/86400, origin = "1582-10-14")
datax[["date.t1"]]=pss2date(datax[["DATENPQ1.t1"]])
datax[["date.t2"]]=pss2date(datax[["Date.t2"]])
datax[["interval.days"]]=datax[["date.t2"]]-datax[["date.t1"]]

cat("diff.prop are (t2-t1)/t1. 0 / 0 output NaN. Number / 0 output Inf.\n")
datax[items.diff.abs]=datax[items.t2]-datax[items.t1]
datax[items.mean]=(datax[items.t1]+datax[items.t2])/2
datax[items.diff.prop]=datax[items.diff.abs]/datax[items.t1]
cat("diff.perc are (t2-t1)/t1*100. 0 / 0 output NaN. Number / 0 output Inf.\n")
datax[items.diff.perc]=datax[items.diff.prop]*100

cat("diff.prop3 are (t2-t1)/t1. 0 if t2-t1 is 0.\n")
#datax[items.diff.prop3]=ifelse(!datax[items.diff.abs], 0, datax[items.diff.abs] / datax[items.t1]) # does not work
datax[["SOCFXC.diff.prop3"]]=ifelse(!datax[["SOCFXC.diff.abs"]], 0, datax[["SOCFXC.diff.abs"]] / datax[["SOCFXC.t1"]]) # 0 is FALSE
datax[["ROLEFX.diff.prop3"]]=ifelse(!datax[["ROLEFX.diff.abs"]], 0, datax[["ROLEFX.diff.abs"]] / datax[["ROLEFX.t1"]]) # 0 is FALSE
datax[["SIPTOT.diff.prop3"]]=ifelse(!datax[["SIPTOT.diff.abs"]], 0, datax[["SIPTOT.diff.abs"]] / datax[["SIPTOT.t1"]]) # 0 is FALSE
datax[["SINTOT.diff.prop3"]]=ifelse(!datax[["SINTOT.diff.abs"]], 0, datax[["SINTOT.diff.abs"]] / datax[["SINTOT.t1"]]) # 0 is FALSE
datax[["SIDTOT.diff.prop3"]]=ifelse(!datax[["SIDTOT.diff.abs"]], 0, datax[["SIDTOT.diff.abs"]] / datax[["SIDTOT.t1"]]) # 0 is FALSE
datax[["SIGTOT.diff.prop3"]]=ifelse(!datax[["SIGTOT.diff.abs"]], 0, datax[["SIGTOT.diff.abs"]] / datax[["SIGTOT.t1"]]) # 0 is FALSE
cat("diff.perc3 are (t2-t1)/t1*100. 0 if t2-t1 is 0.\n")
datax[items.diff.perc3]=datax[items.diff.prop3]*100

cat("diff.prop2 are (t2-t1)/((t1+t2)/2). 0 if t2-t1 is 0.\n")
#datax[items.diff.prop2]=ifelse(!datax[items.diff.abs], 0, datax[items.diff.abs] / datax[items.mean]) # does not work
datax[["SOCFXC.diff.prop2"]]=ifelse(!datax[["SOCFXC.diff.abs"]], 0, datax[["SOCFXC.diff.abs"]] / datax[["SOCFXC.mean"]]) # 0 is FALSE
datax[["ROLEFX.diff.prop2"]]=ifelse(!datax[["ROLEFX.diff.abs"]], 0, datax[["ROLEFX.diff.abs"]] / datax[["ROLEFX.mean"]]) # 0 is FALSE
datax[["SIPTOT.diff.prop2"]]=ifelse(!datax[["SIPTOT.diff.abs"]], 0, datax[["SIPTOT.diff.abs"]] / datax[["SIPTOT.mean"]]) # 0 is FALSE
datax[["SINTOT.diff.prop2"]]=ifelse(!datax[["SINTOT.diff.abs"]], 0, datax[["SINTOT.diff.abs"]] / datax[["SINTOT.mean"]]) # 0 is FALSE
datax[["SIDTOT.diff.prop2"]]=ifelse(!datax[["SIDTOT.diff.abs"]], 0, datax[["SIDTOT.diff.abs"]] / datax[["SIDTOT.mean"]]) # 0 is FALSE
datax[["SIGTOT.diff.prop2"]]=ifelse(!datax[["SIGTOT.diff.abs"]], 0, datax[["SIGTOT.diff.abs"]] / datax[["SIGTOT.mean"]]) # 0 is FALSE
cat("diff.perc2 are (t2-t1)/((t1+t2)/2)*100. 0 if t2-t1 is 0.\n")
datax[items.diff.perc2]=datax[items.diff.prop2]*100

# display (exapmle)
# data.frame(prop=datax[["SIDTOT.diff.prop"]],prop2=datax[["SIDTOT.diff.prop2"]],prop3=datax[["SIDTOT.diff.prop3"]],perc=datax[["SIDTOT.diff.perc"]],perc2=datax[["SIDTOT.diff.perc2"]],perc3=datax[["SIDTOT.diff.perc3"]],abs=datax[["SIDTOT.diff.abs"]],t1=datax[["SIDTOT.t1"]],t2=datax[["SIDTOT.t2"]]) # display

cat("diff.1.prop are (t2-t1)/(t1+1)\n")
datax[items.1.diff.abs]=datax[items.1.t2]-datax[items.1.t1]
datax[items.1.mean]=(datax[items.1.t1]+datax[items.1.t2])/2
datax[items.1.diff.prop]=datax[items.1.diff.abs]/datax[items.1.t1]
cat("diff.1.perc are (t2-t1)/(t1+1)*100\n")
datax[items.1.diff.perc]=datax[items.1.diff.prop]*100

cat("diff.1.prop2 are (t2-t1)/((t1+1+t2+1)/2). 0 if t2-t1 is 0.\n")
#datax[items.1.diff.prop2]=ifelse(!datax[items.1.diff.abs], 0, datax[items.1.diff.abs] / datax[items.1.mean]) # does not work
datax[["SOCFXC.1.diff.prop2"]]=ifelse(!datax[["SOCFXC.1.diff.abs"]], 0, datax[["SOCFXC.1.diff.abs"]] / datax[["SOCFXC.1.mean"]]) # 0 is FALSE
datax[["ROLEFX.1.diff.prop2"]]=ifelse(!datax[["ROLEFX.1.diff.abs"]], 0, datax[["ROLEFX.1.diff.abs"]] / datax[["ROLEFX.1.mean"]]) # 0 is FALSE
datax[["SIPTOT.1.diff.prop2"]]=ifelse(!datax[["SIPTOT.1.diff.abs"]], 0, datax[["SIPTOT.1.diff.abs"]] / datax[["SIPTOT.1.mean"]]) # 0 is FALSE
datax[["SINTOT.1.diff.prop2"]]=ifelse(!datax[["SINTOT.1.diff.abs"]], 0, datax[["SINTOT.1.diff.abs"]] / datax[["SINTOT.1.mean"]]) # 0 is FALSE
datax[["SIDTOT.1.diff.prop2"]]=ifelse(!datax[["SIDTOT.1.diff.abs"]], 0, datax[["SIDTOT.1.diff.abs"]] / datax[["SIDTOT.1.mean"]]) # 0 is FALSE
datax[["SIGTOT.1.diff.prop2"]]=ifelse(!datax[["SIGTOT.1.diff.abs"]], 0, datax[["SIGTOT.1.diff.abs"]] / datax[["SIGTOT.1.mean"]]) # 0 is FALSE
cat("diff.perc2 are (t2-t1)/((t1+1+t2+1)/2)*100. 0 if t2-t1 is 0.\n")
datax[items.1.diff.perc2]=datax[items.1.diff.prop2]*100

cat("output tables\n")
library(coin)    # for wilcox_test
library(ez)    # for exANOVA
myfunction <- function(){
    tmp.mt=sapply(datax[items],mean,na.rm=TRUE)
    tmp.mtr=round(tmp.mt,digits=2)
    tmp.mg=by(datax[items],datax[["GROUP.t1"]],sapply,mean,na.rm=TRUE)
    tmp.mgr.pro=round(tmp.mg[["PRO"]],digits=2)
    tmp.mgr.hc=round(tmp.mg[["HVPRO"]],digits=2)
    tmp.st=sapply(datax[items],sd,na.rm=TRUE)
    tmp.str=round(tmp.st,digits=2)
    tmp.sg=by(datax[items],datax[["GROUP.t1"]],sapply,sd,na.rm=TRUE)
    tmp.sgr.pro=round(tmp.sg[["PRO"]],digits=2) # vector
    tmp.sgr.hc=round(tmp.sg[["HVPRO"]],digits=2) # vector
    # Wilcox-Mann-Whiteney test
    tmp.p=rep(NA,length(items))
    for (i in 1:length(items)) {
        tmp=wilcox_test(datax[[items[i]]]~datax[["GROUP.t1"]],distribution="exact")
        tmp.p[i]=tmp@distribution@pvalue(tmp@statistic@teststatistic)
    }
    tmp.pr=round(tmp.p,digits=3)
    #ANOVA
    tmp.an.DFd=rep(NA,length(items))
    tmp.an.F=rep(NA,length(items))
    tmp.an.p=rep(NA,length(items))
    for (i in 1:length(items)) {
        data.tmp=datax[c(items[i],"caseid","GROUP.t1")]
        data.tmp.complete <- data.tmp[complete.cases(data.tmp),]
        cmd=paste("ezANOVA(data.tmp.complete, dv=",items[i],",wid=caseid,between=GROUP.t1,type=3)",sep="")
        tmp=eval(parse(text=cmd))
        tmp.an.DFd[i]=tmp[["ANOVA"]][["DFd"]]
        tmp.an.F[i]=tmp[["ANOVA"]][["F"]]
        tmp.an.p[i]=tmp[["ANOVA"]][["p"]]
    }
    tmp.an.pr=round(tmp.an.p,digits=3)
    tmp.table=data.frame(
        PRO=paste(tmp.mgr.pro," (",tmp.sgr.pro,")",sep=""),
        HVPRO=paste(tmp.mgr.hc," (",tmp.sgr.hc,")",sep=""),
        TOTAL=paste(tmp.mtr," (",tmp.str,")",sep=""),
        WMW.p=tmp.pr,
        WMW.p2=tmp.p,
        ANOVA.df=tmp.an.DFd,
        ANOVA.F=tmp.an.F,
        ANOVA.p=tmp.an.pr,
        ANOVA.p2=tmp.an.p
    )
    rownames(tmp.table)=items
    cat("\nmean (sd)\n")
    print(kable(tmp.table))
}

myfunction.woANOVA <- function(){
    tmp.mt=sapply(datax[items],mean,na.rm=TRUE)
    tmp.mtr=round(tmp.mt,digits=2)
    tmp.mg=by(datax[items],datax[["GROUP.t1"]],sapply,mean,na.rm=TRUE)
    tmp.mgr.pro=round(tmp.mg[["PRO"]],digits=2)
    tmp.mgr.hc=round(tmp.mg[["HVPRO"]],digits=2)
    tmp.st=sapply(datax[items],sd,na.rm=TRUE)
    tmp.str=round(tmp.st,digits=2)
    tmp.sg=by(datax[items],datax[["GROUP.t1"]],sapply,sd,na.rm=TRUE)
    tmp.sgr.pro=round(tmp.sg[["PRO"]],digits=2) # vector
    tmp.sgr.hc=round(tmp.sg[["HVPRO"]],digits=2) # vector
    # Wilcox-Mann-Whiteney test
    tmp.p=rep(NA,length(items))
    for (i in 1:length(items)) {
        tmp=wilcox_test(datax[[items[i]]]~datax[["GROUP.t1"]],distribution="exact")
        tmp.p[i]=tmp@distribution@pvalue(tmp@statistic@teststatistic)
    }
    tmp.pr=round(tmp.p,digits=3)
    tmp.table=data.frame(
        PRO=paste(tmp.mgr.pro," (",tmp.sgr.pro,")",sep=""),
        HVPRO=paste(tmp.mgr.hc," (",tmp.sgr.hc,")",sep=""),
        TOTAL=paste(tmp.mtr," (",tmp.str,")",sep=""),
        WMW.p=tmp.pr,
        WMW.p2=tmp.p
    )
    rownames(tmp.table)=items
    cat("\nmean (sd)\n")
    print(kable(tmp.table))
}

items=items.t1
myfunction()
items=items.t2
myfunction()
items=items.diff.perc
# myfunction() # erro because of Inf
myfunction.woANOVA()
items=items.diff.perc3
# myfunction() # error because of Inf
myfunction.woANOVA()
items=items.diff.perc2
myfunction()
items=items.diff.abs
myfunction()
items=items.1.diff.perc
myfunction()
# items=c("interval.days")
# myfunction() # error because of time format
# myfunction.woANOVA() # error because of time format
datax[["interval.days.num"]]=as.numeric(datax[["interval.days"]])
items=c("interval.days.num")
myfunction()



# myfunction <- function(){
#     tmp1=sapply(datax[items],mean,na.rm=TRUE)
#     tmp2=by(datax[items],datax$GROUP.t1,sapply,mean,na.rm=TRUE)
#     cat("mean\n")
#     print(data.frame(TOTAL=tmp1,PRO=tmp2[["PRO"]],HVPRO=tmp2[["HVPRO"]]))
#     tmp1=sapply(datax[items],sd,na.rm=TRUE)
#     tmp2=by(datax[items],datax$GROUP.t1,sapply,sd,na.rm=TRUE)
#     cat("sd\n")
#     print(data.frame(TOTAL=tmp1,PRO=tmp2[["PRO"]],HVPRO=tmp2[["HVPRO"]]))
# }

# # exmaple for Wilcox-Mann-Whiteney test
# library(coin)    # for wilcox_test
# data.tmp=stack(datax[c("SIPTOT.t1","SIPTOT.t2")])
# wilcox_test(data.tmp[[1]]~data.tmp[[2]],distribution="exact")
# 
# tmp.p=rep(NA,length(items)) # setup
# for (i in 1:length(items)) {
#     tmp=wilcox_test(datax[[items[i]]]~datax[["GROUP.t1"]],distribution="exact")
#     tmp.p[i]=tmp@distribution@pvalue(tmp@statistic@teststatistic)
# }
# 
# # exmaple for ANOVA
# library(ez)    # for exANOVA
# ezANOVA(datax, dv=SIPTOT.t1,wid=caseid,between=GROUP.t1,type=3)
# ezANOVA(datax, dv=SINTOT.t1,wid=caseid,between=GROUP.t1,type=3) # error because including NA
# data.tmp=datax[c("SINTOT.t1","caseid","GROUP.t1")]
# data.tmp.complete <- data.tmp[complete.cases(data.tmp),]    # exclude NA
# ezANOVA(data.tmp.complete, dv=SINTOT.t1,wid=caseid,between=GROUP.t1,type=3) # without error
# 
# cmd=paste("ezANOVA(datax, dv=",items[3],",wid=caseid,between=GROUP.t1,type=3)",sep="")
# eval(parse(text=cmd))
# 
# tmp.an.DFd=rep(NA,length(items)) # setup
# tmp.an.F=rep(NA,length(items)) # setup
# tmp.an.p=rep(NA,length(items)) # setup
# for (i in 1:length(items)) {
#     data.tmp=datax[c(items[i],"caseid","GROUP.t1")]
#     data.tmp.complete <- data.tmp[complete.cases(data.tmp),]
#     cmd=paste("ezANOVA(data.tmp.complete, dv=",items[i],",wid=caseid,between=GROUP.t1,type=3)",sep="")
#     tmp=eval(parse(text=cmd))
#     tmp.an.DFd[i]=tmp[["ANOVA"]][["DFd"]]
#     tmp.an.F[i]=tmp[["ANOVA"]][["F"]]
#     tmp.an.p[i]=tmp[["ANOVA"]][["p"]]
# }

# notes
#subset(datax,GROUP.t1=="PRO")
#subset(datax,GROUP.t1=="HVPRO")
# savehistory(file = ".Rhistory")
