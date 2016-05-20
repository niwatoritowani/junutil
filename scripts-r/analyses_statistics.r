# outline


# --------------------------------------
# effect size 2016/03/10
# --------------------------------------

datax=data.ex3.exna
field.names=c("r.CC_Anterior", "r.CC_Mid_Anterior", "r.CC_Central", "r.CC_Mid_Posterior", "r.CC_Posterior")
data.cc=jun.stack(field.names,c("caseid2","GROUP","ICV"))    # may be used
data.cc.central=subset(data.cc,ind=="r.CC_Central")    # maybe be used
field.names=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle")
data.lv=jun.stack(field.names,c("caseid2","GROUP"))
field.names=c("r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent")
data.lvt=jun.stack(field.names,c("caseid2","GROUP"))
field.names=c("r.Right.Amygdala","r.Left.Amygdala")
data.amy=jun.stack(field.names,c("caseid2","GROUP"))
field.names=c("r.Right.Hippocampus","r.Left.Hippocampus")
data.hip=jun.stack(field.names,c("caseid2","GROUP"))

library(ez)
#ezANOVA(data.lvt,dv=values,wid=caseid2,within=ind,between=GROUP,type=3,detailed=TRUE,return_aov=TRUE)
ezANOVA(datax, dv=r.CC_Central,wid=caseid2,between=GROUP,type=3)
ezANOVA(data.lv, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.lvt, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.amy, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.hip, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)


# correlation


# --------------------
# set up data
# --------------------

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")


# --------------------
# correlatinon between volumes, selected items, spearman, 2016/01/06
# --------------------

items.row=c("r.CC_Central","r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle",
    "r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus") # relative volume
items.col=c("r.CC_Central","r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle",
    "r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus") # relative volume
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
mtx.p.hc=arr.hc[,,2]; mtx.rho.hc=arr.hc[,,1]
mtx.p.pro.sig=sigmtx(mtx.p.pro); 
mtx.rho.pro.sig=sigmtx.rho(mtx.p.pro,mtx.rho.pro)    # 2016/03/03
mtx.p.hc.pro.sig=sigmtx(mtx.p.hc)

#mtx.p.pro.adjust=matrix(p.adjust(mtx.p.pro,"bonferroni",n=36),nrow(mtx.p.pro),)
#rownames(mtx.p.pro.adjust)=rownames(mtx.p.pro)
#colnames(mtx.p.pro.adjust)=colnames(mtx.p.pro)
#kable(mtx.p.pro.adjust)    # for debugging
mtx.p.pro.adjust=mtx.p.pro * 36
mtx.p.pro.adjust[(mtx.p.pro.adjust > 1)]=1    # If the values are greater than 1, they become 1. 
mtx.p.pro.adjust.sig=sigmtx.rho(mtx.p.pro,mtx.p.pro.adjust)

# --------------------
# output table
# --------------------

# - input : the results of above correlation analyses

# output table: combine rho and p

m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab=matrix(NA,n,2*m)
for (p in 1:m) {
    mtx.pro.outtab[,2*p-1]=mtx.rho.pro[,p]
    mtx.pro.outtab[,2*p]  =mtx.p.pro[,p]
}
rownames(mtx.pro.outtab)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab)


# output to file

sink(file="tmp",append=TRUE)    # start output
print(kable(mtx.pro.outtab))
sink()    # stop output


# output table: combine rho and p (remain only significant p)

m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab.sig=matrix(NA,n,2*m)
for (p in 1:m) {
    mtx.pro.outtab.sig[,2*p-1]=mtx.rho.pro.sig[,p]
    mtx.pro.outtab.sig[,2*p]  =mtx.p.pro.sig[,p]
}
rownames(mtx.pro.outtab.sig)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab.sig)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab.sig)


# output to file

sink(file="tmp",append=TRUE)    # start output
print(kable(mtx.pro.outtab.sig))
sink()    # stop output


# --------------------
# output table 2
# --------------------

# - input : the results of above correlation analyses
#     - mpx.rho.pro      : rho values
#     - mtx.p.pro.adjust : adjusted p values (instead of mtx.p.pro)
#     - mtx.p.pro        : colmun names and raw names

# output table: combine rho and p

m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab=matrix(NA,n,2*m)
for (p in 1:m) {
    mtx.pro.outtab[,2*p-1]=mtx.rho.pro[,p]
    mtx.pro.outtab[,2*p]  =mtx.p.pro.adjust[,p]    # mtx.p.pro into mtx.p.pro.adjust
}
rownames(mtx.pro.outtab)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab)


# output to file

sink(file="tmp",append=TRUE)    # start output
print(kable(mtx.pro.outtab))
sink()    # stop output


# output table: combine rho and p (remain only significant p)

m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab.sig=matrix(NA,n,2*m)
for (p in 1:m) {
    mtx.pro.outtab.sig[,2*p-1]=mtx.rho.pro.sig[,p]  
    mtx.pro.outtab.sig[,2*p]  =mtx.p.pro.adjust.sig[,p]    # mtx.p.pro.sig into mtx.p.pro.adjust.sig
}
rownames(mtx.pro.outtab.sig)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab.sig)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab.sig)


# output to file

sink(file="tmp",append=TRUE)    # start output
print(kable(mtx.pro.outtab.sig))
sink()    # stop output


# --------------------
# correlation between volumes and clinical scores, selected items, spearman, 2016/01/06
# --------------------

items.row=c("r.CC_Central","r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle",
    "r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus") # relative volume
items.col=c("GAFC","SIPTOTEV","SINTOTEV")
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
mtx.p.hc=arr.hc[,,2]
mtx.p.pro.sig=sigmtx(mtx.p.pro); 
mtx.rho.pro.sig=sigmtx.rho(mtx.p.pro,mtx.rho.pro)    # 2016/03/03
sig.mtx=sigmtx(mtx.p.hc); 

mtx.p.pro.adjust=mtx.p.pro * 27
mtx.p.pro.adjust[(mtx.p.pro.adjust > 1)]=1
mtx.p.pro.adjust.sig=sigmtx.rho(mtx.p.pro,mtx.p.pro.adjust)


# --------------------
# output table
# --------------------

# - input are supposed to be the results of above correlation analyses


# output table: combine rho and p

m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab=matrix(NA,n,2*m)
for (p in 1:m) {
    mtx.pro.outtab[,2*p-1]=mtx.rho.pro[,p]
    mtx.pro.outtab[,2*p]  =mtx.p.pro[,p]
}
rownames(mtx.pro.outtab)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab)


# output to file

sink(file="tmp",append=TRUE)    # start output
print(kable(mtx.pro.outtab))
sink()    # stop output


# output table: combine rho and p (remain only significant p)

m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab.sig=matrix(NA,n,2*m)
for (p in 1:m) {
    mtx.pro.outtab.sig[,2*p-1]=mtx.rho.pro.sig[,p]
    mtx.pro.outtab.sig[,2*p]  =mtx.p.pro.sig[,p]
}
rownames(mtx.pro.outtab.sig)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab.sig)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab.sig)


# output to file

sink(file="tmp",append=TRUE)    # start output
print(kable(mtx.pro.outtab.sig))
sink()    # stop output


# --------------------
# output table 2
# --------------------

# - input are supposed to be the results of above correlation analyses


# output table: combine rho and p

m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab=matrix(NA,n,2*m)
for (p in 1:m) {
    mtx.pro.outtab[,2*p-1]=mtx.rho.pro[,p]
    mtx.pro.outtab[,2*p]  =mtx.p.pro.adjust[,p]    # mtx.p.pro into mtx.p.pro.adjust
}
rownames(mtx.pro.outtab)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab)


# output to file

sink(file="tmp",append=TRUE)    # start output
print(kable(mtx.pro.outtab))
sink()    # stop output


# output table: combine rho and p (remain only significant p)

m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab.sig=matrix(NA,n,2*m)
for (p in 1:m) {
    mtx.pro.outtab.sig[,2*p-1]=mtx.rho.pro.sig[,p]  
    mtx.pro.outtab.sig[,2*p]  =mtx.p.pro.adjust.sig[,p]    # mtx.p.pro.sig into mtx.p.pro.adjust.sig
}
rownames(mtx.pro.outtab.sig)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab.sig)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab.sig)


# output to file

sink(file="tmp",append=TRUE)    # start output
print(kable(mtx.pro.outtab.sig))
sink()    # stop output


# date
# - 2016/05/20

