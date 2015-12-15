# --------------------------------------------
# rANCOVA
# --------------------------------------------

# environment
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()

# functions
jun.stack <- function(fieldnames1,fieldnames2){
    datax.stack=stack(datax[fieldnames1])
    datax.stack[fieldnames2]=datax[fieldnames2]
    datax.stack
}

# analyses
datax=data.ex3.exna
fieldnames=regions
data.cc=jun.stack(fieldnames,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.cc))

field.names=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle")  
data.lv=jun.stack(fieldnames,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.lv))

field.names=c("Right.Inf.Lat.Vent","Left.Inf.Lat.Vent") 
data.lvt=jun.stack(fieldnames,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.lvt))

field.names=c("Right.Amygdala","Left.Amygdala")   
data.amy=jun.stack(fieldnames,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.amy))

field.names=c("Right.Hippocampus","Left.Hippocampus")   
data.amy=jun.stack(fieldnames,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.amy))

# analyses in subgroup

datax=data.ex3.exna
dep.vars=
    c(regions,
    "Right.Lateral.Ventricle","Left.Lateral.Ventricle",
    "X3rd.Venricle",
    "Right.Inf.Lat.Vent","Left.Inf.Lat.Vent",
    "Right.Amygdala","Left.Amygdala",
    "Right.Hippocampus","Left.Hippocampus")

exp.vars="GROUP+ICV"
jun.ans(dep.vars,exp.vars,"")

exp.vars="GROUP*SEX2+ICV"
jun.ans(dep.vars,exp.vars,"")





# --------------------------------------------
# rANCOVA - plots
# --------------------------------------------

