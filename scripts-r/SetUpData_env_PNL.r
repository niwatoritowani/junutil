
library(xlsx)
library(knitr)    # for kable
library(ggplot2)
library(gridExtra)
library(car)    # for Anova()
library(ppcor) # for pcor.test partial correlation analysis

#setwd("/projects/schiz/3Tprojects/2015-jun-prodrome/stats/02_editedfreesurfer") # commented out on 2016/06/15
setwd("/rfanfs/pnl-zorro/projects/2015-jun-prodrome/stats/02_editedfreesurfer") # added on 2016/06/15
#demographictable="/projects/schiz/3Tprojects/2015-jun-prodrome/caselist/Caselist_CC_prodromes.xlsx"
demographictable="/rfanfs/pnl-zorro/Collaborators/jun/2015-jun-prodrome/caselist/Caselist_CC_prodromes.xlsx"
fsstatfile.aseg="edited.aseg_stats.txt"
fsstatfile.rh="edited.aparc_stats_rh_volume.txt"
fsstatfile.lh="edited.aparc_stats_lh_volume.txt"
