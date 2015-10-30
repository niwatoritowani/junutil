# analyses
# separate PRO group into two by the left LV volume

# absolute volume

datax=datay
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")
ROI="Left.Lateral.Ventricle"

datax=data.pro
d1=datax[[ROI]]
datax[["lt.LV.group"]]=cut(d1,c(min(d1),median(d1),max(d1)),labels=c("L","H"),include.lowest=TRUE)
data.pro=datax

data.pro.lLVl=subset(data.pro,lt.LV.group=="L")
data.pro.lLVh=subset(data.pro,lt.LV.group=="H")

items.row=c(names.field,parameters1,parameters2,parameters_si)     # 
items.col=c(ROI)      # absolute volumes
items.ana=c("estimate","p.value") 

arr.pro.lLVl=jun.cor.test(items.row,items.col,items.ana,data.pro.lLVl)
arr.pro.lLVh=jun.cor.test(items.row,items.col,items.ana,data.pro.lLVh)

mtx.p.lLVl=arr.pro.lLVl[,,2]
mtx.p.lLVh=arr.pro.lLVh[,,2]
d.p.lLV=cbind(low=mtx.p.lLVl,high=mtx.p.lLVh)

sig.mtx=sigmtx(d.p.lLV)

d.p.lLV[c("ROLEFX","GAFC","GAFH","SINTOTEV"),]

mtx.rho.lLVl=arr.pro.lLVl[,,1]
mtx.rho.lLVh=arr.pro.lLVh[,,1]
d.rho.lLV=cbind(low=mtx.rho.lLVl,high=mtx.rho.lLVh)
d.rho.lLV[c("ROLEFX","GAFC","GAFH","SINTOTEV"),]

cat(file="tmp","# results\n\n")
sink(file="tmp",append=TRUE)
cat("\n# correlation analyses with left ventricle volume\n")
cat("\n# absolute volumes\n")
cat("\n# table of p-values\n")
print(kable(d.p.lLV))
cat("\n# p < .05\n")
print(kable(sig.mtx))
cat("\n# selected items\n")
cat("\n# p-values\n")
print(kable(d.p.lLV[c("ROLEFX","GAFC","GAFH","SINTOTEV"),]))
cat("\n# rho")
print(kable(d.rho.lLV[c("ROLEFX","GAFC","GAFH","SINTOTEV"),]))
sink()

pdf("plot.LV.pdf",width=10,height=20,useDingbats=FALSE)
p1=ggplot(data.pro.lLVl,aes(x=ROLEFX,  y=Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p2=ggplot(data.pro.lLVh,aes(x=ROLEFX,  y=Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p3=ggplot(data.pro.lLVl,aes(x=GAFC,    y=Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p4=ggplot(data.pro.lLVh,aes(x=GAFC,    y=Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p5=ggplot(data.pro.lLVl,aes(x=GAFH,    y=Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p6=ggplot(data.pro.lLVh,aes(x=GAFH,    y=Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p7=ggplot(data.pro.lLVl,aes(x=SINTOTEV,y=Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p8=ggplot(data.pro.lLVh,aes(x=SINTOTEV,y=Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8,ncol=2 , main = "Correlation (y-axis : volume of left ventricle)")
dev.off()

# relative volume 

datax=datay
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")
ROI="r.Left.Lateral.Ventricle"

datax=data.pro
d1=datax[[ROI]]
datax[["lt.LV.group"]]=cut(d1,c(min(d1),median(d1),max(d1)),labels=c("L","H"),include.lowest=TRUE)
data.pro=datax

data.pro.lLVl=subset(data.pro,lt.LV.group=="L")
data.pro.lLVh=subset(data.pro,lt.LV.group=="H")

items.row=c(names.field.r,parameters1,parameters2,parameters_si)     # 
items.col=c(ROI)      # absolute volumes
items.ana=c("estimate","p.value") 

arr.pro.lLVl=jun.cor.test(items.row,items.col,items.ana,data.pro.lLVl)
arr.pro.lLVh=jun.cor.test(items.row,items.col,items.ana,data.pro.lLVh)

mtx.p.lLVl=arr.pro.lLVl[,,2]
mtx.p.lLVh=arr.pro.lLVh[,,2]
d.p.lLV=cbind(low=mtx.p.lLVl,high=mtx.p.lLVh)

sig.mtx=sigmtx(d.p.lLV)

d.p.lLV[c("ROLEFX","GAFC","GAFH","SINTOTEV"),]

mtx.rho.lLVl=arr.pro.lLVl[,,1]
mtx.rho.lLVh=arr.pro.lLVh[,,1]
d.rho.lLV=cbind(low=mtx.rho.lLVl,high=mtx.rho.lLVh)
d.rho.lLV[c("ROLEFX","GAFC","GAFH","SINTOTEV"),]


sink(file="tmp",append=TRUE)
cat("\n# correlation analyses with left ventricle volume\n")
cat("\n# relative volumes (divided by ICV)\n")
cat("\n# table of p-values\n")
print(kable(d.p.lLV))
cat("\n# p < .05\n")
print(kable(sig.mtx))
cat("\n# selected items\n")
cat("\n# p-values\n")
print(kable(d.p.lLV[c("ROLEFX","GAFC","GAFH","SINTOTEV"),]))
cat("\n# rho")
print(kable(d.rho.lLV[c("ROLEFX","GAFC","GAFH","SINTOTEV"),]))
sink()

pdf("plot.relativeLtLV.pdf",width=10,height=20,useDingbats=FALSE)
p1=ggplot(data.pro.lLVl,aes(x=ROLEFX,  y=r.Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p2=ggplot(data.pro.lLVh,aes(x=ROLEFX,  y=r.Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p3=ggplot(data.pro.lLVl,aes(x=GAFC,    y=r.Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p4=ggplot(data.pro.lLVh,aes(x=GAFC,    y=r.Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p5=ggplot(data.pro.lLVl,aes(x=GAFH,    y=r.Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p6=ggplot(data.pro.lLVh,aes(x=GAFH,    y=r.Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p7=ggplot(data.pro.lLVl,aes(x=SINTOTEV,y=r.Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
p8=ggplot(data.pro.lLVh,aes(x=SINTOTEV,y=r.Left.Lateral.Ventricle)) + geom_point() + 
    theme(axis.title.y=element_blank())
grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8,ncol=2 , main = "Correlation (y-axis : volume of left ventricle dividie by ICV)")
dev.off()
