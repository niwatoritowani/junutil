# This file is a script for R and run by
#     R --vanilla < rscript3.r

# =============
# set variables
# =============

# project=2015-delisi
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
#     AGE
#     SEX: 0 or 1; need to be changed to factor(class)
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
data6$rBil.Lateral.Ventricle=data6$Bil.Lateral.Ventricle/data6$ICV
data6$rCC_Anterior          =data6$CC_Anterior          /data6$ICV
data6$rCC_Mid_Anterior      =data6$CC_Mid_Anterior      /data6$ICV
data6$rCC_Central           =data6$CC_Central           /data6$ICV
data6$rCC_Mid_Posterior     =data6$CC_Mid_Posterior     /data6$ICV
data6$rCC_Posterior         =data6$CC_Posterior         /data6$ICV

# set variables

regions=c("CC_Anterior", "CC_Mid_Anterior", "CC_Central", "CC_Mid_Posterior", "CC_Posterior")
regions2=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle","X3rd.Ventricle")
regions3=c("Bil.Lateral.Ventricle","X3rd.Ventricle")
regions4=c("rCC_Anterior", "rCC_Mid_Anterior", "rCC_Central", "rCC_Mid_Posterior", "rCC_Posterior", "rBil.Lateral.Ventricle")

# ====================
# statistical analysis
# ===================

# ---------------------------
# analyses of corpus callosum
# ---------------------------

# ANOVA with factors: GROUP, SEX, ICV

funclm1 <- function(arg1){
    # arg1: characters
    # r=lm(arg1~GROUP*SEX+ICV,data=data6)
   
    txt1="r=lm("
    txt2=arg1
    txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")

    eval(parse(text=txt0))
    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])
}

for (region in regions ) {
    funclm1(region)
}

# ANOVA with factors: GROUP, ICV

funclm2 <- function(arg1){
    # arg1: characters
    # r=lm(arg1~GROUP+ICV,data=data6)
    # print(summary(r))
   
    txt1="r=lm("
    txt2=arg1
    txt3="~GROUP+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")

    eval(parse(text=txt0))
    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])
}

for (region in regions ) {
    funclm2(region)
}
# results: no significant group difference

# ANOVA with factors: GROUP, SEX; relative volume

funclm3 <- function(arg1){
    # arg1: characters
    # r=lm(arg1~GROUP*SEX,data=data6)
   
    txt1="r=lm("
    txt2=arg1
    txt3="~GROUP*SEX,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")

    eval(parse(text=txt0))
    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])
}

for (region in regions4 ) {
    funclm3(region)
}
# results: no significant group difference

# ---------------------
# analyses of venricles
# ---------------------

# ANOVA with factors: GROUP, SEX, ICV

for (region in regions2 ) {
    funclm1(region)
}

# make data.frame for the analyses with hemisphere as factor

dlvrt=data.frame(GROUP=data6$GROUP, volume=data6$Right.Lateral.Ventricle, ICV=data6$ICV, SEX=data6$SEX, hemi="rt")
dlvlt=data.frame(GROUP=data6$GROUP, volume=data6$Left.Lateral.Ventricle, ICV=data6$ICV, SEX=data6$SEX, hemi="lt")
dlv=rbind(dlvrt,dlvlt)

# ANOVA with factors: GROUP, hemi, SEX, ICV

r=lm(volume~GROUP*hemi*SEX+ICV,data=dlv)
    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])

# ANOVA with factors: GROUP, hemi, ICV

r=lm(volume~GROUP*hemi+ICV,data=dlv)
    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])

# ANOVA with factors: GROUP, SEX, ICV

for (region in regions3 ) {
    funclm1(region)
}

# ANOVA with factors: GROUP, ICV

for (region in regions3 ) {
    funclm2(region)
}

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

datax=
    cbind(
        data6[c(1:15)],
        data6[c("READSTD","WASIIQ","GAFC","GAFH")],
        data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
        data6[c(regions,regions3)],
        data6[regions4]
    )

datax_pro=subset(datax,GROUP=="PRO")
datax=datax_pro
mask=sapply(datax,is.numeric)    # apply is.numeric to each column, output nuber is same as the number of co
datax=subset(datax,select=mask)    # select only data which are numeric
#datax=na.omit(datax)    # revome row data with NA

n=length(datax)
col=c("estimate","p.value")
m=length(col)
item=c("rCC_Mid_Posterior","rBil.Lateral.Ventricle")
o=length(item)

lst=list()
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

# use linear model
# ----------------

# set up data

datax=
    cbind(
        data6[c(1:15)],
        data6[c("READSTD","WASIIQ","GAFC","GAFH")],
        data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
        data6[c(regions,regions3)],
        data6[regions4],
        data6["ICV"]
    )

datax_pro=subset(datax,GROUP=="PRO")
datax=datax_pro

# ANOVA with factors: ICV

funclm4 <- function(arg1,arg2){
    # arg1: character
    # arg2: character
    # r=lm(arg1~arg2+ICV,data=datax)
   
    txt1="r=lm("
    txt2=arg1
    txt3="~"
    txt4=arg2
    txt5="+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")

    eval(parse(text=txt0))
    s=summary(r)
    cat("----------------\n")
    print(s[["call"]])
    print(s[["coefficients"]][,c(1,4)])
}

item=c("CC_Mid_Posterior","Bil.Lateral.Ventricle")
m=length(item)
datacol=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
n=length(datacol)

for ( j in 1:m) {
    for ( i in 1:n ) {
        funclm4(item[j],datacol[i])
    }
}

# ANOVA with factors:SEX, ICV

funclm5 <- function(arg1,arg2){
    # arg1: character
    # arg2: character
    # r=lm(arg1~arg2+SEX+ICV,data=datax)
   
    txt1="r=lm("
    txt2=arg1
    txt3="~"
    txt4=arg2
    txt5="+SEX+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")

    eval(parse(text=txt0))
    s=summary(r)
    cat("----------------\n")
    print(s[["call"]])
    print(s[["coefficients"]][,c(1,4)])
}

item=c("CC_Mid_Posterior","Bil.Lateral.Ventricle")
m=length(item)
datacol=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
n=length(datacol)

for ( j in 1:m) {
    for ( i in 1:n ) {
        funclm5(item[j],datacol[i])
    }
}

# ====
# plot
# ====

library(ggplot2)
library(gridExtra)
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
# dev.off()    # use if you want to output plot. 

# I did not set the plot output settings. Rplots.pdf is output and saved. Why? 

# ----------------------------------------------------------
# # plot with jitter
# 
# p1=ggplot(data6, aes(x=GROUP,y=CC_Anterior,fill=GROUP)) +
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

# ----------------------------------------------------------------------
# Notes: 
# CC_Posterior, CC_Mid_Posterior, CC_Central, CC_Mid_Anterior, CC_Anterior	
# "Right.Lateral.Ventricle", "Left.Lateral.Ventricle", "X3rd.Ventricle"
# "EstimatedTotalIntraCranialVol"
# CC_Posterior is numeric? Dx is factor? AGE is numeric? 
# check by mode(), or is.numeric(), is.factor(), change by as.numeric(), as.factor()
# references of functions: 
#   setwd() sets working directory, 
#   list.files() shows files in current directory, 
#   objects() shows all objects
# 
# r=ln(...)
# s=summary(r)
# s[[1]], s$call; 
# s[[4]], s$coefficients; class:matrix, 
#     # How to get the row and column labels of matrix?
# colnames(s[[4]]) ... "Estimate" "Std. Error" "t value" "Pr(>|t|)"
# rownames(summary_r[[4]]) ... "(Intercept)" "GROUPPRO" "SEX1" "ICV" "GROUPPRO:SEX1"
#     - print(s[[1]]), print(s[[4]][,c(1,4)})
# 
# R options: 
#     -q, --quiet           Don't print startup message
#     --slave               Make R run as quietly as possible
# - Can I install Sublime Text 3 in PNL PC?
# - NA in volume are in HVPRO. no need to delete lines including NA in PRO
 
#----------------------------------------------
# Example functions

mkcmd <- function(arg1){
# arg1: characters
  txt1="start"
  txt2=arg1
  txt3="end"
  paste(txt1,txt2,txt3,sep="")
}
# What if command include double-quotation-marks? -> Just use \"

run <- function(arg1){
#    arg1: character
    print(arg1)    # maybe not necessary
    log(arg1)    # not yet defined
    eval(parse(text=arg1))
}

log=function(arg1,arg2){
    # arg1: one-element:character
    # arg2: one-element:character
    cat(c(arg1,"\n"),file=arg2)
}

#----------------------------------------------

# =======================
# data setting in home PC
# =======================

setwd("C:/Users/jun/Documents/test")
fsstatfile="output20150911.csv"
demographictable="Caselist_CC_prodromes.xlsx"
data1=read.xlsx(demographictable,sheetName="Full",header=TRUE)
data4=read.csv(fsstatfile,header=TRUE)
data6=data4
data6=cbind(data6,data1)    # NOT paired data only for tryal analyses
data6_pro=subset(data6,GROUP="PRO")    # NOT paired data only for tryal analyses

# ===================================
# statistic analyses
# ===================================

# ----------------------------------
# ANOVA with factors: GROUP, SEX, ICV
# ----------------------------------

funclm1 <- function(arg1){
    # arg1: characters
    # r=lm(arg1~GROUP*SEX+ICV,data=data6)
   
    txt1="r=lm("
    txt2=arg1
    txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0))
   
    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])
}

funclm1("CC_Mid_Posterior")
funclm1("Bil.Lateral.Ventricle")

# ----------------------------------
# correlation analyses
# ----------------------------------

# extract PRO data for correlation analyses

data6_pro=subset(data6,GROUP=="PRO")
datax=data6_pro

# analyses

func=function(arg1){
    # arg1 : vector:numeric
    print(cor.test(x,arg1,method="spearman")[["p.value"]])
}

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

funclm1 <- function(arg1){
    # arg1: characters
    # r=lm(arg1~GROUP*SEX+ICV,data=data6)

    txt1="r=lm("
    txt2=arg1
    txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0))

    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])
}

funclm1("CC_Mid_Posterior")
funclm1("Bil.Lateral.Ventricle")

# ----------------------------------
# correlation analyses
# ----------------------------------

datax=
    cbind(
        data6[c(1:15)],
        data6[c("READSTD","WASIIQ","GAFC","GAFH")],
        data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
        data6[c(regions,regions3)],
        data6[regions4]
    )

datax_pro=subset(datax,GROUP=="PRO")
datax=datax_pro
mask=sapply(datax,is.numeric)    # apply is.numeric to each column, output nuber is same as the number of co
datax=subset(datax,select=mask)    # select only data which are numeric

n=length(datax)
col=c("estimate","p.value")
m=length(col)
item=c("rCC_Mid_Posterior","rBil.Lateral.Ventricle")
o=length(item)

lst=list()
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
lst

