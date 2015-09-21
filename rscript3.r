# This file is a script for R and run by
#     R --vanilla < rscript3.r

# -------------------------------------------------------------
# set variables
#     in the future, variables should be set in other "SetUpData.sh" file. 

# project=2015-delisi
# projectdir=/projects/schiz/3Tprojects/2015-jun-prodrome
# statdir=${projectdir}/stat
# fsstatdir=
fsstatfile="/projects/schiz/3Tprojects/2015-jun-prodrome/stats/aseg_stats.txt"
demographictable="/projects/schiz/3Tprojects/2015-jun-prodrome/caselist/Caselist_CC_prodromes.xlsx"

# ----------------------------------------------------------
# set up data

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
data6=subset(data5,! is.na(SEX))    # exclude rows which don't have SEX data.
data6$SEX=as.factor(data6$SEX)    # change into class:factor
data6$ICV=data6$EstimatedTotalIntraCranialVol    # change field name to be handled easier
data6$Bil.Lateral.Ventricle=data6$Right.Lateral.Ventricle+data6$Left.Lateral.Ventricle    # sum lt rt into bilateral

# # extract imprtatnt data
# 
# data7=subset(data6,select=c(GROUP,SEX,CC_Posterior,CC_Mid_Posterior,CC_Central,CC_Mid_Anterior,CC_Anterior,Left.Lateral.Ventricle,Right.Lateral.Ventricle,X3rd.Ventricle,EstimatedTotalIntraCranialVol))
# write.csv(data7,file="output20150911")

# -------------------------------------------------------------------------
# statistical analysis

# set variables

regions=c("CC_Anterior", "CC_Mid_Anterior", "CC_Central", "CC_Mid_Posterior", "CC_Posterior")
regions2=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle","X3rd.Ventricle")
regions3=c("Bil.Lateral.Ventricle","X3rd.Ventricle")

# ANOVA with factors: GROUP, SEX, ICV

funclm1 <- function(arg1){
    # arg1: characters
    # r=lm(arg1~GROUP*SEX+ICV,data=data6)
    # print(summary(r))
   
    txt1="r=lm("
    txt2=arg1
    txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")

#    print(txt0)
    eval(parse(text=txt0))
   
#    print(summary(r))
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

#    print(txt0)
    eval(parse(text=txt0))
   
#    print(summary(r))
    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])
}

for (region in regions ) {
    funclm2(region)
}

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
#print(summary(r))
    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])

# ANOVA with factors: GROUP, hemi, ICV

r=lm(volume~GROUP*hemi+ICV,data=dlv)
#print(summary(r))
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

# correlation analysis

mcor=cor(cbind(data6[c(regions,regions3)]),use="complete.obs")
#     # option use : for NA
# mcor=cor(na.omit(cbind(data6[c(regions,regions3)])))    # same as above

datax=na.omit(cbind(data6[c(regions,regions3)]))
plot(datax)    # plot of correlation matrix

n=length(datax)
mcorp=matrix(0,n,n)
for (j in 1:n) {    # matrix of correlation p-value
    for (i in 1:n) {
        mcorp[i,j]=cor.test(datax[[j]],datax[[i]])[["p.value"]]
    }
}
rownames(mcorp)=names(datax)
colnames(mcorp)=names(datax)
mask=(mcorp < 0.05)
mcorp.sig=mcorp
mcorp.sig[!mask]=NA
mcorp.sig.round=sprintf("%.2f",mcorp.sig)
mcorp.sig.round=as.numeric(mcorp.sig.round)
dim(mcorp.sig.round)=c(n,n)
rownames(mcorp.sig.round)=names(datax)
colnames(mcorp.sig.round)=names(datax)

datax=
    cbind(
        data6[c(1:15)],
#        data6[c(44:344)],
        data6[c("READSTD","WASIIQ","GAFC","GAFH")],
        data6[c(regions,regions3)]
    )
mask=sapply(datax,is.numeric)
# datax=datax[mask]    # ... this does not work
datax=subset(datax,select=mask)

# datax=na.omit(datax)    # ... this does not work
n=length(datax)
for (i in 1:n) {
#    print(names(datax[i]))
#    print(cor.test(datax[["CC_Mid_Posterior"]],datax[[i]])[["p.value"]])
    mcorp[i]=cor.test(datax[["CC_Mid_Posterior"]],datax[[i]])[["p.value"]]
}
# ... this does not work ... error in columns which have NAs

myfunc = function(arg1){
    # arg1: vector:numeric
    print(cor.test(datax[["CC_Mid_Posterior"]],datax[[arg1]])[["p.value"]])
}
myfunc("READSTD")
myfunc("WASIIQ")
myfunc("GAFC")
myfunc("GAFH")

cor.test(datax[["CC_Mid_Posterior"]],datax[["READSTD"]])[["p.value"]]    # 0.8071653
cor.test(datax[["CC_Mid_Posterior"]],datax[["WASIIQ"]])[["p.value"]]    # 0.8257893
cor.test(datax[["CC_Mid_Posterior"]],datax[["GAFC"]])[["p.value"]]    # 0.2955193
cor.test(datax[["CC_Mid_Posterior"]],datax[["GAFH"]])[["p.value"]]    # 0.2031281
cor.test(datax[["Bil.Lateral.Ventricle"]],datax[["READSTD"]])[["p.value"]]    # 0.1728446
cor.test(datax[["Bil.Lateral.Ventricle"]],datax[["WASIIQ"]])[["p.value"]]    # 0.8411307
cor.test(datax[["Bil.Lateral.Ventricle"]],datax[["GAFC"]])[["p.value"]]    # 0.04665685
cor.test(datax[["Bil.Lateral.Ventricle"]],datax[["GAFH"]])[["p.value"]]    # 0.09014714

# ... cor.test: arg1:vector, arg2:vector,


x=datax[["CC_Mid_Posterior"]]    # vector
mask=!is.na(x)    # vector:logical
x=x[mask]    # vector:numeric
y=datax[["READSTD"]][mask]
f=datax[["GROUP"]][mask]
func = function(arg1){
    # arg1 : vector:numeric
    print(cor.test(x,arg1)[["p.value"]])
}
tapply(y,f,func)

# in "func", x is not devided two. 
# so it does not work. 


maskfpro=(f == "PRO")    # vector:logical




names(mcorp)=names(datax)
mask=(mcorp < 0.05)
mcorp.sig=mcorp
mcorp.sig[!mask]=NA
mcorp.sig.round=printf("%.2f",mcorp.sig)
mcorp.sig.round=as.numeric(mcorp.sig.round)
names(mcorp.sig.round)=names(detax)


# plot

library(ggplot2)
library(gridExtra)
#pdf("output.pdf")
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
# dev.off()

# This function includes double-quotation-marks, so it's difficult to use eval...
#     It would work just using \" 
# I did not set the plot output settings. Rplots.pdf is output and saved. Why? 


# ----------------------------------------------------------
# # plot with jitter
# 
# p1=ggplot(data6, aes(x=GROUP,y=CC_Anterior,fill=GROUP)) +
#     geom_point(size=3,shape=21,position=position_jitter(width=.1,height=0))+
#     stat_summary(fun.y="mean",goem="point",shape="-",size=6,color="black",ymin=0,ymax=0) +
#     guides(fill=FALSE) +    # don't display guide
#     theme(axis.title.x=element_blank()) +    # don't display x-axis-label
#     annotate("segment",x=1,xend=2,y=1150,yend=1150,arrow=arrow(ends="both",angle=90)) +    # add a bar
#     annotate("text",x=1.5,y=1120,label="*",size=10)    # add a * 

# ------------------------------------------------------------
# # plot for correlation matrix
# 
# mcor=cor([data.frame],use="complete.obs")
#     # option use : for NA
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
# atomic-data-type: character, complex, double, integer, logical
# structural-data-type: vector, (matrix,) list, data.frame
# mode: numeric, character, list, function, ... mode()
# class: factor, ... class()

# 
# list[["name"]] is a element
# list["name"] is list
# 
# R options: 
#     -q, --quiet           Don't print startup message
#     --slave               Make R run as quietly as possible
 
#----------------------------------------------
# Example functions

mkcmd <- function(arg1){
# arg1: characters
  txt1="start"
  txt2=arg1
  txt3="end"
  paste(txt1,txt2,txt3,sep="")
}

# What if command include double-quotation-marks?

run <- function(arg1){
#    arg1: characters
#    print(arg1)    # maybe not necessary
#    log(arg1)    # not yet defined
    eval(parse(text=print(arg1)))
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
# ANOVA with factors: GROUP, SEX, ICV
# ===================================

funclm1 <- function(arg1){
    # arg1: characters
    # r=lm(arg1~GROUP*SEX+ICV,data=data6)
    # print(summary(r))
   
    txt1="r=lm("
    txt2=arg1
    txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")

#    print(txt0)
    eval(parse(text=txt0))
   
#    print(summary(r))
    s=summary(r)
    cat("----------------\n")
    print(s[[1]])
    print(s[[4]][,c(1,4)])
}

funclm1("CC_Mid_Posterior")
funclm1("Bil.Lateral.Ventricle")

# ====================
# correlation analyses
# ====================

# todo
# - which values should we analyses? 

# extract PRO data for correlation analyses

data6_pro=subset(data6,GROUP=="PRO")
    # memo: NA in volume are in HVPRO
    #       no need to delete lines including NA in PRO

# set data.frame

datax=data6_pro

# set function

func = function(arg1){
    # arg1 : vector:numeric
    print(cor.test(x,arg1,method="spearman")[["p.value"]])
}

# analyses

x=datax[["CC_Mid_Posterior"]]    # vector
mask=!is.na(x)    # vector:logical
x=x[mask]    # vector:numeric

y=datax[["READSTD"]][mask]
func(y)
y=datax[["WASIIQ"]][mask]
func(y)
y=datax[["GAFC"]][mask]
func(y)
y=datax[["GAFH"]][mask]
func(y)


x=datax[["Bil.Lateral.Ventricle"]]    # vector
mask=!is.na(x)    # vector:logical
x=x[mask]    # vector:numeric

y=datax[["READSTD"]][mask]
func(y)
y=datax[["WASIIQ"]][mask]
func(y)
y=datax[["GAFC"]][mask]
func(y)
y=datax[["GAFH"]][mask]
func(y)


# -----------------------------------------------
# Note
# ----------------------------------------------

# - Can I install Sublime Text 3 in PNL PC?

