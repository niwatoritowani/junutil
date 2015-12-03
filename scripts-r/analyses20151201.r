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


# 

datax=data.ex3.exna
dep.vars=c(regions,"Right.Lateral.Ventricle","Left.Lateral.Ventricle",
    "X3rd.Ventricle",
    "Right.Inf.Lat.Vent","Left.Inf.Lat.Vent","Right.Amygdala","Left.Amygdala")

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

# todo add amygdala

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")

items.row=c(regions4,"r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala") # relative volume
items.col=c(regions4,"r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala") # relative volume
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]
mtx.p.hc=arr.hc[,,2]
sig.mtx=sigmtx(mtx.p.pro); #kable(sig.mtx)
sig.mtx
sig.mtx=sigmtx(mtx.p.hc); #kable(sig.mtx)

items.row=c(regions4,"r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent","r.Right.Amygdala","r.Left.Amygdala") # relative volume
items.col=c("SOCFXC","ROLEFX","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV")
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

# output table: combine rho and p (remain only significant p)

m=ncol(mtx.p.pro);n=nrow(mtx.p.pro);mtx.pro.outtab.sig=matrix(NA,n,2*m)
for (p in 1:m) {
    mtx.pro.outtab.sig[,2*p-1]=mtx.rho.pro[,p]
    mtx.pro.outtab.sig[,2*p]  =mtx.p.pro.sig[,p]
}
rownames(mtx.pro.outtab.sig)=rownames(mtx.p.pro)
colnames(mtx.pro.outtab.sig)=paste(colnames(mtx.p.pro)[sort(rep(1:m,2))],rep(c("rho","p"),m),sep=".")
kable(mtx.pro.outtab.sig)

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

