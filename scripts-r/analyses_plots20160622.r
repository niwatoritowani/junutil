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

# function
run=function(cmd){cat(cmd,"\n",sep="");eval(parse(text=cmd))}
WORKDIR="/rfanfs/pnl-zorro/projects/2015-jun-prodrome/stats/02_editedfreesurfer/20160622"

# using data "data.ex4.exna"
# NEED TO SET UP ...
    source("/home/jkonishi/junutil/scripts-r/SetUpData_env_PNL.r")
    source("/home/jkonishi/junutil/scripts-r/SetUpData_table.r")
    source("/home/jkonishi/junutil/scripts-r/functions.r")

setwd(WORKDIR)

datax=data.ex4.exna # 2016/06/15

cat("\n----caselist----\n")
print(data.frame(line=1:dim(datax)[1],datax[c("caseid2","GROUP")]))
data.pro=subset(datax,GROUP=="PRO")
data.hc=subset(datax,GROUP=="HVPRO")


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
        #theme(legend.position=posi1,legend.justification=posi2) +    # this works 
        #theme(legend.background=element_blank()) +    # set legend background to blanc
        #theme(legend.key=element_blank()) +    # set key background to blanc
        theme(legend.key.size=unit(0.4,"cm")) +    # my default unit(0.2, "cm")
        theme(legend.text=element_text(size=7)) +  # no effect? 
        guides(fill=guide_legend(title=NULL)) +    # don't display legend title
        theme(axis.title.x=element_blank()) +    # don't display x-axis-label : GROUP
        #xlab("HC                                     CHR") +    #  change x-axils-label
        scale_x_discrete(breaks=c(levels(datax$R2D2)),    # separate into plot groups by datax$R2D2 
            labels=c(xlabel1)) +   # change the labels of the scale
        ylab(ylabel) +   # change the label of y axis
        # scale_fill_discrete(labels=c("HC","CHR")) +   # This does not work 2016/03/10
        #annotate("text", x=-Inf, y=Inf, label=label1, hjust=-0.2, vjust=1.5)    # add sub-id of figure
        ggtitle(label1) +
        theme(plot.title = element_text(hjust = 0))
    p1    # output p1 
}

xlabel1=c("","")    # set x-axis label text
p1=jun.plot32(data.cc.central,"\nthe CCC",xlabel1,"c",c(1.05,1.1),c(1,1))    # default: with \n
p1=p1 + 
    annotate("segment",x=1,xend=2,y=0.00040,yend=0.00040) +
    annotate("text",x=1.5,y=0.00041,label="*")

xlabel1=c("left","right","left","right")    # set x-axis label text
p2=jun.plot32(data.lv,"\nthe LV",xlabel1,"a",c(0.05,1.1),c(0,1)) # 2016/06/22
p2=p2 + 
    annotate("segment",x=1.5,xend=3.5,y=0.015,yend=0.015) +
    annotate("text",x=2.5,y=0.016,label="*")
p3=jun.plot32(data.lvt,"\nthe temporal horns of the LV",xlabel1,"b",c(0.05,1.1),c(0,1))    # default: with \n
p3=p3 +
    annotate("segment",x=1.5,xend=3.5,y=0.0007,yend=0.0007) +
    annotate("text",x=2.5,y=0.00072,label="*")
p4=jun.plot32(data.amy,"\nthe amygdala",xlabel1,"d",c(1.05,1.1),c(1,1))    # default: with \n
p4=p4 +
    annotate("segment",x=1.5,xend=3.5,y=0.0015,yend=0.0015) +
    annotate("text",x=2.5,y=0.00152,label="*")

options(scipen=2) # change exponent notation, default: options(scipen=0)
grid.arrange(p2, p3, p1, p4, ncol=1)    # line up automatically
options(scipen=0) # return to the default setting

options(scipen=2) # change exponent notation, default: options(scipen=0)
dev.copy2eps(file="plot_vol_group_20160622.eps",width=3.3, height=10)  # inches, for journals
options(scipen=0) # return to the default setting
# If use theme(text=element_text(family="sans")), stop with error, 2016/05/25. 

ppi=300    # 300 is better for poster, 600 is better for article (large size)
tiff("plot_vol_group_300dpiw3.3h10.tif",width=3.3*ppi, height=10*ppi, res=ppi)    # default inches
options(scipen=2) # default: options(scipen=0) for changing display of decimalpoint in p3
grid.arrange(p2, p3,p1, p4, ncol=1)
options(scipen=0) # default
dev.off()

ppi=300    # 300 is better for poster, 600 is better for article (large size)
tiff("plot_vol_group_300dpiw3.3h10complzw.tif",width=3.3*ppi, height=10*ppi, res=ppi,compression="lzw")    # default inches
options(scipen=2) # default: options(scipen=0) for changing display of decimalpoint in p3
grid.arrange(p2, p3,p1, p4, ncol=1)
options(scipen=0) # default
dev.off()
# compression="rle" 
# output error message "plot_vol_group_300dpiw3.3h10comprle.tif: Compression algorithm does not support random access."



# -------------------------------------------------------
# plots of correlation, relative, 2016/04/26, 2016/06/22
# -------------------------------------------------------

# - created from "plots of correlation 2 relative 3, 2016/03/09"
# - dev.copy2eps() was deleted
# - png() were deleted
# - font family sans, 2016/04/26
# - sublabel were changed from A to a, 2016/04/26

datax=data.pro
cat("\n----caselist----\n")
print(data.frame(line=1:dim(datax)[1],datax[c("caseid2","GROUP")]))

#items1=c("caseid2","GROUP","ICV","SINTOTEV","SIPTOTEV")
#data.lv=jun.stack(c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle"),items1)
#data.hip=jun.stack(c("r.Right.Hippocampus","r.Left.Hippocampus"),items1)

p1=ggplot(datax, aes(x=SINTOTEV, y=r.Bil.Lateral.Ventricle)) + # delete "colour=ind"
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Negative symptom score") + 
    ylab("Relative volume of the bilateral LV") +
    #annotate("text", x=-Inf, y=Inf, label="a", hjust=-0.2, vjust=1.5)  
    ggtitle("a") +
    theme(plot.title = element_text(hjust = 0))
p2=ggplot(datax, aes(x=ROLEFX, y=r.Bil.Inf.Lat.Vent)) + # delete "colour=ind"
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Score of the General Functions: Role") + 
    ylab("Relative volume of the bilateral temporal horns of LV") +
    #annotate("text", x=-Inf, y=Inf, label="b", hjust=-0.2, vjust=1.5)  
    ggtitle("b") +
    theme(plot.title = element_text(hjust = 0))
p3=ggplot(datax, aes(x=SIDTOTEV, y=r.Bil.Hippocampus)) + # delete "colour=ind"
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Disorganized symptom score") + 
    ylab("Relative volume of the bilateral hippocampus") +
    #annotate("text", x=-Inf, y=Inf, label="c", hjust=-0.2, vjust=1.5)  
    ggtitle("c") +
    theme(plot.title = element_text(hjust = 0))


ppi=300    # 300 is better for poster and email. 600 is better for an article (large size)
tiff("plot_correlation_300dpi3.3w9.9h.tif",width=3.3*ppi, height=9.9*ppi, res=ppi)
options(scipen=2) # change exponent notation, default: options(scipen=0)
grid.arrange(p1,p2,p3,ncol=1)
options(scipen=0) # default
dev.off()

ppi=300    # 300 is better for poster and email. 600 is better for an article (large size)
tiff("plot_correlation_300dpi3.3w9.9hcomplzw.tif",width=3.3*ppi, height=9.9*ppi, res=ppi,compression="lzw")
options(scipen=2) # change exponent notation, default: options(scipen=0)
grid.arrange(p1,p2,p3,ncol=1)
options(scipen=0) # default
dev.off()

# ----------------------------------------------------------------------------
# plots of correlation, relative, hemisphere-separated, 2016/04/26, 2016/06/22
# ----------------------------------------------------------------------------

# - 2016/06/24
# - created from "plots of correlation 2 relative 3, 2016/03/09"
# - dev.copy2eps() was deleted
# - png() were deleted
# - font family sans, 2016/04/26
# - sublabel were changed from A to a, 2016/04/26

datax=data.pro
cat("\n----caselist----\n")
print(data.frame(line=1:dim(datax)[1],datax[c("caseid2","GROUP")]))

items=c("caseid2","GROUP","ICV","SINTOTEV","SIPTOTEV","SIDTOTEV","ROLEFX")
data.lv=jun.stack(c("r.Right.Lateral.Ventricle","r.Left.Lateral.Ventricle"),items)
cat("\n----caselist-data.lv---\n")
print(data.frame(line=1:dim(data.lv)[1],data.lv))

data.lvt=jun.stack(c("r.Right.Inf.Lat.Vent","r.Left.Inf.Lat.Vent"),items)
cat("\n----caselist-data.lvt---\n")
print(data.frame(line=1:dim(data.lvt)[1],data.lvt))

data.hip=jun.stack(c("r.Right.Hippocampus","r.Left.Hippocampus"),items)
cat("\n----caselist-data.hip---\n")
print(data.frame(line=1:dim(data.hip)[1],data.hip))

p1=ggplot(data.lv,aes(x=SINTOTEV, y=values,colour=ind)) + # delete "colour=ind"
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Negative symptom score") + 
    ylab("Relative volume of the LV") +
    theme(legend.position=c(0,1),legend.justification=c(0,1)) +    # this works 
    theme(legend.background=element_blank()) +
    theme(legend.key=element_blank()) +
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))  +  # change labels in guide
    #annotate("text", x=-Inf, y=Inf, label="a", hjust=-0.2, vjust=1.5)  
    ggtitle("a") +
    theme(plot.title = element_text(hjust = 0))
p2=ggplot(data.lv,aes(x=ROLEFX, y=values,colour=ind)) + # delete "colour=ind"
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Score of the General Function: Role") + 
    ylab("Relative volume of the LV") +
    theme(legend.position=c(1,1),legend.justification=c(1,1)) +    # this works 
    theme(legend.background=element_blank()) +
    theme(legend.key=element_blank()) +
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))  +  # change labels in guide
    #annotate("text", x=-Inf, y=Inf, label="a", hjust=-0.2, vjust=1.5)  
    ggtitle("b") +
    theme(plot.title = element_text(hjust = 0))
p3=ggplot(data.lvt, aes(x=SIDTOTEV, y=values,colour=ind)) + # delete "colour=ind"
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Disorganized symptom score") + 
    ylab("Relative volume of the temporal horns of LV") +
    theme(legend.position=c(0,1),legend.justification=c(0,1)) +    # this works 
    theme(legend.background=element_blank()) +
    theme(legend.key=element_blank()) +
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))  +  # change labels in guide
    #annotate("text", x=-Inf, y=Inf, label="b", hjust=-0.2, vjust=1.5)  
    ggtitle("c") +
    theme(plot.title = element_text(hjust = 0))
p4=ggplot(data.lvt, aes(x=ROLEFX, y=values,colour=ind)) + # delete "colour=ind"
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Score of the General Functions: Role") + 
    ylab("Relative volume of the temporal horns of LV") +
    theme(legend.position=c(1,1),legend.justification=c(1,1)) +    # this works 
    theme(legend.background=element_blank()) +
    theme(legend.key=element_blank()) +
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))  +  # change labels in guide
    #annotate("text", x=-Inf, y=Inf, label="b", hjust=-0.2, vjust=1.5)  
    ggtitle("d") +
    theme(plot.title = element_text(hjust = 0))
p5=ggplot(data.hip, aes(x=SIDTOTEV, y=values,colour=ind)) + # delete "colour=ind"
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Disorganized symptom score") + 
    ylab("Relative volume of the hippocampus") +
    theme(legend.position=c(1,0),legend.justification=c(1,0)) +    # this works 
    theme(legend.background=element_blank()) +
    theme(legend.key=element_blank()) +
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))  +  # change labels in guide
    #annotate("text", x=-Inf, y=Inf, label="c", hjust=-0.2, vjust=1.5)  
    ggtitle("e") +
    theme(plot.title = element_text(hjust = 0))
p6=ggplot(data.hip, aes(x=ROLEFX, y=values,colour=ind)) + # delete "colour=ind"
    theme_bw() + 
    theme(text=element_text(size=10, family="sans")) +
    geom_point(size=2) + 
    stat_smooth(method=lm, se=FALSE) +
    xlab("Score of the General Functions: Role") + 
    ylab("Relative volume of the hippocampus") +
    theme(legend.position=c(1,0),legend.justification=c(1,0)) +    # this works 
    theme(legend.background=element_blank()) +
    theme(legend.key=element_blank()) +
    guides(colour=guide_legend(title=NULL))  +
    scale_colour_discrete(labels=c("left","right"))  +  # change labels in guide
    #annotate("text", x=-Inf, y=Inf, label="c", hjust=-0.2, vjust=1.5)  
    ggtitle("f") +
    theme(plot.title = element_text(hjust = 0))


ppi=300    # 300 is better for poster and email. 600 is better for an article (large size)
tiff("plot_correlation_300dpi3.3w9.9h.tif.....",width=3.3*ppi, height=9.9*ppi, res=ppi)
options(scipen=2) # change exponent notation, default: options(scipen=0)
grid.arrange(p1,p2,p3,ncol=1)
options(scipen=0) # default
dev.off()

ppi=300    # 300 is better for poster and email. 600 is better for an article (large size)
tiff("plot_correlation_sep_300dpi6.6w9.9hcomplzw.tif",width=6.6*ppi, height=9.9*ppi, res=ppi,compression="lzw")
options(scipen=2) # change exponent notation, default: options(scipen=0)
grid.arrange(p1,p2,p3,p4,p5,p6,ncol=2)
options(scipen=0) # default
dev.off()


# appendix

# code for changing guide of plot
    # theme(legend.position=c(0,1),legend.justification=c(0,1)) +    # this works 
    # theme(legend.background=element_blank()) +
    # theme(legend.key=element_blank()) +
    # guides(colour=guide_legend(title=NULL))  +
    # scale_colour_discrete(labels=c("left","right"))  +  # change labels in guide

# notes
# savehistory(file = ".Rhistory")

