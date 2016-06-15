# "caseid" in a table in /rfanfs/pnl-zorro/projects/2015-jun-prodrome/stats/20160609/script20160610.r
# "caseid2" in a table in junutil/scripts-r/SetUpData_table.r

# workin in a new directory
WORKDIR="/rfanfs/pnl-zorro/projects/2015-jun-prodrome/stats/20160614"
setwd(WORKDIR)
setwd("/rfanfs/pnl-zorro/projects/2015-jun-prodrome/stats/20160609")
source("script20160610.r")
data.t1t2=datax
source("/home/jkonishi/junutil/scripts-r/SetUpData_env_PNL.r")
# The above script setwd("/projects/schiz/3Tprojects/2015-jun-prodrome/stats/02_editedfreesurfer")
# The directory should be changed to the directory in /rfanfs/pnl-zorro
source("/home/jkonishi/junutil/scripts-r/SetUpData_table.r")
source("/home/jkonishi/junutil/scripts-r/functions.r")
data.str=data.ex3.exna
setwd(WORKDIR)

run=function(cmd){cat(cmd,"\n",sep="");eval(parse(text=cmd))}

d1=data.str
d2=data.t1t2
run('print(d1["caseid2"])')  # data.frame
run('print(d2["caseid"]')  # data.frame
run('d1 %in% d2')
run('d2 %in% d2')
run('dim(d1)')
run('dim(d2)')
d=merge(d1,d2,by.x="caseid2",by.y="caseid")
run('dim(d)')

# example
d1=c("a","b","c","d","e")
d2=c(1,2,3,4,5)
d3=c("a","b","d","f","g")
d4=c(6,7,8,9,10)
d5=data.frame(d1,d2); print(d5)
d6=data.frame(d3,d2=d4); print(d6)
d7=merge(d5,d6,by.x="d1",by.y="d3"); print(d7)
# > d7
#   d1 d2.x d2.y
# 1  a    1    6
# 2  b    2    7
# 3  d    4    8
d8=merge(d5,d6,by.x="d1",by.y="d3",suffixes = c("",".new")); print(d8)
# > d8=merge(d5,d6,by.x="d1",by.y="d3",suffixes = c("",".new")); print(d8)
#   d1 d2 d2.new
# 1  a  1      6
# 2  b  2      7
# 3  d  4      8
d9=c("a","c","g")
d9 %in% d1 # Use for vector
# [1]  TRUE  TRUE FALSE
d9 %in% d3
# [1]  TRUE FALSE  TRUE
d1 %in% d9
# [1]  TRUE FALSE  TRUE FALSE FALSE
d3 %in% d9
# [1]  TRUE FALSE FALSE FALSE  TRUE
d5[1] %in% d6[1] # ???
# [1] TRUE
d5[[1]] %in% d6[[1]]
# [1]  TRUE  TRUE FALSE  TRUE FALSE

cmd='print("example")'
cat(cmd,sep="\n");eval(parse(text=cmd))
run=function(cmd){cat(cmd,"\n",sep="");eval(parse(text=cmd))}
run('print("example")')
run('d3 %in% d9')
run('d1 %in% d9; d3 %in% d9') # This doesn't work
run=function(cmd){
    cat(cmd,"\n",sep="")
    eval(parse(text=cmd))
}
run('d1 %in% d9; d3 %in% d9') # This doesn't work
