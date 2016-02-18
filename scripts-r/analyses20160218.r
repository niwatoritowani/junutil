# ------------------------------
# summary
# ------------------------------

# - plots of volumes between groups
# - 
# - 
# - 


# -----------------------------------------------
# to do
# -----------------------------------------------

# - change axis labels
# - change transparency of the dots in the plots
# - graphs for correlations


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



# CCs, LV, LVThorn

# # change the order of the levels in factor
# data.cc$Regions2=factor(data.cc$Region2,regions)    # the order of the levels to be the same as in regions
# data.cc$Diagnosis2=factor(data.cc$Diagnosis2,rev(levels(data.cc$Diagnosis2)))
# n=length(levels(data.cc$Regions2));m=length(levels(data.cc$Diagnosis2))
# data.cc$R2D2=factor(
#     paste(data.cc$Region2,data.cc$Diagnosis2,sep="."),
#     paste(levels(data.cc$Region2)[sort(rep(1:n,m))],levels(data.cc$Diagnosis2)[rep(1:m,n)],sep=".")
# )
# 
# datax=data.cc
# p1=ggplot(datax, aes(x=R2D2,y=Vol2,fill=Diagnosis2)) +
#     scale_fill_manual(values=c("red","blue")) +
#     geom_dotplot(binaxis="y",stackdir="center") +
#     stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
# #    guides(fill=FALSE) +    # don't display guide
#     theme(axis.title.x=element_blank())    # don't display x-axis-label


# function to plot

jun.plot2 <- function(data.cc) {
    # change the order of the levels in factor
    data.cc$Regions2=factor(data.cc$ind)     # the order of the leves are not changed
    data.cc$Diagnosis2=factor(data.cc$GROUP,rev(levels(data.cc$GROUP)))    # lever order to be PRO, HVPRO
    n=length(levels(data.cc$GROUP));m=length(levels(data.cc$GROUP))
    data.cc$R2D2=factor(
        paste(data.cc$ind,data.cc$GROUP,sep="."),
        paste(levels(data.cc$ind)[sort(rep(1:n,m))],levels(data.cc$GROUP)[rep(1:m,n)],sep=".")
    )

    datax=data.cc
    p1=ggplot(datax, aes(x=GROUP,y=values,fill=ind)) +
        scale_fill_manual(values=c("red","blue")) +
        geom_dotplot(binaxis="y",stackdir="center") +
        stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
        guides(fill=FALSE) +    # don't display guide
        theme(axis.title.x=element_blank())    # don't display x-axis-label
    p1
}


# make plot componets

p1=jun.plot2(data.cc.central)
p2=jun.plot2(data.lv)
p3=jun.plot2(data.lvt)
p4=jun.plot2(data.amy)
p5=jun.plot2(data.hip)


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


