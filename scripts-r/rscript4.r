--------------------
filename: rscript4.r
author: Jun Konishi
--------------------

# =============
# set up data
# =============

# setwd("/projects/schiz/3Tprojects/2015-jun-prodrome/stats/02_editedfreesurfer/")
fsstatfile="/projects/schiz/3Tprojects/2015-jun-prodrome/stats/02_editedfreesurfer/edited.aseg_stats.txt"
demographictable="/projects/schiz/3Tprojects/2015-jun-prodrome/caselist/Caselist_CC_prodromes.xlsx"

# load the demographic table

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
asegnames=names(data4)
# field labels:
#     Measure:volume (field label) is turened to Measure.volume 
#     and its data is for example DELISI_HM_0403.freesurfer

# format the strings of case id, merge tables, arrange field names

data1[["caseid2"]]=substring(data1[["Case.."]],1,9)
data4[["caseid2"]]=substring(data4[["Measure.volume"]],1,9)     # this work even in fs-edited file
data5=merge(data1,data4,by.x="caseid2",by.y="caseid2",all=TRUE)
data6=subset(data5,! is.na(SEX))    # exclude rows which don't have SEX data
data6$SEX=as.factor(data6$SEX)    # change into class:factor
data6$ICV=data6$EstimatedTotalIntraCranialVol    # change field name to be handled more easily
data6$Bil.Lateral.Ventricle=data6$Right.Lateral.Ventricle+data6$Left.Lateral.Ventricle    # summarize lt rt into bilateral
data6$rRight.Lateral.Ventricle=data6$Right.Lateral.Ventricle/data6$ICV
data6$rLeft.Lateral.Ventricle =data6$Left.Lateral.Ventricle /data6$ICV
data6$rBil.Lateral.Ventricle  =data6$Bil.Lateral.Ventricle  /data6$ICV
data6$rX3rd.Ventricle         =data6$X3rd.Ventricle  /data6$ICV
data6$rCC_Anterior          =data6$CC_Anterior          /data6$ICV
data6$rCC_Mid_Anterior      =data6$CC_Mid_Anterior      /data6$ICV
data6$rCC_Central           =data6$CC_Central           /data6$ICV
data6$rCC_Mid_Posterior     =data6$CC_Mid_Posterior     /data6$ICV
data6$rCC_Posterior         =data6$CC_Posterior         /data6$ICV
data6$SEX2=as.character(data6$SEX);mask=(data6$SEX2=="0");data6$SEX2[mask]="M";data6$SEX2[!mask]="F";data6$SEX2=as.factor(data6$SEX2)
data6$GROUPSEX=as.factor(paste(data6$GROUP,as.character(data6$SEX2),sep=""))

# set cerebral volumes

setwd("/projects/schiz/3Tprojects/2015-jun-prodrome/stats/02_editedfreesurfer")
datax=data6
#rh
fsstatfile="edited.aparc_stats_rh_volume.txt"
data4=read.table(fsstatfile,header=TRUE)
data4[["caseid2"]]=substring(data4[["rh.aparc.volume"]],1,9)     # this work even in fs-edited file
rhnames=names(data4)
datax=merge(datax,data4,by.x="caseid2",by.y="caseid2",all=TRUE)
#lh
fsstatfile="edited.aparc_stats_lh_volume.txt"
data4=read.table(fsstatfile,header=TRUE)
data4[["caseid2"]]=substring(data4[["lh.aparc.volume"]],1,9)     # this work even in fs-edited file
lhnames=names(data4)
datay=merge(datax,data4,by.x="caseid2",by.y="caseid2",all=TRUE)
#data.vol=datay    # after calculating relative volumes

# set other data

# set variables

regions=c("CC_Anterior", "CC_Mid_Anterior", "CC_Central", "CC_Mid_Posterior", "CC_Posterior")
regions2=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle","X3rd.Ventricle")
regions3=c("Bil.Lateral.Ventricle","X3rd.Ventricle")
regions4=c("rCC_Anterior", "rCC_Mid_Anterior", "rCC_Central", "rCC_Mid_Posterior", "rCC_Posterior", "rRight.Lateral.Ventricle","rLeft.Lateral.Ventricle","rBil.Lateral.Ventricle","rX3rd.Ventricle")
demographics1=c("GROUP","AGE","SEX")
parameters1=c("SOCFXC","ROLEFX")
parameters2=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
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

summary(data6[,c(demographics1,parameters2,parameters1)]) # summary
#by(data6[demographics1],data6$SEX,summary) # grouped by sex
by(data6[,c(demographics1,parameters2)],data6$GROUP,summary)  # groupd by GROUP (PRO and control)
summary(table(data6$GROUP,data6$SEX)) # chi test
t.test(subset(data6,GROUP=="PRO")["AGE"],subset(data6,GROUP=="HVPRO")["AGE"]) # t-test

# ---------------------------------------------
# output demographic table
# ---------------------------------------------

#datax=data6
#datax=data6[-29,]  # exclude a case which have no volume data
datax=subset(data6,subset=(!is.na(CC_Anterior))) # exclude a case which have no volume data
items=c("AGE","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV","SOCFXC","ROLEFX")
v1=sapply(datax[,items],mean,na.rm=TRUE)
v2=sapply(datax[,items],sd,na.rm=TRUE)

datay=subset(datax,GROUP=="PRO");
v3=sapply(datay[,items],mean,na.rm=TRUE)
v4=sapply(datay[,items],sd,na.rm=TRUE)

datay=subset(datax,!GROUP=="PRO");
v5=sapply(datay[,items],mean,na.rm=TRUE)
v6=sapply(datay[,items],sd,na.rm=TRUE)

n=length(items);v7=numeric(n);
for ( i in 1:n){
    r1=t.test(subset(datax,GROUP=="PRO")[items[i]],subset(datax,GROUP=="HVPRO")[items[i]])
    v7[i]=r1[["p.value"]]
}

table1=data.frame(tot_mean=v1,tot_sd=v2,pro_mean=v3,pro_sd=v4,hc_mean=v5,hc_sd=v6,p.value=v7)

m=by(datax[,c("SEX")],datax$GROUP,summary) # ... use table() ?
r=summary(table(datax$GROUP,datax$SEX))[["p.value"]]  # chi test
table1=rbind(table1,c("","",m[["PRO"]][["0"]],"",m[["HVPRO"]][["0"]],"",r))
rownames(table1)[nrow(table1)]="male"

table1[1,c(1:6)]=sprintf("%.1f",as.numeric(table1[1,c(1:6)])) 
table1[2,c(1:6)]=sprintf("%.1f",as.numeric(table1[2,c(1:6)])) 
table1[3,c(1:6)]=sprintf("%.1f",as.numeric(table1[3,c(1:6)])) 
table1[4,c(1:6)]=sprintf("%.1f",as.numeric(table1[4,c(1:6)])) 
table1[5,c(1:6)]=sprintf("%.2f",as.numeric(table1[5,c(1:6)])) 
table1[6,c(1:6)]=sprintf("%.2f",as.numeric(table1[6,c(1:6)])) 
table1[7,c(1:6)]=sprintf("%.2f",as.numeric(table1[7,c(1:6)])) 
table1[8,c(1:6)]=sprintf("%.2f",as.numeric(table1[8,c(1:6)])) 
table1[9,c(1:6)]=sprintf("%.2f",as.numeric(table1[9,c(1:6)])) 
table1[10,c(1:6)]=sprintf("%.2f",as.numeric(table1[10,c(1:6)])) 
table1[11,c(1:6)]=sprintf("%.2f",as.numeric(table1[11,c(1:6)])) 
table1[,7]=sprintf("%.3f",as.numeric(table1[,7])) 

n=nrow(table1); tablex=rbind(table1[n,])
for ( i in 1:(n-1) ) {tablex=rbind(tablex,table1[i,])} 

table1=tablex;knitr::kable(table1)

# ---------------------------
# analyses of corpus callosum
# ---------------------------

options(contrasts =c("contr.treatment","contr.poly")) # default contrast
funclm <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
    print(s[["call"]]);     # show model
    print(s[["coefficients"]][,c(1,4)])
#    print(anova(r))    # for anova
}
myfunc=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {funclm(item[j],datacol[i],arg3)}}
}

# General linear model with various factors: GROUP, SEX, GROUP*SEX, ICV

datax=data6
item=c(regions,regions2);myfunc(item,"","GROUP*SEX+ICV")    # CC, ventricles
item=c(regions3);        myfunc(item,"","GROUP*SEX+ICV")    # ventricles, bil.LV
item=c(regions,regions2);myfunc(item,"","GROUP+ICV")  # CC, ventricles
item=c(regions3);        myfunc(item,"","GROUP+ICV")  # ventricles, bil.LV
datax=subset(data6,SEX==0); item=c(regions); myfunc(item,"","GROUP+ICV")
datax=subset(data6,SEX==1); item=c(regions); myfunc(item,"","GROUP+ICV")
datax=data6; item=c(regions4); myfunc(item,"","GROUP*SEX")
datax=data6; item=c(regions); myfunc(item,"","GROUP*SEX+AGE+ICV")

# General linear model with factors: [SEX,] [:SEX,] [AGE,] ICV in subgroup (PRO/HVPRO or Male/Female)

#item=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","Left.Lateral.Ventricle")
item=c(regions,regions2)
#datacol=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
#datacol=c(parameters_si)
datacol=c(parameters1)
#datacol=c(regions,regions2)

datax=subset(data6,GROUP=="PRO"); myfunc(item,datacol,"+ICV")
datax=subset(data6,GROUP=="PRO"); myfunc(item,datacol,"+SEX+ICV")
datax=subset(data6,GROUP=="PRO"); myfunc(item,datacol,"+SEX+AGE+ICV")
datax=subset(data6,GROUP=="PRO"); myfunc(item,datacol,"*SEX+AGE+ICV")

datax=subset(data6,SEX==0);myfunc("Left.Lateral.Ventricle","","GROUP+ICV")
datax=subset(data6,SEX==1);myfunc("Left.Lateral.Ventricle","","GROUP+ICV")
datax=subset(data6,GROUP=="PRO");myfunc("Left.Lateral.Ventricle","","SEX+ICV")
datax=subset(data6,!GROUP=="PRO");myfunc("Left.Lateral.Ventricle","","SEX+ICV")

# General linear model with factors:SEX in PRO, relative volume

item=c("rCC_Mid_Posterior","rBil.Lateral.Ventricle")
datacol=c("rCC_Mid_Posterior","rBil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
datax=subset(data6,GROUP=="PRO"); myfunc(item,datacol,"+SEX")

# ---------------------
# analyses of venricles
# ---------------------

# make data.frame for the analyses with hemisphere as factor

dlvrt=data.frame(GROUP=data6$GROUP, volume=data6$Right.Lateral.Ventricle, ICV=data6$ICV, SEX=data6$SEX, hemi="rt")
dlvlt=data.frame(GROUP=data6$GROUP, volume=data6$Left.Lateral.Ventricle, ICV=data6$ICV, SEX=data6$SEX, hemi="lt")
dlv=rbind(dlvrt,dlvlt)

# General linear model with factors: GROUP, hemi, [SEX,] ICV

r=lm(volume~GROUP*hemi*SEX+ICV,data=dlv); s=summary(r); print(s[[1]]); print(s[[4]][,c(1,4)])
r=lm(volume~GROUP*hemi+ICV,data=dlv);     s=summary(r); print(s[[1]]); print(s[[4]][,c(1,4)])
# General linear model with factors: GROUP, SEX, ICV  --> above
# General linear model with factors: GROUP, ICV       --> above

# ------------------------------------------
# t-test on "CC_Mid_Posterior" by GROUP, SEX
# ------------------------------------------

datax=data6; t.test(subset(datax,GROUP=="PRO")["CC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["CC_Mid_Posterior"])
datax=subset(data6,SEX==0); t.test(subset(datax,GROUP=="PRO")["CC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["CC_Mid_Posterior"])
datax=subset(data6,SEX==1); t.test(subset(datax,GROUP=="PRO")["CC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["CC_Mid_Posterior"])
datax=data6;t.test(subset(datax,SEX==0)["CC_Mid_Posterior"],subset(datax,SEX==1)["CC_Mid_Posterior"])
datax=subset(data6,GROUP=="PRO");t.test(subset(datax,SEX==0)["CC_Mid_Posterior"],subset(datax,SEX==1)["CC_Mid_Posterior"])
datax=subset(data6,GROUP=="HVPRO");t.test(subset(datax,SEX==0)["CC_Mid_Posterior"],subset(datax,SEX==1)["CC_Mid_Posterior"])
    # results: PRO  < HC     in all (PRO  << HC    in male, PRO  > HC     in female)
    # results: male < female in all (male > female in HC,   male < female in PRO)
datax=data6; t.test(subset(datax,GROUP=="PRO")["rCC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["rCC_Mid_Posterior"])
datax=subset(data6,SEX==0); t.test(subset(datax,GROUP=="PRO")["rCC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["rCC_Mid_Posterior"])
datax=subset(data6,SEX==1); t.test(subset(datax,GROUP=="PRO")["rCC_Mid_Posterior"],subset(datax,GROUP=="HVPRO")["rCC_Mid_Posterior"])
datax=data6;t.test(subset(datax,SEX==0)["rCC_Mid_Posterior"],subset(datax,SEX==1)["rCC_Mid_Posterior"])
datax=subset(data6,GROUP=="PRO");t.test(subset(datax,SEX==0)["rCC_Mid_Posterior"],subset(datax,SEX==1)["rCC_Mid_Posterior"])
datax=subset(data6,GROUP=="HVPRO");t.test(subset(datax,SEX==0)["rCC_Mid_Posterior"],subset(datax,SEX==1)["rCC_Mid_Posterior"])
    # results: PRO  < HC  in all    (PRO  << HC     in male, PRO  > HC     in female)
    # results: male < female in all (male <  female in PRO,  male > female in HC)

# -------------------------------------------
# more simple script for correlation analysis
# -------------------------------------------

datax=    cbind(
    data6[c(1:15)],
    data6[c("READSTD","WASIIQ","GAFC","GAFH")],
    data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
#    data6[c(regions,regions3)],
    data6[regions4],
#    data6[regions2],
#    data6[parameters_si],
    data6[parameters1]
)
datax=subset(datax,GROUP=="PRO")
mask=sapply(datax,is.numeric)    # apply is.numeric to each column, output nuber is same as the number of co
datax=subset(datax,select=mask)    # select only data which are numeric
#datax=na.omit(datax)    # revome row data with NA

col=c("estimate","p.value")    # vector:character
item=c("rCC_Mid_Posterior","rLeft.Lateral.Ventricle","rBil.Lateral.Ventricle")
#item=c(regions4)
n=length(datax);m=length(col); o=length(item); lst=list()
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

# ====
# plot
# ====

# ---------------
# volume graphs
# ---------------

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
# options of geom_dotplot(); color:, filll:, 
# options of stat_summary(); ymin:, ymax:, 
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, nrow=4, ncol=2, main = "Volumes of corpus callosum")
    # should use top instead of main?
# dev.off()    # use if you want to output plot. 

# -------------------------------
# simple volume graphs, 2015/09/29
# --------------------------------

library(ggplot2); library(gridExtra)
# pdf("tmp.pdf",useDingbats=FALSE)
p1=ggplot(data6, aes(x=GROUP,y=CC_Anterior,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p2=ggplot(data6, aes(x=GROUP,y=CC_Mid_Anterior,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p3=ggplot(data6, aes(x=GROUP,y=CC_Central,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p4=ggplot(data6, aes(x=GROUP,y=CC_Mid_Posterior,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p5=ggplot(data6, aes(x=GROUP,y=CC_Posterior,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p6=ggplot(data6, aes(x=GROUP,y=Bil.Lateral.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=2000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p7=ggplot(data6, aes(x=GROUP,y=X3rd.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=40,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p8=ggplot(data6, aes(x=GROUP,y=Right.Lateral.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=1000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p9=ggplot(data6, aes(x=GROUP,y=Left.Lateral.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=1000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, main = "Volumes of corpus callosum")
# dev.off()

# ---------------------------------
# simple volume graph 2, 2015/10/09
# ---------------------------------


library(ggplot2); library(gridExtra)
datax=data6
#pdf("tmp.pdf",useDingbats=FALSE)
p1=ggplot(datax, aes(x=GROUP,y=CC_Anterior,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p2=ggplot(datax, aes(x=GROUP,y=CC_Mid_Anterior,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p3=ggplot(datax, aes(x=GROUP,y=CC_Central,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p4=ggplot(datax, aes(x=GROUP,y=CC_Mid_Posterior,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p5=ggplot(datax, aes(x=GROUP,y=CC_Posterior,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p6=ggplot(datax, aes(x=GROUP,y=Bil.Lateral.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=2000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p7=ggplot(datax, aes(x=GROUP,y=X3rd.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=40,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p8=ggplot(datax, aes(x=GROUP,y=Right.Lateral.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=1000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p9=ggplot(datax, aes(x=GROUP,y=Left.Lateral.Ventricle,fill=SEX)) +
    geom_dotplot(binaxis="y",binwidth=1000,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, main = "Volumes of corpus callosum")
#dev.off()

# ---------------------------
# plot for correlation in PRO 
# ---------------------------

datax=subset(data6,GROUP=="PRO")
plot(datax$SINTOTEV, datax$Bil.Lateral.Ventricle)
library(ggplot2)
ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle,colour=SEX)) + geom_point()
ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle,colour=SEX)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)

# ----------------
# exploratory plot
# ----------------

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

library(ggplot2); library(gridExtra)
p1=ggplot(data6, aes(x=GROUPSEX,y=CC_Mid_Posterior,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p2=ggplot(data6, aes(x=GROUPSEX,y=rCC_Mid_Posterior,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p3=ggplot(data6, aes(x=GROUPSEX,y=Bil.Lateral.Ventricle,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p4=ggplot(data6, aes(x=GROUPSEX,y=rBil.Lateral.Ventricle,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p5=ggplot(data6, aes(x=GROUPSEX,y=Left.Lateral.Ventricle,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p6=ggplot(data6, aes(x=GROUPSEX,y=rLeft.Lateral.Ventricle,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p7=ggplot(data6, aes(x=GROUPSEX,y=ICV,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
# pdf("CCMid_LV_by_GROUPSEX.pdf")
grid.arrange(p1,p2,p3,p4,p5,p6,p7,nrow=2,ncol=4)
# dev.off()

p7=ggplot(data6, aes(x=ICV,y=CC_Mid_Posterior,colour=GROUP,shape=SEX)) +
    geom_point(size=4)
p8=ggplot(data6, aes(x=ICV,y=Bil.Lateral.Ventricle,colour=GROUP,shape=SEX)) +
    geom_point(size=4)
p9=ggplot(data6, aes(x=ICV,y=Left.Lateral.Ventricle,colour=GROUP,shape=SEX)) +
    geom_point(size=4)
grid.arrange(p7,p8,p9,nrow=2)

datax=subset(data6,GROUP=="PRO")
p10=ggplot(datax, aes(x=ROLEFX,y=Left.Lateral.Ventricle,colour=SEX)) +
    geom_point(size=4)
p11=ggplot(datax, aes(x=ROLEFX,y=rLeft.Lateral.Ventricle,colour=SEX)) +
    geom_point(size=4)
p12=ggplot(datax, aes(x=ROLEFX,y=ICV,colour=SEX)) +
    geom_point(size=4)
datax=subset(data6,!GROUP=="PRO")
p13=ggplot(datax, aes(x=ROLEFX,y=Left.Lateral.Ventricle,colour=SEX)) +
    geom_point(size=4)
p14=ggplot(datax, aes(x=ROLEFX,y=rLeft.Lateral.Ventricle,colour=SEX)) +
    geom_point(size=4)
p15=ggplot(datax, aes(x=ROLEFX,y=ICV,colour=SEX)) +
    geom_point(size=4)
grid.arrange(p10,p11,p12,p13,p14,p15,nrow=2)


# plot with mark which explain where difference exist
library(ggplot2); library(gridExtra)

means=tapply(data6$rCC_Mid_Posterior,data6$GROUPSEX,mean,na.rm=TRUE)
p1=ggplot(data6, aes(x=GROUPSEX,y=rCC_Mid_Posterior,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
#    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank()) +   # don't display x-axis-label
    annotate("segment",x=0.75,xend=1.25,y=means[1],yend=means[1]) + 
    annotate("segment",x=1.75,xend=2.25,y=means[2],yend=means[2]) + 
    annotate("segment",x=2.75,xend=3.25,y=means[3],yend=means[3]) + 
    annotate("segment",x=3.75,xend=4.25,y=means[4],yend=means[4]) + 
    annotate("segment",x=1.5,xend=3.5,y=0.0005,yend=0.0005) +
    annotate("segment",x=1,xend=2,y=0.000475,yend=0.000475) +
    annotate("segment",x=1,xend=1,y=0.000475,yend=0.000460) +
    annotate("segment",x=2,xend=2,y=0.000475,yend=0.000460) +
    annotate("segment",x=3,xend=4,y=0.000475,yend=0.000475) +
    annotate("segment",x=3,xend=3,y=0.000475,yend=0.000460) +
    annotate("segment",x=4,xend=4,y=0.000475,yend=0.000460) +
    annotate("text",x=2.5,y=0.0005,label="*",size=10)    # add a * 

means=tapply(data6$rRight.Lateral.Ventricle,data6$GROUPSEX,mean,na.rm=TRUE)
p2=ggplot(data6, aes(x=GROUPSEX,y=rRight.Lateral.Ventricle,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
#    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank()) +   # don't display x-axis-label
    annotate("segment",x=0.75,xend=1.25,y=means[1],yend=means[1]) + 
    annotate("segment",x=1.75,xend=2.25,y=means[2],yend=means[2]) + 
    annotate("segment",x=2.75,xend=3.25,y=means[3],yend=means[3]) + 
    annotate("segment",x=3.75,xend=4.25,y=means[4],yend=means[4]) + 
    annotate("segment",x=1.5,xend=3.5,y=0.0145,yend=0.0145) +
    annotate("segment",x=1,xend=3,y=0.013,yend=0.013) +
    annotate("segment",x=1,xend=1,y=0.013,yend=0.0125) +
    annotate("segment",x=3,xend=3,y=0.013,yend=0.0125) +
    annotate("segment",x=2,xend=4,y=0.014,yend=0.014) + 
    annotate("segment",x=2,xend=2,y=0.014,yend=0.0135) + 
    annotate("segment",x=4,xend=4,y=0.014,yend=0.0135) + 
    annotate("text",x=2.5,y=0.015,label="*",size=10)    # add a * 

means=tapply(data6$rLeft.Lateral.Ventricle,data6$GROUPSEX,mean,na.rm=TRUE)
p3=ggplot(data6, aes(x=GROUPSEX,y=rLeft.Lateral.Ventricle,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
#    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank()) +   # don't display x-axis-label
    annotate("segment",x=0.75,xend=1.25,y=means[1],yend=means[1]) + 
    annotate("segment",x=1.75,xend=2.25,y=means[2],yend=means[2]) + 
    annotate("segment",x=2.75,xend=3.25,y=means[3],yend=means[3]) + 
    annotate("segment",x=3.75,xend=4.25,y=means[4],yend=means[4]) + 
    annotate("segment",x=1.5,xend=3.5,y=0.016,yend=0.016) +
    annotate("segment",x=1,xend=3,y=0.0145,yend=0.0145) +
    annotate("segment",x=1,xend=1,y=0.0145,yend=0.014) +
    annotate("segment",x=3,xend=3,y=0.0145,yend=0.014) +
    annotate("segment",x=2,xend=4,y=0.0155,yend=0.0155) +
    annotate("segment",x=2,xend=2,y=0.0155,yend=0.015) +
    annotate("segment",x=4,xend=4,y=0.0155,yend=0.015) +
    annotate("text",x=2.5,y=0.016,label="*",size=10) +   # add a * 
    annotate("segment",x=1,xend=2,y=0.012,yend=0.012) +
    annotate("text",x=1.5,y=0.012,label="*",size=10)    # add a * 
grid.arrange(p1,p2,p3,nrow=2)

# ----------------------------------------------------------
# plot with jitter
# ----------------------------------------------------------
 
p1=ggplot(data6, aes(x=GROUP,y=CC_Mid_Posterior,fill=GROUP)) +
    geom_point(size=3,shape=21,position=position_jitter(width=.1,height=0))+    # with jitter
    stat_summary(fun.y="mean",goem="point",shape="-",size=6,color="black",ymin=0,ymax=0) +    # add mean
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank()) +    # don't display x-axis-label
    annotate("segment",x=1,xend=2,y=600,yend=600,arrow=arrow(ends="both",angle=90)) +    # add a bar
    annotate("text",x=1.5,y=580,label="*",size=10)    # add a * 

# -------------------------------------------------------------
# difference between with/without binpositions="all"
# -------------------------------------------------------------
 
p51=ggplot(data6, aes(x=GROUP,y=CC_Posterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center",binpositions="all") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p52=ggplot(data6, aes(x=GROUP,y=CC_Posterior,fill=GROUP)) +
    geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
grid.arrange(p51, p52, nrow=1, ncol=2, main = "Volumes of corpus callosum")

# -------------------------------------------
# scatter plots where significant coefficient
# -------------------------------------------

#pdf("scatterplot.pfd")
datax=subset(data6,GROUP=="PRO")
p11=ggplot(datax, aes(x=SIDTOTEV,y=rCC_Anterior,colour=SEX)) +
    geom_point(size=4)
p12=ggplot(datax, aes(x=SIDTOTEV,y=rCC_Mid_Anterior,colour=SEX)) +
    geom_point(size=4)
p13=ggplot(datax, aes(x=SIDTOTEV,y=rCC_Posterior,colour=SEX)) +
    geom_point(size=4)
p14=ggplot(datax, aes(x=READSTD,y=rLeft.Lateral.Ventricle,colour=SEX)) +
    geom_point(size=4)
p15=ggplot(datax, aes(x=SOCFXC,y=rCC_Anterior,colour=SEX)) +
    geom_point(size=4)
p16=ggplot(datax, aes(x=SOCFXC,y=rCC_Mid_Anterior,colour=SEX)) +
    geom_point(size=4)
p17=ggplot(datax, aes(x=ROLEFX,y=rCC_Posterior,colour=SEX)) +
    geom_point(size=4)
p18=ggplot(datax, aes(x=ROLEFX,y=rRight.Lateral.Ventricle,colour=SEX)) +
    geom_point(size=4)
p19=ggplot(datax, aes(x=ROLEFX,y=rLeft.Lateral.Ventricle,colour=SEX)) +
    geom_point(size=4)
grid.arrange(p11,p12,p13,p14,p15,p16,p17,p18,p19)
#dev.off()

# =================
# important analyses
# ==================

# ---------------------------------
# set data
# ---------------------------------

# set data in PNL
setwd("/projects/schiz/3Tprojects/2015-jun-prodrome/stats/02_editedfreesurfer/")
fsstatfile="/projects/schiz/3Tprojects/2015-jun-prodrome/stats/02_editedfreesurfer/edited.aseg_stats.txt"
demographictable="/projects/schiz/3Tprojects/2015-jun-prodrome/caselist/Caselist_CC_prodromes.xlsx"

# # set data in vaio, home PC
# setwd("C:/Users/jun/Documents/test")
# fsstatfile="aseg_stats.txt"
# demographictable="Caselist_CC_prodromes.xlsx"
# setwd("C:/Users/jun/Documents/test/02")  # 2015/10/27
# fsstatfile="edited.aseg_stats.txt"
# demographictable="Caselist_CC_prodromes.xlsx"

library(xlsx)
data1=read.xlsx(demographictable,sheetName="Full",header=TRUE)
data1=subset(data1,! is.na(Case..))
data4=read.table(fsstatfile,header=TRUE)
asegnames=names(data4)

data1[["caseid2"]]=substring(data1[["Case.."]],1,9)
data4[["caseid2"]]=substring(data4[["Measure.volume"]],1,9)
data5=merge(data1,data4,by.x="caseid2",by.y="caseid2",all=TRUE)
data6=subset(data5,! is.na(SEX))    # exclude rows which don't have SEX data
data6$SEX=as.factor(data6$SEX)    # change into class:factor
data6$ICV=data6$EstimatedTotalIntraCranialVol    # change field name to be handled more easily
data6$Bil.Lateral.Ventricle=data6$Right.Lateral.Ventricle+data6$Left.Lateral.Ventricle    # summarize lt rt into bilateral
data6$rRight.Lateral.Ventricle=data6$Right.Lateral.Ventricle/data6$ICV
data6$rLeft.Lateral.Ventricle =data6$Left.Lateral.Ventricle /data6$ICV
data6$rBil.Lateral.Ventricle  =data6$Bil.Lateral.Ventricle  /data6$ICV
data6$rX3rd.Ventricle         =data6$X3rd.Ventricle  /data6$ICV
data6$rCC_Anterior          =data6$CC_Anterior          /data6$ICV
data6$rCC_Mid_Anterior      =data6$CC_Mid_Anterior      /data6$ICV
data6$rCC_Central           =data6$CC_Central           /data6$ICV
data6$rCC_Mid_Posterior     =data6$CC_Mid_Posterior     /data6$ICV
data6$rCC_Posterior         =data6$CC_Posterior         /data6$ICV
data6$SEX2=as.character(data6$SEX);mask=(data6$SEX2=="0");data6$SEX2[mask]="M";data6$SEX2[!mask]="F";data6$SEX2=as.factor(data6$SEX2)
data6$GROUPSEX=as.factor(paste(data6$GROUP,as.character(data6$SEX2),sep=""))

regions=c("CC_Anterior", "CC_Mid_Anterior", "CC_Central", "CC_Mid_Posterior", "CC_Posterior")
regions2=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle","X3rd.Ventricle")
regions3=c("Bil.Lateral.Ventricle","X3rd.Ventricle")
regions4=c("rCC_Anterior", "rCC_Mid_Anterior", "rCC_Central", "rCC_Mid_Posterior", "rCC_Posterior", "rRight.Lateral.Ventricle","rLeft.Lateral.Ventricle","rBil.Lateral.Ventricle","rX3rd.Ventricle")
demographics1=c("GROUP","AGE","SEX")
parameters1=c("SOCFXC","ROLEFX")
parameters2=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
parameters_sip=c("SIP1SEV","SIP1SEV","SIP1SEV","SIP1SEV","SIP5SEV")
parameters_sin=c("SIN1SEV","SIN1SEV","SIN1SEV","SIN1SEV","SIN1SEV","SIN6SEV")
parameters_sid=c("SID1SEV","SID1SEV","SID1SEV","SID4SEV")
parameters_sig=c("SIG1SEV","SIG1SEV","SIG1SEV","SIG4SEV")
parameters_si=c(parameters_sip,parameters_sin,parameters_sid,parameters_sig)

# ---------------------------------------------
# output demographic table
# ---------------------------------------------

#datax=data6[-29,]  # exclude a case which have no volume data
datax=subset(data6,subset=(!is.na(CC_Anterior))) # exclude a case which have no volume data
items=c("AGE","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV","SOCFXC","ROLEFX")
v1=sapply(datax[,items],mean,na.rm=TRUE)
v2=sapply(datax[,items],sd,na.rm=TRUE)

datay=subset(datax,GROUP=="PRO");
v3=sapply(datay[,items],mean,na.rm=TRUE)
v4=sapply(datay[,items],sd,na.rm=TRUE)

datay=subset(datax,!GROUP=="PRO");
v5=sapply(datay[,items],mean,na.rm=TRUE)
v6=sapply(datay[,items],sd,na.rm=TRUE)

n=length(items);v7=numeric(n);
for ( i in 1:n){
    r1=t.test(subset(datax,GROUP=="PRO")[items[i]],subset(datax,GROUP=="HVPRO")[items[i]])
    v7[i]=r1[["p.value"]]
}

table1=data.frame(tot_mean=v1,tot_sd=v2,pro_mean=v3,pro_sd=v4,hc_mean=v5,hc_sd=v6,p.value=v7)

m=by(datax[,c("SEX")],datax$GROUP,summary) # ... use table() ?
r=summary(table(datax$GROUP,datax$SEX))[["p.value"]]  # chi test
PROmalefemale=paste(m[["PRO"]]["0"],"/",m[["PRO"]]["1"],sep="")
HVPROmalefemale=paste(m[["HVPRO"]]["0"],"/",m[["HVPRO"]]["1"],sep="")
table1=rbind(table1,c("","",PROmalefemale,"",HVPROmalefemale,"",r))
rownames(table1)[nrow(table1)]="male/female"

table1[1,c(1:6)]=sprintf("%.1f",as.numeric(table1[1,c(1:6)])) 
table1[2,c(1:6)]=sprintf("%.1f",as.numeric(table1[2,c(1:6)])) 
table1[3,c(1:6)]=sprintf("%.1f",as.numeric(table1[3,c(1:6)])) 
table1[4,c(1:6)]=sprintf("%.1f",as.numeric(table1[4,c(1:6)])) 
table1[5,c(1:6)]=sprintf("%.2f",as.numeric(table1[5,c(1:6)])) 
table1[6,c(1:6)]=sprintf("%.2f",as.numeric(table1[6,c(1:6)])) 
table1[7,c(1:6)]=sprintf("%.2f",as.numeric(table1[7,c(1:6)])) 
table1[8,c(1:6)]=sprintf("%.2f",as.numeric(table1[8,c(1:6)])) 
table1[9,c(1:6)]=sprintf("%.2f",as.numeric(table1[9,c(1:6)])) 
table1[10,c(1:6)]=sprintf("%.2f",as.numeric(table1[10,c(1:6)])) 
table1[11,c(1:6)]=sprintf("%.2f",as.numeric(table1[11,c(1:6)])) 
table1[,7]=sprintf("%.3f",as.numeric(table1[,7])) 

n=nrow(table1); tablex=rbind(table1[n,])
for ( i in 1:(n-1) ) {tablex=rbind(tablex,table1[i,])} 
knitr::kable(tablex)

cat(file="tmp","",append=FALSE)
cat(file="tmp","\n# -------------------------------------\n",append=TRUE)
cat(file="tmp",paste("# pwd: ",getwd(),"\n",sep=""),append=TRUE)
cat(file="tmp",paste("# fsstatfile: ",fsstatfile,"\n",sep=""),append=TRUE)
cat(file="tmp",paste("# demographictable: ",demographictable,"\n",sep=""),append=TRUE)
cat(file="tmp","# -------------------------------------\n\n",append=TRUE)
cat(file="tmp","\n# -------------------------------------\n",append=TRUE)
cat(file="tmp","# Table\n",append=TRUE)
cat(file="tmp","# -------------------------------------\n\n",append=TRUE)
sink(file="tmp",append=TRUE);knitr::kable(tablex);sink()

# --------------------------------------
# ANCOVA
# --------------------------------------

library(car) # for Anova()
options(contrasts = c("contr.sum", "contr.sum")) # for Anova(), this change other lm results. 
funclm <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
    print(s[["call"]]); # print(s[["coefficients"]][,c(1,4)])
    print(Anova(r,type=3))
}
myfunc=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {funclm(item[j],datacol[i],arg3)}}
}
datax=data6
item=c(regions,regions2)
myfunc(item,"","GROUP*SEX+ICV")

cat(file="tmp","\n# -------------------------------------\n",append=TRUE)
cat(file="tmp","# ANCOVA\n",append=TRUE)
cat(file="tmp","# -------------------------------------\n\n",append=TRUE)
sink(file="tmp",append=TRUE);myfunc(item,"","GROUP*SEX+ICV");sink()

# ------------------------------------------------------
# correlation analyses: relative volume (divided by ICV)
# ------------------------------------------------------

datax=    cbind(
    data6[c(1:15)],
    data6[c("READSTD","WASIIQ","GAFC","GAFH")],
    data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
    data6[regions4],
    data6[parameters1]
)
datax=subset(datax,GROUP=="PRO")
mask=sapply(datax,is.numeric);datax=subset(datax,select=mask)    # select numeric data

col=c("estimate","p.value");item=c(regions4)
n=length(datax);m=length(col); o=length(item); lst=list()
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

cat(file="tmp","\n# -------------------------------------\n",append=TRUE)
cat(file="tmp","# correlation analyses: relavive volume (divided by ICV) in PRO\n",append=TRUE)
cat(file="tmp","# -------------------------------------\n\n",append=TRUE)
sink(file="tmp",append=TRUE);print(lst);sink()

# --------------------------------------
# general linear model
# --------------------------------------

# similar to but not the same as two-factors ANCOVA: GROUP, SEX; ICV

options(contrasts =c("contr.treatment","contr.poly")) # default contrast
funclm1 <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP*SEX+ICV,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP*SEX+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
datax=data6;for (region in regions ) { funclm1(region) } # CC
datax=data6;for (region in regions2 ) {funclm1(region)} # centricles

cat(file="tmp","\n# -------------------------------------\n",append=TRUE)
cat(file="tmp","# regression analyses (volumes)\n",append=TRUE)
cat(file="tmp","# -------------------------------------\n\n",append=TRUE)
sink(file="tmp",append=TRUE)
datax=data6;for (region in regions ) { funclm1(region) } # CC
datax=data6;for (region in regions2 ) {funclm1(region)} # centricles
sink()

# -------------------------------------
# Follow-up analyses: 
# -------------------------------------

# separated into groups by SEX; factor:GROUP; covariate:ICV
# separated into groups by GROUP; factor:SEX; covariate:ICV
# This is general linear model and similar to but not the same as one-factor ANCOVA

funclm4 <- function(arg1,arg2){
    # arg1: character; arg2: character; r=lm(arg1~arg2+ICV,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5="+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
}

datax=subset(data6,SEX==0);funclm4("Left.Lateral.Ventricle","GROUP")
datax=subset(data6,SEX==1);funclm4("Left.Lateral.Ventricle","GROUP")
datax=subset(data6,GROUP=="PRO");funclm4("Left.Lateral.Ventricle","SEX")
datax=subset(data6,!GROUP=="PRO");funclm4("Left.Lateral.Ventricle","SEX")

cat(file="tmp","\n# -------------------------------------\n",append=TRUE)
cat(file="tmp","# follow-up analyses (volumes)\n",append=TRUE)
cat(file="tmp","# -------------------------------------\n\n",append=TRUE)
sink(file="tmp",append=TRUE)
datax=subset(data6,SEX==0);funclm4("Left.Lateral.Ventricle","GROUP")
datax=subset(data6,SEX==1);funclm4("Left.Lateral.Ventricle","GROUP")
datax=subset(data6,GROUP=="PRO");funclm4("Left.Lateral.Ventricle","SEX")
datax=subset(data6,!GROUP=="PRO");funclm4("Left.Lateral.Ventricle","SEX")
sink()

# -------------------------------------------------
# regression analyses
# -------------------------------------------------

# dependent variable:volumes; explanatory varialbe:clinical scales; covariate:ICV

funclm4 <- function(arg1,arg2){
    # arg1: character; arg2: character; r=lm(arg1~arg2+ICV,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5="+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
}

datax=subset(data6,GROUP=="PRO")
item=c(regions,regions2)
datacol=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV",parameters1)
m=length(item); n=length(datacol)
for ( j in 1:m) {
    for ( i in 1:n ) {
        funclm4(item[j],datacol[i])
    }
}

cat(file="tmp","\n# -------------------------------------\n",append=TRUE)
cat(file="tmp","# Regression analyses for clinical parameters in PRO\n",append=TRUE)
cat(file="tmp","# -------------------------------------\n\n",append=TRUE)
sink(file="tmp",append=TRUE)
for ( j in 1:m) {
    for ( i in 1:n ) {
        funclm4(item[j],datacol[i])
    }
}
sink()

# ------------------
# dot plots: volumes
# ------------------

library(ggplot2); library(gridExtra)
pdf("plot.pdf",useDingbats=FALSE)
p4=ggplot(data6, aes(x=GROUP,y=rCC_Mid_Posterior,fill=SEX2)) +
    scale_fill_manual(values=c("red","blue")) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p5=ggplot(data6, aes(x=GROUP,y=rLeft.Lateral.Ventricle,fill=SEX2)) +
    scale_fill_manual(values=c("red","blue")) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p6=ggplot(data6, aes(x=SEX2,y=rRight.Lateral.Ventricle,fill=GROUP)) +
    scale_fill_manual(values=c("#E69F00","#009E73")) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p7=ggplot(data6, aes(x=SEX2,y=rLeft.Lateral.Ventricle,fill=GROUP)) +
    scale_fill_manual(values=c("#E69F00","#009E73")) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
grid.arrange(p4,p5,p6,p7,nrow=2)
dev.off()

# -------------------
# scatter plot
# -------------------

library(ggplot2); library(gridExtra)
pdf("scatterplot.pdf",width=12,useDingbats=FALSE)
datax=subset(data6,GROUP=="PRO")
p11=ggplot(datax, aes(x=SIDTOTEV,y=rCC_Anterior,colour=SEX2)) +
    geom_point()
p12=ggplot(datax, aes(x=SIDTOTEV,y=rCC_Mid_Anterior,colour=SEX2)) +
    geom_point()
p13=ggplot(datax, aes(x=SIDTOTEV,y=rCC_Posterior,colour=SEX2)) +
    geom_point()
p14=ggplot(datax, aes(x=READSTD,y=rLeft.Lateral.Ventricle,colour=SEX2)) +
    geom_point()
p15=ggplot(datax, aes(x=SOCFXC,y=rCC_Anterior,colour=SEX2)) +
    geom_point()
p16=ggplot(datax, aes(x=SOCFXC,y=rCC_Mid_Anterior,colour=SEX2)) +
    geom_point()
p17=ggplot(datax, aes(x=ROLEFX,y=rCC_Posterior,colour=SEX2)) +
    geom_point()
p18=ggplot(datax, aes(x=ROLEFX,y=rRight.Lateral.Ventricle,colour=SEX2)) +
    geom_point()
p19=ggplot(datax, aes(x=ROLEFX,y=rLeft.Lateral.Ventricle,colour=SEX2)) +
    geom_point()
grid.arrange(p11,p12,p13,p14,p15,p16,p17,p18,p19)
dev.off()

# ===============================
# new description
# ===============================

# --------------------------------------------------
# more flexible functions for linear model and ANOVA
# --------------------------------------------------
# if you want to create p-value table, refer to mkpvalmtx function

options(contrasts =c("contr.treatment","contr.poly")) # default contrast
funclm <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
    print(s[["call"]]);     # show model
    print(s[["coefficients"]][,c(1,4)])
#    print(anova(r))    # for anova
}
myfunc=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {funclm(item[j],datacol[i],arg3)}}
}
datax=data6
#datax=subset(data6,GROUP=="PRO")
item=c(regions,regions2)
datacol=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV",parameters1)
myfunc(item,datacol,"+ICV")
myfunc(item,datacol,"+SEX+ICV")
myfunc("Left.Lateral.Ventricle","ROLEFX","+ICV")
myfunc("ROLEFX","Left.Lateral.Ventricle","+ICV")
sink(file="tmp",append=FALSE);myfunc(item,datacol,"+ICV");sink()
myfunc(item,"","GROUP+SEX+ICV")

library(car) # for Anova()
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
funclm <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
    print(s[["call"]]);    # show model
#    print(s[["coefficients"]][,c(1,4)])
    print(Anova(r,type=3))    # show anova type3
}
myfunc=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {funclm(item[j],datacol[i],arg3)}}
}
#datax=data6
datax=subset(data6,GROUP=="PRO")
item=c(regions,regions2)
#item=c(regions4)
datacol=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV",parameters1)
myfunc(item,datacol,"+ICV")
myfunc(item,datacol,"+SEX+ICV")
myfunc("Left.Lateral.Ventricle","ROLEFX","+ICV")
myfunc("ROLEFX","Left.Lateral.Ventricle","+ICV")
sink(file="tmp",append=FALSE);myfunc(item,datacol,"+ICV");sink()
sink(file="tmp",append=FALSE);myfunc(datacol,item,"+ICV");sink()
myfunc(item,"","GROUP+SEX+ICV")
myfunc(item,"","GROUP+ICV")
myfunc(item,"","GROUP*SEX")
myfunc(item,"","GROUP+SEX")
myfunc(item,"","GROUP")

# ---------------------------------------------------
# new plot, correlation between volumes and parameters
# ----------------------------------------------------

library(ggplot2); library(gridExtra)
datax=subset(data6,GROUP=="PRO")
# pdf("tmp.pdf")
formatter=function(x){
	return(sprintf("%.4f",x))
}
p11=ggplot(datax, aes(x=SIDTOTEV,y=rCC_Anterior,colour=SEX)) +
    geom_point() +
    scale_y_continuous(breaks=seq(0.0004,0.0006,0.0001),labels=formatter) +
    scale_colour_discrete(guide=FALSE) + 
    xlab("SID total") + ylab("relative anterior CC")
p12=ggplot(datax, aes(x=SIDTOTEV,y=rCC_Mid_Anterior,colour=SEX)) +
    geom_point() +
    scale_colour_discrete(guide=FALSE) +
    xlab("SID total") + ylab("relative middle anteiror CC")
p13=ggplot(datax, aes(x=SIDTOTEV,y=rCC_Posterior,colour=SEX)) +
    geom_point() +
    scale_y_continuous(breaks=seq(0.0005,0.0007,0.0001),labels=formatter) +
    scale_colour_discrete(guide=FALSE) +
    xlab("SID total") + ylab("relative posterior CC")
p14=ggplot(datax, aes(x=READSTD,y=rLeft.Lateral.Ventricle,colour=SEX)) +
    geom_point() +
    ylim(0,0.015) +
    scale_colour_discrete(guide=FALSE) +
    xlab("READSTD") + ylab("relative left lateral ventricle")
p15=ggplot(datax, aes(x=SOCFXC,y=rCC_Anterior,colour=SEX)) +
    geom_point() +
    scale_y_continuous(breaks=seq(0.0004,0.0006,0.0001),labels=formatter) +
    scale_colour_discrete(guide=FALSE) +
    xlab("Social Function") + ylab("relative anterior CC")
p16=ggplot(datax, aes(x=SOCFXC,y=rCC_Mid_Anterior,colour=SEX)) +
    geom_point() +
    scale_colour_discrete(guide=FALSE) +
    xlab("Social Function") + ylab("relative middle anterior CC")
p17=ggplot(datax, aes(x=ROLEFX,y=rCC_Posterior,colour=SEX)) +
    geom_point() +
    scale_y_continuous(breaks=seq(0.0005,0.0007,0.0001),labels=formatter) +
    scale_colour_discrete(guide=FALSE) +
    xlab("Role Function") + ylab("relative posterior CC")
p18=ggplot(datax, aes(x=ROLEFX,y=rRight.Lateral.Ventricle,colour=SEX)) +
    geom_point() +
    ylim(0,0.015)+
    scale_colour_discrete(guide=FALSE) +
    xlab("Role Function") + ylab("relative right lateral ventricle")
p19=ggplot(datax, aes(x=ROLEFX,y=rLeft.Lateral.Ventricle,colour=SEX)) +
    geom_point() +
    ylim(0,0.015) +
    theme(legend.position=c(.85,.85)) +
    theme(legend.background=element_blank()) +
    xlab("Role Function") + ylab("relative left lateral ventricle")
grid.arrange(p11,p12,p13,p14,p15,p16,p17,p18,p19)
# dev.off()

# -----------------------------------------------
# table of volumes for checking data, 2015/09/29, 
# -----------------------------------------------

datax=data6[,c("caseid2","GROUP","SEX2",regions,regions2)]
t1=knitr::kable(datax);print(t1)
cat(knitr::kable(datax),file="tmp.txt",sep="\n")
tx=rbind(summary(datax), sapply(datax,sd,na.rm=TRUE))
t3=knitr::kable(tx);print(t3)
cat(t3,file="tmp.txt",sep="\n",append=TRUE)

tx=by(datax,datax$GROUP,summary);
t4=knitr::kable(tx[[1]]);t5=knitr::kable(tx[[2]])
cat(c(t4,"",t5),sep="\n")

datax=data6[,c("caseid2","GROUP","SEX2",regions,regions2)];datax=subset(datax,GROUP=="PRO")
t1=knitr::kable(datax);print(t1)
tx=rbind(summary(datax), sapply(datax,sd,na.rm=TRUE))
t3=knitr::kable(tx);print(t3)

datax=data6[,c("caseid2","GROUP","SEX2",regions,regions2)];datax=subset(datax,GROUP=="HVPRO")
t1=knitr::kable(datax);print(t1)
tx=rbind(summary(datax), sapply(datax,sd,na.rm=TRUE))
t3=knitr::kable(tx);print(t3)

# --------------------------------------------------
# ANCOVA or ANOVA: p-values of main effect of GROUP
# --------------------------------------------------

mkpvalmtx <- function(datax,items,models) {
    library(car) # for Anova()
    options(contrasts = c("contr.sum", "contr.sum")) # for Anova(), or interaction 
    funclm <- function(arg1,arg2,arg3){
        # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
        txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
        txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
        eval(parse(text=txt0)); s=summary(r)
        Anova(r,type=3)["GROUP","Pr(>F)"]   # output
    }
    pvaluesmatrix=matrix(0,length(models),length(items))
    rownames(pvaluesmatrix)=c(1:length(models))   # need to initializing the rownames
    colnames(pvaluesmatrix)=items
    for ( j in ( 1:length(models) ) ) {
        rownames(pvaluesmatrix)[j]=paste("Volume ~",models[j])
        for ( i in ( 1 : length(items) ) ) {
            pvaluesmatrix[j,i]=funclm(items[i],"",models[j])
        }
    }
    pvaluesmatrix
}

datax=data6
items=c(regions,regions2)
models=c("GROUP+ICV","GROUP+SEX+ICV","GROUP+READSTD+ICV",
    "GROUP*SEX+ICV",
    "GROUP+SEX+AGE+ICV","GROUP+AGE+ICV",
    "GROUP","GROUP+SEX","GROUP+AGE","GROUP+AGE+SEX",
    "GROUP+WASIIQ+ICV","GROUP+WASIIQ",
    "GROUP+READSTD","GROUP+READSTD+ICV","GROUP+READSTD+SEX+ICV","GROUP+SEX+READSTD+ICV","GROUP*SEX+READSTD+ICV",
    "GROUP+READSTD+AGE+ICV","GROUP+READSTD+SEX+AGE+ICV"
)
pvaluesmatrix=mkpvalmtx(datax,items,models)
knitr::kable(pvaluesmatrix)

# settings for the analyses in other regions

#datax=data6
datax=datay
models=c("GROUP+ICV","GROUP+SEX+ICV","GROUP+READSTD+ICV")
#items=names(data4)[c(2:35,38,41:66)]   # exclude c(1,36,37,39,40,68) which leads errors
items=c(asegnames[c(2:35,38,41:66)],rhnames[c(2:35)],lhnames[c(2:35)])
# function mkpvalmatx
pvaluesmatrix=mkvalmtx(datax,items,models)
knitr::kable(t(pvaluesmatrix))     # translocate matrix for display

# output text file

sink(file="tmp",append=TRUE)
    cat("\n# -------------------------------------\n")
    cat("# ANCOVA or ANOVA: p-values of main effect of GROUP\n")
    cat("# -------------------------------------\n\n")
    print(knitr::kable(pvaluesmatrix));cat("\n")
#    print(knitr::kable(t(pvaluesmatrix)));cat("\n")
sink()    # translocate matrix for display

# ANOVA in caudata and amygdala which were significant
Anova(lm(Right.Caudate~GROUP+READSTD+ICV,data=datax),type=3)
by(datax$Right.Caudate,datax$GROUP,summary)
Anova(lm(Left.Caudate~GROUP+READSTD+ICV,data=datax),type=3)
by(datax$Left.Caudate,datax$GROUP,summary)
Anova(lm(Right.Amygdala~GROUP+READSTD+ICV,data=datax),type=3)
by(datax$Right.Amygdala,datax$GROUP,summary)
Anova(lm(Left.Amygdala~GROUP+READSTD+ICV,data=datax),type=3)
by(datax$Left.Amygdala,datax$GROUP,summary)


# -----------------------------------------
# working other table: relative to whole CC
# -----------------------------------------

datax=datay
items=c(regions,regions2)
#items=c(vol.names)
models=c("GROUP+ICV","GROUP+SEX+ICV","GROUP+READSTD+ICV",
    "GROUP*SEX+ICV",
    "GROUP+SEX+AGE+ICV","GROUP+AGE+ICV",
    "GROUP","GROUP+SEX","GROUP+AGE","GROUP+AGE+SEX",
    "GROUP+WASIIQ+ICV","GROUP+WASIIQ",
    "GROUP+READSTD","GROUP+READSTD+SEX+ICV","GROUP+SEX+READSTD+ICV","GROUP*SEX+READSTD+ICV",
    "GROUP+READSTD+AGE+ICV","GROUP+READSTD+SEX+AGE+ICV"
)
#models=c("GROUP+ICV","GROUP+SEX+ICV","GROUP+READSTD+ICV")
pvaluesmatrix=mkpvalmtx(datax,items,models)
#pvaluesmatrix=t(mkpvalmtx(datax,items,models))

sig.mtx=sigmtx(pvaluesmatrix)
subset=extractsig(sig.mtx)
jun.heatmap(sig.mtx)

# relative to total CC

datax=datay    # input data is set as datax
datax[["CC_Total"]]=apply(datax[regions],1,sum)
cc.r.vol.names=paste("cc.r.",vol.names,sep="")
n=length(rvol.names)
for (i in 1:n) {
    datax[[cc.r.vol.names[i]]]=datax[[vol.names[i]]]/datax[["CC_Total"]]
}
datay=datax    # output is datay
data.vol=datay    # output a object as data.vol

# function mkpvalmtx
datax=data.vol
items=cc.r.vol.names
models=c("GROUP+ICV","GROUP+SEX+ICV","GROUP+READSTD+ICV")
pvaluesmatrix=t(mkpvalmtx(datax,items,models))
sig.mtx=sigmtx(pvaluesmatrix)
subset=extractsig(sig.mtx)
jun.heatmap(t(sig.mtx))
jun.heatmap(t(subset))
    # results: rt and lt caudate, Left.Inf.Lat.Vent

# function mkpvalmtx
datax=data.vol
items=cc.r.vol.names
models=c("GROUP","GROUP+SEX","GROUP+READSTD")
pvaluesmatrix=t(mkpvalmtx(datax,items,models))
sig.mtx=sigmtx(pvaluesmatrix)
subset=extractsig(sig.mtx)
jun.heatmap(t(sig.mtx))
jun.heatmap(t(subset))
    # results: rt and lt caudate, Left.Inf.Lat.Vent

# ------------------
# set up other data
# -----------------
# 2015/10/26

library(xlsx)
library(knitr)    # for kable
library(ggplot2)
library(gridExtra)
library(car)    # for Anova()

setwd("/projects/schiz/3Tprojects/2015-jun-prodrome/stats/02_editedfreesurfer")
demographictable="/projects/schiz/3Tprojects/2015-jun-prodrome/caselist/Caselist_CC_prodromes.xlsx"
fsstatfile.aseg="edited.aseg_stats.txt"
fsstatfile.rh="edited.aparc_stats_rh_volume.txt"
fsstatfile.lh="edited.aparc_stats_lh_volume.txt"

# # set data in vaio, home PC
# setwd("C:/Users/jun/Documents/test")
# setwd("02")  # 2015/10/27
# demographictable="Caselist_CC_prodromes.xlsx"

merge.tbl <- function(fsstatfile,datax){
    data4=read.table(fsstatfile,header=TRUE)
    data4[["caseid2"]]=substring(data4[[1]],1,9)     # column 1 shoud be freesurfer subject ID
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
data1=read.xlsx(demographictable,sheetName="Full",header=TRUE)
data1=subset(data1,! is.na(Case..))
data1[["caseid2"]]=substring(data1[["Case.."]],1,9)
data1$SEX=as.factor(data1$SEX)    # change into class:factor
#data1=subset(data1,! is.na(SEX))    # exclude rows which don't have SEX data
data1$SEX2=as.character(data1$SEX);mask=(data1$SEX2=="0");data1$SEX2[mask]="M";data1$SEX2[!mask]="F";data1$SEX2=as.factor(data1$SEX2)
data1$GROUPSEX=as.factor(paste(data1$GROUP,as.character(data1$SEX2),sep=""))

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

# compare the numbers of regions related to CC between PRO and HC, 2015/10/21

datax=datay
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")
#items.row=c(names.field.r)     # relative volumes
items.row=c(names.field)       # absolute volumes
#items.col=c(regions4)             # relative volumes
items.col=c(regions,regions2)      # absolute volumes
items.ana=c("estimate","p.value") 
# function jun.cor.test
jun.cor.test <-function (items.row,items.col,items.ana,datax) {
    n=length(items.row)    # i
    m=length(items.col)   # j
    o=length(items.ana)   # k
    arr=array(0,dim=c(n,m,o))
    dimnames(arr)=list(items.row,items.col,items.ana)
    for (k in 1:o) {
        for (j in 1:m) {
            for (i in 1:n) {
                arr[i,j,k]=cor.test(datax[[items.row[i]]],datax[[items.col[j]]],method="spearman")[[items.ana[k]]]
            }
        }
    }
    arr
}
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]
mtx.p.hc=arr.hc[,,2]
pvaluesmatrix=data.frame(PRO=mtx.p.pro[,4],HC=mtx.p.hc[,4])    # extrac  CC_Mid_Posteiro
pvaluesmatrix.1=data.frame(PRO=mtx.p.pro[,1],HC=mtx.p.hc[,1])    # extrac  CC_Anterior
# function sigmtx
sigmtx <- function(mtx) {
    mask.mtx=(mtx < 0.05)                          # mask for under 0.05
    sig.mtx=mtx
    sig.mtx[!mask.mtx]=NA
    sig.mtx
}
sig.mtx=sigmtx(pvaluesmatrix)
kable(sig.mtx)
# function jun.heatmap
jun.heatmap <- function(sig.mtx) {
    sig.mtx=as.matrix(sig.mtx)    # in case sig.mtx is a data.frame, This does not work why?
    pvalues=as.numeric(sig.mtx)
    xaxis=rep(rownames(sig.mtx),length(colnames(sig.mtx)))
    yaxis=c()
    for ( arg in colnames(sig.mtx) ) {yaxis=c(yaxis,rep(arg,length(rownames(sig.mtx))))}
    forplot=data.frame(xaxis,yaxis,pvalues)
    p=ggplot(forplot, aes(x=xaxis,y=yaxis,fill=pvalues)) 
    p + geom_tile() +
        theme(axis.text.x=element_text(angle=90,hjust=1,vjust=.5)) +
        scale_fill_gradient(low="green",high="white") + 
        theme(axis.title.x=element_blank()) +
        theme(axis.title.y=element_blank())
}
jun.heatmap(t(sig.mtx))
# function extractsigsig
extractsig <- function(sig.mtx) {
    mask.mtx=!is.na(sig.mtx)
    mask.vec.num=apply(mask.mtx,1,sum)
    mask.vec=as.logical(mask.vec.num)
    subset=sig.mtx[mask.vec,]
    subset
}
subset.p=extractsig(sig.mtx)
kable(subset.p)
# funftion jun.heatmap
jun.heatmap(t(subset.p))
# edit subset
knitr::kable(cbind(subset,c(1:nrow(subset.p))))
#knitr::kable(cbind(subset,c(1:nrow(subset.p)))[c(-3,-5,-13,-14,-19,-20,-21),])
#pdf("tmp.pdf")
#p.subset.p=jun.heatmap(t(subset.p[c(-3,-5,-13,-14,-19,-20,-21),]))
#dev.off()

# rho
mtx.rho.pro=arr.pro[,,1]
mtx.rho.hc=arr.pro[,,1]
#knitr::kable(mtx.rho.pro)
#knitr::kable(mtx.rho.hc)
rho.mtx=data.frame(PRO=mtx.rho.pro[,4],HC=mtx.rho.hc[,4])    # extrac  CC_Mid_Posteiro
#knitr::kable(pvaluesmatrix)
# function sigmtx.rho
sigmtx.rho <- function(p.mtx,rho.mtx) {
    mask.p.mtx=(p.mtx < 0.05)                          # mask for under 0.05
    sig.rho.mtx=rho.mtx
    sig.rho.mtx[!mask.p.mtx]=NA
    sig.rho.mtx
}
sig.rho.mtx=sigmtx.rho(pvaluesmatrix,rho.mtx)
# function jun.heatmap.rho
jun.heatmap.rho <- function(sig.mtx) {
    sig.mtx=as.matrix(sig.mtx)    # in case sig.mtx is a data.frame, This does not work why?
    rho=as.numeric(sig.mtx)
    xaxis=rep(rownames(sig.mtx),length(colnames(sig.mtx)))
    yaxis=c()
    for ( arg in colnames(sig.mtx) ) {yaxis=c(yaxis,rep(arg,length(rownames(sig.mtx))))}
    forplot=data.frame(xaxis,yaxis,rho)
    p=ggplot(forplot, aes(x=xaxis,y=yaxis,fill=rho))
    p + geom_tile() +
        theme(axis.text.x=element_text(angle=90,hjust=1,vjust=.5)) +
        scale_fill_gradient(low="blue",high="red") + 
        theme(axis.title.x=element_blank()) +
        theme(axis.title.y=element_blank())
}
jun.heatmap.rho(t(sig.rho.mtx))
# function extractsigsig.rho
extractsig.rho <- function(sig.p.mtx,sig.rho.mtx) {
    mask.p.mtx=!is.na(sig.p.mtx)
    mask.p.vec.num=apply(mask.p.mtx,1,sum)
    mask.p.vec=as.logical(mask.p.vec.num)
    subset.rho=sig.rho.mtx[mask.p.vec,]
    subset.rho
}
subset.rho=extractsig.rho(sig.mtx,sig.rho.mtx)
knitr::kable(subset.rho)
# funftion jun.heatmap.rho
jun.heatmap.rho(t(subset.rho))
# edit subset
knitr::kable(cbind(subset,c(1:nrow(subset.rho))))
#knitr::kable(cbind(subset,c(1:nrow(subset.rho)))[c(-3,-5,-13,-14,-19,-20,-21),])
#p.subset.rho=jun.heatmap.rho(t(subset.rho[c(-3,-5,-13,-14,-19,-20,-21),]))
#pdf("tmp.pdf",width=8)
library(gridExtra)
#grid.arrange(p.subset.p,p.subset.rho, nrow=1,ncol=2,top="Regions significantly correlated to middle posterior corpus callosum")
#dev.off()

# function mtx.adjust
mtx.adjust <- function(pvaluesmatrix,meth){
    mtx.adjusted=matrix(p.adjust(as.matrix(pvaluesmatrix),meth),,2)
    rownames(mtx.adjusted)=rownames(pvaluesmatrix)
    colnames(mtx.adjusted)=colnames(pvaluesmatrix)
    mtx.adjusted
}
mtx.adjust(pvaluemtrix,"fdr")

# select region where temporal and parietal

names.temporal=c(
    "rh_superiortemporal",  "lh_superiortemporal", 
    "rh_middletemporal",    "lh_middletemporal", 
    "rh_inferiortemporal",  "lh_inferiortemporal", 
    "rh_bankssts",          "lh_bankssts",
    "rh_fusiform",          "lh_fusiform",          
    "rh_transversetemporal","lh_transversetemporal",
    "rh_entorhinal",        "lh_entorhinal",        
    "rh_temporalpole",      "lh_temporalpole",      
    "rh_parahippocampal",   "lh_parahippocampal"  
)
names.parietal=c(
    "rh_postcentral",     "lh_postcentral",
    "rh_supramarginal",   "lh_supramarginal",
    "rh_superiorparietal","lh_superiorparietal",
    "rh_inferiorparietal","lh_inferiorparietal",
    "rh_precuneus",       "lh_precuneus"
)
names.temporal.vol=paste(names.temporal,"_volume",sep="")
names.parietal.vol=paste(names.parietal,"_volume",sep="")
pvaluesmatrix[c(names.temporal.vol,names.parietal.vol),]
names.temporal.vol.r=paste("r.",names.temporal.vol,sep="")
names.parietal.vol.r=paste("r.",names.parietal.vol,sep="")
pvaluesmatrix[c(names.temporal.vol.r,names.parietal.vol.r),]

# investigating about thickness

fsstatfile.rh="edited.aparc_stats_rh_thickness.txt"
fsstatfile.lh="edited.aparc_stats_lh_thickness.txt"
names.temporal.th=paste(names.temporal,"_thickness",sep="")
names.parietal.th=paste(names.parietal,"_thickness",sep="")
pvaluesmatrix[c(names.temporal.th,names.parietal.th),]

# investigating about area

fsstatfile.rh="edited.aparc_stats_rh_area.txt"
fsstatfile.lh="edited.aparc_stats_lh_area.txt"
names.temporal.ar=paste(names.temporal,"_area",sep="")
names.parietal.ar=paste(names.parietal,"_area",sep="")
pvaluesmatrix[c(names.temporal.ar,names.parietal.ar),]

# investigating about Destriaux atlas (aparc.a2009s)

fsstatfile.rh="edited.aparc.a2009s_stats_rh_volume.txt"
fsstatfile.lh="edited.aparc.a2009s_stats_lh_volume.txt"

names.parietal=c(
    "rh_G_parietal_sup_volume",        "lh_G_parietal_sup_volume",       
    "rh_G_pariet_inf.Angular_volume",  "lh_G_pariet_inf.Angular_volume", 
    "rh_G_pariet_inf.Supramar_volume", "lh_G_pariet_inf.Supramar_volume", 
    "rh_G_postcentral_volume",         "lh_G_postcentral_volume",        
    "rh_S_postcentral_volume",         "lh_S_postcentral_volume",        
    "rh_G_precuneus_volume",           "lh_G_precuneus_volume"          
)
names.temporal=c(
    "rh_G_temp_sup.G_T_transv_volume", "lh_G_temp_sup.G_T_transv_volume", 
    "rh_G_temp_sup.Lateral_volume",    "lh_G_temp_sup.Lateral_volume",    
    "rh_G_temp_sup.Plan_polar_volume", "lh_G_temp_sup.Plan_polar_volume", 
    "rh_G_temp_sup.Plan_tempo_volume", "lh_G_temp_sup.Plan_tempo_volume", 
    "rh_G_temporal_inf_volume",        "lh_G_temporal_inf_volume",        
    "rh_G_temporal_middle_volume",     "lh_G_temporal_middle_volume",     
    "rh_S_temporal_inf_volume",        "lh_S_temporal_inf_volume",        
    "rh_S_temporal_sup_volume",        "lh_S_temporal_sup_volume",        
    "rh_S_temporal_transverse_volume", "lh_S_temporal_transverse_volume", 
    "rh_Pole_temporal_volume",         "lh_Pole_temporal_volume"         
)

names.temporal.vol=paste(names.temporal,"_volume",sep="")
names.parietal.vol=paste(names.parietal,"_volume",sep="")
pvaluesmatrix[c(names.temporal,names.parietal),]
names.temporal.vol.r=paste("r.",names.temporal.vol,sep="")
names.parietal.vol.r=paste("r.",names.parietal.vol,sep="")
pvaluesmatrix[c(names.temporal.vol.r,names.parietal.vol.r),]

# investigating about thickness

fsstatfile.rh="edited.aparc.a2009s_stats_rh_thickness.txt"
fsstatfile.lh="edited.aparc.a2009s_stats_lh_thickness.txt"

names.temporal=paste(names.temporal,"_thickness",sep="")
names.parietal=paste(names.parietal,"_thickness",sep="")
pvaluesmatrix[c(names.temporal,names.parietal),]

# investigating about area

fsstatfile.rh="edited.aparc.a2009s_stats_rh_area.txt"
fsstatfile.lh="edited.aparc.a2009s_stats_lh_area.txt"

names.temporal=paste(names.temporal,"_area",sep="")
names.parietal=paste(names.parietal,"_area",sep="")
pvaluesmatrix[c(names.temporal,names.parietal),]


# ----------------------------------
# summary
# ----------------------------------

# ----------------------------------
# contents 
# ----------------------------------

- set up data
- statistical analysis
- demographics
- output demographic table
- analyses of corpus callosum
- analyses of venttricles
- correlation analysis - output correlation matrix
- correlation analysis - outpu p-values of the analyses
- correlation analysis in PRO and HVPRO data
- correlation analysis in PRO data
- more simple script for correlation analysis
- use linear model, analyses in subgroups
- volume graphs
- simple volume graphs, 2015/09/29
- plot for correlation in PRO
- exploratory plot 
- plot with jitter
- plot for correlation matrix
- difference between with/without binpositions="all"
- scatter plots where significant coefficient
- Notes: about the data, R, ...
- Examples for functions
* data setting in home PC
- correlation analyses
* important analyses
- old records of important analyses
- output data table, edit at home, 2015/09/28
- flexible function for linear model
- ANOVA, same as in SPSS default
- more flexible functions for linear model and ANOVA
- table of volumes for checking data, 2015/09/29, 
- ANCOVA or ANOVA: p-values of main effect of GROUP
- summary

* important analyses
- more flexible functions for linear model and ANOVA

