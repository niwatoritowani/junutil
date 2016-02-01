# --------------------------
# summary
# --------------------------

- correlation
- FDR correction
- general linear model

# ----------------------------
# correlation
# ----------------------------

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")



# correlation between r.LV and r.CC

items.row=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle","r.Bil.Lateral.Ventricle","r.X3rd.Ventricle","r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent")
items.col=c("r.CC_Anterior", "r.CC_Mid_Anterior","r.CC_Central","r.CC_Mid_Posterior","r.CC_Posterior")      # relative volumes
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]
mtx.p.hc=arr.hc[,,2]
sig.mtx=sigmtx(mtx.p.pro); kable(sig.mtx)
sig.mtx=sigmtx(mtx.p.hc); kable(sig.mtx)

# FDR-corrected-p

mtx.p.pro.adjust=matrix(p.adjust(mtx.p.pro,method="fdr"),nrow(mtx.p.pro))
rownames(mtx.p.pro.adjust)=rownames(mtx.p.pro)
colnames(mtx.p.pro.adjust)=colnames(mtx.p.pro)
kable(mtx.p.pro.adjust)

# correlation between clinical and r.volume

items.row=c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
items.col=c(regions4,regions5r)      # relative volumes
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]
mtx.p.hc=arr.hc[,,2]
sig.mtx=sigmtx(mtx.p.pro); kable(sig.mtx)
sig.mtx=sigmtx(mtx.p.hc); kable(sig.mtx)

# plot
plot(data.pro$r.CC_Anterior,data.pro$SIDTOTEV)
plot(data.pro$r.CC_Posterior,data.pro$SIDTOTEV)

# FDR-corrected-p in selected items

mtx.p.pro.sub=mtx.p.pro[,1:5]
mtx.p.pro.sub.adjust=matrix(p.adjust(mtx.p.pro.sub,method="fdr"),nrow(mtx.p.pro.sub))
rownames(mtx.p.pro.sub.adjust)=rownames(mtx.p.pro.sub)
colnames(mtx.p.pro.sub.adjust)=colnames(mtx.p.pro.sub)
kable(mtx.p.pro.sub.adjust)

# correlation between clinical and abslute-volume
# It is better to use relative volume

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")
items.row=c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
items.col=c(regions,regions2,regions5)      # absolute volumes
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]
mtx.p.hc=arr.hc[,,2]
sig.mtx=sigmtx(mtx.p.pro); kable(sig.mtx)
sig.mtx=sigmtx(mtx.p.hc); kable(sig.mtx)

# analyses with general linear model
# This is not prominet than correlation analyses
# original function jun.lm 

jun.lm <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    options(contrasts =c("contr.treatment","contr.poly")) # default contrast
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
    print(s[["call"]]);     # show model
    print(s[["coefficients"]][,c(1,4)])
#    print(anova(r))    # for anova
}
jun.lms=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {jun.lm(item[j],datacol[i],arg3)}}
}

datax=data.pro
arg1=c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
arg2=c(regions,regions2,regions5)
arg3="+ICV"
jun.lms(arg1,arg2,arg3)

# change contrast in jun.lm

jun.lm <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
    print(s[["call"]]);     # show model
    print(s[["coefficients"]][,c(1,4)])
#    print(anova(r))    # for anova
}
jun.lms=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {jun.lm(item[j],datacol[i],arg3)}}
}

datax=data.pro
arg1=c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
arg2=c(regions,regions2,regions5)
arg3="+ICV"
jun.lms(arg1,arg2,arg3)

# the results are same

# change output

# change contrast in jun.lm

jun.lmp <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
#    cat("---------------------------\n")
    cat(s[["coefficients"]][2,4],"  : ") # the-second-factor p-value
    cat(arg2,"\n");     # show model
}
jun.lmps=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {jun.lmp(item[j],datacol[i],arg3)}}
}

datax=data.pro
arg1=c("SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
arg2=c(regions,regions2,regions5)
arg3="+ICV"
jun.lmps(arg1,arg2,arg3)

# results: 0.006774931   : CC_Posterior

arg3="+SEX+ICV"
jun.lmps(arg1,arg2,arg3)

