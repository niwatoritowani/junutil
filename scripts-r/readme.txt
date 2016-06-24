1. read set up files. 

- in the "readscripts.r", there are code for reading setup files
- command

    cat readscripts.r

- output of "cat readscripts.r"

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
analyses_statistics.r : edited analyses20160410.r
analyses_plots.r      : edited analyses20160426.r
    - trun code into function but difficult to generalize
analyses_statistics_additems.r : add many items for analyses
analyses20160610.r : based on analyses_statistics_additems.r
    - exclude 3 cases -> exclude 4 cases. 2016/06/15
script201606141520.r : for reference
script20160614.r     : for reference
analyses20160615.r   : based on analyses20160610.r
    - include data in t1 and t2
    - add shapiro test, 2016/06/20.
    - add "*36" for multiple comparisons, 2016/06/23.
analyses20160616.r   : based on analyses20160615.r
    - calculate mean sd ...
analyses_plots20160622.r : based on analyses_plots.r
    - hemisphere-combined version
