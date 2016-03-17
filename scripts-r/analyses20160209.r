# --------
# outline
# --------

# - rANOVA with r.volume ~ group (BSFactor) * hemi (WSFactor)
# - ANOVA with r.bil.volume ~ group (ISFactor)


# ---------------------------------------------------------
# rANOVA with r.volume ~ group (ISFactor) * hemi (WSFactor)
# ---------------------------------------------------------


# environment
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()


# analyses
datax=data.ex3.exna

summary(aov(r.CC_Central~GROUP,data=datax))

field.names=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle")  
data.lv=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.lv))

field.names=c("r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent") 
data.lvt=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.lvt))

field.names=c("r.Right.Amygdala","r.Left.Amygdala")   
data.amy=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.amy))

field.names=c("r.Right.Hippocampus","r.Left.Hippocampus")   
data.hip=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.amy))


# ------------------------------------
# effect size 2016/03/10 failed
# ------------------------------------


datax=data.ex3.exna

# CCC
summary(aov(r.CC_Central~GROUP,data=datax))
Anova(lm(r.CC_Central~GROUP,data=datax))
Anova(lm(r.CC_Central~GROUP,data=datax, type=1))
Anova(lm(r.CC_Central~GROUP,data=datax, type=2))
Anova(lm(r.CC_Central~GROUP,data=datax, type=3))
# partial eta square
etasq(lm(r.CC_Central~GROUP,data=datax))
etasq(Anova(lm(r.CC_Central~GROUP,data=datax)))                # does not work
etasq(Anova(lm(r.CC_Central~GROUP,data=datax)), anova=TRUE)    # does not work

# LV
field.names=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle")  
data.lv=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.lv))
anova.lv=aov(values~ind*GROUP+Error(caseid2/ind),data=data.lv)
Anova(lm(values~ind*GROUP+Error(caseid2/ind),data=data.lv))            # does not work
Anova(lm(values~ind*GROUP+Error(caseid2/ind),data=data.lv), type=1)    # does not work
etasq(lm(values~ind*GROUP+Error(caseid2/ind),data=data.lv))            # does not work


# TH
field.names=c("r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent") 
data.lvt=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.lvt))

field.names=c("r.Right.Amygdala","r.Left.Amygdala")   
data.amy=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.amy))

field.names=c("r.Right.Hippocampus","r.Left.Hippocampus")   
data.amy=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.amy))


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

#library(ez)
#ezANOVA(data.lvt,dv=values,wid=caseid2,within=ind,between=GROUP,type=3,detailed=TRUE,return_aov=TRUE)
ezANOVA(datax, dv=r.CC_Central,wid=caseid2,between=GROUP,type=3)
ezANOVA(data.lv, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.lvt, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.amy, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)
ezANOVA(data.hip, dv=values,wid=caseid2,within=ind,between=GROUP,type=3)


# ---------------------------------------------------------
# ANOVA with r.bil.volume ~ group
# ---------------------------------------------------------

datax=data.ex3.exna
dep.vars=
    c("r.CC_Central",
    "r.Bil.Lateral.Ventricle",
    "r.Bil.Inf.Lat.Vent",
    "r.Bil.Amygdala",
    "r.Bil.Hippocampus")
exp.vars="GROUP"
jun.ans2(dep.vars,exp.vars,"")    # output table


# ---------------------------------------------------------
# ANOVA with r.hemi.volume ~ group
# ---------------------------------------------------------

datax=data.ex3.exna
dep.vars=
    c("r.CC_Central",
    "r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle",
    "r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent",
    "r.Right.Amygdala","r.Left.Amygdala",
    "r.Right.Hippocampus","r.Left.Hippocampus")
exp.vars="GROUP"
jun.ans2(dep.vars,exp.vars,"")    # output table

