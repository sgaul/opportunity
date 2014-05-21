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
markdown    : kramdown
---

## Opportunity Index



### Census data for neighborhoods



<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Wed May 21 12:05:44 2014 -->
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



![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3.png) 


If the data are not normally distributed - if, for instance, they are skewed or there are multiple modes in the data - then the z-scores can be harder to interpret. And it's also harder to compare the z-scores across variables - a z-score of 2 for poverty doesn't mean the same thing as a z-score of 2 for commute time if they don't have the same-shaped distribution. 

This matters since the opportunity index is calculated using the average z-scores across all of the variables. If the variables have different distributions, then the z-scores will have different ranges and the z-scores won't have the same interpretation or influence on the final index values. 

The charts below show the standardized results for each variable - they report the z-scores between -/+3 standard deviations for each variable. You can see that variables like poverty, public assistance, unemployment tend to have similar shapes and are skewed positive - there are many above-average tracts, but a long tail of tracts with below-average scores on these variables. 

![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-4.png) 


To see this visually, we can map each of the variables for the state. Several variables - like poverty, public assistance, unemployment - show similar patterns across tracts, while job growth and vacancy are less similar. 

![plot of chunk unnamed-chunk-5](assets/fig/unnamed-chunk-5.png) 



![plot of chunk unnamed-chunk-6](assets/fig/unnamed-chunk-6.png) 




![plot of chunk unnamed-chunk-7](assets/fig/unnamed-chunk-7.png) 


This map reflects fewer areas of 'very low' opportunity, but more areas of 'low' and 'moderate' opportunity. Another way to see this is to plot the distribution of the index values for the tracts, including the breakpoints. The chart below shows the breakpoints using the quintiles. (Again, the overall distribution is skewed positive.)

![plot of chunk unnamed-chunk-8](assets/fig/unnamed-chunk-8.png) 


And this chart shows the breakpoints using the natural breaks method. 

![plot of chunk unnamed-chunk-9](assets/fig/unnamed-chunk-9.png) 


Using quintiles means that roughly 20 percent of the population will always live in high opportunity areas (since census tracts have roughly similar population), while the Jenks breaks (or other methods) would reflect the concentration of poverty in a smaller set of areas. 

### What is driving the Opportunity Index? 


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




![plot of chunk unnamed-chunk-13](assets/fig/unnamed-chunk-13.png) 




![plot of chunk unnamed-chunk-14](assets/fig/unnamed-chunk-14.png) 




