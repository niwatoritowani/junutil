# This file is a script for R and run by
# R --vanilla < script.r

# set variables
# in the future, variables should be set in other "SetUpData.sh" file. 

# project=2015-delisi
# projectdir=/rfanfs/pnl-a/pnl/Collaborators/Delisi
# statdir=${projectdir}/stat
# statdir=/rfanfs/pnl-a/pnl/Collaborators/Delisi/pipelines-realign/test_stats
# fsstatdir=/rfanfs/pnl-a/pnl/Collaborators/Delisi/pipelines-realign/test_stats
fsstatfile="/projects/schiz/3Tprojects/2015-jun-prodrome/stats/aseg_stats.txt"
demographictable="/projects/schiz/3Tprojects/2015-jun-prodrome/caselist/Caselist_CC_prodromes.xlsx"

# ----------------------------------------------------------

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
# # nrow(sheet4) is ...
# # sheet4[44,] 

# load the freesurfer output table

data4=read.table(fsstatfile,header=TRUE)
# Measure:volume (field label) is turened to Measure.volume 
# and its data is for example DELISI_HM_0403.freesurfer

# formatting the strings of case id

data1[["caseid2"]]=substring(data1[["Case.."]],1,9)
data4[["caseid2"]]=substring(data4[["Measure.volume"]],1,9)
# substring(object,start,end) index starts from 1 not 0

# merge tables

data5=merge(data1,data4,by.x="caseid2",by.y="caseid2",all=TRUE)
data6=subset(data5,! is.na(SEX))
data6$SEX=as.factor(data6$SEX)
data6$ICV=data6$EstimatedTotalIntraCranialVol
data6$Bil.Lateral.Ventricle=data6$Right.Lateral.Ventricle+data6$Left.Lateral.Ventricle

# # extract imprtatnt data
# 
# data7=subset(data6,select=c(GROUP,SEX,CC_Posterior,CC_Mid_Posterior,CC_Central,CC_Mid_Anterior,CC_Anterior,Left.Lateral.Ventricle,Right.Lateral.Ventricle,X3rd.Ventricle,EstimatedTotalIntraCranialVol))
# write.csv(data7,file="output20150911")


# # plot data
# 
# library(Rcmdr)
# myfunc3 <- function(input,column,output){
#   png(output)
#     plotMeans(input$column,input$Dx,error.bars="se")
#   dev.off()
# }
# myfunc3(data5,CC_Posterio,"plot_CCPost.png")
# myfunc3(data5,CC_Mid_Posterio,"plot_CCMidPost.png")
# myfunc3(data5,CC_Central,"plot_CCCent.png")
# myfunc3(data5,CC_Mid_Anterior,"plot_CCMidAnt.png")
# myfunc3(data5,CC_Anterior,"plot_CCAnt.png")

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
#    print(arg1)
#    log(arg1)    # not yet defined
    eval(parse(text=print(arg1)))
}

#----------------------------------------------

regions=c("CC_Anterior", "CC_Mid_Anterior", "CC_Central", "CC_Mid_Posterior", "CC_Posterior")

funclm1 <- function(arg1){
    # arg1: characters
    # r=lm(CC_Posterior~GROUP*SEX+ICV,data=data6)
    # print(summary(r))
   
    txt1="r=lm("
    txt2=arg1
    txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")

    print(txt0)
    eval(parse(text=txt0))
   
    print(summary(r))
}

for (region in regions ) {
    funclm1(region)
}

funclm2 <- function(arg1){
    # arg1: characters
    # r=lm(arg1~GROUP+ICV,data=data6)
    # print(summary(r))
   
    txt1="r=lm("
    txt2=arg1
    txt3="~GROUP+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")

    print(txt0)
    eval(parse(text=txt0))
   
    print(summary(r))
}

for (region in regions ) {
    funclm2(region)
}

regions2=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle","X3rd.Ventricle")
for (region in regions2 ) {
    funclm1(region)
}

dlvrt=data.frame(GROUP=data6$GROUP, volume=data6$Right.Lateral.Ventricle, ICV=data6$ICV, SEX=data6$SEX, hemi="rt")
dlvlt=data.frame(GROUP=data6$GROUP, volume=data6$Left.Lateral.Ventricle, ICV=data6$ICV, SEX=data6$SEX, hemi="lt")
dlv=rbind(dlvrt,dlvlt)
r=lm(volume~GROUP*hemi*SEX+ICV,data=dlv)
summary(r)
r=lm(volume~GROUP*hemi+ICV,data=dlv)
summary(r)

regions3=c("Bil.Lateral.Ventricle","X3rd.Ventricle")
for (region in regions3 ) {
    funclm1(region)
}

library(ggplot2)
library(gridExtra)
pdf("output.pdf")
p1=ggplot(data6, aes(x=GROUP,y=CC_Anterior)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
p2=ggplot(data6, aes(x=GROUP,y=CC_Mid_Anterior)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
p3=ggplot(data6, aes(x=GROUP,y=CC_Central)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
p4=ggplot(data6, aes(x=GROUP,y=CC_Mid_Posterior)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
p5=ggplot(data6, aes(x=GROUP,y=CC_Posterior)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
p6=ggplot(data6, aes(x=GROUP,y=Bil.Lateral.Ventricle)) +
    geom_dotplot(binaxis="y",binwidth=2000,stackdir="center")
p7=ggplot(data6, aes(x=GROUP,y=X3rd.Ventricle)) +
    geom_dotplot(binaxis="y",binwidth=40,stackdir="center")
p8=ggplot(data6, aes(x=SEX,y=Bil.Lateral.Ventricle)) +
    geom_dotplot(binaxis="y",binwidth=2000,stackdir="center")

grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, nrow=4, ncol=2, main = "Volumes of corpus callosum")
dev.off()
# This function includes double-quotation-marks, so it's difficult to use eval...



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
