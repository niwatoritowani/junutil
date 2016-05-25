# ------------------------------
# summary
# ------------------------------

# - This is for the figures in argicle, 2016/04/26

# - plots of volumes between grops separated by hemi, 2016/04/26
# - plots of correlation, relative, 2016/04/26

# --------------------------------------------------------------
# plots of volumes between grops separated by hemi, 2016/04/26
# --------------------------------------------------------------

# - This is for the figures in article and may be going to be changed, 2016/04/26. 
# - created based on "plots of volumes between grops separated by hemi 4, 2016/03/14"
# - "plots of volumes between grops separated by hemi 4, 2016/03/14" are trial for new appearances. 2016/03/14. 
# - For the poster, the older plots above were planed to be used. 2016/03/14. 
# - a code for error bar was changed. 2016/03/14. 
# - change fontsize from 7, 2016/03/17
# - change legend size from 0.2, 2016/03/17
# - png() for poster were deleted, 2016/04/26
# - dev.copy2eps() was deleted, 2016/04/26
# - font size 10, family sans, 2016/04/26
# - sublabel were changed from A to a, 2016/04/26
# - 600 dpi is needed to submit to an article but too big to send with email, 2016/05/20
# - 300 dpi is apropriate for a poster presentation. 2016/05/20
# - dev.copy2eps() was added from analyses20160218. 2016/05/25. 

# set up data

datax=data.ex3.exna
field.names=c("r.CC_Anterior", "r.CC_Mid_Anterior", "r.CC_Central", "r.CC_Mid_Posterior", "r.CC_Posterior")
data.cc=jun.stack(field.names,c("caseid2","GROUP","ICV"))    # example data.cc$ind is "r.cc_Anterilr"
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
    #datax$GROUP=factor(datax$GROUP,rev(levels(datax$GROUP)))    # reverse level alphabetical order to be PRO, HVPRO
    datax$GROUP=factor(datax$GROUP)    # level order to be HVPRO, PRO
    n=length(levels(datax$ind));m=length(levels(datax$GROUP))
    datax$R2D2=factor(    # factor(vector,levels) can explicitly express the order of the levels
        paste(datax$ind,datax$GROUP,sep="."),     # example r.lt.amygdala.PRO
        paste(levels(datax$ind)[rep(1:n,m)],levels(datax$GROUP)[sort(rep(1:m,n))],sep=".")    # hemi.Gr
    )

    ylabel=paste("Relative volumes of",ylabel1)    # combine tests for y label
    p1=ggplot(datax, aes(x=R2D2,y=values,fill=GROUP)) +
        theme_bw() + # change the thema to brack and white
        theme(text=element_text(size=10)) +    # default: size=7, family="sans"
        scale_fill_manual(values=c("grey","red"),labels=c("HC","CHR")) +    # use default color if commented out
        geom_dotplot(binaxis="y",stackdir="center") +    # center plots to y axis
        stat_summary(fun.ymin=function(x) mean(x), fun.ymax=function(x) mean(x), 
            geom="errorbar", width=0.3) + # add mean as a error bar
        #stat_summary(fun.ymin=function(x) mean(x) - sd(x), fun.ymax=function(x) mean(x) + sd(x), 
        #    geom="errorbar", width=0.15) + # error bar
        stat_summary(fun.data="mean_sdl", mult=1, geom="errorbar", width=0.15) + # add error bar
        #guides(fill=FALSE) +    # don't display guide
        theme(legend.position=posi1,legend.justification=posi2) +    # this works 
        theme(legend.background=element_blank()) +    # set legend background to blanc
        theme(legend.key=element_blank()) +    # set key background to blanc
        theme(legend.key.size=unit(0.4,"cm")) +    # my default unit(0.2, "cm")
        theme(legend.text=element_text(size=7)) +  # no effect? 
        guides(fill=guide_legend(title=NULL)) +    # don't display legend title
        theme(axis.title.x=element_blank()) +    # don't display x-axis-label : GROUP
        #xlab("HC                                     CHR") +    #  change x-axils-label
        scale_x_discrete(breaks=c(levels(datax$R2D2)),    # separate into plot groups by datax$R2D2 
            labels=c(xlabel1)) +   # change the labels of the scale
        ylab(ylabel) +   # change the label of y axis
        # scale_fill_discrete(labels=c("HC","CHR")) +   # This does not work 2016/03/10
        annotate("text", x=-Inf, y=Inf, label=label1, hjust=-0.2, vjust=1.5)    # add sub-id of figure
    p1    # output p1 
}

xlabel1=c("","")    # set x-axis label text
p1=jun.plot32(data.cc.central,"\nthe CCC",xlabel1,"a",c(1.05,1.1),c(1,1))    # default: with \n
xlabel1=c("left","right","left","right")    # set x-axis label text
p3=jun.plot32(data.lvt,"\nthe temporal horns of the LV",xlabel1,"b",c(0.05,1.1),c(0,1))    # default: with \n
p4=jun.plot32(data.amy,"\nthe amygdala",xlabel1,"c",c(1.05,1.1),c(1,1))    # default: with \n
options(scipen=2) # change exponent notation, default: options(scipen=0)
grid.arrange(p1, p3, p4)    # line up automatically
options(scipen=0) # return to the default setting

dev.copy2eps(file="plot_vol_group_20160311.eps",width=3.3, height=6)  # inches, for journals
# If use theme(text=element_text(family="sans")), stop with error, 2016/05/25. 

ppi=600    # 300 is better for poster 
tiff("plot_vol_group_600dpiw3.3h7.5.tif",width=3.3*ppi, height=7.5*ppi, res=ppi)    # default inches
options(scipen=2) # default: options(scipen=0) for changing display of decimalpoint in p3
grid.arrange(p1, p3, p4)
options(scipen=0) # default
dev.off()


# ---------------------------------------------------
# plots of correlation, relative, 2016/04/26
# ---------------------------------------------------

# - created from "plots of correlation 2 relative 3, 2016/03/09"
# - dev.copy2eps() was deleted
# - png() were deleted
# - font family sans, 2016/04/26
# - sublabel were changed from A to a, 2016/04/26

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO");    data.hc=subset(datax,GROUP=="HVPRO")
datax=data.pro
items1=c("caseid2","GROUP","ICV","SINTOTEV","SIPTOTEV")
data.lv=jun.stack(c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle"),items1)
data.hip=jun.stack(c("r.Right.Hippocampus","r.Left.Hippocampus"),items1)

p2=ggplot(data.lv, aes(x=SINTOTEV, y=values,colour=ind)) +
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Negative symptom score") + 
    ylab("Relative volumes of the LV") +
    theme(legend.position=c(0,1),legend.justification=c(0,1)) +    # this works 
    theme(legend.background=element_blank()) +
    theme(legend.key=element_blank()) +
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))  +
    annotate("text", x=-Inf, y=Inf, label="a", hjust=-0.2, vjust=1.5)  
p3=ggplot(data.hip, aes(x=SIPTOTEV, y=values,colour=ind)) +
    theme_bw() + 
    theme(text=element_text(size=10)) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Positive symptom score") +
    ylab("Relative volumes of the hippocampus") +
    theme(legend.position=c(0,0),legend.justification=c(0,0)) +    # this works 
    theme(legend.background=element_blank()) +
    theme(legend.key=element_blank()) +
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))    +
    annotate("text", x=-Inf, y=Inf, label="b", hjust=-0.2, vjust=1.5)  
grid.arrange(p2,p3,nrow=2)


ppi=600    # 300 is better
tiff("plot_correlation_600dpi3.3w6.6h.tif",width=3.3*ppi, height=6.6*ppi, res=ppi)
grid.arrange(p2,p3,nrow=2)
dev.off()


# ----------------------------------------------
# plots of correlation 2016/05/23
# ----------------------------------------------


# the below is for the relation between the volume and the clinical parametere

datax=data.ex3.exna
data.pro=subset(datax,GROUP=="PRO");    data.hc=subset(datax,GROUP=="HVPRO")
datax=data.pro
items1=c("caseid2","GROUP","ICV","SINTOTEV","SIPTOTEV")
data.lv=jun.stack(c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle"),items1)
data.hip=jun.stack(c("r.Right.Hippocampus","r.Left.Hippocampus"),items1)

jun.plot.cor <- function(datax,xlabel,ylabel) {
    p2=ggplot(datax, aes(x=SINTOTEV, y=values,colour=ind)) +
        theme_bw() +
        theme(text=element_text(size=10, family="sans")) +
        geom_point(size=2) +
        stat_smooth(method=lm, se=FALSE) +
        xlab(xlabel) +
        ylab(ylabel) +
        theme(legend.position=c(0,1),legend.justification=c(0,1)) +    # this works 
        theme(legend.background=element_blank()) +
        theme(legend.key=element_blank()) +
        guides(colour=guide_legend(title=NULL))  +
        scale_colour_discrete(labels=c("left","right"))  +
        annotate("text", x=-Inf, y=Inf, label="a", hjust=-0.2, vjust=1.5)
    p2
}

p1=jun.plot.cor(data.lv,"Negative symptom score","Relative volumes of the LV")
p1


# the below is for the relation between the volume and the volume

jun.plot.cor2 <- function(datax,xaxis.name,yaxis.name,xlabel,ylabel) {
    datax[["xaxis"]]=datax[[xaxis.name]]
    datax[["yaxis"]]=datax[[yaxis.name]]
    p2=ggplot(datax, aes(x=xaxis, y=yaxis)) +    # "colour=ind" was delteted
        theme_bw() +
        theme(text=element_text(size=10, family="sans")) +
        geom_point(size=2) +
        stat_smooth(method=lm, se=FALSE) +
        xlab(xlabel) +
        ylab(ylabel) +
        theme(legend.position=c(0,1),legend.justification=c(0,1)) +    # this works 
        theme(legend.background=element_blank()) +
        theme(legend.key=element_blank()) +
        guides(colour=guide_legend(title=NULL))  +
        scale_colour_discrete(labels=c("left","right"))  +
        annotate("text", x=-Inf, y=Inf, label="", hjust=-0.2, vjust=1.5)
    p2
}

p1=jun.plot.cor2(datax,"r.Right.Lateral.Ventricle","r.Right.Hippocampus","Relative volume of the right LV","Relative volumes of the right hippocampus")
p2=jun.plot.cor2(datax,"r.Left.Lateral.Ventricle","r.Left.Hippocampus","Relative volume of the left LV","Relative volumes of the left hippocampus")

ppi=300
tiff("plot_correlation_ltHIP_ltLV_300dpi3.3w3.3h.tif", width=3.3*ppi, height=3.3*ppi, res=ppi)
p2
dev.off()    # 2016/05/23

# the below is a copy from the past code (the above) and not yet edited

p3=ggplot(data.hip, aes(x=SIPTOTEV, y=values,colour=ind)) +
    theme_bw() +
    theme(text=element_text(size=10)) +
    geom_point(size=2) +
    stat_smooth(method=lm, se=FALSE) +
    xlab("Positive symptom score") +
    ylab("Relative volumes of the hippocampus") +
    theme(legend.position=c(0,0),legend.justification=c(0,0)) +    # this works 
    theme(legend.background=element_blank()) +
    theme(legend.key=element_blank()) +
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))    +
    annotate("text", x=-Inf, y=Inf, label="b", hjust=-0.2, vjust=1.5)
grid.arrange(p2,p3,nrow=2)


ppi=600    # 300 is better
tiff("plot_correlation_600dpi3.3w6.6h.tif",width=3.3*ppi, height=6.6*ppi, res=ppi)
grid.arrange(p2,p3,nrow=2)
dev.off()

