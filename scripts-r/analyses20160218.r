# ------------------------------
# summary
# ------------------------------

# - plots of volumes between groups
# - plots of correlation


# -----------------------------------------------
# to do
# -----------------------------------------------

# - change transparency of the dots in the plots


# -----------------------------------------------
# plots of volumes between grops
# -----------------------------------------------


# set up data

datax=data.ex3.exna
field.names=regions
data.cc=jun.stack(field.names,c("caseid2","GROUP","ICV"))
data.cc.central=subset(data.cc,ind=="CC_Central")
field.names=c("Right.Lateral.Ventricle","Left.Lateral.Ventricle")
data.lv=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("Right.Inf.Lat.Vent","Left.Inf.Lat.Vent")
data.lvt=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("Right.Amygdala","Left.Amygdala")
data.amy=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("Right.Hippocampus","Left.Hippocampus")
data.hip=jun.stack(field.names,c("caseid2","GROUP","ICV"))


# function to plot
# - refer to analyses20151201.r
# - combine hemi

jun.plot2 <- function(data.cc,ylabel1) {
    # change the order of the levels in factor
    data.cc$ind=factor(data.cc$ind)     # the order of the leves are not changed
    data.cc$GROUP=factor(data.cc$GROUP,rev(levels(data.cc$GROUP)))    # lever order to be PRO, HVPRO
    n=length(levels(data.cc$ind));m=length(levels(data.cc$GROUP))
    data.cc$R2D2=factor(
        paste(data.cc$ind,data.cc$GROUP,sep="."),
        paste(levels(data.cc$ind)[sort(rep(1:n,m))],levels(data.cc$GROUP)[rep(1:m,n)],sep=".")
    )

    datax=data.cc
    ylabel=paste("Volumes of",ylabel1)    # combine tests for y label
    p1=ggplot(datax, aes(x=GROUP,y=values,fill=ind)) +
        scale_fill_manual(values=c("red","blue")) +
        geom_dotplot(binaxis="y",stackdir="center") +
        stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
        guides(fill=FALSE) +    # don't display guide
        theme(axis.title.x=element_blank()) +    # don't display x-axis-label : GROUP
        scale_x_discrete(breaks=c("HVPRO","PRO"),
            labels=c("HC","CHR")) +   # change the labels of the scale
        ylab(ylabel)    # change the label of y axis
    p1
}


# make plot componets

p1=jun.plot2(data.cc.central,"CCC")
p2=jun.plot2(data.lv,"LV")
p3=jun.plot2(data.lvt,"temporal horns of LV")
p4=jun.plot2(data.amy,"amygdala")
p5=jun.plot2(data.hip,"hippocampus")


# display in one picture

# Move to a new page
grid.newpage()
# Create layout : nrow = 2, ncol = 3
pushViewport(viewport(layout = grid.layout(5,1)))
# A helper function to define a region on the layout
define_region <- function(row, col){
  viewport(layout.pos.row = row, layout.pos.col = col)
}
print(p1,vp=define_region(1,1))
print(p2,vp=define_region(2,1))
print(p3,vp=define_region(3,1))
print(p4,vp=define_region(4,1))
print(p5,vp=define_region(5,1))


# function to plot 2016/02/24
# - refer to analyses20151201.r
# - separated by hemi

jun.plot3 <- function(datax,ylabel1,xlabel1) {
    # change the order of the levels in factor
    datax$ind=factor(datax$ind)     # the order of the leves are not changed
    datax$GROUP=factor(datax$GROUP,rev(levels(datax$GROUP)))    # lever order to be PRO, HVPRO
    n=length(levels(datax$ind));m=length(levels(datax$GROUP))
    datax$R2D2=factor(    # factor(vector,levels) can explicitly express the order of the levels
        paste(datax$ind,datax$GROUP,sep="."),     # example r.lt.amygdala.PRO
        paste(levels(datax$ind)[rep(1:n,m)],levels(datax$GROUP)[sort(rep(1:m,n))],sep=".")    # hemi.Gr
    )

#    datax=data.cc
    ylabel=paste("Volumes of",ylabel1,xlabel1)    # combine tests for y label
    p1=ggplot(datax, aes(x=R2D2,y=values,fill=ind)) +
        scale_fill_manual(values=c("red","blue")) +
        geom_dotplot(binaxis="y",stackdir="center") +
#        stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +  # add mean
        guides(fill=FALSE) +    # don't display guide
#        theme(axis.title.x=element_blank()) +    # don't display x-axis-label : GROUP
        xlab("CHR                   HC") +    #  change x-axils-label
        scale_x_discrete(breaks=c(levels(datax$R2D2)),
            labels=c(xlabel1)) +   # change the labels of the scale
        ylab(ylabel)    # change the label of y axis
    p1
}


# make plot componets

xlabel1=c("","")
p1=jun.plot3(data.cc.central,"CCC",xlabel1)
xlabel1=c("left","right","left","right")
p2=jun.plot3(data.lv,"LV",xlabel1)
p3=jun.plot3(data.lvt,"temporal horns of LV",xlabel1)
p4=jun.plot3(data.amy,"amygdala",xlabel1)
p5=jun.plot3(data.hip,"hippocampus",xlabel1)


# display in one picture

# Move to a new page
grid.newpage()
# Create layout : nrow = 2, ncol = 3
pushViewport(viewport(layout = grid.layout(5,1)))
# A helper function to define a region on the layout
define_region <- function(row, col){
  viewport(layout.pos.row = row, layout.pos.col = col)
}
print(p1,vp=define_region(1,1))
print(p2,vp=define_region(2,1))
print(p3,vp=define_region(3,1))
print(p4,vp=define_region(4,1))
print(p5,vp=define_region(5,1))


# ------------------------
# output plot
# ------------------------
# - 2016/02/24

ppi=300    # 300 is better
png("plot201602241257.png",width=4*ppi, height=12*ppi, res=ppi)
# plot
dev.off()


# -----------------------------------------------
# plots of correlation
# -----------------------------------------------


# set up data

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")


# plot

datax=data.pro
p1=ggplot(datax, aes(x=r.Bil.Lateral.Ventricle, y=r.Bil.Inf.Lat.Vent)) +
    geom_point() + stat_smooth(method=lm, se=FALSE) +
    xlab("Volumes of LV") +
    ylab("Volumes of tenporal horns of LV")
p2=ggplot(datax, aes(x=SINTOTEV, y=r.Bil.Lateral.Ventricle)) +
    geom_point() + stat_smooth(method=lm, se=FALSE) +
    xlab("Negative symptom score") + 
    ylab("Volumes of LV")
p3=ggplot(datax, aes(x=SIPTOTEV, y=r.Bil.Hippocampus)) +
    geom_point() + stat_smooth(method=lm, se=FALSE) +
    xlab("Positive symptom score") +
    ylab("Volumes of hippocampus")
grid.arrange(p1, p2, p3, main = "Correlation")




