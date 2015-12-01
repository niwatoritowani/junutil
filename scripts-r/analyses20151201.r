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


# ------------------------------------
# rANCOVA - plot
# ------------------------------------

# CCs, LV, LVThorn
# todo: the order of Region2Diagnosis2, handling factor-character during paste()
# todo: add amygdala
# 

datax=data.cc
datax$Region2Diagnosis2=paste(datax$Region2,dataxDiagnosis2,sep=".")
p4=ggplot(datax, aes(x=Region2Diagnosis2,y=Vol2,fill=Diagnosis2)) +
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



# ------------------------------------
# correlation
# ------------------------------------

# todo add amygdala

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")

items.row=c(parameters1,parameters2,parameters_si)
items.col=c(regions4,"r.Left.Inf.Lat.Vent","r.Right.Inf.Lat.Vent") # relative volume
items.ana=c("estimate","p.value")
arr.pro=jun.cor.test(items.row,items.col,items.ana,data.pro)
arr.hc=jun.cor.test(items.row,items.col,items.ana,data.hc)
mtx.p.pro=arr.pro[,,2]
mtx.p.hc=arr.hc[,,2]
sig.mtx=sigmtx(mtx.p.pro); kable(sig.mtx)
sig.mtx=sigmtx(mtx.p.hc); kable(sig.mtx)


# ------------------------------------
# correlation - plot
# ------------------------------------

ggplot(datax, aes(x=SINTOTEV, y=Bil.Lateral.Ventricle)) + 
    geom_point() + stat_smooth(method=lm, se=FALSE)
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, main = "Volumes of corpus callosum")
