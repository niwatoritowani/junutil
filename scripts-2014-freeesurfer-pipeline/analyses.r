# analyses

# If I can, 
# volume=hemisphere+GROUP+ICV

# reconstruct datay into datay2 for rANOVA

datax=datay
field.names=regions
no.fields=length(field.names)
no.row=nrow(datax)
Vol2=c(); Diagnosis2=factor();Time2=factor(); Region2=factor();Subject2=factor();ICV2=c()
for (i in 1:no.fields) {
    Vol2=c(Vol2,datax[[field.names[i]]])
    Diagnosis2=c(Diagnosis2,datax[["Diagnosis"]])
    Time2=c(Time2,datax[["Time"]])
    Region2=c(Region2,rep(field.names[i],no.row))
    Subject2=c(Subject2,datax[["subject"]])
    ICV2=c(ICV2,datax[["ICV"]])
}
datay2=data.frame(Vol2,Diagnosis2,Time2,Region2)
datax=datay2

# rANOVA : b-sub Diagnosis, w-sub Time,Region, cov ICV

options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
#r=lm(Vol2~Diagnosis2*Time2*Region2+Error(Subject2/Time2*Reion2),data=datax)
#Anova(r,type=3)

# we can not use Error() in lm()

summary(aov(Vol2~Diagnosis2*Time2*Region2+Error(Subject2/(Time2*Region2)),data=datax))
summary(aov(Vol2~Diagnosis2*Time2*Region2+ICV2+Error(Subject2/(Time2*Region2)),data=datax))

# Time2 are only 4 cases
datax=subset(datay,Time2==1)
summary(aov(Vol2~Diagnosis2*Region2+Error(Subject2/(Region2)),data=datax))
summary(aov(Vol2~Diagnosis2*Region2+ICV2+Error(Subject2/(Region2)),data=datax))


# subgroup analyses
# separate group by region but with w-sub-factor Time, cov ICV

datax=datay
item=regions
#datacol=c("Diagnosis*Time+ICV+Error(Scan.Other.Sub../(Time))","Diagnosis+Time+ICV+ERROR(Scan.Other.Sub../(Time))")
datacol=c("Diagnosis*Time+ICV+Error(Scan.Other.Sub../(Time))")
jun.rans(item,datacol,"")

# This above does not work 

summary(aov(CC_Anterior~Diagnosis*Time+ICV+Error((Scan.Other.Sub..)/(Time)),data=datax))

# Above resulted in error message
# #    In aov(CC_Anterior ~ Diagnosis * Time + ICV + Error((Scan.Other.Sub..)/(Time)),  :
# #     Error() model is singular

# Time2 are only 4 cases

# separeta group by region and time : b-sub Diagnosi, cov ICV

datax=datay
datay.t1=subset(datax,Time==1)
datay.t2=subset(datax,Time==2)
item=regions
datacol=c("Diagnosis+ICV")
datax=jun.ans(item,datacol,"")
datax=datay.t1;jun.ans(item,datacol,"")
datax=datay.t2;jun.ans(item,datacol,"")

datax=datay.t1;jun.ans(item,"Diagnosis*ICV","")
datax=datay.t1;jun.rans(item,"Diagnosis*ICV","")


# reconstruct datay into datay2 for rANOVA : add hemi as a factor

datax=datay
field.names=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle")
no.fields=length(field.names)
no.row=nrow(datax)
Vol3=c(); Diagnosis3=factor();Time3=factor(); Region3=factor();Subject3=factor();ICV3=c()
for (i in 1:no.fields) {
    Vol3=c(Vol3,datax[[field.names[i]]])
    Diagnosis3=c(Diagnosis3,datax[["Diagnosis"]])
    Time3=c(Time3,datax[["Time"]])
    Region3=c(Region3,rep(field.names[i],no.row))
    Subject3=c(Subject3,datax[["subject"]])
    ICV3=c(ICV3,datax[["ICV"]])
}
datay3=data.frame(Vol3,Diagnosis3,Time3,Region3)
datax=datay3

# rANOVA

options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
summary(aov(Vol3~Diagnosis3*Time3*Region3+Error(Subject3/(Time3*Region3)),data=datax))
summary(aov(Vol3~Diagnosis3*Time3*Region3+ICV3+Error(Subject3/(Time3*Region3)),data=datax))

# Time2 are only 4 cases
datax=subset(datay,Time2==1)
summary(aov(Vol3~Diagnosis3*Region3+Error(Subject3/(Region3)),data=datax))
summary(aov(Vol3~Diagnosis3*Region3+ICV3+Error(Subject3/(Region3)),data=datax))


datax=datay
datay.t1=subset(datax,Time==1)
datay.t2=subset(datax,Time==2)
item=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle")
datacol=c("Diagnosis+ICV")
datax=datay.t1;jun.ans(item,datacol,"")
datax=datay.t2;jun.ans(item,datacol,"")

datax=datay.t1;jun.ans(item,"Diagnosis*ICV","")
datax=datay.t1;jun.rans(item,"Diagnosis*ICV","")


