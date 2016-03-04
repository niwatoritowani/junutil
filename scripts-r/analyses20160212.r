# ----------------------
# outline
# ----------------------

# - using general linear mode (not finished) 
# - using partial correlation in PRO (not in HC)
# - partial correlation with a function


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


# --------------------
# partial correlation
# --------------------

# templates were made 2016/02/12
# using partial correlation in prodroms

# pcor.test can not handle factor as a covariate.
# I changed the data.tmp$ind into numeric. Is this appropiate? 

# one SINTOTEV is missing (NA) in each hemisphere (one subject)
# pcor.test can not handle NA data
# I delete NA row in the analysis of SINTOTEV. Is this appropriate? 


# set up data 

# install.packages("ppcor", dep=T)    # for installation
# library(ppcor)    # for partial correlation
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


# ------------------------------------
# function for partial correlation
# ------------------------------------

# - This functions were copied into functions.r in 2016/03/04. They would not be updated more.  

# jun.pcor.test0 <- function(fieldx,fieldy,fieldcov,method1="pearson",datax=datax) {
#     datax1=datax[c(fieldx,fieldy,fieldcov)]    # extract necessary field for pcor.test
#     datax2=na.omit(datax1)        # missing values are not allowed for pcor.test
#     pcor.test(datax2[[fieldx]],datax2[[fieldy]],as.numeric(datax2[[fieldcov]]),method=method1)
#     # should be [[]] but not []
# }
# 
# jun.pcor.test01 <- function(items1,items.ana,methods1, datax=datax, showresults=TRUE) {
#     l=length(items.ana); m=length(methods1); n=length(items1);  # l-h, m-i, n-j
#     arr=array(0,dim=c(n,l,m))
#     dimnames(arr)=list(items1, items.ana, methods1)  # the order is correspond to l, m, n
#     for (j in 1:n) {            # cat("for parameters, i is",i,"\n") # for debug
#         for (i in 1:m) {        # cat("for method, j is", j, "\n")   # for debug
#             if (showresults) {  # optional
#                 cat("\n\npartial correlation between","values","and",items1[i],"with","ind","as a covariate\n\n")
#                 result1=jun.pcor.test0("values",items1[j],"ind",methods1[i],datax)
#                 print(result1)
#             }
#             for (h in 1:l) {
#                 # cat("h,i,j is", h,i,j, "\n"); cat("items.ana[",h,"] is",items.ana[h], "\n\n")  # for debug
#                 arr[j,h,i]=jun.pcor.test0("values",items1[j],"ind",methods1[i],datax)[[items.ana[h]]]
#                 # shoud be [[]] but not []
#             }
#         }
#     }
#     arr
# }


# ------------------------------------
# partial correlation with a function
# ------------------------------------

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO");  data.hc=subset(datax,GROUP=="HVPRO")
datax=data.pro
items1=c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV")
data.lv=jun.stack(c("Right.Lateral.Ventricle","Left.Lateral.Ventricle"),items1)
data.th=jun.stack(c("Right.Inf.Lat.Vent","Left.Inf.Lat.Vent"),items1)
data.amy=jun.stack(c("Right.Amygdala","Left.Amygdala"),items1)
data.hip=jun.stack(c("Right.Hippocampus","Left.Hippocampus"),items1)

items1=c("GAFC","SIPTOTEV","SINTOTEV")
items.ana=c("estimate","p.value")
methods1=c("pearson","spearman")

jun.pcor.test01(items1,items.ana,methods1,data.lv)
jun.pcor.test01(items1,items.ana,methods1,data.th)
jun.pcor.test01(items1,items.ana,methods1,data.amy)
jun.pcor.test01(items1,items.ana,methods1,data.hip)

