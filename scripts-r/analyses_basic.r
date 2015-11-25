# -----------------------
# demographics
# -----------------------

datax=data.ex3.exna
kable(datax[,c("caseid2","GROUP",regions2,regions5,"Left.Amygdala","Right.Amygdala")]) # show table
summary(datax[,c(demographics1,parameters2,parameters1)]) # summary
#by(data6[demographics1],data6$SEX,summary) # grouped by sex
by(datax[,c(demographics1,parameters2)],datax$GROUP,summary)  # groupd by GROUP (PRO and control)
#summary(table(data6$GROUP,data6$SEX)) # chi test
#t.test(subset(data6,GROUP=="PRO")["AGE"],subset(data6,GROUP=="HVPRO")["AGE"]) # t-test

# ---------------------------------------------
# output demographic table
# ---------------------------------------------


datax=data.ex3.exna
items=c("AGE","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV","SOCFXC","ROLEFX")
v1=sapply(datax[,items],mean,na.rm=TRUE)
v2=sapply(datax[,items],sd,na.rm=TRUE)

datay=subset(datax,GROUP=="PRO");
v3=sapply(datay[,items],mean,na.rm=TRUE)
v4=sapply(datay[,items],sd,na.rm=TRUE)

datay=subset(datax,!GROUP=="PRO");
v5=sapply(datay[,items],mean,na.rm=TRUE)
v6=sapply(datay[,items],sd,na.rm=TRUE)

n=length(items);v7=numeric(n);
for ( i in 1:n){
    r1=t.test(subset(datax,GROUP=="PRO")[items[i]],subset(datax,GROUP=="HVPRO")[items[i]])
    v7[i]=r1[["p.value"]]
}

table1=data.frame(tot_mean=v1,tot_sd=v2,pro_mean=v3,pro_sd=v4,hc_mean=v5,hc_sd=v6,p.value=v7)

m=by(datax[,c("SEX")],datax$GROUP,summary) # ... use table() ?
r=summary(table(datax$GROUP,datax$SEX))[["p.value"]]  # chi test
PROmalefemale=paste(m[["PRO"]]["0"],"/",m[["PRO"]]["1"],sep="")
HVPROmalefemale=paste(m[["HVPRO"]]["0"],"/",m[["HVPRO"]]["1"],sep="")
table1=rbind(table1,c("","",PROmalefemale,"",HVPROmalefemale,"",r))
rownames(table1)[nrow(table1)]="male/female"

table1[1,c(1:6)]=sprintf("%.1f",as.numeric(table1[1,c(1:6)])) 
table1[2,c(1:6)]=sprintf("%.1f",as.numeric(table1[2,c(1:6)])) 
table1[3,c(1:6)]=sprintf("%.1f",as.numeric(table1[3,c(1:6)])) 
table1[4,c(1:6)]=sprintf("%.1f",as.numeric(table1[4,c(1:6)])) 
table1[5,c(1:6)]=sprintf("%.2f",as.numeric(table1[5,c(1:6)])) 
table1[6,c(1:6)]=sprintf("%.2f",as.numeric(table1[6,c(1:6)])) 
table1[7,c(1:6)]=sprintf("%.2f",as.numeric(table1[7,c(1:6)])) 
table1[8,c(1:6)]=sprintf("%.2f",as.numeric(table1[8,c(1:6)])) 
table1[9,c(1:6)]=sprintf("%.2f",as.numeric(table1[9,c(1:6)])) 
table1[10,c(1:6)]=sprintf("%.2f",as.numeric(table1[10,c(1:6)])) 
table1[11,c(1:6)]=sprintf("%.2f",as.numeric(table1[11,c(1:6)])) 
table1[,7]=sprintf("%.3f",as.numeric(table1[,7])) 

n=nrow(table1); tablex=rbind(table1[n,])
for ( i in 1:(n-1) ) {tablex=rbind(tablex,table1[i,])} 
knitr::kable(tablex)

cat(file="tmp","",append=FALSE)
cat(file="tmp","\n# -------------------------------------\n",append=TRUE)
cat(file="tmp",paste("# pwd: ",getwd(),"\n",sep=""),append=TRUE)
cat(file="tmp",paste("# fsstatfile: ",fsstatfile.aseg,"\n",sep=""),append=TRUE)
cat(file="tmp",paste("# demographictable: ",demographictable,"\n",sep=""),append=TRUE)
cat(file="tmp","# -------------------------------------\n\n",append=TRUE)
cat(file="tmp","\n# -------------------------------------\n",append=TRUE)
cat(file="tmp","# Table\n",append=TRUE)
cat(file="tmp","# -------------------------------------\n\n",append=TRUE)
sink(file="tmp",append=TRUE);knitr::kable(tablex);sink()

