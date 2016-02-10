# -------------------
# summary
# -------------------

- rANCOVA with hemi, group, ICV as factors. This scripts were revised into analyses20151203.r. 
- rANCOVA plot
- correlation unilateral
- correlation bilateral
- table for correlation
- plot for correlation
- output data for prism


# ---------------------
# to do
# ---------------------

- reedit the script for plot, deleting regions in corpus callosum exept for Central.
- ANCOVA plot script was made based on the old script of ANCOVA. 


# ------------------------------------
# rANCOVA
# ------------------------------------

datax=data.ex3.exna
field.names=regions    # corpus callosum
no.fields=length(field.names)
no.row=nrow(datax)
Vol2=c(); Diagnosis2=factor(); Region2=factor();Subject2=factor();ICV2=c()
for (i in 1:no.fields) {
    Vol2=c(Vol2,datax[[field.names[i]]])
    Region2=c(Region2,rep(field.names[i],no.row))
}
# using recycle rules
datay=data.frame(Vol2,Region2,Diagnosis2=datax$GROUP,Subject2=datax$caseid2,ICV2=datax$ICV)
data.cc=datay
datax=data.cc
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
summary(aov(Vol2~Diagnosis2*Region2+ICV2+Error(Subject2/(Region2)),data=datax))


datax=data.ex3.exna
field.names=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle")    
no.fields=length(field.names)
no.row=nrow(datax)
Vol2=c(); Diagnosis2=factor(); Region2=factor();Subject2=factor();ICV2=c()
for (i in 1:no.fields) {
    Vol2=c(Vol2,datax[[field.names[i]]])
    Region2=c(Region2,rep(field.names[i],no.row))
}
# using recycle rules
datay=data.frame(Vol2,Region2,Diagnosis2=datax$GROUP,Subject2=datax$caseid2,ICV2=datax$ICV)
data.lv=datay
datax=data.lv
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
summary(aov(Vol2~Diagnosis2*Region2+ICV2+Error(Subject2/(Region2)),data=datax))


datax=data.ex3.exna
field.names=c("Right.Inf.Lat.Vent","Left.Inf.Lat.Vent")    
no.fields=length(field.names)
no.row=nrow(datax)
Vol2=c(); Diagnosis2=factor(); Region2=factor();Subject2=factor();ICV2=c()
for (i in 1:no.fields) {
    Vol2=c(Vol2,datax[[field.names[i]]])
    Region2=c(Region2,rep(field.names[i],no.row))
}
# using recycle rules
datay=data.frame(Vol2,Region2,Diagnosis2=datax$GROUP,Subject2=datax$caseid2,ICV2=datax$ICV)
data.lvt=datay
datax=data.lvt
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
summary(aov(Vol2~Diagnosis2*Region2+ICV2+Error(Subject2/(Region2)),data=datax))


datax=data.ex3.exna
field.names=c("Right.Amygdala","Left.Amygdala")    
no.fields=length(field.names)
no.row=nrow(datax)
Vol2=c(); Diagnosis2=factor(); Region2=factor();Subject2=factor();ICV2=c()
for (i in 1:no.fields) {
    Vol2=c(Vol2,datax[[field.names[i]]])
    Region2=c(Region2,rep(field.names[i],no.row))
}
# using recycle rules
datay=data.frame(Vol2,Region2,Diagnosis2=datax$GROUP,Subject2=datax$caseid2,ICV2=datax$ICV)
data.amy=datay
datax=data.amy
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
summary(aov(Vol2~Diagnosis2*Region2+ICV2+Error(Subject2/(Region2)),data=datax))


# ANCOVA in subgroups

datax=data.ex3.exna
dep.vars=c(regions,"Right.Lateral.Ventricle","Left.Lateral.Ventricle",
    "X3rd.Ventricle",
    "Right.Inf.Lat.Vent","Left.Inf.Lat.Vent","Right.Amygdala","Left.Amygdala",
    "Right.Hippocampus","Left.Hippocampus")

exp.vars="GROUP+ICV"
jun.ans(dep.vars,exp.vars,"")

exp.vars="GROUP*SEX2+ICV"
jun.ans(dep.vars,exp.vars,"")


# ------------------------------------
# rANCOVA - plot
# ------------------------------------

# CCs, LV, LVThorn

# change the order of the levels in factor
data.cc$Regions2=factor(data.cc$Region2,regions)    # the order of the levels to be the same as in regions
data.cc$Diagnosis2=factor(data.cc$Diagnosis2,rev(levels(data.cc$Diagnosis2)))
n=length(levels(data.cc$Regions2));m=length(levels(data.cc$Diagnosis2))
data.cc$R2D2=factor(
    paste(data.cc$Region2,data.cc$Diagnosis2,sep="."),
    paste(levels(data.cc$Region2)[sort(rep(1:n,m))],levels(data.cc$Diagnosis2)[rep(1:m,n)],sep=".")
)

datax=data.cc
p1=ggplot(datax, aes(x=R2D2,y=Vol2,fill=Diagnosis2)) +
    scale_fill_manual(values=c("red","blue")) +
    geom_dotplot(binaxis="y",stackdir="center") +
    stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
#    guides(fill=FALSE) +    # don't display guide
    theme(axis.title.x=element_blank())    # don't display x-axis-label


jun.plot <- function(data.cc) {
    # change the order of the levels in factor
    data.cc$Regions2=factor(data.cc$Region2)     # the order of the leves are not changed
    data.cc$Diagnosis2=factor(data.cc$Diagnosis2,rev(levels(data.cc$Diagnosis2)))    # lever order to be PRO, HVPRO
    n=length(levels(data.cc$Regions2));m=length(levels(data.cc$Diagnosis2))
    data.cc$R2D2=factor(
        paste(data.cc$Region2,data.cc$Diagnosis2,sep="."),
        paste(levels(data.cc$Region2)[sort(rep(1:n,m))],levels(data.cc$Diagnosis2)[rep(1:m,n)],sep=".")
    )
    
    datax=data.cc
    p1=ggplot(datax, aes(x=R2D2,y=Vol2,fill=Diagnosis2)) +
        scale_fill_manual(values=c("red","blue")) +
        geom_dotplot(binaxis="y",stackdir="center") +
        stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
        guides(fill=FALSE) +    # don't display guide
        theme(axis.title.x=element_blank())    # don't display x-axis-label
    p1
}
p2=jun.plot(data.lv)
p3=jun.plot(data.lvt)
p4=jun.plot(data.amy)

# Move to a new page
grid.newpage()
# Create layout : nrow = 2, ncol = 3
pushViewport(viewport(layout = grid.layout(2, 3)))
# A helper function to define a region on the layout
define_region <- function(row, col){
  viewport(layout.pos.row = row, layout.pos.col = col)
} 
print(p1,vp=define_region(1,1:3))
print(p2,vp=define_region(2,1))
print(p3,vp=define_region(2,2))
print(p4,vp=define_region(2,3))


# ------------------------------------
# correlation
# ------------------------------------

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")


# correlatinon between volumes

items.row=c(regions4,"r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus") # relative volume
items.col=c(regions4,"r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus") # relative volume
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
mtx.p.hc=arr.hc[,,2]; mtx.rho.hc=arr.hc[,,1]
#sig.mtx=sigmtx(mtx.p.pro); #kable(sig.mtx)
mtx.p.pro.sig=sigmtx(mtx.p.pro); #kable(mtx.p.pro.sig)
#sig.mtx=sigmtx(mtx.p.hc); #kable(sig.mtx)
mtx.p.hc.pro.sig=sigmtx(mtx.p.hc)


# correlatinon between volumes, selected items, 2016/01/06

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
#sig.mtx=sigmtx(mtx.p.pro); #kable(sig.mtx)
mtx.p.pro.sig=sigmtx(mtx.p.pro); #kable(mtx.p.pro.sig)
#sig.mtx=sigmtx(mtx.p.hc); #kable(sig.mtx)
mtx.p.hc.pro.sig=sigmtx(mtx.p.hc)


# correlatinon between volumes, selected items, bilateral, 2016/01/06

items.row=c("r.CC_Central","r.Bil.Lateral.Ventricle",
    "r.Bil.Inf.Lat.Vent","r.Bil.Amygdala","r.Bil.Hippocampus") # relative volume
items.col=c("r.CC_Central","r.Bil.Lateral.Ventricle",
    "r.Bil.Inf.Lat.Vent","r.Bil.Amygdala","r.Bil.Hippocampus") # relative volume
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
mtx.p.hc=arr.hc[,,2]; mtx.rho.hc=arr.hc[,,1]
#sig.mtx=sigmtx(mtx.p.pro); #kable(sig.mtx)
mtx.p.pro.sig=sigmtx(mtx.p.pro); #kable(mtx.p.pro.sig)
#sig.mtx=sigmtx(mtx.p.hc); #kable(sig.mtx)
mtx.p.hc.pro.sig=sigmtx(mtx.p.hc)


# correlation between volumes and clinical scores

items.row=c(regions4,"r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus") # relative volume
items.col=c("SOCFXC","ROLEFX","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
mtx.p.hc=arr.hc[,,2]
#sig.mtx=sigmtx(mtx.p.pro); kable(sig.mtx)
mtx.p.pro.sig=sigmtx(mtx.p.pro); #kable(mtx.p.pro.sig)
sig.mtx=sigmtx(mtx.p.hc); #kable(sig.mtx)


# correlation between volumes and clinical scores, selected items, 2016/01/06

items.row=c("r.CC_Central","r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle",
    "r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus") # relative volume
items.col=c("GAFC","SIPTOTEV","SINTOTEV")
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
mtx.p.hc=arr.hc[,,2]
#sig.mtx=sigmtx(mtx.p.pro); kable(sig.mtx)
mtx.p.pro.sig=sigmtx(mtx.p.pro); #kable(mtx.p.pro.sig)
sig.mtx=sigmtx(mtx.p.hc); #kable(sig.mtx)


# correlation between volumes and clinical scores, selected items, bilateral, 2016/01/06

items.row=c("r.CC_Central","r.Bil.Lateral.Ventricle",
    "r.Bil.Inf.Lat.Vent","r.Bil.Amygdala","r.Bil.Hippocampus") # relative volume
items.col=c("GAFC","SIPTOTEV","SINTOTEV")
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]; mtx.rho.pro=arr.pro[,,1]
mtx.p.hc=arr.hc[,,2]
#sig.mtx=sigmtx(mtx.p.pro); kable(sig.mtx)
mtx.p.pro.sig=sigmtx(mtx.p.pro); #kable(mtx.p.pro.sig)
sig.mtx=sigmtx(mtx.p.hc); #kable(sig.mtx)


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
    mtx.pro.outtab.sig[,2*p-1]=mtx.rho.pro[,p]
    mtx.pro.outtab.sig[,2*p]  =mtx.p.pro.sig[,p]
}
rownames(mtx.pro.outtab.sig)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab.sig)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab.sig)


# output to file

sink(file="tmp",append=TRUE)    # start output
print(kable(mtx.pro.outtab.sig))
sink()    # stop output


# ------------------------------------
# correlation - plot
# ------------------------------------

datax=data.pro
p1=ggplot(datax, aes(x=ROLEFX, y=r.Left.Lateral.Ventricle)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p2=ggplot(datax, aes(x=ROLEFX, y=r.Right.Inf.Lat.Vent)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p3=ggplot(datax, aes(x=SINTOTEV, y=Right.Lateral.Ventricle)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p4=ggplot(datax, aes(x=SINTOTEV, y=Left.Lateral.Ventricle)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p5=ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p6=ggplot(datax, aes(x=SIDTOTEV, y=r.CC_Anterior)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p7=ggplot(datax, aes(x=SIDTOTEV, y=r.CC_Mid_Anterior)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p8=ggplot(datax, aes(x=SIDTOTEV, y=r.CC_Posterior)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p9=ggplot(datax, aes(x=SIDTOTEV, y=r.X3rd.Ventricle)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, main = "Correlation")


# correlateion plot, selected, 2016/01/06, 

datax=data.pro
p1=ggplot(datax, aes(x=SINTOTEV, y=r.Right.Lateral.Ventricle)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p2=ggplot(datax, aes(x=SINTOTEV, y=r.Left.Lateral.Ventricle)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
p3=ggplot(datax, aes(x=SIPTOTEV, y=r.Left.Hippocampus)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
grid.arrange(p1, p2, p3, main = "Correlation")


# --------------------------------
# output data for prism 2016/02/01
# --------------------------------

- I would like to extract data for prism.
- One problem is it is difficult to handle different record number in each field.


# using list and write.csv

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")

data4prism=list(
    data.pro[["r.CC_Central"]],data.hc[["r.CC_Central"]],
    data.pro[["r.Right.Lateral.Ventricle"]],data.hc[["r.Right.Lateral.Ventricle"]]
)

write.csv(matrix(data4prism),file="tmp")

# write.csv can not use col.names and append.
# This output a file ... "name", c(233, 455, 324, ...) in each line
# But matrix() deletes field names. ... 
# We can delete "c(" and ")" then output to a csv file by shell commands. 
# cat tmp | tr -d 'c(' | tr -d ')' > tmpto.csv
# We can transpose row-column by OpenOfficeCalc


# using write.table for exapmles (the below is with for-loop)

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")

cat("pro.r.CC_Central",file="tmp.csv.rownames",append=TRUE)
cat("\n",file="tmp.csv.rownames",append=TRUE)
write.table(t(data.pro[["r.CC_Central"]]),file="tmp.csv",col.names=FALSE,append=TRUE,sep=",")
cat("hc.r.CC_Central",file="tmp.csv.rownames",append=TRUE)
cat("\n",file="tmp.csv.rownames",append=TRUE)
write.table(t(data.hc[["r.CC_Central"]]),file="tmp.csv",col.names=FALSE,append=TRUE,sep=",")
cat("pro.r.Right.Lateral.Ventricle",file="tmp.csv.rownames",append=TRUE)
cat("\n",file="tmp.csv.rownames",append=TRUE)
write.table(t(data.pro[["r.Right.Lateral.Ventricle"]]),file="tmp.csv",col.names=FALSE,append=TRUE,sep=",")
cat("hc.r.Right.Lateral.Ventricle",file="tmp.csv.rownames",append=TRUE)
cat("\n",file="tmp.csv.rownames",append=TRUE)
write.table(t(data.hc[["r.Right.Lateral.Ventricle"]]),file="tmp.csv",col.names=FALSE,append=TRUE,sep=",")

# In terminlal, these files are combined. 
# paste -d"," tmp.csv.rownames tmp.csv > tmp2.csv
# We can transpose row-column by OpenOfficeCalc


# using write.table with for-loop

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")

rownamesfile="tmp.csv.rownames"
csvfile="tmp.csv"
items=c("r.CC_Central","r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle",
    "r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus","GAFC","SIPTOTEV","SINTOTEV")
for (arg in items) {
    cat("pro.",file=rownamesfile,append=TRUE)
    cat(arg,file=rownamesfile,append=TRUE)
    cat("\n",file=rownamesfile,append=TRUE)
    write.table(t(data.pro[[arg]]),file=csvfile,col.names=FALSE,append=TRUE,sep=",")
    cat("hc.",file=rownamesfile,append=TRUE)
    cat(arg,file=rownamesfile,append=TRUE)
    cat("\n",file=rownamesfile,append=TRUE)
    write.table(t(data.hc[[arg]]),file=csvfile,col.names=FALSE,append=TRUE,sep=",")
}

# In terminlal, these files are combined. 
# paste -d"," tmp.csv.rownames tmp.csv > tmp2.csv
# We can transpose row-column by OpenOfficeCalc




