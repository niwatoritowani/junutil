# --------------------------------
# data setup
# --------------------------------

# # The code below were commented out on 2016/06/13
# datax=data.main
# datax[["caseid2"]] # display
# subset(datax,is.na(SEX))[["caseid2"]] # display 4 cases "321400178" "321400205" "321400270" "321400297"
# datax=subset(datax,!is.na(SEX))
# datax[["caseid2"]] # display
# subset(datax,is.na(CC_Mid_Anterior))[["caseid2"]] # display "321400204"
# datax=subset(datax,!is.na(CC_Mid_Anterior))
# datax[["caseid2"]] # display
# cat("exclude 3 cases (these cases were selected for display)\n")
# datax=subset(datax,caseid2!="321100267" & caseid2!="321400145" & caseid2!="321400119")
# datax[["caseid2"]] # display
# data.ex3.2.exna=datax
# 
# datax=data.ex3.2.exna
# sink(file="tmp",append=TRUE)    # start output caseids
#     cat("\n----caselist----\n")
#     print(data.frame(line=1:dim(datax)[1],datax[c("caseid2","GROUP")]))
# sink()
# data.pro=subset(datax,GROUP=="PRO")
# data.hc=subset(datax,GROUP=="HVPRO")

# using data "data.ex3.exna"
# datax=data.ex3.exna # commented out on 2016/06/15

# using data "data.ex4.exna"
datax=data.ex4.exna # 2016/06/15

sink(file="tmp",append=TRUE)    # start output caseids
    cat("\n----caselist----\n")
    print(data.frame(line=1:dim(datax)[1],datax[c("caseid2","GROUP")]))
sink()
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")

# --------------------------------------
# effect size 2016/03/10
# --------------------------------------

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
field.names=c("r.Right.LVTH","r.Left.LVTH")
data.lvth=jun.stack(field.names,c("caseid2","GROUP"))
field.names=c("r.Right.HipAmyCom","r.Left.HipAmyCom")
data.hipamy=jun.stack(field.names,c("caseid2","GROUP"))

library(ez)
#ezANOVA(data.lvt,dv=values,wid=caseid2,within=ind,between=GROUP,type=3,detailed=TRUE,return_aov=TRUE)
ezANOVA(datax, dv=r.CC_Central,wid=caseid2,between=GROUP,type=3)
ezANOVA(data.lv, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.lvt, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.amy, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.hip, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.lvth, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.hipamy, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)

# output to file

sink(file="tmp",append=TRUE)    # start output
    cat("CCC\n")
    ezANOVA(datax, dv=r.CC_Central,wid=caseid2,between=GROUP,type=3)
    cat("LV\n")
    ezANOVA(data.lv, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
    cat("TH\n")
    ezANOVA(data.lvt, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
    cat("AMY\n")
    ezANOVA(data.amy, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
    cat("HIP\n")
    ezANOVA(data.hip, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
    cat("LVTH\n")
    ezANOVA(data.lvth, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
    cat("HIPAMY\n")
    ezANOVA(data.hipamy, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
sink()    # stop output


# -------------------
# items
# -------------------

items.base=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle",
    "r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent",
    "r.CC_Central",
    "r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus"
    ,"r.Bil.Lateral.Ventricle","r.Bil.Inf.Lat.Vent"
    ,"r.Right.LVTH","r.Left.LVTH","r.Bil.LVTH"
    ,"r.Bil.Amygdala","r.Bil.Hippocampus"
    ,"r.Right.HipAmyCom","r.Left.HipAmyCom","r.Bil.HipAmyCom"
) # relative volume

items.hemi=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle",
    "r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent",
    "r.CC_Central",
    "r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus"
) # relative volume

items.bil=c("r.Bil.Lateral.Ventricle","r.Bil.Inf.Lat.Vent"
    ,"r.CC_Central"
    ,"r.Bil.Amygdala","r.Bil.Hippocampus"
) # relative volume

items.comb=c("r.Right.LVTH","r.Left.LVTH"
    ,"r.CC_Central"
    ,"r.Right.HipAmyCom","r.Left.HipAmyCom"
) # relative volume

items.bilcomb=c("r.Bil.LVTH"
    ,"r.CC_Central"
    ,"r.Bil.HipAmyCom"
) # relative volume

items.clinical=c("GAFC","SIPTOTEV","SINTOTEV","SIGTOTEV","SIDTOTEV"
    ,"SOCFXC","ROLEFX")


# ----------------------------------------------
# correlatinon between volumes, spearman
# ----------------------------------------------


myfunction <- function(){
    items.ana=c("estimate","p.value")
    arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
    arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
    mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
    mtx.p.hc=arr.hc[,,2]; mtx.rho.hc=arr.hc[,,1]
    mtx.p.pro.sig=sigmtx(mtx.p.pro); 
    mtx.rho.pro.sig=sigmtx.rho(mtx.p.pro,mtx.rho.pro)    # 2016/03/03
    mtx.p.hc.pro.sig=sigmtx(mtx.p.hc)
    
    # output table: combine rho and p
    m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab=matrix(NA,n,2*m)
    for (p in 1:m) {
        mtx.pro.outtab[,2*p-1]=mtx.rho.pro[,p]
        mtx.pro.outtab[,2*p]  =mtx.p.pro[,p]
    }
    rownames(mtx.pro.outtab)=rownames(mtx.p.pro)
    colnames(mtx.pro.outtab)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
    kable(mtx.pro.outtab) # display
    # output to file
    sink(file="tmp",append=TRUE)    # start output
    cat("\n----------------spearman---------------\n")
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
    kable(mtx.pro.outtab.sig) # display
    # output to file
    sink(file="tmp",append=TRUE)    # start output
    cat("\n----------------spearman---------------\n")
    print(kable(mtx.pro.outtab.sig))
    sink()    # stop output
}

items.row=items.hemi
items.col=items.hemi
myfunction()

items.row=items.bil
items.col=items.bil
myfunction()

items.row=items.comb
items.col=items.comb
myfunction()

items.row=items.bilcomb
items.col=items.bilcomb
myfunction()


# -------------------------------------
# correlation between volumes, pearson
# -------------------------------------

myfunction <- function(){
    items.ana=c("estimate","p.value")
    arr.pro=jun.cor.test.ps(items.row,items.col,items.ana,data.pro)
    arr.hc=jun.cor.test.ps(items.row,items.col,items.ana,data.hc)
    mtx.p.pro=arr.pro[,,2]; mtx.r.pro=arr.pro[,,1]
    mtx.p.hc=arr.hc[,,2]; mtx.r.hc=arr.hc[,,1]
    mtx.p.pro.sig=sigmtx(mtx.p.pro); 
    mtx.r.pro.sig=sigmtx.rho(mtx.p.pro,mtx.r.pro)    # 2016/03/03, data are "r" but function name is "rho"
    mtx.p.hc.pro.sig=sigmtx(mtx.p.hc)
    
    # output table: combine r and p
    m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab=matrix(NA,n,2*m)
    for (p in 1:m) {
        mtx.pro.outtab[,2*p-1]=mtx.r.pro[,p]
        mtx.pro.outtab[,2*p]  =mtx.p.pro[,p]
    }
    rownames(mtx.pro.outtab)=rownames(mtx.p.pro)
    colnames(mtx.pro.outtab)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("r","p"),m),sep=".")
    kable(mtx.pro.outtab) # display
    # output to file
    sink(file="tmp",append=TRUE)    # start output
    cat("\n----------------pearson---------------\n")
    print(kable(mtx.pro.outtab))
    sink()    # stop output
    
    # output table: combine r and p (remain only significant p)
    m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab.sig=matrix(NA,n,2*m)
    for (p in 1:m) {
        mtx.pro.outtab.sig[,2*p-1]=mtx.r.pro.sig[,p]
        mtx.pro.outtab.sig[,2*p]  =mtx.p.pro.sig[,p]
    }
    rownames(mtx.pro.outtab.sig)=rownames(mtx.p.pro)
    colnames(mtx.pro.outtab.sig)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("r","p"),m),sep=".")
    kable(mtx.pro.outtab.sig) # display
    # output to file
    sink(file="tmp",append=TRUE)    # start output
    cat("\n----------------pearson---------------\n")
    print(kable(mtx.pro.outtab.sig))
    sink()    # stop output
}

items.row=items.hemi
items.col=items.hemi
myfunction()

items.row=items.bil
items.col=items.bil
myfunction()

items.row=items.comb
items.col=items.comb
myfunction()

items.row=items.bilcomb
items.col=items.bilcomb
myfunction()

# ----------------------------------------------------------
# correlation between volumes and clinical scores, spearman
# ----------------------------------------------------------


myfunction <- function(){
    items.ana=c("estimate","p.value")
    arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
    arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
    mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
    mtx.p.hc=arr.hc[,,2]
    mtx.p.pro.sig=sigmtx(mtx.p.pro); 
    mtx.rho.pro.sig=sigmtx.rho(mtx.p.pro,mtx.rho.pro)    # 2016/03/03
    sig.mtx=sigmtx(mtx.p.hc); 
    
    # output table: combine rho and p
    m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab=matrix(NA,n,2*m)
    for (p in 1:m) {
        mtx.pro.outtab[,2*p-1]=mtx.rho.pro[,p]
        mtx.pro.outtab[,2*p]  =mtx.p.pro[,p]
    }
    rownames(mtx.pro.outtab)=rownames(mtx.p.pro)
    colnames(mtx.pro.outtab)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
    kable(mtx.pro.outtab) # display
    # output to file
    sink(file="tmp",append=TRUE)    # start output
    cat("\n----------------spearman---------------\n")
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
    kable(mtx.pro.outtab.sig) # display
    # output to file
    sink(file="tmp",append=TRUE)    # start output
    cat("\n----------------spearman---------------\n")
    print(kable(mtx.pro.outtab.sig))
    sink()    # stop output
}

items.row=items.hemi
items.col=items.clinical
myfunction()

items.row=items.bil
items.col=items.clinical
myfunction()

items.row=items.comb
items.col=items.clinical
myfunction()

items.row=items.bilcomb
items.col=items.clinical
myfunction()



# ---------------------------------------------------------
# correlation between volumes and clinical scores, pearson
# ---------------------------------------------------------

myfunction <- function(){
    items.ana=c("estimate","p.value")
    arr.pro=jun.cor.test.ps(items.row,items.col,items.ana,data.pro) # jun.cor.test -> jun.cor.test.ps, 2016/05/25
    arr.hc=jun.cor.test.ps(items.row,items.col,items.ana,data.hc) # jun.cor.test -> jun.cor.test.ps, 2016/05/25
    mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
    mtx.p.hc=arr.hc[,,2]
    mtx.p.pro.sig=sigmtx(mtx.p.pro); 
    mtx.rho.pro.sig=sigmtx.rho(mtx.p.pro,mtx.rho.pro)    # 2016/03/03
    sig.mtx=sigmtx(mtx.p.hc); 
    
    # output table: combine rho and p
    m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab=matrix(NA,n,2*m)
    for (p in 1:m) {
        mtx.pro.outtab[,2*p-1]=mtx.rho.pro[,p]
        mtx.pro.outtab[,2*p]  =mtx.p.pro[,p]
    }
    rownames(mtx.pro.outtab)=rownames(mtx.p.pro)
    colnames(mtx.pro.outtab)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("r","p"),m),sep=".") # rho -> r, 2016/05/25
    kable(mtx.pro.outtab) # display
    # output to file
    sink(file="tmp",append=TRUE)    # start output
    cat("\n----------------pearson---------------\n")
    print(kable(mtx.pro.outtab))
    sink()    # stop output
    
    # output table: combine rho and p (remain only significant p)
    m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab.sig=matrix(NA,n,2*m)
    for (p in 1:m) {
        mtx.pro.outtab.sig[,2*p-1]=mtx.rho.pro.sig[,p]
        mtx.pro.outtab.sig[,2*p]  =mtx.p.pro.sig[,p]
    }
    rownames(mtx.pro.outtab.sig)=rownames(mtx.p.pro)
    colnames(mtx.pro.outtab.sig)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("r","p"),m),sep=".") # rho -> r, 2016/05/25
    kable(mtx.pro.outtab.sig) # display
    # output to file
    sink(file="tmp",append=TRUE)    # start output
    cat("\n----------------pearson---------------\n")
    print(kable(mtx.pro.outtab.sig))
    sink()    # stop output
}

items.row=items.hemi
items.col=items.clinical
myfunction()

items.row=items.bil
items.col=items.clinical
myfunction()

items.row=items.comb
items.col=items.clinical
myfunction()

items.row=items.bilcomb
items.col=items.clinical
myfunction()


