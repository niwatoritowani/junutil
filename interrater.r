# in project 2015-melissa
# read values from csv, calculate ICC, display the results

# set input file name in the directory where input file exists
inputfile="results_calcinterrater.csv"
d1=read.csv(inputfile,header=TRUE)

# # estimate ICC in command line
# testee=c("A","A","B","B","C","C","D","D","E","E")  # a vector
# measured=d1[["FA.mean"]]   # a vector, underbar is turend to period, 
# r1=ICCest(testee,measured)

# # chack the names of results
# names(r1)
# ## [1] "ICC"     "LowerCI" "UpperCI" "N"       "k"       "varw"    "vara" 

# estimate ICC by function
library("ICC")
func_ICC <- function(measured){
    testee=c("A","A","B","B","C","C","D","D","E","E","F","F","G","G","H","H","I","I","J","J")  # a vector
    # d1[[measured]] is a vector, underbar is turend to period, 
    r1=ICCest(testee,d1[[measured]])
    r1["ICC"]
}
func_ICC("FA.mean")
func_ICC("trace.mean")
func_ICC("radial.mean")
func_ICC("axial.mean")

# ----------------------------------------------------Begin 20150721

# set input file name in the directory where input file exists
inputfile="results_calcinterrater.csv"
d1=read.csv(inputfile,header=TRUE)
# delete row 5,6,17,18 whic are the tracts of case01229
d2=d1[c(-5,-6,-17,-18),]
# estimate ICC by function, arguments are data frame and its column 
library("ICC")
func_ICC <- function(dx,measured){
    testee=c("A","A","B","B","C","C","D","D","E","E","F","F","G","G","H","H","I","I","J","J")  # a vector
    # dx[[measured]] is a vector, underbar is turend to period, 
    r1=ICCest(testee,dx[[measured]])
    r1["ICC"]
}
func_ICC(d2,"FA.mean")
func_ICC(d2,"trace.mean")
func_ICC(d2,"radial.mean")
func_ICC(d2,"axial.mean")

# -----------------------------------------------------End of 20150721

# calculate ICC only in FA mean with separately in lh and rh
func_ICC10 <- function(dx,measured){
    testee=c("A","A","B","B","C","C","D","D","E","E")  # a vector
    # dx[[measured]] is a vector, underbar is turend to period, 
    r1=ICCest(testee,dx[[measured]])
    r1["ICC"]
}
dl=d1[c(1,2,3,4,7,8,9,10,11,12),]
dr=d1[c(13,14,15,16,19,20,21,22,23,24),]
func_ICC10(dl,"FA.mean")
func_ICC10(dr,"FA.mean")

## results 
## > dl[["FA.mean"]]
##  [1] 391.0017 388.1824 377.0024 338.7199 410.5894 405.5672 406.4336 407.7659
##  [9] 399.1161 446.5691
## > dr[["FA.mean"]]
##  [1] 326.0770 330.2872 301.0478 339.3762 371.5756 369.8417 367.8623 396.4071
##  [9] 375.4050 374.9215

# --------------------------------------------------------

# change the results of 01099-lh, 01222-lh, 01373-lh, 01222-lh, 01222-rh
inputfile="results_20150723.csv"
d3=read.csv(inputfile,header=TRUE)
# 01099-lh, 01222-lh, 01373-lh, 01222-lh, 01222-rh
dl[1,]=d3[1,]
dl[3,]=d3[2,]
dl[9,]=d3[3,]
dr[3,]=d3[4,]
dr[7,]=d3[5,]
# But this resuts are not good. So I will try to replace results in each tract. 

## > dl[["FA.mean"]]
##  [1] 377.3233 388.1824 367.7719 338.7199 410.5894 405.5672 406.4336 407.7659
##  [9] 387.3974 446.5691
## > dr[["FA.mean"]]
##  [1] 326.0770 330.2872 298.7690 339.3762 371.5756 369.8417 358.9787 396.4071
##  [9] 375.4050 374.9215

# --------------------------------------------------------

# create original dl and lr
dl=d1[c(1,2,3,4,7,8,9,10,11,12),]
dr=d1[c(13,14,15,16,19,20,21,22,23,24),]

# input the results of 01099-lh-stria.vtk
inputfile="results_201507240958.csv"
d4=read.csv(inputfile,header=TRUE)
# 01099-lh of mine is in row 1 in data dl
dl[1,]=d4[1,]
dl[["FA.mean"]]
func_ICC10(dl,"FA.mean")

# input the results of 01222-lh-stria.vtk
inputfile="results_201507241055.csv"
d5=read.csv(inputfile,header=TRUE)
# 01222-lh of mine is in row 3 in data dl
dl[3,]=d5[1,]
dl[["FA.mean"]]
func_ICC10(dl,"FA.mean")

# input the results of 01373-lh-stria.vtk
inputfile="results_201507270941.csv"
d6=read.csv(inputfile,header=TRUE)
# 01222-lh of mine is in row 9 in data dl
dl[9,]=d6[1,]
dl[["FA.mean"]]
func_ICC10(dl,"FA.mean")

# input the results of 01222-rh-stria.vtk
inputfile="results_201507271010.csv"
d7=read.csv(inputfile,header=TRUE)
# 01222-rh of mine is in row 3 in data dl
dr[3,]=d7[1,]
dr[["FA.mean"]]
func_ICC10(dr,"FA.mean")

# input the results of 01362-rh-stria.vtk
inputfile="results_201507271257.csv"
d8=read.csv(inputfile,header=TRUE)
# 01362-rh of mine is in row 7 in data dl
dr[7,]=d8[1,]
dr[["FA.mean"]]
func_ICC10(dr,"FA.mean")


# ----------------------------------------------------

# 2015/07/27
# start these command after all editing is finished

# set input file name in the directory where input file exists
inputfile="results_calcinterrater201507271333.csv"
d1=read.csv(inputfile,header=TRUE)
library("ICC")

# calculate ICC only in FA mean with separately in lh and rh
func_ICC10 <- function(dx,measured){
    testee=c("A","A","B","B","C","C","D","D","E","E")  # a vector
    # dx[[measured]] is a vector, underbar is turend to period, 
    r1=ICCest(testee,dx[[measured]])
    r1["ICC"]
}
# extract left data
dl=d1[c(1,2,3,4,5,6,7,8,9,10),]
# extract right data
dr=d1[c(11,12,13,14,15,16,17,18,19,20),]

# display FA mean data and calculate ICC. 
dl[["FA.mean"]]
dr[["FA.mean"]]
func_ICC10(dl,"FA.mean")
func_ICC10(dr,"FA.mean")

## > func_ICC10(dl,"FA.mean")
## $ICC
## [1] 0.9523677
## 
## > func_ICC10(dr,"FA.mean")
## $ICC
## [1] 0.9550325

# ----------------------------------------------------

# output results to file or ?


## file	numFibers	FA_min	FA_max	FA_mean	FA_std	trace_min	trace_max	trace_mean	trace_std	mode_min	mode_max	mode_mean	mode_std	linear_min	linear_max	linear_mean	linear_std	planar_min	planar_max	planar_mean	planar_std	spherical_min	spherical_max	spherical_mean	spherical_std	length_min	length_max	length_mean	length_std	axial_min	axial_max	axial_mean	axial_std	radial_min	radial_max	radial_mean	radial_std	scalar_min	scalar_max	scalar_mean	scalar_std	
# underbar in the first row is turend to period
# > names(d1)
#  [1] "tract"                 "Spherical.stDev"       "Spherical.minimum"    
#  [4] "Spherical.maximum"     "Spherical.mean"        "FA.stDev"             
#  [7] "FA.minimum"            "FA.maximum"            "FA.mean"              
# [10] "Planar.stDev"          "Planar.minimum"        "Planar.maximum"       
# [13] "Planar.mean"           "num_fibers.num_fibers" "Linear.stDev"         
# [16] "Linear.minimum"        "Linear.maximum"        "Linear.mean"          
# [19] "trace.stDev"           "trace.minimum"         "trace.maximum"        
# [22] "trace.mean"            "radial.stDev"          "radial.minimum"       
# [25] "radial.maximum"        "radial.mean"           "mode.stDev"           
# [28] "mode.minimum"          "mode.maximum"          "mode.mean"            
# [31] "axial.stDev"           "axial.minimum"         "axial.maximum"        
# [34] "axial.mean"            "RA.stDev"              "RA.minimum"           
# [37] "RA.maximum"            "RA.mean" 
