# --------------------------------
# data setup
# --------------------------------

# function
run=function(cmd){cat(cmd,"\n",sep="");eval(parse(text=cmd))}
WORKDIR="/rfanfs/pnl-zorro/projects/2015-jun-prodrome/stats/02_editedfreesurfer/20160616"

# using data "data.ex4.exna"
# NEED TO SET UP ...
    source("/home/jkonishi/junutil/scripts-r/SetUpData_env_PNL.r")
    source("/home/jkonishi/junutil/scripts-r/SetUpData_table.r")
    source("/home/jkonishi/junutil/scripts-r/functions.r")

datax=data.ex4.exna # 2016/06/15
data.str=data.ex4.exna

# set up other table
setwd("/rfanfs/pnl-zorro/projects/2015-jun-prodrome/stats/20160609")
source("script20160610.r")
data.t1t2=datax

# set working directory
setwd(WORKDIR)

d1=data.str
d2=data.t1t2
run('print(d1["caseid2"])')  # data.frame
run('print(d2["caseid"])')  # data.frame
run('print(data.frame(line=1:dim(datax)[1],d1[c("caseid2","GROUP")]))')
run('print(data.frame(line=1:dim(datax)[1],d2[c("caseid","GROUP.t1")]))')
run('d1[["caseid2"]] %in% d2[["caseid"]]')
run('d2[["caseid"]] %in% d1[["caseid2"]]')
run('dim(d1)')
run('dim(d2)')
print('d=merge(d1,d2,by.x="caseid2",by.y="caseid",suffixes = c("",".new"))')
d=merge(d1,d2,by.x="caseid2",by.y="caseid",suffixes = c("",".new"))
run('dim(d)')
run('print(d[["caseid"]])')  # added on 2016/06/16
run('d[["caseid"]]=d[["caseid2"]]') # added on 2016/06/16

datax=d
cat("\n----caselist----\n")
print(data.frame(line=1:dim(datax)[1],datax[c("caseid2","GROUP")]))
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")


# -----------------
# calculate
# -----------------



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




items=c("GAFC.t1","SOCFXC.t1","ROLEFX.t1","SIPTOT.t1","SINTOT.t1","SIDTOT.t1","SIGTOT.t1")
myfunction.woANOVA()
items=c("GAFC.t2","SOCFXC.t2","ROLEFX.t2","SIPTOT.t2","SINTOT.t2","SIDTOT.t2","SIGTOT.t2")
myfunction.woANOVA()
items=c("AGE","READSTD","WASIIQ","GAFC","interval.days.num")
myfunction.woANOVA()

# gender
m=by(datax[,c("SEX")],datax$GROUP,summary) # ... use table() ?
r=summary(table(datax$GROUP,datax$SEX))[["p.value"]]  # chi test
PROmalefemale=paste(m[["PRO"]]["0"],"/",m[["PRO"]]["1"],sep="")
HVPROmalefemale=paste(m[["HVPRO"]]["0"],"/",m[["HVPRO"]]["1"],sep="")
kable(data.frame(malefemale.PRO=PROmalefemale,malefemale.HVPRO=HVPROmalefemale,chi.p=r))

# medicine
items=c("caseid2","GROUP","MED1.t2","MED2.t2","MED3.t2","MED4.t2","MED5.t2","MED6.t2","MED7.t2","MED8.t2","MED9.t2","MED10.t2")
kable(datax[items])






