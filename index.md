---
title       : Connecticut Opportunity Index
subtitle    : 2015 Opportunity Index levels for Connecticut
author      : Scott Gaul
job         : Community Indicators Project
framework   : minimal        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
mode        : selfcontained # {standalone, draft}
markdown    : kramdown
---

## Opportunity Index

The following presents the methodology and indicators for the Connecticut opportunity analysis. To download the data, go [here](https://github.com/sgaul/opportunity/blob/gh-pages/opportunity-index.csv). For more on the use of Opportunity Mapping in Connecticut, see the websites for the [Open Communities Alliance](http://www.ctoca.org/opportunity_in_connecticut), the [Kirwan Institute](http://kirwaninstitute.osu.edu/) and the [Connecticut Fair Housing Center](http://www.ctfairhousing.org/).

### What is opportunity?

For this analysis, opportunity is defined as environmental conditions or resources that are conducive to healthier, vibrant communities and are associated with success in life, defined in a variety of ways. Indicators could either be impediments to opportunity (which are analyzed as negative neighborhood factors, e.g., high neighborhood poverty) or conduits to opportunity (which are analyzed as positive factors, e.g., access to an abundance of jobs). 

To map opportunity in the region, we use variables that are indicative of high and low opportunity. <i>High opportunity</i> indicators include the availability of sustainable employment, high-performing schools, a safe environment, and safe neighborhoods. A central requirement of indicator selection is a clear connection between the indicator and opportunity. 

## Data Sources

Spatial distribution of opportunity is based on indicators categorized under three sub areas of opportunity: 
* Educational
* Economic
* Neighborhood/Housing quality 

The comprehensive opportunity map represents the combined score based on these three sub-areas. 

The 2009 Opportunity Index for Connecticut was created by the Kirwan Institute working in partnership with the CT Fair Housing Center, and was based on 11 variables from public data sources; details can be found in appendix B and C [here](http://kirwaninstitute.osu.edu/reports/2009/11_2009_CTOppMapping_FullReport.pdf).

This updated 2014 Opportunity Index for Connecticut was created by the [CT Open Communities Alliance](http://www.ctoca.org/) and contributors as a joint project with the [Kirwan Institute](http://kirwaninstitute.osu.edu/) and the [Connecticut Fair Housing Center](http://www.ctfairhousing.org/), and is based on 12 variables from similar public data sources, as described below.
* Educational indicators
  * [Educational attainment for the population](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_11_5YR_B23006) (college and associates degrees)
  * [3rd grade reading test scores](http://www.ctreports.com/)
  * [3rd grade math test scores](http://www.ctreports.com/)
* Economic indicators
  * [Unemployment rates](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B23025) (percent in labor force but unemployed)
  * [Economic Climate](http://www1.ctdol.state.ct.us/lmi/)
  * [Employment Access](http://www.locationaffordability.info/lai.aspx?url=download.php)
  * [Job Diversity](http://www.locationaffordability.info/lai.aspx?url=download.php)
  * [Population on public assistance](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_11_5YR_B19058)
* Neighborhood / housing quality indicators
  * [Home ownership rate](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml)
  * [Crime rate](http://www.dpsdata.ct.gov/dps/ucr/ucr.aspx)
  * [Vacancy rate](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B25002) (percent vacant housing)
  * [Poverty](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B17017) (percent below poverty line)

### Census data for neighborhood variables

The index uses census tracts as a proxy for 'neighborhoods,' which restricts are reported as 5-year estimates from the American Community Survey. The [acs.R package](http://cran.r-project.org/web/packages/acs/index.html) uses the Census API to download data by tract for the entire state for each of these seven variables. For this project, the 2008 - 2012 5-year estimates are reported, but the script could be updated for new years as data becomes available.

To ensure that each of the variables are oriented in the same 'direction' (more homeownership is 'good,' while more poverty is 'bad'), the public assistance, poverty, unemployment and vacancy rates are converted to their inverse percentages (i.e. 1 - rate). 

### Town data: test scores

The variables for math and reading test scores and job growth aren't publicly available at the neighborhood level. 

Math and reading scores for Connecticut are reported by the State Department of Education [at the school and district level](http://www.ctreports.com/). Since many children do not attend neighborhood schools, even if data were readily available by neighborhood, it may  not accurately represent the academic performance for students residing in that neighborhood. As a proxy, the index uses the average scale scores for the local school district in each town. Average scale scores take into account the performance of all students, not just those crossing a particular threshold. The Connecticut index uses 3rd grade reading and math scores as a [standard milestone indicator for education](http://gradelevelreading.net/). 

A few smaller districts do not have 2013 reports for math and reading test scores, so the most recent year available was used instead. Cornwall and Union did not have data for any of the past seven years and thus don't report values for this variable. Scores for regional school districts were manually assigned to each town in that region, using the assignment [here](www.csde.state.ct.us/public/psis/downloads/RegionalSchoolDistrictsMemberTowns.xls). 

### Town data: economic climate and crime

"Economic climate" was defined for the original Opportunity Index as "the change in jobs within 5 miles from 2005 to 2008," using data from ESRI Business Analyst. In order to not rely on proprietary data sources, like Business Analyst, this index relies on data from the [Quarterly Census of Earnings and Wages](http://www1.ctdol.state.ct.us/lmi/) series from the Bureau of Labor Statistics. Data from this series is a direct census of employment from wage records reported by town. The index uses 2009 to 2012 as the timeframe, as the most recent available at the time of this update. 

As in the prior Opportunity Index, the job change data has some outlier values, particularly for small towns (for example, Barkhamsted, where employment doubled from 616 to 1145 people over the three years). These are noticeable in the summary stats reported below, but the effect of this should be minimized when combined with the other index components that are largely uncorrelated with this measure of economic climate.

Crime rates are reported by local authorities to the [Uniform Crime Reports](http://www.dpsdata.ct.gov/dps/ucr/ucr.aspx) database. Rates are calculated as the number of incidents in a town divided by the current population of the town. For this index, the 2010 crime rates are used as the [most recent readily-available](http://ctdata.org/visualization/total-crime) for the state.

### Employment Access and Diversity Indices
The final two variables provide new measures for access to employment and the diversity of local job markets. Data for both of these indices are drawn from the [Location Affordability Index](http://www.locationaffordability.info/) (LAI). LAI values are reported at the block group level for metro areas in Connecticut, but for the Opportunity Index the metro-level results are combined and aggregated at the census tract level in order to combine with the other variables. 

The methodology for calculating access to employment and jobs diversity is described more fully in the [LAI documentation](http://www.locationaffordability.info/LAPMethods.pdf). 

The employment access index replaces the average commute time variable from the [previous Opportunity Mapping effort](http://www.ctfairhousing.org/people-place-and-opportunity-report/) in Connecticut. The jobs access index measures potential access to jobs - indicating opportunity - rather than the actual commute times experienced by currently employed residents. The index is calculated as the number of jobs in a block group, divided by the squared distance to that block group - jobs that are closer to a given neighborhood are thus weighted more highly than jobs that are distant from that neighborhood. 

The jobs diversity index looks at the correlation between 20 major job sectors - areas with higher concentration in a few sectors are reported as having lower diversity. For instance, in Connecticut, parts of Fairfield County with a high concentration of employment in finance and insurance are reported with relatively low levels of job diversity. 

### Results for components of the Opportunity Index

Below are summary stats for the components of the index:

<!-- html table generated in R 3.0.2 by xtable 1.7-4 package -->
<!-- Mon Feb 23 09:37:31 2015 -->
<table border=1>
<tr> <th> % adults with college degree </th> <th> % not receiving public assistance </th> <th> % not in poverty </th> <th>   % employed </th> <th> % living in owner-occupied housing </th> <th> % housing that is not vacant </th> <th> Employment access index </th>  </tr>
  <tr> <td> Min.   :0.142   </td> <td> Min.   :0.202   </td> <td> Min.   :0.000   </td> <td> Min.   :0.615   </td> <td> Min.   :0.000   </td> <td> Min.   :0.000   </td> <td> Min.   :  3928   </td> </tr>
  <tr> <td> 1st Qu.:0.518   </td> <td> 1st Qu.:0.850   </td> <td> 1st Qu.:0.860   </td> <td> 1st Qu.:0.890   </td> <td> 1st Qu.:0.526   </td> <td> 1st Qu.:0.885   </td> <td> 1st Qu.: 11162   </td> </tr>
  <tr> <td> Median :0.666   </td> <td> Median :0.944   </td> <td> Median :0.936   </td> <td> Median :0.926   </td> <td> Median :0.793   </td> <td> Median :0.930   </td> <td> Median : 19149   </td> </tr>
  <tr> <td> Mean   :0.646   </td> <td> Mean   :0.884   </td> <td> Mean   :0.890   </td> <td> Mean   :0.910   </td> <td> Mean   :0.692   </td> <td> Mean   :0.912   </td> <td> Mean   : 23248   </td> </tr>
  <tr> <td> 3rd Qu.:0.780   </td> <td> 3rd Qu.:0.974   </td> <td> 3rd Qu.:0.967   </td> <td> 3rd Qu.:0.945   </td> <td> 3rd Qu.:0.907   </td> <td> 3rd Qu.:0.959   </td> <td> 3rd Qu.: 29170   </td> </tr>
  <tr> <td> Max.   :1.000   </td> <td> Max.   :1.000   </td> <td> Max.   :1.000   </td> <td> Max.   :1.000   </td> <td> Max.   :1.000   </td> <td> Max.   :1.000   </td> <td> Max.   :113840   </td> </tr>
  <tr> <td> NA's   :6   </td> <td> NA's   :8   </td> <td> NA's   :8   </td> <td> NA's   :8   </td> <td> NA's   :8   </td> <td> NA's   :7   </td> <td> NA's   :6   </td> </tr>
   </table>
<!-- html table generated in R 3.0.2 by xtable 1.7-4 package -->
<!-- Mon Feb 23 09:37:31 2015 -->
<table border=1>
<tr> <th> Job diversity index </th> <th> % change in jobs (2009-12) </th> <th> 3rd grade math, avg. scale scores </th> <th> 3rd grade reading, avg. scale scores </th> <th> Lack of crime (1 - rate) </th>  </tr>
  <tr> <td> Min.   :1719   </td> <td> Min.   :-0.367   </td> <td> Min.   :212   </td> <td> Min.   :208   </td> <td> Min.   :0.929   </td> </tr>
  <tr> <td> 1st Qu.:2219   </td> <td> 1st Qu.:-0.011   </td> <td> 1st Qu.:239   </td> <td> 1st Qu.:228   </td> <td> 1st Qu.:0.967   </td> </tr>
  <tr> <td> Median :2349   </td> <td> Median : 0.013   </td> <td> Median :255   </td> <td> Median :240   </td> <td> Median :0.979   </td> </tr>
  <tr> <td> Mean   :2468   </td> <td> Mean   : 0.012   </td> <td> Mean   :254   </td> <td> Mean   :241   </td> <td> Mean   :0.975   </td> </tr>
  <tr> <td> 3rd Qu.:2567   </td> <td> 3rd Qu.: 0.034   </td> <td> 3rd Qu.:271   </td> <td> 3rd Qu.:257   </td> <td> 3rd Qu.:0.988   </td> </tr>
  <tr> <td> Max.   :5053   </td> <td> Max.   : 0.858   </td> <td> Max.   :298   </td> <td> Max.   :279   </td> <td> Max.   :0.996   </td> </tr>
  <tr> <td> NA's   :6   </td> <td> NA's   :6   </td> <td> NA's   :7   </td> <td> NA's   :8   </td> <td> NA's   :5   </td> </tr>
   </table>

To visualize the results for each of the variables, we can map each for the state. Several variables - like poverty, public assistance, unemployment - show similar patterns across tracts, while job growth and commute times are less similar. In each case, the darker shades of orange highlight areas doing 'better' on that variable. 

![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-21.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-22.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-23.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-24.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-25.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-26.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-27.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-28.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-29.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-210.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-211.svg) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-212.svg) 

The patterns in each map correspond to the distribution of values for these indicators across the state. 

Another way to see the same patterns is to plot the distribution for the components across the 833 census tracts in Connecticut. For instance, the map of employment access shows many areas of relatively low access to employment, with concentrations of higher access to jobs along the Metro North corridor and around Hartford and I-91. That concentration is reflected in the relatively unequal distribution plotted below. 

One can see that most variables do not have 'bell-curve' shaped distributions. Rather, several are skewed, which reflects the general concentration of poverty, public assistance and related variables in a small set of neighborhoods within the state. 

![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-31.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-32.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-33.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-34.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-35.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-36.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-37.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-38.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-39.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-310.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-311.svg) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-312.svg) 

## Methodology
### Calculating z-scores for the index

The distribution of values shown above is important because it directly influences how the index is calculated. The Opportunity Index uses [z-scores](https://statistics.laerd.com/statistical-guides/standard-score.php) to scale the component variables and calculate the index. 

Z-scores are a way to standardize data by reporting how many standard deviations an observation is from the average value. The interpretation of the z-scores depends on how the data are distributed. If data are distributed normally ('bell-curve' style), the z-scores can tell us roughly how much of the data is below or above a certain z-score. You can then also compare z-scores for different bell-curve-shaped data sets - the z-scores mean the same thing if the underlying distributions have the same shape. 

If the data are not normally distributed - if, for instance, they are skewed or there are multiple modes in the data - then the z-scores can be harder to interpret. And it's also harder to compare the z-scores across variables - a z-score of 2 for poverty doesn't mean the same thing as a z-score of 2 for reading test scores if they don't have the same-shaped distribution. 

This matters since the opportunity index is calculated using the average z-scores across all of the variables. The [OECD guide to composite indicators](http://www.oecd.org/std/42495745.pdf) notes that using z-scores means that "indicators with extreme values thus have a greater effect on the composite indicator." That can be an issue in a state with a high degree of inequality and concentration of poverty. 
If the variables have different distributions, then the z-scores will have different ranges and the z-scores won't have the same interpretation or influence on the final index values. 

The charts below show the standardized results for each variable. The z-scores between -/+2 standard deviations are shown for each variable. Variables like poverty, public assistance, unemployment tend to have similar shapes and are skewed positive - there are many above-average tracts, but a long tail of tracts with below-average scores on these variables.

![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-41.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-42.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-43.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-44.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-45.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-46.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-47.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-48.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-49.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-410.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-411.svg) ![plot of chunk unnamed-chunk-4](assets/fig/unnamed-chunk-412.svg) 

We can then calculate the opportunity index as the average of the z-scores of the individual variables. The map below shows the updated index for the state. 

![plot of chunk unnamed-chunk-5](assets/fig/unnamed-chunk-5.svg) 

The Kirwan Institute mapping uses [quintiles to color the maps](http://kirwaninstitute.osu.edu/reports/2009/11_2009_CTOppMapping_FullReport.pdf), which means 1/5th of the tracts will fall into each color category. 

Another way to see this is to plot the distribution of the index values for the tracts, including the breakpoints. The chart below shows the breakpoints using the quintiles. (Again, the overall distribution is skewed positive.)

![plot of chunk unnamed-chunk-6](assets/fig/unnamed-chunk-6.png) 

Using quintiles means that roughly 20 percent of the population will always live in high opportunity areas (since census tracts have roughly similar population).

### What is driving the Opportunity Index?

With a composite index, it helps to see if specific variables are playing more of a role in determining the final index values. 

As a start, we know that many of the variables are correlated with each other - the correlation matrix below shows that several of the variables - poverty, public assistance, etc. - are correlated with each other. Job change (economic climate) has almost no correlation with any of the variables. 

<!-- html table generated in R 3.0.2 by xtable 1.7-4 package -->
<!-- Mon Feb 09 14:54:58 2015 -->
<table border=1>
<tr> <th>  </th> <th> % adults with college degree </th> <th> % not receiving public assistance </th> <th> % not in poverty </th> <th> % employed </th> <th> % living in owner-occupied housing </th> <th> % housing that is not vacant </th> <th> Employment access index </th> <th> Job diversity index </th> <th> % change in jobs (2009-12) </th> <th> 3rd grade math, avg. scale scores </th> <th> 3rd grade reading, avg. scale scores </th> <th> Lack of crime (1 - rate) </th>  </tr>
  <tr> <td align="right"> % adults with college degree </td> <td align="right"> 1.00 </td> <td align="right"> 0.77 </td> <td align="right"> 0.65 </td> <td align="right"> 0.69 </td> <td align="right"> 0.66 </td> <td align="right"> 0.30 </td> <td align="right"> -0.34 </td> <td align="right"> -0.23 </td> <td align="right"> 0.05 </td> <td align="right"> 0.69 </td> <td align="right"> 0.70 </td> <td align="right"> 0.53 </td> </tr>
  <tr> <td align="right"> % not receiving public assistance </td> <td align="right"> 0.77 </td> <td align="right"> 1.00 </td> <td align="right"> 0.88 </td> <td align="right"> 0.80 </td> <td align="right"> 0.81 </td> <td align="right"> 0.45 </td> <td align="right"> -0.60 </td> <td align="right"> -0.29 </td> <td align="right"> 0.02 </td> <td align="right"> 0.66 </td> <td align="right"> 0.64 </td> <td align="right"> 0.67 </td> </tr>
  <tr> <td align="right"> % not in poverty </td> <td align="right"> 0.65 </td> <td align="right"> 0.88 </td> <td align="right"> 1.00 </td> <td align="right"> 0.73 </td> <td align="right"> 0.84 </td> <td align="right"> 0.56 </td> <td align="right"> -0.63 </td> <td align="right"> -0.35 </td> <td align="right"> 0.02 </td> <td align="right"> 0.64 </td> <td align="right"> 0.62 </td> <td align="right"> 0.65 </td> </tr>
  <tr> <td align="right"> % employed </td> <td align="right"> 0.69 </td> <td align="right"> 0.80 </td> <td align="right"> 0.73 </td> <td align="right"> 1.00 </td> <td align="right"> 0.66 </td> <td align="right"> 0.35 </td> <td align="right"> -0.52 </td> <td align="right"> -0.20 </td> <td align="right"> -0.03 </td> <td align="right"> 0.54 </td> <td align="right"> 0.53 </td> <td align="right"> 0.54 </td> </tr>
  <tr> <td align="right"> % living in owner-occupied housing </td> <td align="right"> 0.66 </td> <td align="right"> 0.81 </td> <td align="right"> 0.84 </td> <td align="right"> 0.66 </td> <td align="right"> 1.00 </td> <td align="right"> 0.49 </td> <td align="right"> -0.65 </td> <td align="right"> -0.35 </td> <td align="right"> -0.00 </td> <td align="right"> 0.66 </td> <td align="right"> 0.64 </td> <td align="right"> 0.64 </td> </tr>
  <tr> <td align="right"> % housing that is not vacant </td> <td align="right"> 0.30 </td> <td align="right"> 0.45 </td> <td align="right"> 0.56 </td> <td align="right"> 0.35 </td> <td align="right"> 0.49 </td> <td align="right"> 1.00 </td> <td align="right"> -0.24 </td> <td align="right"> -0.27 </td> <td align="right"> -0.02 </td> <td align="right"> 0.32 </td> <td align="right"> 0.29 </td> <td align="right"> 0.29 </td> </tr>
  <tr> <td align="right"> Employment access index </td> <td align="right"> -0.34 </td> <td align="right"> -0.60 </td> <td align="right"> -0.63 </td> <td align="right"> -0.52 </td> <td align="right"> -0.65 </td> <td align="right"> -0.24 </td> <td align="right"> 1.00 </td> <td align="right"> 0.15 </td> <td align="right"> 0.09 </td> <td align="right"> -0.48 </td> <td align="right"> -0.46 </td> <td align="right"> -0.67 </td> </tr>
  <tr> <td align="right"> Job diversity index </td> <td align="right"> -0.23 </td> <td align="right"> -0.29 </td> <td align="right"> -0.35 </td> <td align="right"> -0.20 </td> <td align="right"> -0.35 </td> <td align="right"> -0.27 </td> <td align="right"> 0.15 </td> <td align="right"> 1.00 </td> <td align="right"> -0.05 </td> <td align="right"> -0.37 </td> <td align="right"> -0.36 </td> <td align="right"> -0.41 </td> </tr>
  <tr> <td align="right"> % change in jobs (2009-12) </td> <td align="right"> 0.05 </td> <td align="right"> 0.02 </td> <td align="right"> 0.02 </td> <td align="right"> -0.03 </td> <td align="right"> -0.00 </td> <td align="right"> -0.02 </td> <td align="right"> 0.09 </td> <td align="right"> -0.05 </td> <td align="right"> 1.00 </td> <td align="right"> 0.03 </td> <td align="right"> 0.05 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td align="right"> 3rd grade math, avg. scale scores </td> <td align="right"> 0.69 </td> <td align="right"> 0.66 </td> <td align="right"> 0.64 </td> <td align="right"> 0.54 </td> <td align="right"> 0.66 </td> <td align="right"> 0.32 </td> <td align="right"> -0.48 </td> <td align="right"> -0.37 </td> <td align="right"> 0.03 </td> <td align="right"> 1.00 </td> <td align="right"> 0.96 </td> <td align="right"> 0.77 </td> </tr>
  <tr> <td align="right"> 3rd grade reading, avg. scale scores </td> <td align="right"> 0.70 </td> <td align="right"> 0.64 </td> <td align="right"> 0.62 </td> <td align="right"> 0.53 </td> <td align="right"> 0.64 </td> <td align="right"> 0.29 </td> <td align="right"> -0.46 </td> <td align="right"> -0.36 </td> <td align="right"> 0.05 </td> <td align="right"> 0.96 </td> <td align="right"> 1.00 </td> <td align="right"> 0.76 </td> </tr>
  <tr> <td align="right"> Lack of crime (1 - rate) </td> <td align="right"> 0.53 </td> <td align="right"> 0.67 </td> <td align="right"> 0.65 </td> <td align="right"> 0.54 </td> <td align="right"> 0.64 </td> <td align="right"> 0.29 </td> <td align="right"> -0.67 </td> <td align="right"> -0.41 </td> <td align="right"> 0.00 </td> <td align="right"> 0.77 </td> <td align="right"> 0.76 </td> <td align="right"> 1.00 </td> </tr>
   </table>

Principal components analysis is another way to see the key factors that determine the final index. A principal components analysis of the index data shows that the first principal component dominates the results - explaining 56 percent of the overall variance in the data (first bar in the graph, first column in the table). 

<!-- html table generated in R 3.0.2 by xtable 1.7-4 package -->
<!-- Mon Feb 09 15:02:12 2015 -->
<table border=1>
<tr> <th>  </th> <th> PC1 </th> <th> PC2 </th> <th> PC3 </th> <th> PC4 </th> <th> PC5 </th> <th> PC6 </th> <th> PC7 </th> <th> PC8 </th> <th> PC9 </th> <th> PC10 </th> <th> PC11 </th> <th> PC12 </th>  </tr>
  <tr> <td align="right"> Standard deviation </td> <td align="right"> 2.5833 </td> <td align="right"> 1.0526 </td> <td align="right"> 0.9919 </td> <td align="right"> 0.9760 </td> <td align="right"> 0.8644 </td> <td align="right"> 0.7534 </td> <td align="right"> 0.5534 </td> <td align="right"> 0.4528 </td> <td align="right"> 0.4384 </td> <td align="right"> 0.3793 </td> <td align="right"> 0.2920 </td> <td align="right"> 0.1875 </td> </tr>
  <tr> <td align="right"> Proportion of Variance </td> <td align="right"> 0.5561 </td> <td align="right"> 0.0923 </td> <td align="right"> 0.0820 </td> <td align="right"> 0.0794 </td> <td align="right"> 0.0623 </td> <td align="right"> 0.0473 </td> <td align="right"> 0.0255 </td> <td align="right"> 0.0171 </td> <td align="right"> 0.0160 </td> <td align="right"> 0.0120 </td> <td align="right"> 0.0071 </td> <td align="right"> 0.0029 </td> </tr>
  <tr> <td align="right"> Cumulative Proportion </td> <td align="right"> 0.5561 </td> <td align="right"> 0.6484 </td> <td align="right"> 0.7304 </td> <td align="right"> 0.8098 </td> <td align="right"> 0.8721 </td> <td align="right"> 0.9194 </td> <td align="right"> 0.9449 </td> <td align="right"> 0.9620 </td> <td align="right"> 0.9780 </td> <td align="right"> 0.9900 </td> <td align="right"> 0.9971 </td> <td align="right"> 1.0000 </td> </tr>
   </table>
![plot of chunk unnamed-chunk-8](assets/fig/unnamed-chunk-8.png) 

We can look at the weights for each of the variables in the first principal component in the chart below. This shows that job growth has little influence on the first component (weight close to 0), while job diversity and access to employment offset some of the other variables (positive weight). Poverty, public assistance and owner-occupied housing have the strongest weights. In other words, access to jobs and job diversity are counterbalanced by areas with high poverty and low home-ownership - which roughly matches the patterns in the maps of the index components above. 

![plot of chunk unnamed-chunk-9](assets/fig/unnamed-chunk-9.png) 

Not surprisingly, many of the same variables have very skewed distributions across Connecticut neighborhoods, and hence a more extreme range of z-scores to factor into the overall index.




