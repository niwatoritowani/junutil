# This file is a script for R and run by
#     R --vanilla < rscript3.r

# =============
# set variables
# =============

# project=2015-jun-prodrome
# projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
# statdir=${projectdir}/stat
# fsstatdir=
fsstatfile="/projects/schiz/3Tprojects/2015-jun-prodrome/stats/aseg_stats.txt"
demographictable="/projects/schiz/3Tprojects/2015-jun-prodrome/caselist/Caselist_CC_prodromes.xlsx"

# =============
# set up data
# =============

# load the demographic table

# install.packages("xlsx", dep=T) # only necessary if it is not installed
library(xlsx)
data1=read.xlsx(demographictable,sheetName="Full",header=TRUE)
data1=subset(data1,! is.na(Case..))
# field labels: 
#     dx: diagnosis 1 for PRO, 2 for HVPRO
#     GROUP: PRO (prodrome), HVPRO (healthy volunteer)
#     AGE
#     SEX: 0 (male) or 1 (female); need to be changed to factor(class)
#     Case..: case ID

# sheet4=read.xlsx(demographictable,sheetName="Sheet4",header=TRUE)
# sheet4=subset(sheet4,! is.na(Case..))

# load the freesurfer output table

data4=read.table(fsstatfile,header=TRUE)
# field labels:
#     Measure:volume (field label) is turened to Measure.volume 
#     and its data is for example DELISI_HM_0403.freesurfer

# formatting the strings of case id

data1[["caseid2"]]=substring(data1[["Case.."]],1,9)
data4[["caseid2"]]=substring(data4[["Measure.volume"]],1,9)
# substring(object,start,end) index starts from 1 not 0

# merge tables

data5=merge(data1,data4,by.x="caseid2",by.y="caseid2",all=TRUE)
data6=subset(data5,! is.na(SEX))    # exclude rows which don't have SEX data
data6$SEX=as.factor(data6$SEX)    # change into class:factor
data6$ICV=data6$EstimatedTotalIntraCranialVol    # change field name to be handled more easily
data6$Bil.Lateral.Ventricle=data6$Right.Lateral.Ventricle+data6$Left.Lateral.Ventricle    # summarize lt rt into bilateral
data6$rRight.Lateral.Ventricle=data6$Right.Lateral.Ventricle/data6$ICV
data6$rLeft.Lateral.Ventricle =data6$Left.Lateral.Ventricle /data6$ICV
data6$rBil.Lateral.Ventricle  =data6$Bil.Lateral.Ventricle  /data6$ICV
data6$rCC_Anterior          =data6$CC_Anterior          /data6$ICV
data6$rCC_Mid_Anterior      =data6$CC_Mid_Anterior      /data6$ICV
data6$rCC_Central           =data6$CC_Central           /data6$ICV
data6$rCC_Mid_Posterior     =data6$CC_Mid_Posterior     /data6$ICV
data6$rCC_Posterior         =data6$CC_Posterior         /data6$ICV

# set variables

regions=c("CC_Anterior", "CC_Mid_Anterior", "CC_Central", "CC_Mid_Posterior", "CC_Posterior")
regions2=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle","X3rd.Ventricle")
regions3=c("Bil.Lateral.Ventricle","X3rd.Ventricle")
regions4=c("rCC_Anterior", "rCC_Mid_Anterior", "rCC_Central", "rCC_Mid_Posterior", "rCC_Posterior", "rRight.Lateral.Ventricle","rLeft.Lateral.Ventricle","rBil.Lateral.Ventricle")
demographics1=c("GROUP","AGE","SEX")
parameters1=c("SOCFXC","ROLEFX")
parameters_sip=c("SIP1SEV","SIP1SEV","SIP1SEV","SIP1SEV","SIP5SEV")
parameters_sin=c("SIN1SEV","SIN1SEV","SIN1SEV","SIN1SEV","SIN1SEV","SIN6SEV")
parameters_sid=c("SID1SEV","SID1SEV","SID1SEV","SID4SEV")
parameters_sig=c("SIG1SEV","SIG1SEV","SIG1SEV","SIG4SEV")
parameters_si=c(parameters_sip,parameters_sin,parameters_sid,parameters_sig)

# ====================
# statistical analysis
# ===================

# -----------------------
# demographics
# -----------------------

by(data6[demographics1],data6$SEX,summary)
by(data6[demographics1],data6$GROUP,summary)
summary(table(data6$GROUP,data6$SEX)) # chi test
t.test(subset(data6,GROUP=="PRO")["AGE"],subset(data6,GROUP=="HVPRO")["AGE"]) # t test

# ---------------------------
# analyses of corpus callosum
# ---------------------------

# ANOVA with factors: GROUP, SEX, ICV

funclm1 <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP*SEX+ICV,data=data6)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
for (region in regions ) { funclm1(region) }

# ANOVA with factors: GROUP, ICV

funclm2 <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP+ICV,data=data6)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
for (region in regions ) { funclm2(region) }
# results: no significant group difference

# ANOVA with factors: GROUP, ICV, by SEX

funclm2 <- function(arg1){
    # arg1:character; arg2:character; r=lm(arg1~GROUP+ICV,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP+ICV,data="; txt4="datax";txt5=")"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
functmp=function(arg1){
    # arg1:vecotr:character,
    for (region in arg1 ) { funclm2(region) }
}
datax=subset(data6,SEX==0); functmp(regions)
datax=subset(data6,SEX==1); functmp(regions)

# t-test on "CC_Mid_Posterior" by GROUP, SEX

datax=data6; t.test(subset(datax,GROUP=="PRO")["CC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["CC_Mid_Posterior"])
datax=subset(data6,SEX==0); t.test(subset(datax,GROUP=="PRO")["CC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["CC_Mid_Posterior"])
datax=subset(data6,SEX==1); t.test(subset(datax,GROUP=="PRO")["CC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["CC_Mid_Posterior"])
datax=data6;t.test(subset(datax,SEX==0)["CC_Mid_Posterior"],subset(datax,SEX==1)["CC_Mid_Posterior"])
datax=subset(data6,GROUP=="PRO");t.test(subset(datax,SEX==0)["CC_Mid_Posterior"],subset(datax,SEX==1)["CC_Mid_Posterior"])
datax=subset(data6,GROUP=="HVPRO");t.test(subset(datax,SEX==0)["CC_Mid_Posterior"],subset(datax,SEX==1)["CC_Mid_Posterior"])
    # results: PRO < HVPRO in all
    # results: PRO << HVPRO in male, but p=0.007493, 
    # results: PRO > HVPRO in female
    # results: male < female in all
    # results: male > female in HVPRO
    # results: male < female in PRO
datax=data6; t.test(subset(datax,GROUP=="PRO")["rCC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["rCC_Mid_Posterior"])
datax=subset(data6,SEX==0); t.test(subset(datax,GROUP=="PRO")["rCC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["rCC_Mid_Posterior"])
datax=subset(data6,SEX==1); t.test(subset(datax,GROUP=="PRO")["rCC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["rCC_Mid_Posterior"])
datax=data6;t.test(subset(datax,SEX==0)["rCC_Mid_Posterior"],subset(datax,SEX==1)["rCC_Mid_Posterior"])
datax=subset(data6,GROUP=="PRO");t.test(subset(datax,SEX==0)["rCC_Mid_Posterior"],subset(datax,SEX==1)["rCC_Mid_Posterior"])
datax=subset(data6,GROUP=="HVPRO");t.test(subset(datax,SEX==0)["rCC_Mid_Posterior"],subset(datax,SEX==1)["rCC_Mid_Posterior"])
    # results: PRO < HVPRO in all
    # results: PRO << HVPRO in male, but p=0.09395, 
    # results: PRO > HVPRO in female
    # results: male < female in all
    # results: male < female in PRO
    # results: male > female in HVPRO

# ANOVA with factors: GROUP, SEX; relative volume

funclm3 <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP*SEX,data=data6)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP*SEX,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
for (region in regions4 ) { funclm3(region) }
# results: no significant group difference

# ANOVA with factors: GROUP, AGE, SEX, ICV

funclm <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP*SEX+AGE+ICV,data=data6)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP*SEX+AGE+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
for (region in regions ) { funclm(region) }
# results: no significant group difference

# ---------------------
# analyses of venricles
# ---------------------

# ANOVA with factors: GROUP, SEX, ICV

for (region in regions2 ) {funclm1(region)}
# results: significant group difference of Left.Lateral.Ventricle

# ANOVA with factors: GROUP, ICV

for (region in regions2 ) {funclm2(region)}
# results: no significant group difference

# make data.frame for the analyses with hemisphere as factor

dlvrt=data.frame(GROUP=data6$GROUP, volume=data6$Right.Lateral.Ventricle, ICV=data6$ICV, SEX=data6$SEX, hemi="rt")
dlvlt=data.frame(GROUP=data6$GROUP, volume=data6$Left.Lateral.Ventricle, ICV=data6$ICV, SEX=data6$SEX, hemi="lt")
dlv=rbind(dlvrt,dlvlt)

# ANOVA with factors: GROUP, hemi, SEX, ICV

r=lm(volume~GROUP*hemi*SEX+ICV,data=dlv); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])

# ANOVA with factors: GROUP, hemi, ICV

r=lm(volume~GROUP*hemi+ICV,data=dlv); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])

# ANOVA with factors: GROUP, SEX, ICV

for (region in regions3 ) {funclm1(region)}

# ANOVA with factors: GROUP, ICV

for (region in regions3 ) {funclm2(region)}
    # results: no significant group difference

# -------------------
# correlation analysis
# --------------------

# set data, extract columns fo analyses
# --------------------------------------

datax=cbind(data6[c(regions,regions3)])

# correlation analysis - output correlation matrix
# -----------------------------------------------

mcor=cor(datax,use="complete.obs")    # correlation matrix with correlation coefficients but not p-values
plot(datax)    # plot of correlation matrix

# you may use below
# datax=na.omit(datax)    # omit rows including NA for correlation analysis

# correlation analysis - output p-values of the analyses
# ------------------------------------------------------

n=length(datax)
mcorp=matrix(0,n,n)
for (j in 1:n) {    # matrix of correlation p-value
    for (i in 1:n) {
        mcorp[i,j]=cor.test(datax[[j]],datax[[i]])[["p.value"]]
    }
}
rownames(mcorp)=names(datax)
colnames(mcorp)=names(datax)
mask=(mcorp < 0.05)                          # mask for under 0.05
mcorp.sig=mcorp
mcorp.sig[!mask]=NA
mcorp.sig.round=sprintf("%.2f",mcorp.sig)    # turn into vector, why?
mcorp.sig.round=as.numeric(mcorp.sig.round)
dim(mcorp.sig.round)=c(n,n)                  # intend to turn into matrix
rownames(mcorp.sig.round)=names(datax)
colnames(mcorp.sig.round)=names(datax)

# extract column for correlation analysis  
# -----------------------------------------

datax=
    cbind(
        data6[c(1:15)],
#        data6[c(44:344)],
        data6[c("READSTD","WASIIQ","GAFC","GAFH")],
        data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
        data6[c(regions,regions3)]
    )

# correlation analysis in PRO and HVPRO data
# ------------------------------------------

mask=sapply(datax,is.numeric)    # apply is.numeric to each column, output nuber is same as the number of columns,
datax=subset(datax,select=mask)    # select only data which are numeric

n=length(datax)    # the number of columns
mcorp=c(1:n)    # set an vectore beforhand

for (i in 1:n) {    # cor test between CC and each-column-indatax
    mcorp[i]=cor.test(datax[["CC_Mid_Posterior"]],datax[[i]],method="spearman")[["p.value"]]
}
mcorp.round=sprintf("%.5f",mcorp)    # round the values
mcorp.round=as.numeric(mcorp.round)    # change character to numecit
mcorp.names=names(datax)    # set names
cbind(mcorp.names,mcorp.round)    # output table

# corelation analysis in PRO data
# -----------------------------------------

# set data

datax_pro=subset(datax,GROUP=="PRO")
datax=datax_pro
mask=sapply(datax,is.numeric)    # apply is.numeric to each column, output nuber is same as the number of co
datax=subset(datax,select=mask)    # select only data which are numeric

n=length(datax)    # the number of columns
mcorp=c(1:n)    # set an vectore beforhand

for (i in 1:n) {    # cor test between CC and each-column-indatax
    mcorp[i]=cor.test(datax[["CC_Mid_Posterior"]],datax[[i]],method="spearman")[["p.value"]]
}
mcorp.round=sprintf("%.5f",mcorp)    # round the values
mcorp.round=as.numeric(mcorp.round)    # change character to numecit
mcorp.names=names(datax)    # set names
cbind(mcorp.names,mcorp.round)    # output table

for (i in 1:n) {    # cor test between CC and each-column-indatax
    mcorp[i]=cor.test(datax[["CC_Mid_Posterior"]],datax[[i]],method="spearman")[["estimate"]]
}
mcorp.round=sprintf("%.5f",mcorp)    # round the values
mcorp.round=as.numeric(mcorp.round)    # change character to numecit
mcorp.names=names(datax)    # set names
cbind(mcorp.names,mcorp.round)    # output table

for (i in 1:n) {    # cor test between CC and each-column-indatax
    mcorp[i]=cor.test(datax[["Bil.Lateral.Ventricle"]],datax[[i]],method="spearman")[["p.value"]]
}
mcorp.round=sprintf("%.5f",mcorp)    # round the values
mcorp.round=as.numeric(mcorp.round)    # change character to numecit
mcorp.names=names(datax)    # set names
cbind(mcorp.names,mcorp.round)    # output table

# more easy
# ----------

datax=    cbind(
    data6[c(1:15)],
    data6[c("READSTD","WASIIQ","GAFC","GAFH")],
    data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
    data6[c(regions,regions3)],
    data6[regions4],
    data6[regions2],
    data6[parameters_si],
    data6[parameters1]
)
datax=subset(datax,GROUP=="PRO")
mask=sapply(datax,is.numeric)    # apply is.numeric to each column, output nuber is same as the number of co
datax=subset(datax,select=mask)    # select only data which are numeric
#datax=na.omit(datax)    # revome row data with NA

col=c("estimate","p.value")    # vector:character
item=c("rCC_Mid_Posterior","rLeft.Lateral.Ventricle","rBil.Lateral.Ventricle")
n=length(datax)    # the number of colmuns
m=length(col); o=length(item); lst=list()
for (k in 1:o) {                  # process of each item
    lst[[item[k]]]=matrix(0,n,m)
    for (j in 1:m) {              # process of each col
        for (i in 1:n) {          # cor test between item and each-column-in-datax
            lst[[item[k]]][i,j]=cor.test(datax[[item[k]]],datax[[i]],method="spearman")[[col[j]]]
        }
    }
    rownames(lst[[item[k]]])=names(datax)
    colnames(lst[[item[k]]])=col
}
print(lst)

# use linear model
# ----------------

# set up data within PRO

datax=cbind(
    data6[c(1:15)],
    data6[c("READSTD","WASIIQ","GAFC","GAFH")],
    data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
    data6[c(regions,regions3,regions4,"ICV")],
    data6[regions2],
    data6[parameters_si],
    data6[parameters1]
)
datax=subset(datax,GROUP=="PRO")

# ANOVA with factors: ICV in PRO

funclm4 <- function(arg1,arg2){
    # arg1: character; arg2: character; r=lm(arg1~arg2+ICV,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5="+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
}
item=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","Left.Lateral.Ventricle")
#datacol=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
#datacol=c(parameters_si)
datacol=c(parameters1)
m=length(item); n=length(datacol)
for ( j in 1:m) {
    for ( i in 1:n ) {
        funclm4(item[j],datacol[i])
    }
}
# results: 
# lm(formula = CC_Mid_Posterior ~ Bil.Lateral.Ventricle + ICV, data = datax), Bil.Lateral.Ventricle p=0.001746613
# lm(formula = Bil.Lateral.Ventricle ~ CC_Mid_Posterior + ICV, data = datax), CC_Mid_Posterior p=0.001746613
# lm(formula = Left.Lateral.Ventricle ~ CC_Mid_Posterior + ICV,data = datax), CC_Mid_Posterior p=0.0005963888
# lm(formula = Left.Lateral.Ventricle ~ READSTD + ICV, data = datax), READSTD p=0.02829156
# lm(formula = Bil.Lateral.Ventricle ~ ROLEFX + ICV, data = datax), ROLEFX p=0.001543687
# lm(formula = Left.Lateral.Ventricle ~ ROLEFX + ICV, data = datax), ROLEFX p=0.001245743

# ANOVA with factors:SEX, ICV in PRO

funclm5 <- function(arg1,arg2){
    # arg1: character; arg2: character; r=lm(arg1~arg2+SEX+ICV,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5="+SEX+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
}
item=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","Left.Lateral.Ventricle")
#datacol=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
#datacol=c(parameters_si)
datacol=c(parameters1)
m=length(item); n=length(datacol)
for ( j in 1:m) {
    for ( i in 1:n ) {
        funclm5(item[j],datacol[i])
    }
}
# results:
# lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV + SEX + ICV, data = datax), SINTOTEV p-value 0.05189117
# lm(formula = Left.Lateral.Ventricle ~ SINTOTEV + SEX + ICV, data = datax), SINTOTEV p-value 0.05510382
# lm(formula = Left.Lateral.Ventricle ~ READSTD + SEX + ICV, data = datax), READSTD p-value 0.03022078
# lm(formula = Bil.Lateral.Ventricle ~ SIN6SEV + SEX + ICV, data = datax), SIN6SEV p-value 0.023728336
# lm(formula = Left.Lateral.Ventricle ~ SIN6SEV + SEX + ICV, data = datax), SIN6SEV p-value 0.03883535
# lm(formula = Bil.Lateral.Ventricle ~ ROLEFX + SEX + ICV, data = datax), ROLEFX p-value 0.0003735877
# lm(formula = Left.Lateral.Ventricle ~ ROLEFX + SEX + ICV, data = datax), ROLEFX p-value 0.0003480755

# ANOVA with factors:SEX in PRO, relative volume

funclm <- function(arg1,arg2){
    # arg1: character; arg2: character; r=lm(arg1~arg2+SEX,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5="+SEX,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
}
item=c("rCC_Mid_Posterior","rBil.Lateral.Ventricle")
datacol=c("rCC_Mid_Posterior","rBil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
m=length(item); n=length(datacol)
for ( j in 1:m) {
    for ( i in 1:n ) {
        funclm(item[j],datacol[i])
    }
}
# results:
# lm(formula = rBil.Lateral.Ventricle ~ SINTOTEV + SEX, data = datax), SINTOTEV     p-value 0.08179919

# ANOVA with factors:SEX, AGE, ICV in PRO

funclm <- function(arg1,arg2){
    # arg1: character; arg2: character
    # r=lm(arg1~arg2+SEX+AGE+ICV,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5="+SEX+AGE+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
}
item=c("CC_Mid_Posterior","Bil.Lateral.Ventricle")
datacol=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
m=length(item); n=length(datacol)
for ( j in 1:m) { 
    for ( i in 1:n ) {
        funclm(item[j],datacol[i])
    }
}
# results:
# lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV + SEX + AGE + ICV, data = datax), SINTOTEV:  p-value 0.05904023

# ANOVA with factors:SEX, :SEX, ICV in PRO

funclm <- function(arg1,arg2){
    # arg1: character; arg2: character; r=lm(arg1~arg2*SEX+ICV,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5="*SEX+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
}
item=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","Left.Lateral.Ventricle")
datacol=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
#datacol=c(parameters_si)
#datacol=c(parameters1)
m=length(item); n=length(datacol)
for ( j in 1:m) { 
    for ( i in 1:n ) {
        funclm(item[j],datacol[i])
    }
}
# results: 
# lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV * SEX + ICV, data = datax), SINTOTEV p=0.006923484
# lm(formula = Left.Lateral.Ventricle ~ SINTOTEV * SEX + ICV, data = datax), SINTOTEV p=0.009573801
# lm(formula = Bil.Lateral.Ventricle ~ SIN6SEV * SEX + ICV, data = datax), SIN6SEV p=0.001664064
# lm(formula = Left.Lateral.Ventricle ~ SIN6SEV * SEX + ICV, data = datax), SIN6SEV p=0.006264122
# lm(formula = CC_Mid_Posterior ~ ROLEFX * SEX + ICV, data = datax), ROLEFX p=0.04545495
# lm(formula = Bil.Lateral.Ventricle ~ ROLEFX * SEX + ICV, data = datax), ROLEFX p=2.426137e-05
# lm(formula = Left.Lateral.Ventricle ~ ROLEFX * SEX + ICV, data = datax), ROLEFX p=1.902738e-05

item=c("CC_Mid_Posterior","Bil.Lateral.Ventricle")
datacol=c(regions,"Bil.Lateral.Ventricle")
m=length(item); n=length(datacol)
for ( j in 1:m) { 
    for ( i in 1:n ) {
        funclm(item[j],datacol[i])
    }
}
# results:
#      CC_Mid_Posterior: significant effect of CC_Central, Bil.Lateral.Ventricle
#      Bil.Lateral.Ventricle: signicficant effect of CC_Central, CC_Mid_Posterior

# ANOVA with Bil.Lateral.Ventricle ~ SINTOTEV, p-value of SINTOTEV
summary(lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV + SEX + AGE + ICV, data = datax))   # 0.0590
summary(lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV + SEX + ICV, data = datax))         # 0.0519
summary(lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV * SEX + ICV, data = datax))         # 0.00692
summary(lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV + ICV, data = datax))               # 0.0666
summary(lm(formula = rBil.Lateral.Ventricle ~ SINTOTEV + SEX + AGE + ICV, data = datax))  # 0.0549
summary(lm(formula = rBil.Lateral.Ventricle ~ SINTOTEV + SEX + ICV, data = datax))        # 0.0483
summary(lm(formula = rBil.Lateral.Ventricle ~ SINTOTEV + SEX + AGE, data = datax))        # 0.0919
summary(lm(formula = rBil.Lateral.Ventricle ~ SINTOTEV + SEX, data = datax))              # 0.0818
summary(lm(formula = rBil.Lateral.Ventricle ~ SINTOTEV, data = datax))                    # 0.0583
#summary(lm(formula = Bil.Lateral.Ventricle ~ GROUP * SEX + SINTOTEV + ICV, data = data6))    # 0.00938
#summary(lm(formula = Bil.Lateral.Ventricle ~ GROUP * SINTOTEV + SEX + ICV, data = data6))    # 0.950
#summary(lm(formula = Bil.Lateral.Ventricle ~ GROUP * SINTOTEV * SEX + ICV, data = data6))    # 0.268347
datax0=subset(datax,SEX==0);summary(lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV + ICV, data = datax0)) # 0.0192
datax1=subset(datax,SEX==1);summary(lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV + ICV, data = datax1)) # 0.895
summary(lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV * SEX + ICV, data = datax))         # 0.00692
summary(lm(formula = Bil.Lateral.Ventricle ~ CC_Mid_Posterior * SEX + ICV, data = datax)) # <.05 
summary(lm(formula = Bil.Lateral.Ventricle ~ CC_Central * SEX + ICV, data = datax))       # <.05 
summary(lm(formula = CC_Mid_Posterior ~ Bil.Lateral.Ventricle * SEX + ICV, data = datax)) # <.05
summary(lm(formula = CC_Mid_Posterior ~ CC_Central * SEX + ICV, data = datax))            # <.05

# ====
# plot
# ====

library(ggplot2); library(gridExtra)
#pdf("output.pdf")    # use if you want to ouput plot as a pdf file and finish with "dev.off()"
p1=ggplot(data6, aes(x=GROUP,y=CC_Anterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p2=ggplot(data6, aes(x=GROUP,y=CC_Mid_Anterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p3=ggplot(data6, aes(x=GROUP,y=CC_Central,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p4=ggplot(data6, aes(x=GROUP,y=CC_Mid_Posterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p5=ggplot(data6, aes(x=GROUP,y=CC_Posterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p6=ggplot(data6, aes(x=GROUP,y=Bil.Lateral.Ventricle,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=2000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p7=ggplot(data6, aes(x=GROUP,y=X3rd.Ventricle,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=40,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p8=ggplot(data6, aes(x=SEX,y=Bil.Lateral.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=2000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE)     # don't display guide
# geom_dotplot(); color:, filll:, 
# stat_summary(); ymin:, ymax:, 

grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, nrow=4, ncol=2, main = "Volumes of corpus callosum")
    # should use top instead of main?
# dev.off()    # use if you want to output plot. 

# memo: I did not set the plot output settings. Rplots.pdf is output and saved. Why? 

# set up data within PRO

datax=cbind(
    data6[c(1:15)],
    data6[c("READSTD","WASIIQ","GAFC","GAFH")],
    data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
    data6[c(regions,regions3,regions4,"ICV")]
)
datax=subset(datax,GROUP=="PRO")

# plot 

plot(datax$SINTOTEV, datax$Bil.Lateral.Ventricle)

library(ggplot2)

ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle)) + geom_point()

ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle,colour=SEX)) + geom_point()

sp=ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle))
sp + geom_point() + stat_smooth(method=lm, se=FALSE)

sp=ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle,colour=SEX))
sp + geom_point() + stat_smooth(method=lm, se=FALSE)

# explatory plot

ggplot(data6, aes(x=GROUP,y=CC_Mid_Posterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label

ggplot(data6, aes(x=GROUP,y=CC_Mid_Posterior,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label

data6$GROUPSEX=as.factor(paste(data6$GROUP,as.character(data6$SEX),sep=""))
p1=ggplot(data6, aes(x=GROUPSEX,y=CC_Mid_Posterior,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label

data6$GROUPSEX=as.factor(paste(data6$GROUP,as.character(data6$SEX),sep=""))
p2=ggplot(data6, aes(x=GROUPSEX,y=rCC_Mid_Posterior,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label

grid.arrange(p1,p2)

# ----------------------------------------------------------
# # plot with jitter
# 
# p1=ggplot(data6, aes(x=GROUP,y=Mid_Posterior,fill=GROUP)) +
#     geom_point(size=3,shape=21,position=position_jitter(width=.1,height=0))+    # with jitter
#     stat_summary(fun.y="mean",goem="point",shape="-",size=6,color="black",ymin=0,ymax=0) +    # add mean
#     guides(fill=FALSE) +    # don't display guide
#     theme(axis.title.x=element_blank()) +    # don't display x-axis-label
#     annotate("segment",x=1,xend=2,y=1150,yend=1150,arrow=arrow(ends="both",angle=90)) +    # add a bar
#     annotate("text",x=1.5,y=1120,label="*",size=10)    # add a * 

# ------------------------------------------------------------
# # plot for correlation matrix
# 
# mcor=cor([data.frame],use="complete.obs")     # option use : for data with NA
# library(corrplot)
# corrplot(mcor)

# -------------------------------------------------------------
# difference between with/without binpositions="all"
# 
# p51=ggplot(data6, aes(x=GROUP,y=CC_Posterior,fill=GROUP)) +
#     geom_dotplot(binaxis="y",binwidth=20,stackdir="center",binpositions="all") +
#     stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#     guides(fill=FALSE) +    # don't display guide
#     theme(axis.title.x=element_blank())    # don't display x-axis-label
# p52=ggplot(data6, aes(x=GROUP,y=CC_Posterior,fill=GROUP)) +
#     geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
#     stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#     guides(fill=FALSE) +    # don't display guide
#     theme(axis.title.x=element_blank())    # don't display x-axis-label
# grid.arrange(p51, p52, nrow=1, ncol=2, main = "Volumes of corpus callosum")

# ----------------------------------------------------------------------
# Notes: 
# "CC_Posterior", "CC_Mid_Posterior", "CC_Central", "CC_Mid_Anterior", "CC_Anterior", 	
# "Right.Lateral.Ventricle", "Left.Lateral.Ventricle", "X3rd.Ventricle"
# "EstimatedTotalIntraCranialVol", 
# check by mode(), or is.numeric(), is.factor(), change by as.numeric(), as.factor()
# references of functions: 
#   setwd() ... sets working directory, 
#   list.files() ... shows files in current directory, 
#   objects() ... shows all objects
# 
# r=ln(...); # s=summary(r)
# s[[1]], s$call; s[[4]], s$coefficients; class:matrix, 
# colnames(s[[4]]) ... "Estimate" "Std. Error" "t value" "Pr(>|t|)"
# rownames(summary_r[[4]]) ... "(Intercept)" "GROUPPRO" "SEX1" "ICV" "GROUPPRO:SEX1"
# 
# R options: 
#     -q, --quiet           Don't print startup message
#     --slave               Make R run as quietly as possible
# - Can I install Sublime Text 3 in PNL PC?
# - NA in volume are in HVPRO. no need to delete lines including NA in PRO
 
#----------------------------------------------
# Examples for functions

mkcmd <- function(arg1){
# arg1: characters
  t1="start"; t2=arg1; t3="end"
  paste(t1,t2,t3,sep="")
}
# What if command include double-quotation-marks? -> Just use \"

run <- function(arg1){
#    arg1: character
    print(arg1)    # maybe not necessary
    log(arg1)    # not yet defined
    eval(parse(text=arg1))
}

log=function(arg1,arg2){
    # arg1: one-element:character; arg2: one-element:character
    cat(c(arg1,"\n"),file=arg2)
}
#----------------------------------------------

# =======================
# data setting in home PC
# =======================

setwd("C:/Users/jun/Documents/test")
#fsstatfile="output20150911.csv"
fsstatfile="aseg_stats.txt"
demographictable="Caselist_CC_prodromes.xlsx"
#data1=read.xlsx(demographictable,sheetName="Full",header=TRUE)
#data4=read.csv(fsstatfile,header=TRUE)
#data6=data4
#data6=cbind(data6,data1)    # NOT paired data only for tryal analyses
#data6_pro=subset(data6,GROUP="PRO")    # NOT paired data only for tryal analyses

# ===================================
# statistic analyses
# ===================================

# ----------------------------------
# ANOVA with factors: GROUP, SEX, ICV
# ----------------------------------

funclm1 <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP*SEX+ICV,data=data6)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
funclm1("CC_Mid_Posterior")
funclm1("Bil.Lateral.Ventricle")

# ----------------------------------
# correlation analyses
# ----------------------------------

# extract PRO data for correlation analyses
datax=subset(data6,GROUP=="PRO")

# analyses

func=function(arg1){print(cor.test(x,arg1,method="spearman")[["p.value"]])}

x=datax[["CC_Mid_Posterior"]]    # vector
y=datax[["READSTD"]] ;func(y)
y=datax[["WASIIQ"]]  ;func(y)
y=datax[["GAFC"]]    ;func(y)
y=datax[["GAFH"]]    ;func(y)

x=datax[["Bil.Lateral.Ventricle"]]    # vector
y=datax[["READSTD"]] ;func(y)
y=datax[["WASIIQ"]]  ;func(y)
y=datax[["GAFC"]]    ;func(y)
y=datax[["GAFH"]]    ;func(y)

# =================
# inprotant analyses
# ==================

# ----------------------------------
# ANOVA with factors: GROUP, SEX, ICV
# ----------------------------------

# significant volume difference between groups

funclm1 <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP*SEX+ICV,data=data6)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
funclm1("CC_Mid_Posterior")
funclm1("Bil.Lateral.Ventricle")

# association in prodromes
# between Bil.Lateral.Ventricle and 
#     ("CC_Anterior","CC_Mid_Anterior","CC_Central","CC_Mid_Posterior","CC_Posterior","Bil.Lateral.Ventricle",
#     "READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
# between CC_Mid_Posterior and
#     ("CC_Anterior","CC_Mid_Anterior","CC_Central","CC_Mid_Posterior","CC_Posterior","Bil.Lateral.Ventricle",
#     "READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
# significant main effects about clinical values is only SINTOTEV on Bil.Lateral.Ventricle

datax=    cbind(
    data6[c(1:15)],
    data6[c("READSTD","WASIIQ","GAFC","GAFH")],
    data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
    data6[c(regions,regions3)],
    data6[regions4], 
    data6["ICV"]
)
datax=subset(datax,GROUP=="PRO")
summary(lm(formula = Bil.Lateral.Ventricle ~ SINTOTEV * SEX + ICV, data = datax))            # 0.00692
summary(lm(formula = Bil.Lateral.Ventricle ~ CC_Mid_Posterior * SEX + ICV, data = datax))    # <.05 
summary(lm(formula = Bil.Lateral.Ventricle ~ CC_Central * SEX + ICV, data = datax))          # <.05 
summary(lm(formula = CC_Mid_Posterior ~ Bil.Lateral.Ventricle * SEX + ICV, data = datax))    # <.05
summary(lm(formula = CC_Mid_Posterior ~ CC_Central * SEX + ICV, data = datax))               # <.05

library(ggplot2); library(gridExtra)
pdf("plot_volumes.pdf")    # use if you want to ouput plot as a pdf file and finish with "dev.off()"
p1=ggplot(data6, aes(x=GROUP,y=CC_Anterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p2=ggplot(data6, aes(x=GROUP,y=CC_Mid_Anterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p3=ggplot(data6, aes(x=GROUP,y=CC_Central,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p4=ggplot(data6, aes(x=GROUP,y=CC_Mid_Posterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p5=ggplot(data6, aes(x=GROUP,y=CC_Posterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p6=ggplot(data6, aes(x=GROUP,y=Bil.Lateral.Ventricle,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=2000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p7=ggplot(data6, aes(x=GROUP,y=X3rd.Ventricle,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=40,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p8=ggplot(data6, aes(x=SEX,y=Bil.Lateral.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=2000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE)     # don't display guide
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, nrow=4,ncol=2,top="Volumes of corpus callosum")
dev.off()    # use if you want to output plot. 

pdf("plot_CC_Mid_Posterior.pdf");p4;dev.off()
pdf("plot_Bil.Lateral.Ventricle.pdf");p6;dev.off()

pdf("plot_scatter.pdf")
ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle,colour=SEX)) + geom_point()
dev.off()

# ----------------------------------
# correlation analyses
# ----------------------------------

datax=cbind(
    data6[c(1:15)],
    data6[c("READSTD","WASIIQ","GAFC","GAFH")],
    data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
    data6[c(regions,regions3,region4)]
)
datax=subset(datax,GROUP=="PRO")
mask=sapply(datax,is.numeric)    # apply is.numeric to each column, output nuber is same as the number of co
datax=subset(datax,select=mask)    # select only data which are numeric

col=c("estimate","p.value")
item=c("rCC_Mid_Posterior","rBil.Lateral.Ventricle")
n=length(datax); m=length(col); o=length(item); lst=list()
for (k in 1:o) {
    lst[[item[k]]]=matrix(0,n,m)
    for (j in 1:m) {
        for (i in 1:n) {    # cor test between item and each-column-in-datax
            lst[[item[k]]][i,j]=cor.test(datax[[item[k]]],datax[[i]],method="spearman")[[col[j]]]
        }
    }
    rownames(lst[[item[k]]])=names(datax)
    colnames(lst[[item[k]]])=col
}
print(lst)

