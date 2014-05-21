---
title       : Opportunity Index
subtitle    : Updating CT Opportunity Index data
author      : Scott Gaul
job         : Community Indicators Project
framework   : minimal        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
ext_widgets : {rCharts: ["libraries/nvd3"]} 
mode        : selfcontained # {standalone, draft}
---

## Opportunity Index

The [Opportunity Index](http://kirwaninstitute.osu.edu/reports/2009/11_2009_CTOppMapping_FullReport.pdf) uses 10 variables; seven of these can be retrieved from the Census Bureau's American Community Survey:
* [Educational attainment for the population](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_11_5YR_B23006) (college and associates degrees)
* [Unemployment rates](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B23025) (percent in labor force but unemployed)
* [Population on public assistance](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_11_5YR_B19058)
* [Mean commute time](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B08135) (average time to commute for residents, using the method outlined [here](http://quickfacts.census.gov/qfd/meta/long_LFE305212.htm))
* [Vacancy rate](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B25002) (percent vacant housing)
* [Poverty](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B17017) (percent below poverty line)
* [Home ownership rate](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B25008) (percent of owner-occupied homes in given housing stock)

### Census data for neighborhoods

For 'neighborhood' data, the index uses census tracts which restricts the data source to the ACS 5-year estimates. I used the [acs.R package](http://cran.r-project.org/web/packages/acs/index.html) to download census data by tract for the entire state for each of these seven variables. The most recent set of 5-year estimates spans 2008 - 2012, but the script could be updated for different years as new data becomes available.

To keep each of the variables in the same 'direction' (more homeownership is 'good,' while more poverty is 'bad'), I converted the public assistance, poverty, unemployment and vacancy to the inverse percentage (i.e. 1 - rate). For the commute times, I multiplied by (-1) so that longer commute times are lower values. 

Below are summary stats for the census data components of the index:

<!-- html table generated in R 3.0.2 by xtable 1.7-1 package -->
<!-- Tue May 20 16:52:57 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH>    college </TH> <TH> publicassistance </TH> <TH>    poverty </TH> <TH>  unemployment </TH> <TH> owneroccupied </TH> <TH>  commutetime </TH> <TH>    vacancy </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Min.   :0.142   </TD> <TD> Min.   :0.202   </TD> <TD> Min.   :0.000   </TD> <TD> Min.   :0.615   </TD> <TD> Min.   :0.000   </TD> <TD> Min.   :-45.34   </TD> <TD> Min.   :0.000   </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> 1st Qu.:0.517   </TD> <TD> 1st Qu.:0.849   </TD> <TD> 1st Qu.:0.860   </TD> <TD> 1st Qu.:0.890   </TD> <TD> 1st Qu.:0.527   </TD> <TD> 1st Qu.:-27.44   </TD> <TD> 1st Qu.:0.885   </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Median :0.666   </TD> <TD> Median :0.944   </TD> <TD> Median :0.936   </TD> <TD> Median :0.926   </TD> <TD> Median :0.793   </TD> <TD> Median :-23.95   </TD> <TD> Median :0.930   </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Mean   :0.646   </TD> <TD> Mean   :0.884   </TD> <TD> Mean   :0.890   </TD> <TD> Mean   :0.910   </TD> <TD> Mean   :0.692   </TD> <TD> Mean   :-24.77   </TD> <TD> Mean   :0.911   </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> 3rd Qu.:0.780   </TD> <TD> 3rd Qu.:0.974   </TD> <TD> 3rd Qu.:0.967   </TD> <TD> 3rd Qu.:0.945   </TD> <TD> 3rd Qu.:0.907   </TD> <TD> 3rd Qu.:-21.59   </TD> <TD> 3rd Qu.:0.959   </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> Max.   :1.000   </TD> <TD> Max.   :1.000   </TD> <TD> Max.   :1.000   </TD> <TD> Max.   :1.000   </TD> <TD> Max.   :1.000   </TD> <TD> Max.   : -8.41   </TD> <TD> Max.   :1.000   </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> NA's   :5   </TD> <TD> NA's   :7   </TD> <TD> NA's   :7   </TD> <TD> NA's   :7   </TD> <TD> NA's   :7   </TD> <TD> NA's   :8   </TD> <TD> NA's   :6   </TD> </TR>
   </TABLE>


### Town data for jobs and test scores

The remaining variables - math and reading test scores and economic climate - aren't publicly available at the neighborhood level. 

Math and reading scores are reported by the State Department of Education [at the school and district level](http://www.ctreports.com/). Since many children do not attend neighborhood schools, even if data were readily available it may  not accurately represent opportunity in a particular neighborhood. As a proxy, we use the average test scores for the school district of the town. Average test scores take into account the performance of all students, not just those crossing a particular threshold. 

A few smaller districts did not have 2013 reports, so the most recent year available was used instead. Scores for regional school districts are reported for each town in the region. Cornwall and Union did not have data for any of the past 7 years. (The index also does not specify the grade to use, so I opted to take 3rd grade reading and math scores as a fairly common milestone indicator.)

'Economic climate' was defined for the Opportunity Index as 'the change in jobs within 5 miles from 2005 to 2008,' using data from ESRI Business Analyst. To get around relying on data from ESRI, I used the [Quarterly Census of Earnings and Wages](http://www1.ctdol.state.ct.us/lmi/) series from the Bureau of Labor Statistics. The data is available by town and is a direct census of employment from wage records. I used 2009 to 2012 as the timeframe, although this does not perfectly match the census data. 

As in the prior Opportunity Index, the job change data has some outlier values, particularly for small towns (such as Barkhamsted, where employment doubled from 616 to 1145 people over the three years) and you can see this in the summary stats below (the average change is 1%, but some towns have up to 86% change). 

<!-- html table generated in R 3.0.2 by xtable 1.7-1 package -->
<!-- Tue May 20 16:53:00 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH>   jobchange </TH> <TH> Total.Mathematics.Avg.Scale.Score </TH> <TH> Total.Reading.Average.Scale.Score </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Min.   :-0.367   </TD> <TD> Min.   :212   </TD> <TD> Min.   :208   </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> 1st Qu.:-0.011   </TD> <TD> 1st Qu.:239   </TD> <TD> 1st Qu.:228   </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Median : 0.013   </TD> <TD> Median :255   </TD> <TD> Median :240   </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Mean   : 0.012   </TD> <TD> Mean   :254   </TD> <TD> Mean   :241   </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> 3rd Qu.: 0.034   </TD> <TD> 3rd Qu.:271   </TD> <TD> 3rd Qu.:257   </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> Max.   : 0.858   </TD> <TD> Max.   :298   </TD> <TD> Max.   :279   </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> NA's   :6   </TD> <TD> NA's   :7   </TD> <TD> NA's   :8   </TD> </TR>
   </TABLE>


### Calculating z-scores for the index

The Opportunity Index uses z-scores to scale the variables and calculate the index. This is important because the interpretation of the z-scores depends on how the data are distributed. If data are distributed normally ('bell-curve' style), the z-scores tell us roughly how much of the data is below or above a certain z-score. You can then also compare z-scores for different bell-curve-shaped data sets - the z-scores mean the same thing if the underlying distributions have the same shape. 

The plots below show the distribution of each of the components of the index for the 833 census tracts in Connecticut. You can see that most are not bell-curve shaped though. Rather, several are skewed, which reflects the general concentration of poverty, public assistance and related variables in a small set of neighborhoods within the state. 

![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3.png) 


If the data are not normally distributed - if, for instance, they are skewed or there are multiple modes in the data - then the z-scores can be harder to interpret. And it's also harder to compare the z-scores across variables - a z-score of 2 for poverty doesn't mean the same thing as a z-score of 2 for commute time if they don't have the same-shaped distribution. 

This matters since the opportunity index is calculated using the average z-scores across all of the variables. If the variables have different distributions, then the z-scores will have different ranges and the z-scores won't have the same interpretation or influence on the final index values. 

The charts below show the standardized results for each variable - they report the z-scores between -/+3 standard deviations for each variable. You can see that variables like poverty, public assistance, unemployment tend to have similar shapes and are skewed positive - there are many above-average tracts, but a long tail of tracts with below-average scores on these variables. 

![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-4.png) 


To see this visually, we can map each of the variables for the state. Several variables - like poverty, public assistance, unemployment - show similar patterns across tracts, while job growth and vacancy are less similar. 

![plot of chunk unnamed-chunk-5](assets/fig/unnamed-chunk-5.png) 


The next step is to calculate the opportunity index from the z-scores of the individual variables. Even this has some choices involved - the Kirwan Institute mapping uses [quintiles to color the maps](http://kirwaninstitute.osu.edu/reports/2009/11_2009_CTOppMapping_FullReport.pdf), which means 1/5th of the tracts will fall into each color category. The map below shows the updated index for the state using quintiles. 

![plot of chunk unnamed-chunk-6](assets/fig/unnamed-chunk-6.png) 


Another way of coloring the map would be to use [Jenks natural breaks](http://support.esri.com/en/knowledgebase/GISDictionary/term/natural%20breaks%20classification) method which looks for natural divisions in the data. The map below uses this coloring method for the same data.

![plot of chunk unnamed-chunk-7](assets/fig/unnamed-chunk-7.png) 


This map reflects fewer areas of 'very low' opportunity, but more areas of 'low' and 'moderate' opportunity. Another way to see this is to plot the distribution of the index values for the tracts, including the breakpoints. The chart below shows the breakpoints using the quintiles. (Again, the overall distribution is skewed positive.)

![plot of chunk unnamed-chunk-8](assets/fig/unnamed-chunk-8.png) 


And this chart shows the breakpoints using the natural breaks method. 

![plot of chunk unnamed-chunk-9](assets/fig/unnamed-chunk-9.png) 


Using quintiles means that roughly 20 percent of the population will always live in high opportunity areas (since census tracts have roughly similar population), while the Jenks breaks (or other methods) would reflect the concentration of poverty in a smaller set of areas. 

### What is driving the Opportunity Index? 

With a composite index of z-scores, it helps to see if specific variables are playing more of a role in determining the final index values. The OECD guide to composite indicators notes that using z-scores means that "indicators with extreme values thus have a greater effect on the composite indicator." That can be an issue in a state with a high degree of inequality and concentration of poverty. 

As a start, we know that many of the variables are correlated with each other - the correlation matrix below shows that several of the variables - poverty, public assistance, etc. - are correlated with each other. Job growth has almost no correlation with any of the variables. 

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Wed May 21 11:12:22 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> college </TH> <TH> publicassistance </TH> <TH> poverty </TH> <TH> unemployment </TH> <TH> owneroccupied </TH> <TH> commutetime </TH> <TH> vacancy </TH> <TH> jobchange </TH> <TH> Total.Mathematics.Avg.Scale.Score </TH> <TH> Total.Reading.Average.Scale.Score </TH>  </TR>
  <TR> <TD align="right"> college </TD> <TD align="right"> 1.00 </TD> <TD align="right"> 0.77 </TD> <TD align="right"> 0.66 </TD> <TD align="right"> 0.69 </TD> <TD align="right"> 0.66 </TD> <TD align="right"> -0.34 </TD> <TD align="right"> 0.31 </TD> <TD align="right"> 0.05 </TD> <TD align="right"> 0.70 </TD> <TD align="right"> 0.70 </TD> </TR>
  <TR> <TD align="right"> publicassistance </TD> <TD align="right"> 0.77 </TD> <TD align="right"> 1.00 </TD> <TD align="right"> 0.88 </TD> <TD align="right"> 0.81 </TD> <TD align="right"> 0.81 </TD> <TD align="right"> -0.26 </TD> <TD align="right"> 0.45 </TD> <TD align="right"> 0.02 </TD> <TD align="right"> 0.67 </TD> <TD align="right"> 0.65 </TD> </TR>
  <TR> <TD align="right"> poverty </TD> <TD align="right"> 0.66 </TD> <TD align="right"> 0.88 </TD> <TD align="right"> 1.00 </TD> <TD align="right"> 0.73 </TD> <TD align="right"> 0.84 </TD> <TD align="right"> -0.29 </TD> <TD align="right"> 0.56 </TD> <TD align="right"> 0.01 </TD> <TD align="right"> 0.64 </TD> <TD align="right"> 0.62 </TD> </TR>
  <TR> <TD align="right"> unemployment </TD> <TD align="right"> 0.69 </TD> <TD align="right"> 0.81 </TD> <TD align="right"> 0.73 </TD> <TD align="right"> 1.00 </TD> <TD align="right"> 0.65 </TD> <TD align="right"> -0.14 </TD> <TD align="right"> 0.36 </TD> <TD align="right"> -0.03 </TD> <TD align="right"> 0.54 </TD> <TD align="right"> 0.53 </TD> </TR>
  <TR> <TD align="right"> owneroccupied </TD> <TD align="right"> 0.66 </TD> <TD align="right"> 0.81 </TD> <TD align="right"> 0.84 </TD> <TD align="right"> 0.65 </TD> <TD align="right"> 1.00 </TD> <TD align="right"> -0.39 </TD> <TD align="right"> 0.49 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 0.66 </TD> <TD align="right"> 0.64 </TD> </TR>
  <TR> <TD align="right"> commutetime </TD> <TD align="right"> -0.34 </TD> <TD align="right"> -0.26 </TD> <TD align="right"> -0.29 </TD> <TD align="right"> -0.14 </TD> <TD align="right"> -0.39 </TD> <TD align="right"> 1.00 </TD> <TD align="right"> -0.09 </TD> <TD align="right"> -0.08 </TD> <TD align="right"> -0.37 </TD> <TD align="right"> -0.37 </TD> </TR>
  <TR> <TD align="right"> vacancy </TD> <TD align="right"> 0.31 </TD> <TD align="right"> 0.45 </TD> <TD align="right"> 0.56 </TD> <TD align="right"> 0.36 </TD> <TD align="right"> 0.49 </TD> <TD align="right"> -0.09 </TD> <TD align="right"> 1.00 </TD> <TD align="right"> -0.02 </TD> <TD align="right"> 0.32 </TD> <TD align="right"> 0.29 </TD> </TR>
  <TR> <TD align="right"> jobchange </TD> <TD align="right"> 0.05 </TD> <TD align="right"> 0.02 </TD> <TD align="right"> 0.01 </TD> <TD align="right"> -0.03 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> -0.08 </TD> <TD align="right"> -0.02 </TD> <TD align="right"> 1.00 </TD> <TD align="right"> 0.03 </TD> <TD align="right"> 0.05 </TD> </TR>
  <TR> <TD align="right"> Total.Mathematics.Avg.Scale.Score </TD> <TD align="right"> 0.70 </TD> <TD align="right"> 0.67 </TD> <TD align="right"> 0.64 </TD> <TD align="right"> 0.54 </TD> <TD align="right"> 0.66 </TD> <TD align="right"> -0.37 </TD> <TD align="right"> 0.32 </TD> <TD align="right"> 0.03 </TD> <TD align="right"> 1.00 </TD> <TD align="right"> 0.96 </TD> </TR>
  <TR> <TD align="right"> Total.Reading.Average.Scale.Score </TD> <TD align="right"> 0.70 </TD> <TD align="right"> 0.65 </TD> <TD align="right"> 0.62 </TD> <TD align="right"> 0.53 </TD> <TD align="right"> 0.64 </TD> <TD align="right"> -0.37 </TD> <TD align="right"> 0.29 </TD> <TD align="right"> 0.05 </TD> <TD align="right"> 0.96 </TD> <TD align="right"> 1.00 </TD> </TR>
   </TABLE>


A scatterplot matrix shows the same visually - job growth and (to a lesser extent) commute time have little obvious relationship with the other variables. 

![plot of chunk unnamed-chunk-11](assets/fig/unnamed-chunk-11.png) 


A principal components analysis shows that the first principal component dominates the results - explaining 56 percent of the overall variance in the index  (first bar in the graph, first column in the table). 

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Wed May 21 11:12:23 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> PC1 </TH> <TH> PC2 </TH> <TH> PC3 </TH> <TH> PC4 </TH> <TH> PC5 </TH> <TH> PC6 </TH> <TH> PC7 </TH> <TH> PC8 </TH> <TH> PC9 </TH> <TH> PC10 </TH>  </TR>
  <TR> <TD align="right"> Standard deviation </TD> <TD align="right"> 2.3721 </TD> <TD align="right"> 1.0697 </TD> <TD align="right"> 0.9723 </TD> <TD align="right"> 0.8904 </TD> <TD align="right"> 0.7957 </TD> <TD align="right"> 0.5817 </TD> <TD align="right"> 0.4936 </TD> <TD align="right"> 0.3927 </TD> <TD align="right"> 0.2927 </TD> <TD align="right"> 0.1887 </TD> </TR>
  <TR> <TD align="right"> Proportion of Variance </TD> <TD align="right"> 0.5627 </TD> <TD align="right"> 0.1144 </TD> <TD align="right"> 0.0945 </TD> <TD align="right"> 0.0793 </TD> <TD align="right"> 0.0633 </TD> <TD align="right"> 0.0338 </TD> <TD align="right"> 0.0244 </TD> <TD align="right"> 0.0154 </TD> <TD align="right"> 0.0086 </TD> <TD align="right"> 0.0036 </TD> </TR>
  <TR> <TD align="right"> Cumulative Proportion </TD> <TD align="right"> 0.5627 </TD> <TD align="right"> 0.6771 </TD> <TD align="right"> 0.7716 </TD> <TD align="right"> 0.8509 </TD> <TD align="right"> 0.9142 </TD> <TD align="right"> 0.9481 </TD> <TD align="right"> 0.9725 </TD> <TD align="right"> 0.9879 </TD> <TD align="right"> 0.9964 </TD> <TD align="right"> 1.0000 </TD> </TR>
   </TABLE>
![plot of chunk unnamed-chunk-12](assets/fig/unnamed-chunk-12.png) 


We can look at the weights for each of the variables in the first principal component in the chart below. This shows that job growth has little influence on the first component (weight close to 0), while commute time offsets some of the other variables (positive weight). Poverty, public assistance and owner-occupied housing have the strongest weights. 

![plot of chunk unnamed-chunk-13](assets/fig/unnamed-chunk-13.png) 


In other words, since much of the variance is explained by the first principal components and since poverty, public assistance, owner-occupied housing, educational attainment, test scores and unemployment have the most weight for that component, most of the opportunity index is described by these variables (poverty, public assistance, etc.). 

Not surprisingly, many of these variables also have skewed distributions for Connecticut, and hence a more extreme range of z-scores to factor into the overall index.

Another way to look at this is to see how well these variables predict the final index values. For example, poverty alone predicts the overall index pretty well - the R-squared is 0.78 - meaning that the variation in poverty alone explains 78% of the variation in opportunity. 

![plot of chunk unnamed-chunk-14](assets/fig/unnamed-chunk-14.png) 


Overall: 
* We can re-calculate the opportunity index using Census data and state data for towns on test scores and jobs, making some concessions for data availability on the latter variables.
* Timing is a consideration - the Census data covers a different time horizon than the other variables. (But the original index used 2000 census data and jobs data for 2005 - 2008, so this may be less of a concern.)
* The index is driven largely by poverty and variables like public assistance that are strongly correlated with poverty. 
* Different ways to display the data will yield different conclusions about the landscape of opportunity in Connecticut. 
* Job growth (economic climate) has the least influence on the index as it is uncorrelated with the other variables. 

