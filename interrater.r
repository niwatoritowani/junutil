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
# delete row 5,6,17,18 whic are the tracts of case01299
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
