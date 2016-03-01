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
data.amy=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.amy))


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
