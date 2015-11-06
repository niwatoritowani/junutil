# analyses_basic

datax=datay
summary(datax[,c("Diagnosis","Time",regions,regions2)])        # summary: NC:133,SZ:165,NA:149
by(datax[,c("Time",regions,regions2)],datax$Diagnosis,summary) # by diagnosis
datax.subset=datax[,c("Diagnosis","Time",regions,regions2)]
datax.subset1=na.omit(datax.subset)                            # NC:25, SZ:26
by(datax.subset1,datax.subset1$Diagnosis,summary)              # by diagnosis NC1:23,NC2:2,SZ1:25,SZ2:26

# select cases which have CC volume data

datax.subset2=subset(datax,! is.na(datax$CC_Anterior))
summary(datax.subset2[,c("Time","Diagnosis","Sample",regions,regions2)])       # summary:NC:27,SZ:33,AN:149
by(datax.subset2[,c("Time",regions,regions2)],datax.subset2$Diagnosis,summary)  # by diagnosis NC1:23,NC2:2,NCNA:2,SZ1:25,SZ2:1,SZNA:7
datax.subset2c=subset(datax.subset2,Sample=="chronic")
summary(datax.subset2c[,c("Time","Diagnosis","Sample",regions,regions2)])       # summary:NC:27,SZ:33;TimeNA:9
by(datax.subset2c[,c("Time",regions,regions2)],datax.subset2c$Diagnosis,summary)  # by diagnosis NC1:23,NC2:2,NCNA:2,SZ1:25,SZ2:1,SZNA:7


# with-CC-volume and not-CSZ are 149, in addition 9 cases have not Time

# select cases which are listed on chronic SZ table

datax.subset3=subset(datax,Sample=="chronic")
summary(datax.subset3[,c("Time","Diagnosis","Sample",regions,regions3)]) # NC:133,SZ:165;CCNA:132
by(datax.subset3[,c("Time",regions,regions2)],datax.subset3$Diagnosis,summary)

datax.subset3woD=datax.subset3[-grep("D",datax.subset3[["caseid2"]]),]
summary(datax.subset3woD[,c("Time","Diagnosis","Sample",regions,regions3)]) # NC:73,SZ:82;CCNA:95
by(datax.subset3woD[,c("Time",regions,regions2)],datax.subset3woD$Diagnosis,summary)

datax.subset3woDwo4=datax.subset3woD[grep(".....",datax.subset3woD[["caseid2"]]),]
summary(datax.subset3woDwo4[,c("Time","Diagnosis","Sample",regions,regions3)]) # NC:64,SZ:71;CCNA:75
datax.subset3woDwo4wo0=datax.subset3woDwo4[-grep("00...",datax.subset3woDwo4[["caseid2"]]),]
summary(datax.subset3woDwo4wo0[,c("Time","Diagnosis","Sample",regions,regions3)]) # NC:46,SZ:57;CCNA:43
by(datax.subset3woDwo4wo0[,c("Time",regions,regions2)],datax.subset3woDwo4wo0$Diagnosis,summary)



# summary(data6[,c(demographics1,parameters2,parameters1)]) # summary
# #by(data6[demographics1],data6$SEX,summary) # grouped by sex
# by(data6[,c(demographics1,parameters2)],data6$GROUP,summary)  # groupd by GROUP (PRO and control)
# summary(table(data6$GROUP,data6$SEX)) # chi test
# t.test(subset(data6,GROUP=="PRO")["AGE"],subset(data6,GROUP=="HVPRO")["AGE"]) # t-test
# 
# # ---------------------------------------------
# # output demographic table
# # ---------------------------------------------
# 
# #datax=data6
# #datax=data6[-29,]  # exclude a case which have no volume data
# datax=subset(data6,subset=(!is.na(CC_Anterior))) # exclude a case which have no volume data
# items=c("AGE","READSTD","WASIIQ","GAFC","GAFH","SIPTOTEV","SINTOTEV","SIDTOTEV","SIGTOTEV","SOCFXC","ROLEFX")
# v1=sapply(datax[,items],mean,na.rm=TRUE)
# v2=sapply(datax[,items],sd,na.rm=TRUE)
# 
# datay=subset(datax,GROUP=="PRO");
# v3=sapply(datay[,items],mean,na.rm=TRUE)
# v4=sapply(datay[,items],sd,na.rm=TRUE)
# 
# datay=subset(datax,!GROUP=="PRO");
# v5=sapply(datay[,items],mean,na.rm=TRUE)
# v6=sapply(datay[,items],sd,na.rm=TRUE)
# 
# n=length(items);v7=numeric(n);
# for ( i in 1:n){
#     r1=t.test(subset(datax,GROUP=="PRO")[items[i]],subset(datax,GROUP=="HVPRO")[items[i]])
#     v7[i]=r1[["p.value"]]
# }
# 
# table1=data.frame(tot_mean=v1,tot_sd=v2,pro_mean=v3,pro_sd=v4,hc_mean=v5,hc_sd=v6,p.value=v7)
# 
# m=by(datax[,c("SEX")],datax$GROUP,summary) # ... use table() ?
# r=summary(table(datax$GROUP,datax$SEX))[["p.value"]]  # chi test
# table1=rbind(table1,c("","",m[["PRO"]][["0"]],"",m[["HVPRO"]][["0"]],"",r))
# rownames(table1)[nrow(table1)]="male"
# 
# table1[1,c(1:6)]=sprintf("%.1f",as.numeric(table1[1,c(1:6)]))
# table1[2,c(1:6)]=sprintf("%.1f",as.numeric(table1[2,c(1:6)]))
# table1[3,c(1:6)]=sprintf("%.1f",as.numeric(table1[3,c(1:6)]))
# table1[4,c(1:6)]=sprintf("%.1f",as.numeric(table1[4,c(1:6)]))
# table1[5,c(1:6)]=sprintf("%.2f",as.numeric(table1[5,c(1:6)]))
# table1[6,c(1:6)]=sprintf("%.2f",as.numeric(table1[6,c(1:6)]))
# table1[7,c(1:6)]=sprintf("%.2f",as.numeric(table1[7,c(1:6)]))
# table1[8,c(1:6)]=sprintf("%.2f",as.numeric(table1[8,c(1:6)]))
# table1[9,c(1:6)]=sprintf("%.2f",as.numeric(table1[9,c(1:6)]))
# table1[10,c(1:6)]=sprintf("%.2f",as.numeric(table1[10,c(1:6)]))
# table1[11,c(1:6)]=sprintf("%.2f",as.numeric(table1[11,c(1:6)]))
# table1[,7]=sprintf("%.3f",as.numeric(table1[,7]))
# 
# n=nrow(table1); tablex=rbind(table1[n,])
# for ( i in 1:(n-1) ) {tablex=rbind(tablex,table1[i,])}
# 
# table1=tablex;knitr::kable(table1)
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
