# ----------------
# statistics
# ----------------


# function jun.lm

jun.lm <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    options(contrasts =c("contr.treatment","contr.poly")) # default contrast
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
    print(s[["call"]]);     # show model
    print(s[["coefficients"]][,c(1,4)])
#    print(anova(r))    # for anova
}
jun.lms=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {jun.lm(item[j],datacol[i],arg3)}}
}


# function jun.an, jun.ans

jun.an <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
    cat("---------------------------\n")
    print(s[["call"]]);    # show model
#    print(s[["coefficients"]][,c(1,4)])
    print(Anova(r,type=3))    # show anova type3
}
jun.ans=function(item,datacol,arg3){
    m=length(item); n=length(datacol)
    for ( j in 1:m) {for ( i in 1:n ) {jun.an(item[j],datacol[i],arg3)}}
}


# jun.an2
#     - corrected to display also F value in addition to p value.
#     - This was copied from analyses20151203.r 2016/02/09. 

jun.an2 <- function(arg1,arg2,arg3){
    # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
    options(contrasts = c("contr.sum", "contr.sum")) # for Anova()
    txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
    txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
    eval(parse(text=txt0)); s=summary(r)
#    cat("---------------------------\n")
#    print(s[["call"]]);    # show model
#    print(s[["coefficients"]][,c(1,4)])
    an=Anova(r,type=3)    # substitute anova type3
    F.p=data.frame(region=arg1,F=an["F value"][2,],p=an["Pr(>F)"][2,])
    F.p
}
jun.ans2=function(item,datacol,arg3){
    m=length(item); n=length(datacol); output=data.frame();
    for ( j in 1:m) {for ( i in 1:n ) {
        output=rbind(output,jun.an2(item[j],datacol[i],arg3))}
    }
    output
}


# function mkpvalmtx

mkpvalmtx <- function(datax,items,models) {
    library(car) # for Anova()
    options(contrasts = c("contr.sum", "contr.sum")) # for Anova(), or interaction 
    funclm <- function(arg1,arg2,arg3){
        # arg1:character; arg2:character;arg3:character; r=lm(arg1~arg2arg3,data=datax)
        txt1="r=lm("; txt2=arg1; txt3="~"; txt4=arg2; txt5=arg3;txt6=",data=datax)"
        txt0=paste(txt1,txt2,txt3,txt4,txt5,txt6,sep="")
        eval(parse(text=txt0)); s=summary(r)
        Anova(r,type=3)["GROUP","Pr(>F)"]   # output
    }
    pvaluesmatrix=matrix(0,length(models),length(items))
    rownames(pvaluesmatrix)=c(1:length(models))   # need to initializing the rownames
    colnames(pvaluesmatrix)=items
    for ( j in ( 1:length(models) ) ) {
        rownames(pvaluesmatrix)[j]=paste("Volume ~",models[j])
        for ( i in ( 1 : length(items) ) ) {
            pvaluesmatrix[j,i]=funclm(items[i],"",models[j])
        }
    }
    pvaluesmatrix
}


# function jun.cor.test

jun.cor.test <- function (items.row,items.col,items.ana,datax) {
    n=length(items.row)   # i
    m=length(items.col)   # j
    o=length(items.ana)   # k
    arr=array(0,dim=c(n,m,o))
    dimnames(arr)=list(items.row,items.col,items.ana)
    for (k in 1:o) {
        for (j in 1:m) {
            for (i in 1:n) {
                arr[i,j,k]=cor.test(datax[[items.row[i]]],datax[[items.col[j]]],method="spearman")[[items.ana[k]]]
            }
        }
    }
    arr
}


# function jun.cor.test.lowtri
#     - 2016/04/11
#     - the jun.cor.test was modified
#     - This creates lower triangular matrix with corerlation-analyses-results as componets.
#     - for(j in 1:(m-1)){for(i in 1+j:(n-1)){cat(i);cat(":");cat(j);cat("\n")}}
#     - You can change NA to 0 as below : matrix1[(is.na(matrix1)]=0
#     - set default method as "spearman" and you can change the correlation-method

jun.cor.test.lowtri <- function (items.row,items.col,items.ana,datax,mtd="spearman") {
    n=length(items.row)   # i
    m=length(items.col)   # j
    o=length(items.ana)   # k
    arr=array(NA,dim=c(n,m,o))
    dimnames(arr)=list(items.row,items.col,items.ana)
    for (k in 1:o) {
        for (j in 1:(m-1)) {
            for (i in 1+j:(n-1)) {
                arr[i,j,k]=cor.test(datax[[items.row[i]]],datax[[items.col[j]]],method=mtd)[[items.ana[k]]]
            }
        }
    }
    arr
}




# function jun.cor.test.ps
#     - 2016/02/10
#     - created from jun.cor.test
#     - change method from spearman to pearson

jun.cor.test.ps <- function (items.row,items.col,items.ana,datax) {
    n=length(items.row)   # i
    m=length(items.col)   # j
    o=length(items.ana)   # k
    arr=array(0,dim=c(n,m,o))
    dimnames(arr)=list(items.row,items.col,items.ana)
    for (k in 1:o) {
        for (j in 1:m) {
            for (i in 1:n) {
                arr[i,j,k]=cor.test(datax[[items.row[i]]],datax[[items.col[j]]],method="pearson")[[items.ana[k]]]
            }
        }
    }
    arr
}


# partial correlation analysis
#     - created in 2016/03/04 in analyses20160212.r 
#     - for stacked data. This includes "values" and "ind" by default.
#     - input  : x, y, covariate, method, output items (p, rho, ...)
#     - output : 3dim-array with y ~ (p, rho, ...) ~ methods (pearson, spearman, ...)

jun.pcor.test0 <- function(fieldx,fieldy,fieldcov,method1="pearson",datax=datax) {
    datax1=datax[c(fieldx,fieldy,fieldcov)]    # extract necessary field for pcor.test
    datax2=na.omit(datax1)        # missing values are not allowed for pcor.test
    pcor.test(datax2[[fieldx]],datax2[[fieldy]],as.numeric(datax2[[fieldcov]]),method=method1)
    # should be [[]] but not []
}

jun.pcor.test01 <- function(items1,items.ana,methods1, datax=datax, showresults=FALSE) {
    l=length(items.ana);  # l-h
    m=length(methods1);   # m-i
    n=length(items1);     # m-j
    arr=array(0,dim=c(n,l,m))
    dimnames(arr)=list(items1, items.ana, methods1)  # the order is correspond to l, m, n
    for (j in 1:n) {            # cat("for parameters, i is",i,"\n") # for debug
        for (i in 1:m) {        # cat("for method, j is", j, "\n")   # for debug
            if (showresults) {  # optional
                cat("\n\npartial correlation between","values","and",items1[i],"with","ind","as a covariate\n\n")
                result1=jun.pcor.test0("values",items1[j],"ind",methods1[i],datax)
                print(result1)
            }
            for (h in 1:l) {
                # cat("h,i,j is", h,i,j, "\n"); cat("items.ana[",h,"] is",items.ana[h], "\n\n")  # for debug
                arr[j,h,i]=jun.pcor.test0("values",items1[j],"ind",methods1[i],datax)[[items.ana[h]]]
                # shoud be [[]] but not []
            }
        }
    }
    arr
}

# examples
#     field.names=c("Right.Hippocampus","Left.Hippocampus")
#     data.hip=jun.stack(field.names,c("caseid2","GROUP","ICV","GAFC","SIPTOTEV","SINTOTEV"))
#     items1=c("GAFC","SIPTOTEV","SINTOTEV")
#     items.ana=c("estimate","p.value")
#     methods1=c("pearson","spearman")
#     jun.pcor.test01(items1,items.ana,methods1,data.lv, showresults=FALSE)




# function sigmtx

sigmtx <- function(mtx) {
    mask.mtx=(mtx < 0.05)                          # mask for under 0.05
    sig.mtx=mtx
    sig.mtx[!mask.mtx]=NA
    sig.mtx
}


# function jun.heatmap

jun.heatmap <- function(sig.mtx) {
    sig.mtx=as.matrix(sig.mtx)    # in case sig.mtx is a data.frame, This does not work why?
    pvalues=as.numeric(sig.mtx)
    xaxis=rep(rownames(sig.mtx),length(colnames(sig.mtx)))
    yaxis=c()
    for ( arg in colnames(sig.mtx) ) {yaxis=c(yaxis,rep(arg,length(rownames(sig.mtx))))}
    forplot=data.frame(xaxis,yaxis,pvalues)
    p=ggplot(forplot, aes(x=xaxis,y=yaxis,fill=pvalues)) 
    p + geom_tile() +
        theme(axis.text.x=element_text(angle=90,hjust=1,vjust=.5)) +
        scale_fill_gradient(low="green",high="white") + 
        theme(axis.title.x=element_blank()) +
        theme(axis.title.y=element_blank())
}


# function extractsigsig

extractsig <- function(sig.mtx) {
    mask.mtx=!is.na(sig.mtx)
    mask.vec.num=apply(mask.mtx,1,sum)
    mask.vec=as.logical(mask.vec.num)
    subset=sig.mtx[mask.vec,]
    subset
}


# function sigmtx.rho
#     - function name includes "rho" but thic can be used for "r". 2016/05/23

sigmtx.rho <- function(p.mtx,rho.mtx) {
    mask.p.mtx=(p.mtx < 0.05)                          # mask for under 0.05
    sig.rho.mtx=rho.mtx
    sig.rho.mtx[!mask.p.mtx]=NA
    sig.rho.mtx
}


# function jun.heatmap.rho

jun.heatmap.rho <- function(sig.mtx) {
    sig.mtx=as.matrix(sig.mtx)    # in case sig.mtx is a data.frame, This does not work why?
    rho=as.numeric(sig.mtx)
    xaxis=rep(rownames(sig.mtx),length(colnames(sig.mtx)))
    yaxis=c()
    for ( arg in colnames(sig.mtx) ) {yaxis=c(yaxis,rep(arg,length(rownames(sig.mtx))))}
    forplot=data.frame(xaxis,yaxis,rho)
    p=ggplot(forplot, aes(x=xaxis,y=yaxis,fill=rho))
    p + geom_tile() +
        theme(axis.text.x=element_text(angle=90,hjust=1,vjust=.5)) +
        scale_fill_gradient(low="blue",high="red") + 
        theme(axis.title.x=element_blank()) +
        theme(axis.title.y=element_blank())
}


# function extractsigsig.rho

extractsig.rho <- function(sig.p.mtx,sig.rho.mtx) {
    mask.p.mtx=!is.na(sig.p.mtx)
    mask.p.vec.num=apply(mask.p.mtx,1,sum)
    mask.p.vec=as.logical(mask.p.vec.num)
    subset.rho=sig.rho.mtx[mask.p.vec,]
    subset.rho
}


# function mtx.adjust

mtx.adjust <- function(pvaluesmatrix,meth){
    mtx.adjusted=matrix(p.adjust(as.matrix(pvaluesmatrix),meth),,2)
    rownames(mtx.adjusted)=rownames(pvaluesmatrix)
    colnames(mtx.adjusted)=colnames(pvaluesmatrix)
    mtx.adjusted
}


# wilcox_text(variable1~factor1),distribution="exact")

library(coin) # for wilcox_text
jun.wilcox_test <- function(variable1,factor){
        wilcox_test(datax[[variable1]]~datax[[factor]],distribution="exact")
}
jun.wilcox_tests <- function(variables1,factors){
        n=length(variables1);m=length(factors)
    for(j in 1:n){for(i in 1:m){
        cat("------------\n")
        cat(variables1[j],"-",factors[i],"\n")
        r=jun.wilcox_test(variables1[j],factors[i])}
        print(r)
    }
}

# example
# items=c(regions2,regions2x); factors="GROUP"; jun.wilcox_tests(items,factors)


# brunner.munzel.test(subset(datax,GROUP=="PRO")$volume, subset(datax,GROUP=="HVPRO")$volume)

library(lawstat) # for brunner.munze.test
jun.brunner.munzel.test = function(item){
    x=subset(datax,GROUP=="PRO")[[item]]
    y=subset(datax,GROUP=="HVPRO")[[item]]
        brunner.munzel.test(x,y)
}
jun.prunner.munzel.tests = function(items){
    n=length(items)
    for (i in 1:n){
        cat("------------\n")
        cat(items[i],"\n")
        r=jun.brunner.munzel.test(items[i])
        print(r)
    }
}

# example
# items=c(regions2,regions2x); jun.prunner.munzel.tests(items)


# jun.stack
#     - for rANOVA
#     - from analyses20151203.r
#     - "datax=datax" was added as a default argument. 2016/03/04
#         - This did not work. So it was deleted. 2016/03/09

jun.stack <- function(fieldnames1, fieldnames2){
    datax.stack=stack(datax[fieldnames1])
    datax.stack[fieldnames2]=datax[fieldnames2]
    datax.stack
}




