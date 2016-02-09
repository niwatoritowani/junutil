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


# # functions
# jun.stack <- function(fieldnames1,fieldnames2){
#     datax.stack=stack(datax[fieldnames1])
#     datax.stack[fieldnames2]=datax[fieldnames2]
#     datax.stack
# }


# analyses
datax=data.ex3.exna

field.names=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle")  
data.lv=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.lv))

field.names=c("r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent") 
data.lvt=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUPError(caseid2/ind),data=data.lvt))

field.names=c("r.Right.Amygdala","r.Left.Amygdala")   
data.amy=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUPError(caseid2/ind),data=data.amy))

field.names=c("r.Right.Hippocampus","r.Left.Hippocampus")   
data.amy=jun.stack(field.names,c("caseid2","GROUP"))
summary(aov(values~ind*GROUP+Error(caseid2/ind),data=data.amy))


# ---------------------------------------------------------
# ANOVA with r.bil.volume ~ group (ISFactor)
# ---------------------------------------------------------

datax=data.ex3.exna
dep.vars=
    c("r.CC_Central",
    "r.Bil.Lateral.Ventricle",
    "r.Bil.Inf.Lat.Vent",
    "r.Bil.Amygdala",
    "r.Bil.Hippocampus")
exp.vars="GROUP"
output=jun.ans2(dep.vars,exp.vars,"")
output

