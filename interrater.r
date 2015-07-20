
# read values from csv

# set input file name
inputfile=results4calcinterrater.csv
d1=read.csv(inputfile,header=TRUE)

# check the names of d1
names(d1)

# estimate ICC

testee=c("A","A","B","B","C","C","D","D","E","E")  # a vector
measured=d1[["FA_mean"]]   # a vector
r1=ICCest(testee,meaured)

# chack the names of results
names(r1)

# output results to file or ?


## file	numFibers	FA_min	FA_max	FA_mean	FA_std	trace_min	trace_max	trace_mean	trace_std	mode_min	mode_max	mode_mean	mode_std	linear_min	linear_max	linear_mean	linear_std	planar_min	planar_max	planar_mean	planar_std	spherical_min	spherical_max	spherical_mean	spherical_std	length_min	length_max	length_mean	length_std	axial_min	axial_max	axial_mean	axial_std	radial_min	radial_max	radial_mean	radial_std	scalar_min	scalar_max	scalar_mean	scalar_std	
