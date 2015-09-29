# This file is a script for R and run by
#     R --vanilla < rscript3.r

# =============
# set up data
# =============

fsstatfile="/projects/schiz/3Tprojects/2015-jun-prodrome/stats/aseg_stats.txt"
demographictable="/projects/schiz/3Tprojects/2015-jun-prodrome/caselist/Caselist_CC_prodromes.xlsx"

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

# format the strings of case id, merge tables, arrange field names

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

summary(data6[,c(demographics1,parameters2,parameters1)])
#by(data6[demographics1],data6$SEX,summary)
by(data6[,c(demographics1,parameters2)],data6$GROUP,summary)
summary(table(data6$GROUP,data6$SEX)) # chi test
t.test(subset(data6,GROUP=="PRO")["AGE"],subset(data6,GROUP=="HVPRO")["AGE"]) # t test

# ---------------------------------------------
# output demographic table
# ---------------------------------------------

datax=data6
#datax=data6[-29,]  # exclude a case which have no volume data
#datax=subset(data6,subset=(!is.na(CC_Anterior))) # exclude a case which have no volume data
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
for ( i in 1:(n-1) ) {
    tablex=rbind(tablex,table1[i,])
} 
table1=tablex
print(table1)
knitr::kable(table1)

# ---------------------------
# analyses of corpus callosum
# ---------------------------

# ANOVA with factors: GROUP, SEX, GROUP*SEX, ICV

funclm1 <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP*SEX+ICV,data=data6)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
for (region in regions ) { funclm1(region) } # CC
for (region in regions2 ) {funclm1(region)} # ventricles
for (region in regions3 ) {funclm1(region)} # ventricles, bil.LV
# results: significant group difference of Left.Lateral.Ventricle


# ANOVA with factors: GROUP, ICV

funclm2 <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP+ICV,data=data6)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
for (region in regions ) { funclm2(region) } # CCs
for (region in regions2 ) {funclm2(region)} # ventricles
for (region in regions3 ) {funclm2(region)} # ventricles, bil.LV
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
    # results: PRO << HVPRO in male, but p=0.07493, 
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

# ANOVA with factors: GROUP, SEX, ICV  --> above
# ANOVA with factors: GROUP, ICV       --> above

# -------------------
# correlation analysis
# --------------------

# correlation analysis - output correlation matrix
# -----------------------------------------------

datax=cbind(data6[c(regions,regions3)])  # set datax
mcor=cor(datax,use="complete.obs")    # correlation matrix with correlation coefficients but not p-values
plot(datax)    # plot of correlation matrix

# you may use "datax=na.omit(datax)"    # omit rows including NA for correlation analysis

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
mask=sapply(datax,is.numeric)    # apply is.numeric to each column, output nuber is same as the number of column of input
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

# use linear model, analyses in subgroups
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
# datax=subset(data6,GROUP=="PRO")
# datax=subset(data6,SEX==0)
# datax=subset(data6,SEX==1)

# ANOVA with factors: ICV in PRO (or in Male/Female)

funclm4 <- function(arg1,arg2){
    # arg1: character; arg2: character; r=lm(arg1~arg2+ICV,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5="+ICV,data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
}
#item=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","Left.Lateral.Ventricle")
item=c(regions,regions2)
#datacol=c("CC_Mid_Posterior","Bil.Lateral.Ventricle","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
#datacol=c(parameters_si)
datacol=c(parameters1)
#datacol=c(regions,regions2)
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

datax=subset(data6,SEX==0);funclm4("Left.Lateral.Ventricle","GROUP")
datax=subset(data6,SEX==1);funclm4("Left.Lateral.Ventricle","GROUP")
datax=subset(data6,GROUP=="PRO");funclm4("Left.Lateral.Ventricle","SEX")
datax=subset(data6,!GROUP=="PRO");funclm4("Left.Lateral.Ventricle","SEX")

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

# exploratory plot

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

pdf("CCMid_LV_by_GROUPSEX.pdf")
grid.arrange(p1,p2,p3,p4,p5,p6,p7,nrow=2,ncol=4)
dev.off()

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

# install.packages("rgl") # for 3D plot
library(rgl)

# plot with mark which explain where difference exist
library(ggplot2); library(gridExtra)
p1=ggplot(data6, aes(x=GROUPSEX,y=rCC_Mid_Posterior,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank()) +   # don't display x-axis-label
    annotate("segment",x=1.5,xend=3.5,y=0.0005,yend=0.0005) +
    annotate("segment",x=1,xend=2,y=0.000475,yend=0.000475) +
    annotate("segment",x=1,xend=1,y=0.000475,yend=0.000460) +
    annotate("segment",x=2,xend=2,y=0.000475,yend=0.000460) +
    annotate("segment",x=3,xend=4,y=0.000475,yend=0.000475) +
    annotate("segment",x=3,xend=3,y=0.000475,yend=0.000460) +
    annotate("segment",x=4,xend=4,y=0.000475,yend=0.000460) +
    annotate("text",x=2.5,y=0.0005,label="*",size=10)    # add a * 
p2=ggplot(data6, aes(x=GROUPSEX,y=rRight.Lateral.Ventricle,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank()) +   # don't display x-axis-label
    annotate("segment",x=1.5,xend=3.5,y=0.0145,yend=0.0145) +
    annotate("segment",x=1,xend=3,y=0.013,yend=0.013) +
    annotate("segment",x=1,xend=1,y=0.013,yend=0.0125) +
    annotate("segment",x=3,xend=3,y=0.013,yend=0.0125) +
    annotate("segment",x=2,xend=4,y=0.014,yend=0.014) + 
    annotate("segment",x=2,xend=2,y=0.014,yend=0.0135) + 
    annotate("segment",x=4,xend=4,y=0.014,yend=0.0135) + 
    annotate("text",x=2.5,y=0.015,label="*",size=10)    # add a * 
p3=ggplot(data6, aes(x=GROUPSEX,y=rLeft.Lateral.Ventricle,fill=GROUPSEX)) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank()) +   # don't display x-axis-label
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
# correlation analyses
# ----------------------------------

datax=subset(data6,GROUP=="PRO")
func=function(arg1){print(cor.test(x,arg1,method="spearman")[["p.value"]])}

x=datax[["rCC_Mid_Posterior"]]    # vector
y=datax[["READSTD"]] ;func(y)
y=datax[["WASIIQ"]]  ;func(y)
y=datax[["GAFC"]]    ;func(y)
y=datax[["GAFH"]]    ;func(y)

x=datax[["rBil.Lateral.Ventricle"]]    # vector
y=datax[["READSTD"]] ;func(y)
y=datax[["WASIIQ"]]  ;func(y)
y=datax[["GAFC"]]    ;func(y)
y=datax[["GAFH"]]    ;func(y)
y=datax[["ROLEFX"]]  ;func(y)

# =================
# important analyses
# ==================

# --------------------------------------
# two-factors ANCOVA: GROUP, SEX; ICV
# --------------------------------------

funclm1 <- function(arg1){
    # arg1: characters; r=lm(arg1~GROUP*SEX+ICV,data=data6)
    txt1="r=lm("; txt2=arg1; txt3="~GROUP*SEX+ICV,data=data6)"
    txt0=paste(txt1,txt2,txt3,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("----------------\n")
    print(s[[1]]); print(s[[4]][,c(1,4)])
}
for (region in regions ) { funclm1(region) } # CC
for (region in regions2 ) {funclm1(region)} # centricles

# -------------------------------------
# Follow-up analyses: one-factor ANCOVA 
# -------------------------------------
# separated into groups by SEX; factor:GROUP; covariate:ICV
# separated into groups by GROUP; factor:SEX; covariate:ICV

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

# -----------------------------
# correlation analyses: relative volume (divided by ICV)
# -----------------------------

datax=    cbind(
    data6[c(1:15)],
    data6[c("READSTD","WASIIQ","GAFC","GAFH")],
    data6[c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")],
    data6[regions4],
    data6[parameters1]
)
datax=subset(datax,GROUP=="PRO")
mask=sapply(datax,is.numeric)    # apply is.numeric to each column, output nuber is same as the number of co
datax=subset(datax,select=mask)    # select only data which are numeric

col=c("estimate","p.value")    # vector:character
item=c(regions4)
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

datax=subset(datax,GROUP=="PRO")
item=c(regions,regions2)
datacol=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV",parameters1)
m=length(item); n=length(datacol)
for ( j in 1:m) {
    for ( i in 1:n ) {
        funclm4(item[j],datacol[i])
    }
}

# ---------------
# dot plots
# --------------

library(ggplot2); library(gridExtra)
#data6$SEX=as.character(data6$SEX);mask=(data6$SEX=="0");data6$SEX[mask]="M";data6$SEX[!mask]="F";data6$SEX=as.factor(data6$SEX)
#data6$GROUPSEX=as.factor(paste(data6$GROUP,as.character(data6$SEX),sep=""))

pdf("plot.pdf")
p4=ggplot(data6, aes(x=GROUP,y=rCC_Mid_Posterior,fill=SEX)) +
    scale_fill_manual(values=c("blue","red")) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p5=ggplot(data6, aes(x=GROUP,y=rLeft.Lateral.Ventricle,fill=SEX)) +
    scale_fill_manual(values=c("blue","red")) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p6=ggplot(data6, aes(x=SEX,y=rRight.Lateral.Ventricle,fill=GROUP)) +
    scale_fill_manual(values=c("#E69F00","#009E73")) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label
p7=ggplot(data6, aes(x=SEX,y=rLeft.Lateral.Ventricle,fill=GROUP)) +
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

pdf("scatterplot.pfd")
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
dev.off()

# --------------------------------------------------------------------------------------------
# old records

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
funclm1("Left.Lateral.Ventricle")
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

# ------------------------
# edit at home, 2015/09/28
# ------------------------

# output files 
write.csv(data6,file="caselist_prodromes_jun.csv",na="")
write.xlsx(data6,file="caselist_prodromes_jun.xlsx",showNA=FALSE)
# The right-bttom of the xlsx table isZQ44

# -----------------------
# lm(), aov() and anova()
# -----------------------

> r

Call:
lm(formula = CC_Mid_Posterior ~ GROUP * SEX + ICV, data = data6)

Coefficients:
  (Intercept)       GROUPPRO           SEX1            ICV  GROUPPRO:SEX1  
    4.042e+02     -7.465e+01     -5.415e+01      3.805e-05      9.976e+01  

> summary(r)

Call:
lm(formula = CC_Mid_Posterior ~ GROUP * SEX + ICV, data = data6)

Residuals:
     Min       1Q   Median       3Q      Max 
-197.037  -46.741    3.802   45.112  233.177 

Coefficients:
                Estimate Std. Error t value Pr(>|t|)  
(Intercept)    4.042e+02  1.900e+02   2.127   0.0401 *
GROUPPRO      -7.465e+01  3.501e+01  -2.132   0.0397 *
SEX1          -5.415e+01  4.191e+01  -1.292   0.2044  
ICV            3.805e-05  1.217e-04   0.313   0.7562  
GROUPPRO:SEX1  9.976e+01  5.554e+01   1.796   0.0806 .
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 87.47 on 37 degrees of freedom
  (1 observation deleted due to missingness)
Multiple R-squared:  0.1219,    Adjusted R-squared:  0.02699 
F-statistic: 1.284 on 4 and 37 DF,  p-value: 0.2938

> anova(r)
Analysis of Variance Table

Response: CC_Mid_Posterior
          Df Sum Sq Mean Sq F value  Pr(>F)  
GROUP      1  11837 11836.8  1.5473 0.22137  
SEX        1   2195  2194.9  0.2869 0.59541  
ICV        1    590   590.2  0.0771 0.78275  
GROUP:SEX  1  24681 24680.8  3.2262 0.08064 .
Residuals 37 283058  7650.2                  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
> aov(r)
Call:
   aov(formula = r)

Terms:
                    GROUP       SEX       ICV GROUP:SEX Residuals
Sum of Squares   11836.80   2194.92    590.17  24680.84 283058.11
Deg. of Freedom         1         1         1         1        37

Residual standard error: 87.46553
Estimated effects may be unbalanced
1 observation deleted due to missingness
> summary(anova(r))
       Df           Sum Sq            Mean Sq           F value       
 Min.   : 1.0   Min.   :   590.2   Min.   :  590.2   Min.   :0.07714  
 1st Qu.: 1.0   1st Qu.:  2194.9   1st Qu.: 2194.9   1st Qu.:0.23447  
 Median : 1.0   Median : 11836.8   Median : 7650.2   Median :0.91708  
 Mean   : 8.2   Mean   : 64472.2   Mean   : 9390.6   Mean   :1.28437  
 3rd Qu.: 1.0   3rd Qu.: 24680.8   3rd Qu.:11836.8   3rd Qu.:1.96698  
 Max.   :37.0   Max.   :283058.1   Max.   :24680.8   Max.   :3.22616  
                                                     NA's   :1        
     Pr(>F)       
 Min.   :0.08064  
 1st Qu.:0.18618  
 Median :0.40839  
 Mean   :0.42004  
 3rd Qu.:0.64225  
 Max.   :0.78275  
 NA's   :1        
> summary(aov(r))
            Df Sum Sq Mean Sq F value Pr(>F)  
GROUP        1  11837   11837   1.547 0.2214  
SEX          1   2195    2195   0.287 0.5954  
ICV          1    590     590   0.077 0.7828  
GROUP:SEX    1  24681   24681   3.226 0.0806 .
Residuals   37 283058    7650                 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
1 observation deleted due to missingness
> anova(r)
Analysis of Variance Table

Response: CC_Mid_Posterior
          Df Sum Sq Mean Sq F value  Pr(>F)  
GROUP      1  11837 11836.8  1.5473 0.22137  
SEX        1   2195  2194.9  0.2869 0.59541  
ICV        1    590   590.2  0.0771 0.78275  
GROUP:SEX  1  24681 24680.8  3.2262 0.08064 .
Residuals 37 283058  7650.2                  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
>

# End of lm(), aov() and anova()
# -----------------------------------------------------------------------------


# -----------------------------------
# flexible function for linear model
# -----------------------------------

funclm <- function(arg1,arg2){
    # arg1: character;arg2:character; r=lm(arg1~arg2,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~";txt4=arg2;txt5=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,sep="")
    eval(parse(text=txt0));s=summary(r);a=anova(r)
    cat("----------------------------------------\n")
    print(s[["call"]]);print(a)
}
datax=data6;for (region in regions ) { funclm(region,"GROUP*SEX+ICV") } # CC
datax=data6;for (region in regions2 ) {funclm(region,"GROUP*SEX+ICV")} # ventricles
datax=data6;for (region in regions ) { funclm(region,"GROUP+SEX+ICV") } # CC
datax=data6;for (region in regions2 ) {funclm(region,"GROUP+SEX+ICV")} # ventricles
datax=data6;for (region in regions ) { funclm(region,"GROUP+ICV") } # CC
datax=data6;for (region in regions2 ) {funclm(region,"GROUP+ICV")} # ventricles
datax=data6;funclm("CC_Mid_Posterior","GROUP*SEX+ICV")
datax=data6;funclm("CC_Mid_Posterior","+ICV+GROUP*SEX")
datax=data6;for (region in regions ) { funclm(region,"+ICV+GROUP*SEX") } # CC

# -----------------------------
# the same analysis as in SPSS
# -----------------------------

library(car)
options(contrasts = c("contr.sum", "contr.sum"))
r2=lm( CC_Mid_Posterior ~ ICV + GROUP * SEX , data = data6)
Anova(r2,type=3)

# -----------------------------------
# more flexible function for linear model
# -----------------------------------

funclm <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
#    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
    print(anova(r))
}
myfunc=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {funclm(item[j],datacol[i],arg3)}}
}
datax=subset(data6,GROUP=="PRO")
item=c(regions,regions2)
datacol=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV",parameters1)
myfunc(item,datacol,"+ICV")
myfunc(item,datacol,"+SEX+ICV")
myfunc("Left.Lateral.Ventricle","ROLEFX","+ICV")
myfunc("ROLEFX","Left.Lateral.Ventricle","+ICV")
sink(file="tmp",append=FALSE);myfunc(item,datacol,"+ICV");sink()


library(car) # for Anova()
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
funclm <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
#    print(s[["call"]]); print(s[["coefficients"]][,c(1,4)])
    print(Anova(r,type=3))
}
myfunc=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {funclm(item[j],datacol[i],arg3)}}
}
datax=subset(data6,GROUP=="PRO")
item=c(regions,regions2)
datacol=c("READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV",parameters1)
myfunc(item,datacol,"+ICV")
myfunc(item,datacol,"+SEX+ICV")
myfunc("Left.Lateral.Ventricle","ROLEFX","+ICV")
myfunc("ROLEFX","Left.Lateral.Ventricle","+ICV")
sink(file="tmp",append=FALSE);myfunc(item,datacol,"+ICV");sink()
sink(file="tmp",append=FALSE);myfunc(datacol,item,"+ICV");sink()

# ------------------
# new plot
# ------------------

library(ggplot2); library(gridExtra)
datax=subset(data6,GROUP=="PRO")
pdf("tmp.pdf")
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
dev.off()


