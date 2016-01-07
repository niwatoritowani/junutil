# -----------------------------------------------
# to do
# -----------------------------------------------

- function jun.stack creates a data.frame. Original field names are in the column named ind. 
- We may have to change the "ind" into for example "Regins2". 2016/01/06. 

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
field.names=regions
data.cc=jun.stack(field.names,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.cc))

field.names=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle")  
data.lv=jun.stack(field.names,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.lv))

field.names=c("Right.Inf.Lat.Vent","Left.Inf.Lat.Vent") 
data.lvt=jun.stack(field.names,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.lvt))

field.names=c("Right.Amygdala","Left.Amygdala")   
data.amy=jun.stack(field.names,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.amy))

field.names=c("Right.Hippocampus","Left.Hippocampus")   
data.amy=jun.stack(field.names,c("caseid2","GROUP","ICV"))
summary(aov(values~ind*GROUP+ICV+Error(caseid2/ind),data=data.amy))

# analyses in subgroup

datax=data.ex3.exna
dep.vars=
    c(regions,
    "Right.Lateral.Ventricle","Left.Lateral.Ventricle",
    "X3rd.Ventricle",
    "Right.Inf.Lat.Vent","Left.Inf.Lat.Vent",
    "Right.Amygdala","Left.Amygdala",
    "Right.Hippocampus","Left.Hippocampus")

exp.vars="GROUP+ICV"
jun.ans(dep.vars,exp.vars,"")

exp.vars="GROUP*SEX2+ICV"
jun.ans(dep.vars,exp.vars,"")

# analyses in subgroup, selected regions, 2016/01/06

datax=data.ex3.exna
dep.vars=
    c("CC_Central",
    "Right.Lateral.Ventricle","Left.Lateral.Ventricle",
    "Right.Inf.Lat.Vent","Left.Inf.Lat.Vent",
    "Right.Amygdala","Left.Amygdala",
    "Right.Hippocampus","Left.Hippocampus")

exp.vars="GROUP+ICV"
jun.ans(dep.vars,exp.vars,"")

# update functions jun.ans, 2016/01/06

# function jun.an, jun.ans. This is described in functions.r. 

jun.an <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
    print(s[["call"]]);    # show model
#    print(s[["coefficients"]][,c(1,4)])
    print(Anova(r,type=3))    # show anova type3
}
jun.ans=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {jun.an(item[j],datacol[i],arg3)}}
}

# edit function. This is not described in functions.r. 

jun.an2 <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
#    cat("---------------------------\n")
#    print(s[["call"]]);    # show model
#    print(s[["coefficients"]][,c(1,4)])
    an=Anova(r,type=3)    # substitute anova type3
    F.p=data.frame(region=arg1,F=an["F value"][2,],p=an["Pr(>F)"][2,])
    F.p
}
jun.ans2=function(item,datacol,arg3){
    m=length(item); n=length(datacol); output=data.frame();
    for ( j in 1:m) {for ( i in 1:n ) {
        output=rbind(output,jun.an2(item[j],datacol[i],arg3))}
    }
    output
}

# run function

datax=data.ex3.exna
dep.vars=
    c("CC_Central",
    "Right.Lateral.Ventricle","Left.Lateral.Ventricle",
    "Right.Inf.Lat.Vent","Left.Inf.Lat.Vent",
    "Right.Amygdala","Left.Amygdala",
    "Right.Hippocampus","Left.Hippocampus")

exp.vars="GROUP+ICV"
output=jun.ans2(dep.vars,exp.vars,"")
output

exp.vars="GROUP*SEX2+ICV"
output=jun.ans2(dep.vars,exp.vars,"")
output

# bilateral

datax=data.ex3.exna
dep.vars=
    c("CC_Central",
    "Bil.Lateral.Ventricle",
    "Bil.Inf.Lat.Vent",
    "Bil.Amygdala",
    "Bil.Hippocampus")

exp.vars="GROUP+ICV"
output=jun.ans2(dep.vars,exp.vars,"")
output

exp.vars="GROUP*SEX2+ICV"
output=jun.ans2(dep.vars,exp.vars,"")
output




# --------------------------------------------
# rANCOVA - plots
# --------------------------------------------

