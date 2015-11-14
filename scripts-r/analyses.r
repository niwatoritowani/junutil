# -------------------------------
# ANCOVA
# ------------------------------

datax=data.main
models=c("GROUP+ICV","GROUP+SEX+ICV","GROUP+READSTD+ICV",
    "GROUP*SEX+ICV",
    "GROUP+SEX+AGE+ICV","GROUP+AGE+ICV",
    "GROUP","GROUP+SEX","GROUP+AGE","GROUP+AGE+SEX",
    "GROUP+WASIIQ+ICV","GROUP+WASIIQ",
    "GROUP+READSTD","GROUP+READSTD+ICV","GROUP+READSTD+SEX+ICV","GROUP+SEX+READSTD+ICV","GROUP*SEX+READSTD+ICV",
    "GROUP+READSTD+AGE+ICV","GROUP+READSTD+SEX+AGE+ICV"
)

items=c(regions,regions2,"Left.Inf.Lat.Vent","Right.Inf.Lat.Vent")
pvaluesmatrix=mkpvalmtx(datax,items,models)
knitr::kable(pvaluesmatrix)

items=c("r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent")
pvaluesmatrix=mkpvalmtx(datax,items,models)
knitr::kable(pvaluesmatrix)

# ---------------------------------
# non-parametric test
# ---------------------------------

datax=data.main

# wilcox_text(variable1~factor1),distribution="exact")
items=c(regions2,regions2x)
factors="GROUP"
jun.wilcox_tests(items,factors)

# brunner.munzel.test(subset(datax,GROUP=="PRO")$volume, subset(datax,GROUP=="HVPRO")$volume)
items=c(regions2,regions2x)
jun.prunner.munzel.tests(items)

# ----------------------------------
# exclude 4 cases
# ----------------------------------

datax=data.main
datax=subset(datax,caseid2!="321100112" & caseid2!="321100125" & caseid2!="321400280" & caseid2!="321400081")
data.ex4=datax

pvaluesmatrix=mkpvalmtx(data.ex4,items,models)
knitr::kable(pvaluesmatrix)

# -----------------
# delete NA
# -----------------

data.main.exna=subset(data.main,!is.na(SEX))
data.main.exna=subset(data.main1,!is.na(CC_Mid_Anterior))

# ------------------------
# repeated-measures-ANCOVA
# ------------------------


datax=data.main.exna
field.names=regions
no.fields=length(field.names)
no.row=nrow(datax)
Vol2=c(); Diagnosis2=factor(); Region2=factor();Subject2=factor();ICV2=c()
for (i in 1:no.fields) {
    Vol2=c(Vol2,datax[[field.names[i]]])
    Diagnosis2=c(Diagnosis2,as.character(datax[["GROUP"]]))
    Region2=c(Region2,rep(field.names[i],no.row))
    Subject2=c(Subject2,datax[["caseid2"]])
    ICV2=c(ICV2,datax[["ICV"]])
}
datay=data.frame(Vol2,Diagnosis2,Region2,Subject2,ICV2)
data.ran=datay
datax=data.ran
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
summary(aov(Vol2~Diagnosis2*Region2+Error(Subject2/(Region2)),data=datax))
summary(aov(Vol2~Diagnosis2*Region2+ICV2+Error(Subject2/(Region2)),data=datax))

# ------------------------------
# repeated-measures-ANCOVA 2
# ------------------------------


datax=data.main.exna
field.names=regions
no.fields=length(field.names)
no.row=nrow(datax)
Vol2=c(); Diagnosis2=factor(); Region2=factor();Subject2=factor();ICV2=c()
for (i in 1:no.fields) {
    Vol2=c(Vol2,datax[[field.names[i]]])
    Region2=c(Region2,rep(field.names[i],no.row))
}
# using recycle rules
datay=data.frame(Vol2,Region2,Diagnosis2=datax$GROUP,Subject2=datax$caseid2,ICV2=datax$ICV)
data.ran=datay
datax=data.ran
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
summary(aov(Vol2~Diagnosis2*Region2+Error(Subject2/(Region2)),data=datax))
summary(aov(Vol2~Diagnosis2*Region2+ICV2+Error(Subject2/(Region2)),data=datax))


# ----------------------------
# correlation
# ----------------------------

datax=data.main.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")

items.row=c(parameters1,parameters2,parameters_si)
items.col=c(regions,regions2,"Left.Inf.Lat.Vent","Right.Inf.Lat.Vent")      # absolute volumes
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]
mtx.p.hc=arr.hc[,,2]
sig.mtx=sigmtx(mtx.p.pro); kable(sig.mtx)
sig.mtx=sigmtx(mtx.p.hc); kable(sig.mtx)
#jun.heatmap(t(sig.mtx))
#subset.p=extractsig(sig.mtx); kable(subset.p)
#jun.heatmap(t(subset.p))
#knitr::kable(cbind(subset,c(1:nrow(subset.p))))

items.row=c(parameters1,parameters2,parameters_si)
items.col=c(regions4,"r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent")
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]
mtx.p.hc=arr.hc[,,2]
sig.mtx=sigmtx(mtx.p.pro); kable(sig.mtx)
sig.mtx=sigmtx(mtx.p.hc); kable(sig.mtx)
#jun.heatmap(t(sig.mtx))
#subset.p=extractsig(sig.mtx); kable(subset.p)
#jun.heatmap(t(subset.p))
#knitr::kable(cbind(subset,c(1:nrow(subset.p))))









