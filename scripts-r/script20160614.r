# example data
d1.t1=c(0,0,1,1,1,2,2,2,NA,0,1)
d1.t2=c(0,1,1,1,2,2,3,3,0,NA,NA)
d2.t1=c(0,0,1,1,1,2,2,2,0,NA,NA)
d2.t2=c(0,0,0,0,1,1,1,2,NA,0,1)

datax=data.frame(d1.t1,d1.t2,d2.t1,d2.t2)
items=c("d1","d2")
items.mean=paste(items,".mean",sep="")
items.t1=paste(items,".t1",sep="")
items.t2=paste(items,".t2",sep="")
items.diff.abs=paste(items,".diff.abs",sep="")
items.diff.prop=paste(items,".diff.prop",sep="")
items.diff.prop2=paste(items,".diff.prop2",sep="")
items.diff.perc=paste(items,".diff.perc",sep="")
items.diff.perc2=paste(items,".diff.perc2",sep="")

items.1=paste(items,".1",sep="")
items.1.mean=paste(items.1,".mean",sep="")
items.1.t1=paste(items.1,".t1",sep="")
items.1.t2=paste(items.1,".t2",sep="")
items.1.diff.abs=paste(items.1,".diff.abs",sep="")
items.1.diff.prop=paste(items.1,".diff.prop",sep="")
items.1.diff.prop2=paste(items.1,".diff.prop2",sep="")
items.1.diff.perc=paste(items.1,".diff.perc",sep="")
items.1.diff.perc2=paste(items.1,".diff.perc2",sep="")

datax[items.1]=datax[items]+1

cat("diff.prop are (t2-t1)/t1\n")
datax[items.diff.abs]=datax[items.t2]-datax[items.t1]
datax[items.mean]=(datax[items.t1]+datax[items.t2])/2
datax[items.diff.prop]=datax[items.diff.abs]/datax[items.t1]
cat("diff.perc are (t2-t1)/t1*100\n")
datax[items.diff.perc]=datax[items.diff.prop]*100

cat("diff.prop2 are (t2-t1)/((t1+t2)/2). 0 if t2-t1 is 0.\n")
#datax[items.diff.prop2]=ifelse(!datax[items.diff.abs], 0, datax[items.diff.abs] / datax[items.mean]) # does not work
datax[["d1.diff.prop2"]]=ifelse(!datax[["d1.diff.abs"]], 0, datax[["d1.diff.abs"]] / datax[["d1.mean"]]) # 0 is FALSE
datax[["d2.diff.prop2"]]=ifelse(!datax[["d2.diff.abs"]], 0, datax[["d2.diff.abs"]] / datax[["d2.mean"]]) # 0 is FALSE
cat("diff.perc2 are (t2-t1)/((t1+t2)/2)*100. 0 if t2-t1 is 0.\n")
datax[items.diff.perc2]=datax[items.diff.prop2]*100

View(datax) # display

myfunction <- function(){
    tmp.mt=sapply(datax[items],mean,na.rm=TRUE)
    print(tmp.mt)
}
items=items.diff.abs
myfunction()
items=items.diff.perc
myfunction()
items=items.diff.perc2
myfunction()

d3=c(0,1,1,1,2,2,3,3,0,NA,NA,NaN,NaN,Inf,Inf)
ifelse(!d3, 0,1)
# [1]  0  1  1  1  1  1  1  1  0 NA NA NA NA  1  1
