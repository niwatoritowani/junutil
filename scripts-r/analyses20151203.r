# --------------------------------------------
# rANCOVA
# --------------------------------------------

# environment
options(contrasts = c("contr.sum", "contr.sum")) # for Anova()

# functions
stack.jun <- function(fieldnames1,fieldnames2){
    datax.stack=stack(datax[fieldnames1])
    datax.stack[fieldnames2]=datax[fieldnames2]
    datax.stack
}

# analyses
datax=data.ex3.exna
fieldnames=regions
data.cc=stack.jun(fieldnames,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind,data=data.cc))

field.names=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle")  
data.lv=stack.jun(fieldnames,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind,data=data.lv))

field.names=c("Right.Inf.Lat.Vent","Left.Inf.Lat.Vent") 
data.lvt=stack.jun(fieldnames,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind,data=data.lvt))

field.names=c("Right.Amygdala","Left.Amygdala")   
data.amy=stack.jun(fieldnames,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind,data=data.amy))

# --------------------------------------------
# rANCOVA - plots
# --------------------------------------------

