# ----------------------
# outline
# ----------------------

# - using general linear mode
# - change the jun.stack() function
# - partial correlation trial
# - using partial correlation in PRO (not in HC)


# ----------------------------------
# analysis with general linear model
# ----------------------------------

# todo using general linear model
# - I did not complete this script for analysis.

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO"

field.names=c("Right.Hippocampus","Left.Hippocampus")   
data.amy=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.amy))

datax=data.pro
jun.an()

> datax=data.ex3.exna
> data.pro=subset(datax,GROUP=="PRO")
> data.hc=subset(datax,GROUP=="HVPRO")
> 

# - I did not complete this script for analysis.


# ------------------------
# jun.stackを変更
# ------------------------


# defaut argument datax=datax
# todo: I thnk this kind of change is needed for other functions. 

jun.stack <- function(fieldnames1,fieldnames2,datax=datax){
    datax.stack=stack(datax[fieldnames1])
    datax.stack[fieldnames2]=datax[fieldnames2]
    datax.stack
}


# ------------------------
# partial correlation trial
# ------------------------


# set up data

# install.packages("ppcor", dep=T)    # for installation
# library(ppcor)
datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO"
datax=data.pro


# analyses

# # CC does not have hemisphere

# field.names=regions
# data.cc=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
# pcor.test(data.amy$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind))
# pcor.test(data.amy$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind),method="spearman")

field.names=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle")  
data.lv=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
pcor.test(data.amy$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind))
pcor.test(data.amy$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind),method="spearman")

field.names=c("Right.Inf.Lat.Vent","Left.Inf.Lat.Vent") 
data.lvt=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
pcor.test(data.amy$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind))
pcor.test(data.amy$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind),method="spearman")

field.names=c("Right.Amygdala","Left.Amygdala")   
data.amy=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
pcor.test(data.amy$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind))
pcor.test(data.amy$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind),method="spearman")

field.names=c("Right.Hippocampus","Left.Hippocampus")   
data.hip=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
pcor.test(data.hip$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind))
pcor.test(data.hip$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind),method="spearman")


# --------------------
# partial correlation
# --------------------

# templates were made 2016/02/12
# using partial correlation
# in prodroms

# pcor.test can not handle factor as a covariate.
# I changed the data.tmp$ind into numeric. Is this appropiate? 

# one SINTOTEV is missing (NA) in each hemisphere (one subject)
# pcor.test can not handle NA data
# I delete NA row in the analysis of SINTOTEV. Is this appropriate? 


# set up data 

# install.packages("ppcor", dep=T)    # for installation
# library(ppcor)
datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")
datax=data.pro


# analyses

field.names=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle")  
data.tmp=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
pcor.test(data.tmp$values,data.tmp$GAFC,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$GAFC,as.numeric(data.tmp$ind),method="spearman")
pcor.test(data.tmp$values,data.tmp$SIPTOTEV,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$SIPTOTEV,as.numeric(data.tmp$ind),method="spearman")
data.tmp=na.omit(data.tmp)
pcor.test(data.tmp$values,data.tmp$SINTOTEV,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$SINTOTEV,as.numeric(data.tmp$ind),method="spearman")

field.names=c("Right.Inf.Lat.Vent","Left.Inf.Lat.Vent") 
data.tmp=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
pcor.test(data.tmp$values,data.tmp$GAFC,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$GAFC,as.numeric(data.tmp$ind),method="spearman")
pcor.test(data.tmp$values,data.tmp$SIPTOTEV,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$SIPTOTEV,as.numeric(data.tmp$ind),method="spearman")
data.tmp=na.omit(data.tmp)
pcor.test(data.tmp$values,data.tmp$SINTOTEV,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$SINTOTEV,as.numeric(data.tmp$ind),method="spearman")

field.names=c("Right.Amygdala","Left.Amygdala")   
data.tmp=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
pcor.test(data.tmp$values,data.tmp$GAFC,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$GAFC,as.numeric(data.tmp$ind),method="spearman")
pcor.test(data.tmp$values,data.tmp$SIPTOTEV,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$SIPTOTEV,as.numeric(data.tmp$ind),method="spearman")
data.tmp=na.omit(data.tmp)
pcor.test(data.tmp$values,data.tmp$SINTOTEV,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$SINTOTEV,as.numeric(data.tmp$ind),method="spearman")

field.names=c("Right.Hippocampus","Left.Hippocampus")   
data.tmp=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
pcor.test(data.tmp$values,data.tmp$GAFC,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$GAFC,as.numeric(data.tmp$ind),method="spearman")
pcor.test(data.tmp$values,data.tmp$SIPTOTEV,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$SIPTOTEV,as.numeric(data.tmp$ind),method="spearman")
data.tmp=na.omit(data.tmp)
pcor.test(data.tmp$values,data.tmp$SINTOTEV,as.numeric(data.tmp$ind))
pcor.test(data.tmp$values,data.tmp$SINTOTEV,as.numeric(data.tmp$ind),method="spearman")


# todo make a function
# This is not finished. 

field.names=c("Right.Hippocampus","Left.Hippocampus")   
data.hip=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
pcor.test(data.hip$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind))
pcor.test(data.hip$values,data.amy$SIPTOTEV,as.numeric(data.amy$ind),method="spearman")



