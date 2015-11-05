datax=datax.subset1

jun.plot <- function(datax) {
    p1=ggplot(datax, aes(x=Diagnosis,y=Right.Lateral.Ventricle,fill=Time)) +
        geom_dotplot(binaxis="y",binwidth=20,stackdir="center") +
        stat_summary(fun.y="mean",goem="point",shape=23,size=0.5,fill="black",ymin=0,ymax=0) +
        guides(fill=FALSE) +    # don't display guide
        theme(axis.title.x=element_blank())    # don't display x-axis-label
    p1
}
#jun.plot(datax.subset1,"Right.Lateral.Ventricle")
jun.plot(datax.subset1)


jun.plot <- function(datax) {
    p1=ggplot(datax, aes(x=Diagnosis,y=Right.Lateral.Ventricle,fill=Time)) +
        geom_dotplot(binaxis="y",stackdir="center") +
        stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
        guides(fill=FALSE) +    # don't display guide
        theme(axis.title.x=element_blank())    # don't display x-axis-label
    p1
}
#jun.plot(datax.subset1,"Right.Lateral.Ventricle")
jun.plot(datax.subset1)


jun.plot <- function(datax) {
    p1=ggplot(datax, aes(x=Diagnosis,y=Left.Lateral.Ventricle,fill=Time)) +
        geom_dotplot(binaxis="y",stackdir="center") +
        stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
        guides(fill=FALSE) +    # don't display guide
        theme(axis.title.x=element_blank())    # don't display x-axis-label
    p1
}
jun.plot(datax.subset1)


jun.plot <- function(datax) {
    p1=ggplot(datax, aes(x=Diagnosis,y=rLeft.Lateral.Ventricle,fill=Time)) +
        geom_dotplot(binaxis="y",stackdir="center") +
        stat_summary(fun.y="mean",goem="point",shape=23,fill="black",ymin=0,ymax=0) +
        guides(fill=FALSE) +    # don't display guide
        theme(axis.title.x=element_blank())    # don't display x-axis-label
    p1
}
jun.plot(datax.subset1)
