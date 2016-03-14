# ------------------------------
# summary
# ------------------------------

# - plots of volumes between groups combining hemi, jun.plot2()
# - plots of volumes between groups separating hemi, jun.plot3()
# - plots of volumes between groups separating hemi, jun.plot31(), 2016/03/09
# - output plot as a pmg
# - plots of volumes between groups separating hemi, relative, jun.plot4()
# - plots of correlation 1
# - plots of correlation 2 relative
# - plots of correlation 3 relative, 2016/03/09


# -----------------------------------------------
# to do
# -----------------------------------------------

# - change transparency of the dots in the plots


# ----------------------------------------------------
# plots of volumes between grops with hemi in one axis
# ----------------------------------------------------


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
    ylabel=paste("Volumes of",ylabel1)    # combine texts for y label
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


# -----------------------------------------------
# plots of volumes between grops separated by hemi
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
    ylabel=paste("Volumes of",ylabel1)    # combine tests for y label
    p1=ggplot(datax, aes(x=R2D2,y=values,fill=ind)) +
#        scale_fill_manual(values=c("red","blue")) +    # use default color if commented out
        stat_summary(fun.ymin=function(x) mean(x), fun.ymax=function(x) mean(x), 
            geom="errorbar", width=0.3) + # add mean as a error bar
        stat_summary(fun.ymin=function(x) mean(x) - sd(x), fun.ymax=function(x) mean(x) + sd(x), 
            geom="errorbar", width=0.15) + # error bar
        geom_dotplot(binaxis="y",stackdir="center") +
#        stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +  # add mean
#        geom_errorbar(aes(ymin=values-se,ymax=values+se), width=.3) +    # This did not work
        guides(fill=FALSE) +    # don't display guide
#        theme(axis.title.x=element_blank()) +    # don't display x-axis-label : GROUP
        xlab("CHR                   HC") +    #  change x-axils-label
        scale_x_discrete(breaks=c(levels(datax$R2D2)),
            labels=c(xlabel1)) +   # change the labels of the scale
        ylab(ylabel)    # change the label of y axis
    p1
}

# geom: errorbar, point, bar, line, ... 2016/03/03. 
#     - errorbar needs fun.y and fun.ymin and fun.ymax
#     - bar needs fun.y and fun.ymin


# make plot componets

xlabel1=c("","")
p1=jun.plot3(data.cc.central,"\nthe CCC",xlabel1)
xlabel1=c("left","right","left","right")
# p2=jun.plot3(data.lv,"the LV",xlabel1) # LV were not significant
p3=jun.plot3(data.lvt,"\nthe temporal horns of the LV",xlabel1)
p4=jun.plot3(data.amy,"\nthe amygdala",xlabel1) 
# p5=jun.plot3(data.hip,"\nthe hippocampus",xlabel1) # HIP wre not significant


# display in one picture

# Move to a new page
grid.newpage()
# Create layout : nrow = 2, ncol = 3
pushViewport(viewport(layout = grid.layout(3,1)))
# A helper function to define a region on the layout
define_region <- function(row, col){
  viewport(layout.pos.row = row, layout.pos.col = col)
}
print(p1,vp=define_region(1,1))
# print(p2,vp=define_region(2,1))   # not significant
print(p3,vp=define_region(2,1))
# print(p4,vp=define_region(4,1))    # not significant
print(p4,vp=define_region(3,1))


# ------------------------
# output plot
# ------------------------
# - 2016/02/24

ppi=300    # 300 is better
png("plot_vol_group_201603031917.png",width=4*ppi, height=12*ppi, res=ppi)
# something plot
dev.off()


# --------------------------------------------------------------
# plots of volumes between grops separated by hemi 3, 2016/03/09
# --------------------------------------------------------------

# set up data

datax=data.ex3.exna
field.names=c("r.CC_Anterior", "r.CC_Mid_Anterior", "r.CC_Central", "r.CC_Mid_Posterior", "r.CC_Posterior")
data.cc=jun.stack(field.names,c("caseid2","GROUP","ICV"))
data.cc.central=subset(data.cc,ind=="r.CC_Central")
field.names=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle")
data.lv=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent")
data.lvt=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("r.Right.Amygdala","r.Left.Amygdala")
data.amy=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("r.Right.Hippocampus","r.Left.Hippocampus")
data.hip=jun.stack(field.names,c("caseid2","GROUP","ICV"))


# change the "set up data", 2016/03/09
# - There was a problem in function jun.stack(). 
# - The option "datax=datax" was deleted. 2016/03/09. 


# function to plot 2016/02/24, 2016/03/09

jun.plot31 <- function(datax,ylabel1,xlabel1,label1,posi1,posi2) {
    datax$ind=factor(datax$ind)     # the order of the leves are not changed
    #datax$GROUP=factor(datax$GROUP,rev(levels(datax$GROUP)))    # lever order to be PRO, HVPRO
    datax$GROUP=factor(datax$GROUP)    # lever order to be HVPRO, PRO
    n=length(levels(datax$ind));m=length(levels(datax$GROUP))
    datax$R2D2=factor(    # factor(vector,levels) can explicitly express the order of the levels
        paste(datax$ind,datax$GROUP,sep="."),     # example r.lt.amygdala.PRO
        paste(levels(datax$ind)[rep(1:n,m)],levels(datax$GROUP)[sort(rep(1:m,n))],sep=".")    # hemi.Gr
    )

    ylabel=paste("Relative olumes of",ylabel1)    # combine tests for y label
    p1=ggplot(datax, aes(x=R2D2,y=values,fill=GROUP)) +
        theme_bw() + # change the thema to brack and white
        theme(text=element_text(size=7)) +
        scale_fill_manual(values=c("grey","red"),labels=c("HC","CHR")) +    # use default color if commented out
        geom_dotplot(binaxis="y",stackdir="center") +
        stat_summary(fun.ymin=function(x) mean(x), fun.ymax=function(x) mean(x), 
            geom="errorbar", width=0.3) + # add mean as a error bar
        stat_summary(fun.ymin=function(x) mean(x) - sd(x), fun.ymax=function(x) mean(x) + sd(x), 
            geom="errorbar", width=0.15) + # error bar
        #guides(fill=FALSE) +    # don't display guide
        theme(legend.position=posi1,legend.justification=posi2) +    # this works 
        theme(legend.background=element_blank()) +
        theme(legend.key=element_blank()) +
        theme(legend.key.size=unit(0.2, "cm")) +
        theme(legend.text=element_text(size=7)) +  # no effect? 
        guides(fill=guide_legend(title=NULL)) +
        theme(axis.title.x=element_blank()) +    # don't display x-axis-label : GROUP
        #xlab("HC                                     CHR") +    #  change x-axils-label
        scale_x_discrete(breaks=c(levels(datax$R2D2)),
            labels=c(xlabel1)) +   # change the labels of the scale
        ylab(ylabel) +   # change the label of y axis
        # scale_fill_discrete(labels=c("HC","CHR")) +   # This does not work 2016/03/10
        annotate("text", x=-Inf, y=Inf, label=label1, hjust=-0.2, vjust=1.5)
    p1
}

xlabel1=c("","")
p1=jun.plot31(data.cc.central,"\nthe CCC",xlabel1,"A",c(1.05,1.1),c(1,1))
xlabel1=c("left","right","left","right")
p3=jun.plot31(data.lvt,"\nthe temporal horns of the LV",xlabel1,"B",c(0.05,1.1),c(0,1))
p4=jun.plot31(data.amy,"\nthe amygdala",xlabel1,"C",c(1.05,1.1),c(1,1)) 
options(scipen=2) # default: options(scipen=0)
grid.arrange(p1, p3, p4)
options(scipen=0) # default

dev.copy2eps(file="plot_vol_group_20160311.eps",width=3.3, height=6)  # inches

ppi=600    # 300 is better
tiff("plot_vol_group_20160310.tif",width=3*ppi, height=6*ppi, res=ppi)
options(scipen=2) # default: options(scipen=0)
grid.arrange(p1, p3, p4)
options(scipen=0) # default
dev.off()

# for poster

ppi=300    # 300 is better
png("plot_vol_group_CCC_20160313_300dpi_w3.3inch.png",width=3.3*ppi, height=2.5*ppi, res=ppi)
p1
dev.off()

ppi=300    # 300 is better
png("plot_vol_group_TH_20160313_300dpi_w3.3inch.png",width=3.3*ppi, height=2.5*ppi, res=ppi)
options(scipen=2) # default: options(scipen=0)
p3
options(scipen=0) # default
dev.off()

ppi=300    # 300 is better
png("plot_vol_group_AMY_20160313_300dpi_w3.3inch.png",width=3.3*ppi, height=2.5*ppi, res=ppi)
p4
dev.off()


# --------------------------------------------------------------
# plots of volumes between grops separated by hemi 4, 2016/03/14
# --------------------------------------------------------------

# - a code for error bar was changed. 2016/03/14. 
# - This plots are trial for new appearances. 2016/03/14. 
# - For the poster, the plots above were planed to be used. 2016/03/14. 


# set up data

datax=data.ex3.exna
field.names=c("r.CC_Anterior", "r.CC_Mid_Anterior", "r.CC_Central", "r.CC_Mid_Posterior", "r.CC_Posterior")
data.cc=jun.stack(field.names,c("caseid2","GROUP","ICV"))
data.cc.central=subset(data.cc,ind=="r.CC_Central")
field.names=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle")
data.lv=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent")
data.lvt=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("r.Right.Amygdala","r.Left.Amygdala")
data.amy=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("r.Right.Hippocampus","r.Left.Hippocampus")
data.hip=jun.stack(field.names,c("caseid2","GROUP","ICV"))

# function to plot 2016/02/24, 2016/03/09, 2016/03/14

jun.plot32 <- function(datax,ylabel1,xlabel1,label1,posi1,posi2) {
    datax$ind=factor(datax$ind)     # the order of the leves are not changed
    #datax$GROUP=factor(datax$GROUP,rev(levels(datax$GROUP)))    # lever order to be PRO, HVPRO
    datax$GROUP=factor(datax$GROUP)    # lever order to be HVPRO, PRO
    n=length(levels(datax$ind));m=length(levels(datax$GROUP))
    datax$R2D2=factor(    # factor(vector,levels) can explicitly express the order of the levels
        paste(datax$ind,datax$GROUP,sep="."),     # example r.lt.amygdala.PRO
        paste(levels(datax$ind)[rep(1:n,m)],levels(datax$GROUP)[sort(rep(1:m,n))],sep=".")    # hemi.Gr
    )

    ylabel=paste("Relative olumes of",ylabel1)    # combine tests for y label
    p1=ggplot(datax, aes(x=R2D2,y=values,fill=GROUP)) +
        theme_bw() + # change the thema to brack and white
        theme(text=element_text(size=7)) +
        scale_fill_manual(values=c("grey","red"),labels=c("HC","CHR")) +    # use default color if commented out
        geom_dotplot(binaxis="y",stackdir="center") +
        stat_summary(fun.ymin=function(x) mean(x), fun.ymax=function(x) mean(x), 
            geom="errorbar", width=0.3) + # add mean as a error bar
        #stat_summary(fun.ymin=function(x) mean(x) - sd(x), fun.ymax=function(x) mean(x) + sd(x), 
        #    geom="errorbar", width=0.15) + # error bar
        stat_summary(fun.data="mean_sdl", mult=1, geom="errorbar", width=0.15) + # error bar
        #guides(fill=FALSE) +    # don't display guide
        theme(legend.position=posi1,legend.justification=posi2) +    # this works 
        theme(legend.background=element_blank()) +
        theme(legend.key=element_blank()) +
        theme(legend.key.size=unit(0.2, "cm")) +
        theme(legend.text=element_text(size=7)) +  # no effect? 
        guides(fill=guide_legend(title=NULL)) +
        theme(axis.title.x=element_blank()) +    # don't display x-axis-label : GROUP
        #xlab("HC                                     CHR") +    #  change x-axils-label
        scale_x_discrete(breaks=c(levels(datax$R2D2)),
            labels=c(xlabel1)) +   # change the labels of the scale
        ylab(ylabel) +   # change the label of y axis
        # scale_fill_discrete(labels=c("HC","CHR")) +   # This does not work 2016/03/10
        annotate("text", x=-Inf, y=Inf, label=label1, hjust=-0.2, vjust=1.5)
    p1
}

xlabel1=c("","")
p1=jun.plot32(data.cc.central,"\nthe CCC",xlabel1,"A",c(1.05,1.1),c(1,1))
xlabel1=c("left","right","left","right")
p3=jun.plot32(data.lvt,"\nthe temporal horns of the LV",xlabel1,"B",c(0.05,1.1),c(0,1))
p4=jun.plot32(data.amy,"\nthe amygdala",xlabel1,"C",c(1.05,1.1),c(1,1)) 
options(scipen=2) # default: options(scipen=0)
grid.arrange(p1, p3, p4)
options(scipen=0) # default

dev.copy2eps(file="plot_vol_group_20160311.eps",width=3.3, height=6)  # inches

ppi=600    # 300 is better
tiff("plot_vol_group_20160310.tif",width=3*ppi, height=6*ppi, res=ppi)
options(scipen=2) # default: options(scipen=0)
grid.arrange(p1, p3, p4)
options(scipen=0) # default
dev.off()

# for poster

ppi=300    # 300 is better
png("plot_vol_group_CCC_20160313_300dpi_w3.3inch.png",width=3.3*ppi, height=2.5*ppi, res=ppi)
p1
dev.off()

ppi=300    # 300 is better
png("plot_vol_group_TH_20160313_300dpi_w3.3inch.png",width=3.3*ppi, height=2.5*ppi, res=ppi)
options(scipen=2) # default: options(scipen=0)
p3
options(scipen=0) # default
dev.off()

ppi=300    # 300 is better
png("plot_vol_group_AMY_20160313_300dpi_w3.3inch.png",width=3.3*ppi, height=2.5*ppi, res=ppi)
p4
dev.off()


# ---------------------------------------------------------------------------------
# plots of volumes between grops separated by hemi 2 summarized relative 2016/03/04
# ---------------------------------------------------------------------------------

datax=data.ex3.exna
items1=c("caseid2","GROUP","ICV")
data.cc=jun.stack(c("r.CC_Anterior", "r.CC_Mid_Anterior", "r.CC_Central", "r.CC_Mid_Posterior", "r.CC_Posterior"), items1)
data.cc.central=subset(data.cc,ind=="r.CC_Central")
data.lvt=jun.stack(c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle"),items1)
data.amy=jun.stack(c("r.Right.Amygdala","r.Left.Amygdala"),items1)

jun.plot4 <- function(datax,ylabel1,xlabel1) {
    datax$ind=factor(datax$ind)     # the order of the leves are not changed
    datax$GROUP=factor(datax$GROUP,rev(levels(datax$GROUP)))    # lever order to be PRO, HVPRO
    n=length(levels(datax$ind));m=length(levels(datax$GROUP))
    datax$R2D2=factor(    # factor(vector,levels) can explicitly express the order of the levels
        paste(datax$ind,datax$GROUP,sep="."),     # example r.lt.amygdala.PRO
        paste(levels(datax$ind)[rep(1:n,m)],levels(datax$GROUP)[sort(rep(1:m,n))],sep=".")    # hemi.Gr
    )
    ggplot(datax, aes(x=R2D2,y=values,fill=ind)) +
        geom_dotplot(binaxis="y",stackdir="center") +
        stat_summary(fun.ymin=function(x) mean(x), fun.ymax=function(x) mean(x), 
            geom="errorbar", width=0.3) + # add mean as a error bar
        stat_summary(fun.ymin=function(x) mean(x) - sd(x), fun.ymax=function(x) mean(x) + sd(x), 
            geom="errorbar", width=0.15) + # error bar
        guides(fill=FALSE) +    # don't display guide
        xlab("CHR                   HC") +    #  change x-axils-label
        scale_x_discrete(breaks=c(levels(datax$R2D2)), labels=c(xlabel1)) +   # change the x scale labels
        ylab(paste("Relative volumes of", ylabel1))    # change the label of y axis
}

jun.print.plot <- function() {
    p1=jun.plot4(data.cc.central,"\nthe CCC",c("",""))
    xlabel1=c("left","right","left","right")
    p3=jun.plot4(data.lvt,"\nthe temporal horns of the LV",xlabel1)
    p4=jun.plot4(data.amy,"\nthe amygdala",xlabel1) 

    grid.newpage()
    pushViewport(viewport(layout = grid.layout(3,1)))
    define_region <- function(row, col) {
      viewport(layout.pos.row = row, layout.pos.col = col)
    }
    print(p1,vp=define_region(1,1))
    print(p3,vp=define_region(2,1))
    print(p4,vp=define_region(3,1))
}
jun.print.plot()


# output plot

ppi=300; png("plot_vol_group_201603040000.png",width=4*ppi, height=12*ppi, res=ppi)
jun.print.plot(); dev.off()


# -----------------------------------------------
# plots of correlation 1
# -----------------------------------------------


# set up data

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")
datax=data.pro


# plot

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


# -----------------------------------------------
# plots of correlation 2 relative
# -----------------------------------------------


# set up data

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")
datax=data.pro
# field.names=regions
# data.cc=jun.stack(field.names,c("caseid2","GROUP","ICV"))
# data.cc.central=subset(data.cc,ind=="CC_Central")
field.names=c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle")
data.lv=jun.stack(field.names,c("caseid2","GROUP","ICV","SINTOTEV"))
# field.names=c("r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent")
# data.lvt=jun.stack(field.names,c("caseid2","GROUP","ICV")) 
# field.names=c("r.Right.Amygdala","r.Left.Amygdala")
# data.amy=jun.stack(field.names,c("caseid2","GROUP","ICV"))
field.names=c("r.Right.Hippocampus","r.Left.Hippocampus")
data.hip=jun.stack(field.names,c("caseid2","GROUP","ICV","SIPTOTEV"))


# plot

p2=ggplot(data.lv, aes(x=SINTOTEV, y=values,colour=ind)) +
    geom_point() + stat_smooth(method=lm, se=FALSE) +
    xlab("Negative symptom score") + 
    ylab("Relative volumes of the LV") +
    theme(legend.position=c(0,1),legend.justification=c(0,1)) +    # this works 
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))    
p3=ggplot(data.hip, aes(x=SIPTOTEV, y=values,colour=ind)) +
    geom_point() + stat_smooth(method=lm, se=FALSE) +
    xlab("Positive symptom score") +
    ylab("Relative volumes of the hippocampus") +
    theme(legend.position=c(0,0),legend.justification=c(0,0)) +    # this works 
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))    
# grid.arrange(p2, p3, main = "Correlation") 
grid.arrange(p2, p3) 


# ouptu plot

ppi=300    # 300 is better
png("plot_correlation_201602291916.png",width=4*ppi, height=8*ppi, res=ppi)
grid.arrange(p2, p3) 
dev.off()


# ---------------------------------------------------
# plots of correlation 2 relative 2 trial, 2016/03/04
# ---------------------------------------------------

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO");    data.hc=subset(datax,GROUP=="HVPRO")
datax=data.pro
items1=c("caseid2","GROUP","ICV","SINTOTEV","SIPTOTEV")
data.lv=jun.stack(c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle"),items1)
data.hip=jun.stack(c("r.Right.Hippocampus","r.Left.Hippocampus"),items1)

p2=ggplot(data.lv, aes(x=SINTOTEV, y=values,colour=ind)) +
    geom_point() + stat_smooth(method=lm, se=FALSE) +
    xlab("Negative symptom score") + 
    ylab("Relative volumes of the LV") +
    theme(legend.position=c(0,1),legend.justification=c(0,1)) +    # this works 
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))    
p3=ggplot(data.hip, aes(x=SIPTOTEV, y=values,colour=ind)) +
    geom_point() + stat_smooth(method=lm, se=FALSE) +
    xlab("Positive symptom score") +
    ylab("Relative volumes of the hippocampus") +
    theme(legend.position=c(0,0),legend.justification=c(0,0)) +    # this works 
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))    grid.arrange(p2, p3) 


# ---------------------------------------------------
# plots of correlation 2 relative 3, 2016/03/09
# ---------------------------------------------------

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO");    data.hc=subset(datax,GROUP=="HVPRO")
datax=data.pro
items1=c("caseid2","GROUP","ICV","SINTOTEV","SIPTOTEV")
data.lv=jun.stack(c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle"),items1)
data.hip=jun.stack(c("r.Right.Hippocampus","r.Left.Hippocampus"),items1)

p2=ggplot(data.lv, aes(x=SINTOTEV, y=values,colour=ind)) +
    theme_bw() + 
    theme(text=element_text(size=10)) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Negative symptom score") + 
    ylab("Relative volumes of the LV") +
    theme(legend.position=c(0,1),legend.justification=c(0,1)) +    # this works 
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))  +
    annotate("text", x=-Inf, y=Inf, label="A", hjust=-0.2, vjust=1.5)  
p3=ggplot(data.hip, aes(x=SIPTOTEV, y=values,colour=ind)) +
    theme_bw() + 
    theme(text=element_text(size=10)) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Positive symptom score") +
    ylab("Relative volumes of the hippocampus") +
    theme(legend.position=c(0,0),legend.justification=c(0,0)) +    # this works 
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))    +
    annotate("text", x=-Inf, y=Inf, label="B", hjust=-0.2, vjust=1.5)  
grid.arrange(p2,p3,nrow=2)


dev.copy2eps(file="plot_correlation_20160310.eps",width=3.3, height=6)  # inches

ppi=600    # 300 is better
tiff("plot_correlation_20160310.tif",width=3*ppi, height=6*ppi, res=ppi)
grid.arrange(p2,p3,nrow=2)
dev.off()

# for poster

ppi=300    # 300 is better
png("plot_correlation_LV_20160313_300ppi_w3.3inch.png",width=3.3*ppi, height=3.3*ppi, res=ppi)
p2
dev.off()

ppi=300    # 300 is better
png("plot_correlation_HIP_20160313_300ppi_w3.3inch.png",width=3.3*ppi, height=3.3*ppi, res=ppi)
p3
dev.off()


