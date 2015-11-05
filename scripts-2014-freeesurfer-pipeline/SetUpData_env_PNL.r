# todo
# - on editing

library(xlsx)
library(knitr)    # for kable
library(ggplot2)
library(gridExtra)
library(car)    # for Anova()

base="/projects/pnl/3Tdata/freesurfer-pipeline"
statdir=paste(base,"/stats/01_CSZ",sep="")
setwd(statdir)
demographictable=paste(base,"/caselist/CIDAR_DATABASE_Scans_with_Genotyping_10-31-15_elisabetta.xlsx",sep="")
fsstatfile.aseg="aseg_stats_cidar.txt"
fsstatfile.rh="aparc_rh_stats_cidar.txt"
fsstatfile.lh="aparc_lh_stats_cidar.txt"
