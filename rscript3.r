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
#     SEX: 0 or 1
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

# # extract imprtatnt data
# 
# data7=subset(data6,select=c(GROUP,SEX,CC_Posterior,CC_Mid_Posterior,CC_Central,CC_Mid_Anterior,CC_Anterior,Left.Lateral.Ventricle,Right.Lateral.Ventricle,X3rd.Ventricle,EstimatedTotalIntraCranialVol))
# write.csv(data7,file="output20150911")

# AGE as a nuisance variable

myfunc <- function(input,column,output){
  output=lm(column~dx+AGE,data=input)
  summary(output)
}
myfunc(data5,CC_Posterio,result_CCPost)
myfunc(data5,CC_Mid_Posterio,result_CCMidPost)
myfunc(data5,CC_Central,result_CCCent)
myfunc(data5,CC_Mid_Anterior,result_CCMidAnt)
myfunc(data5,CC_Anterior,result_CCAnt)

# ICV as a nuisance variable

myfunc2 <- function(input,column,output){
  output=lm(column~dx+EstimatedTotalIntraCranialVol,data=input)
  summary(output)
}
myfunc2(data5,CC_Posterio,result_CCPost)
myfunc2(data5,CC_Mid_Posterio,result_CCMidPost)
myfunc2(data5,CC_Central,result_CCCent)
myfunc2(data5,CC_Mid_Anterior,result_CCMidAnt)
myfunc2(data5,CC_Anterior,result_CCAnt)

# model: group, sex, ICV as factors

myfunc <- function(input,column,output){
  txt=paste(output,"=lm(",column,"~dx*SEX+ICV,data=",input,")",sep="")
  eval(parse(text=txt))
  summary(output)
}
myfunc("data6","CC_Posterior","result_CCPost")
myfunc(data6,CC_Mid_Posterior,result_CCMidPost)
myfunc(data6,CC_Central,result_CCCent)
myfunc(data6,CC_Mid_Anterior,result_CCMidAnt)
myfunc(data6,CC_Anterior,result_CCAnt)

# This does not work.
# eval(parse(text = "command1 command2"))

r=lm(CC_Posterior~dx*SEX+ICV,data=data6)
summary(r)


# plot data

library(Rcmdr)
myfunc3 <- function(input,column,output){
  png(output)
    plotMeans(input$column,input$Dx,error.bars="se")
  dev.off()
}
myfunc3(data5,CC_Posterio,"plot_CCPost.png")
myfunc3(data5,CC_Mid_Posterio,"plot_CCMidPost.png")
myfunc3(data5,CC_Central,"plot_CCCent.png")
myfunc3(data5,CC_Mid_Anterior,"plot_CCMidAnt.png")
myfunc3(data5,CC_Anterior,"plot_CCAnt.png")

# ggplot

library(ggplot2)
myfunc4 <- function(fieldlabel){
    ggplot(data6, aes(x=GROUP,y=fieldlabel)) +
        geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
}
# message : Error in eval(expr, envir, enclos) : object 'fieldlabel' not found
# why?

ggplot(data6, aes(x=GROUP,y=CC_Anterior)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
ggplot(data6, aes(x=GROUP,y=CC_Mid_Anterior)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
ggplot(data6, aes(x=GROUP,y=CC_Central)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
ggplot(data6, aes(x=GROUP,y=CC_Mid_Posterior)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
ggplot(data6, aes(x=GROUP,y=CC_Posterior)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
 

myfunc5(input,column,output){
    png(output)
        ggplot(input, aes(x=GROUP,y=column)) +
            geom_dotplot(binaxis="y",binwidth=20,stackdir="center")
    dev.off()
}
# This probably does not work. 
# eval(parse(text = "command1 command2"))
# may work.





# ----------------------------------------------------------------------
# Notes: 
# CC_Posterior, CC_Mid_Posterior, CC_Central, CC_Mid_Anterior, CC_Anterior	
# CC_Posterior is numeric? Dx is factor? AGE is numeric? 
# check by mode(), or is.numeric(), is.factor(), change by as.numeric(), as.factor()
# references of functions: 
#   setwd() sets working directory, 
#   list.files() shows files in current directory, 
#   objects() shows all objects
