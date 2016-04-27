# # set data in vaio, home PC

library(xlsx)
library(knitr)    # for kable
library(ggplot2)
library(gridExtra)
library(car)    # for Anova()

setwd("C:/Users/jun/Documents/test")
setwd("02")  # 2015/10/27
#demographictable="Caselist_CC_prodromes.xlsx"    # commented out 2016/04/26
demographictable="Caselist_CC_prodromes_anon_jun.xlsx" # 2016/04/26
fsstatfile.aseg="edited.aseg_stats.txt"
fsstatfile.rh="edited.aparc_stats_rh_volume.txt"
fsstatfile.lh="edited.aparc_stats_lh_volume.txt"

