library(ggplot2)
library(reshape)
library(acs)
library(maps)
library(maptools)

#Set up Census API key
key = "ba67d3a427e1f785987b9c8bc59341bf7c8a7cc1"
api.key.install(key)

#Load the UConn tract and town-level shapefiles for maps
CTTracts <- readShapeSpatial(fn="../regionalreport/tractct_37800_0000_2010_s100_census_1_shp/wgs84/tractct_37800_0000_2010_s100_census_1_shp_wgs84")
CTTracts <- fortify(CTTracts, region = "NAME10")
CTTracts <- CTTracts[order(CTTracts$order),]

#Create tracts for the state
ct.tracts = geo.make(state = "CT", county = "*", tract = "*", check = T)

#Percent of population on public assistance
#http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_11_5YR_B19058
B19058 = acs.fetch(geography = ct.tracts, table.number = "B19058", col.names = "pretty", endyear = 2012)

B19058.rate = divide.acs(numerator=B19058[,2],denominator=B19058[,1])

B19058.tract = data.frame(geo=geography(B19058)[[1]],
                              publicassistance= 1 - as.numeric(estimate(B19058.rate)))

#Percent of population with college degree including associate degree
#http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_11_5YR_B23006
B23006 = acs.fetch(geography = ct.tracts, table.number = "B23006", col.names = "pretty", endyear = 2012)

B23006.rate = divide.acs(numerator=(B23006[,16]+B23006[,23]),denominator=B23006[,1])

B23006.tract = data.frame(geo=geography(B23006)[[1]],
                              college= as.numeric(estimate(B23006.rate)))

#Neighborhood poverty rate
B17017 = acs.fetch(geography = ct.tracts, table.number = "B17017", col.names = "pretty", endyear = 2012)

B17017.rate = divide.acs(numerator=B17017[,2], denominator=B17017[,1])

B17017.tract = data.frame(geo=geography(B17017)[[1]], 
                     poverty= 1 - as.numeric(estimate(B17017.rate)))

#Unemployment rate
B23025 = acs.fetch(geography = ct.tracts, table.number = "B23025", col.names = "pretty", endyear = 2012)

B23025.rate = divide.acs(numerator=B23025[,5],denominator=B23025[,2])

B23025.tract = data.frame(geo=geography(B23025)[,1],
                              employment= 1 - as.numeric(estimate(B23025.rate)))

#Home ownership rate - % of owner-occupied homes in housing stock
B25008 = acs.fetch(geography = ct.tracts, table.number = "B25008", col.names = "pretty", endyear = 2012)

B25008.rate = divide.acs(numerator=B25008[,2],denominator=B25008[,1])

B25008.tract = data.frame(geo=geography(B25008)[[1]],
                          owneroccupied= as.numeric(estimate(B25008.rate)))

#Mean commute time, method here: http://quickfacts.census.gov/qfd/meta/long_LFE305212.htm
B08135 = acs.fetch(geography = ct.tracts, table.number = "B08135", col.names = "pretty", endyear = 2012)
B99084 = acs.fetch(geography = ct.tracts, table.number = "B99084", col.names = "pretty", endyear = 2012)

B08135.rate = divide.acs(numerator=B08135[,1],denominator=B99084[,2])

#Multiply commute time by (-1) so that long commute times are bad
B08135.tract = data.frame(geo=geography(B08135)[[1]],
                          commutetime= - as.numeric(estimate(B08135.rate)))

#Neighborhood vacancy rate
B25002 = acs.fetch(geography = ct.tracts, table.number = "B25002", col.names = "pretty", endyear = 2012)

B25002.rate = divide.acs(numerator=B25002[,3],denominator=B25002[,1])

B25002.tract = data.frame(geo=geography(B25002)[[1]],
                          vacancy= 1 - as.numeric(estimate(B25002.rate)))

#Economic climate - change in # of jobs 2005 - 2008 within 5 miles
#Use qcew data instead - from here


#Math test scores
#Reading test scores

#Merge the variables into one data frame

oppdata <- data.frame(B23006.tract,
                      B19058.tract[2], 
                      B17017.tract[2],
                      B23025.tract[2],
                      B25008.tract[2],
                      B08135.tract[2],
                      B25002.tract[2],
                      check.names = F, 
                      row.names = "geo")

#Before scaling, are these normally distributed?
ggplot(data = melt(oppdata)) + 
         geom_density(aes(x = value)) + 
         facet_wrap(~ variable, ncol = 3, scales = "free")

oppdata[1:12] <- scale(oppdata[1:12], center = T, scale = T)

oppdata$index = rowMeans(oppdata, na.rm = T)

#Try basic principal components
plot(oppdata)

x <- subset(oppdata[3:11], commutetime != "NA" & 
              Total.Mathematics.Avg.Scale.Score != "NA")
pca1 = prcomp(x, scale. = T)

# create data frame with scores
scores = as.data.frame(pca1$x)

# plot of observations
ggplot(data = scores, aes(x = PC1, y = PC2, label = rownames(scores))) +
  geom_hline(yintercept = 0, colour = "gray65") +
  geom_vline(xintercept = 0, colour = "gray65") +
  geom_text(colour = "tomato", alpha = 0.8, size = 4)

plot(x$index, pca1$x[,1])

plot(prcomp(x, scale = T))

#write.csv(oppdata, "oppdata.csv", row.names = F)

#Extra text

The [Opportunity Index](http://kirwaninstitute.osu.edu/reports/2009/11_2009_CTOppMapping_FullReport.pdf) uses 10 variables; seven of these can be retrieved from the Census Bureau's American Community Survey:
* [Educational attainment for the population](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_11_5YR_B23006) (college and associates degrees)
* [Unemployment rates](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B23025) (percent in labor force but unemployed)
* [Population on public assistance](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_11_5YR_B19058)
* [Mean commute time](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B08135) (average time to commute for residents, using the method outlined [here](http://quickfacts.census.gov/qfd/meta/long_LFE305212.htm))
* [Vacancy rate](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B25002) (percent vacant housing)
* [Poverty](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B17017) (percent below poverty line)
* [Home ownership rate](http://factfinder2.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_12_5YR_B25008) (percent of owner-occupied homes in given housing stock)

#2

For 'neighborhood' data, the index uses census tracts which restricts the data source to the ACS 5-year estimates. I used the [acs.R package](http://cran.r-project.org/web/packages/acs/index.html) to download census data by tract for the entire state for each of these seven variables. The most recent set of 5-year estimates spans 2008 - 2012, but the script could be updated for different years as new data becomes available.

To keep each of the variables in the same 'direction' (more homeownership is 'good,' while more poverty is 'bad'), I converted the public assistance, poverty, unemployment and vacancy to the inverse percentage (i.e. 1 - rate). For the commute times, I multiplied by (-1) so that longer commute times are lower values. 

Below are summary stats for the census data components of the index:

The remaining variables - math and reading test scores and economic climate - aren't publicly available at the neighborhood level. 

#3

Math and reading scores are reported by the State Department of Education [at the school and district level](http://www.ctreports.com/). Since many children do not attend neighborhood schools, even if data were readily available it may  not accurately represent opportunity in a particular neighborhood. As a proxy, we use the average test scores for the school district of the town. Average test scores take into account the performance of all students, not just those crossing a particular threshold. 

A few smaller districts did not have 2013 reports, so the most recent year available was used instead. Scores for regional school districts are reported for each town in the region. Cornwall and Union did not have data for any of the past 7 years. (The index also does not specify the grade to use, so I opted to take 3rd grade reading and math scores as a fairly common milestone indicator.)

'Economic climate' was defined for the Opportunity Index as 'the change in jobs within 5 miles from 2005 to 2008,' using data from ESRI Business Analyst. To get around relying on data from ESRI, I used the [Quarterly Census of Earnings and Wages](http://www1.ctdol.state.ct.us/lmi/) series from the Bureau of Labor Statistics. The data is available by town and is a direct census of employment from wage records. I used 2009 to 2012 as the timeframe, although this does not perfectly match the census data. 

As in the prior Opportunity Index, the job change data has some outlier values, particularly for small towns (such as Barkhamsted, where employment doubled from 616 to 1145 people over the three years) and you can see this in the summary stats below (the average change is 1%, but some towns have up to 86% change).

#4

The Opportunity Index uses z-scores to scale the variables and calculate the index. This is important because the interpretation of the z-scores depends on how the data are distributed. If data are distributed normally ('bell-curve' style), the z-scores tell us roughly how much of the data is below or above a certain z-score. You can then also compare z-scores for different bell-curve-shaped data sets - the z-scores mean the same thing if the underlying distributions have the same shape. 

The plots below show the distribution of each of the components of the index for the 833 census tracts in Connecticut. You can see that most are not bell-curve shaped though. Rather, several are skewed, which reflects the general concentration of poverty, public assistance and related variables in a small set of neighborhoods within the state. 

#5

Another way of coloring the map would be to use [Jenks natural breaks](http://support.esri.com/en/knowledgebase/GISDictionary/term/natural%20breaks%20classification) method which looks for natural divisions in the data. The map below uses this coloring method for the same data.