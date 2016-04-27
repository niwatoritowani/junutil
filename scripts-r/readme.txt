1. cat readscripts.r

source("/home/jkonishi/junutil/scripts-r/SetUpData_env_PNL.r")
source("/home/jkonishi/junutil/scripts-r/SetUpData_table.r")
source("/home/jkonishi/junutil/scripts-r/functions.r")

# analysis files

analyses_basic.r   : demographic table
analyses20151117.r : old correlation and GLM
analyses20151201.r : correlation
analyses20151203.r : ANCOVA
analyses20160209.r : ANOVA and effect size
analyses20160212.r : partial correlation
analyses20160218.r : plots 
analyses20160410.r : final version
analyses20160426.r : plots for article
