#Load all the libraries and census data
library(ggplot2)
library(reshape)
library(plyr)
library(acs)
library(maps)
library(maptools)

#Set up Census API key
key = "ba67d3a427e1f785987b9c8bc59341bf7c8a7cc1"
api.key.install(key)

#Load the UConn tract and town-level shapefiles for maps
CTTracts <- readShapeSpatial(fn="tractct_37800_0000_2010_s100_census_1_shp/wgs84/tractct_37800_0000_2010_s100_census_1_shp_wgs84")
CTTracts <- fortify(CTTracts, region = "NAME10")
CTTracts <- CTTracts[order(CTTracts$order),]

#Create tracts for the state
ct.tracts = geo.make(state = "CT", county = "*", tract = "*", check = F)

#Percent of population on public assistance
B19058 = acs.fetch(geography = ct.tracts, table.number = "B19058", col.names = "pretty", endyear = 2012)

B19058.rate = divide.acs(numerator=B19058[,2],denominator=B19058[,1])

B19058.tract = data.frame(geo=geography(B19058)[[1]],
                          publicassistance= 1 - as.numeric(estimate(B19058.rate)))

#Percent of population with college degree including associate degree
B23006 = acs.fetch(geography = ct.tracts, table.number = "B23006", col.names = "pretty", endyear = 2012)

B23006.rate = divide.acs(numerator=(B23006[,16]+B23006[,23]),denominator=B23006[,1])

B23006.tract = data.frame(geo=geography(B23006)[[1]],
                          college = as.numeric(estimate(B23006.rate)))

#Neighborhood poverty rate
B17017 = acs.fetch(geography = ct.tracts, table.number = "B17017", col.names = "pretty", endyear = 2012)

B17017.rate = divide.acs(numerator=B17017[,2], denominator=B17017[,1])

B17017.tract = data.frame(geo=geography(B17017)[[1]], 
                          poverty= 1 - as.numeric(estimate(B17017.rate)))

#Unemployment rate
B23025 = acs.fetch(geography = ct.tracts, table.number = "B23025", col.names = "pretty")

B23025.rate = divide.acs(numerator=B23025[,5],denominator=B23025[,2])

B23025.tract = data.frame(geo=geography(B23025)[,1],
                          unemployment= 1 - as.numeric(estimate(B23025.rate)))

#Home ownership rate - percent of owner-occupied homes in housing stock
B25008 = acs.fetch(geography = ct.tracts, table.number = "B25008", col.names = "pretty", endyear = 2012)

B25008.rate = divide.acs(numerator=B25008[,2],denominator=B25008[,1])

B25008.tract = data.frame(geo=geography(B25008)[[1]],
                          owneroccupied= as.numeric(estimate(B25008.rate)))

#Mean commute time
B08013 = acs.fetch(geography = ct.tracts, table.number = "B08013", col.names = "pretty", endyear = 2012)
B99084 = acs.fetch(geography = ct.tracts, table.number = "B99084", col.names = "pretty", endyear = 2012)

B08013.rate = divide.acs(numerator=B08013[,1],denominator=B99084[,2])

B08013.tract = data.frame(geo=geography(B08013)[[1]],
                          commutetime= (-1) * as.numeric(estimate(B08013.rate)))

#Neighborhood vacancy rate
B25002 = acs.fetch(geography = ct.tracts, table.number = "B25002", col.names = "pretty", endyear = 2012)

B25002.rate = divide.acs(numerator=B25002[,3],denominator=B25002[,1])

B25002.tract = data.frame(geo=geography(B25002)[[1]],
                          vacancy= 1 - as.numeric(estimate(B25002.rate)))

#Load the qcew data
qcew <- read.csv('qcew-annual-averages.csv', na.strings = "*")

#Cast into new format to get growth rate in employment
qcew_t <- cast(qcew, Town ~ Year, value = "Annual.Average.Employment")
names(qcew_t) <- make.names(names(qcew_t))
qcew_t$jobchange = (qcew_t$X2012 - qcew_t$X2009) / as.numeric(qcew_t$X2009)

#Load the test scores data
#Need to manually change code regional school districts
#Fill missing years for some towns, i.e. Newtown 2013
cmt <- read.csv('ctreports-2013-grade-3-cmt.csv', na.strings = "-")


#Load the employment access index data from the LAI dataset
eai <- read.csv('lai_data_allCT_blkgrps.csv')

#Group into tracts as weighted avg. 
eai <- ddply(eai, .(tract), summarise,
             employment_access_index = weighted.mean(employment_access_index, households, na.rm = T),
             job_diversity_index = weighted.mean(job_diversity_index, households, na.rm = T))

#Make a map of the eai data as a factor alone
library(classInt)
choropleth=merge(CTTracts, eai, by.x = "id", by.y="tract")
choropleth=choropleth[order(choropleth$order), ]
breaks <- classIntervals(eai$employment_access_index, n=5, style="fisher")
choropleth$employment_access_index=cut(choropleth$employment_access_index, 
                                       breaks=breaks$brks,
                                       include.lowest=T, dig.lab = T)
#Make the map
win.metafile("Employment-access-index.emf", width = 10, pointsize = 9)
ggplot(data = choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = employment_access_index)) + 
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  labs(x = NULL, y = NULL, title = "LAI: Employment Access Index") + 
  coord_equal() +
  scale_fill_brewer(palette = "Purples", name = "Employment\naccess index") +
  theme_minimal()
dev.off()

#Make a map of the jobs diversity data as a factor alone
library(classInt)
choropleth=merge(CTTracts, eai, by.x = "id", by.y="tract")
choropleth=choropleth[order(choropleth$order), ]
breaks <- classIntervals(eai$job_diversity_index, n=5, style="fisher")
choropleth$job_diversity_index=cut(choropleth$job_diversity_index, 
                                       breaks=breaks$brks,
                                       include.lowest=T, dig.lab = T)
#Make the map
win.metafile("Jobs-diversity-index.emf", width = 10, pointsize = 9)
ggplot(data = choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = job_diversity_index)) + 
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  labs(x = NULL, y = NULL, title = "LAI: Jobs Diversity Index") + 
  coord_equal() +
  scale_fill_brewer(palette = "Purples", name = "Job diversity\nindex") +
  theme_minimal()
dev.off()

#Create data table using original tract-level variables
variables <- data.frame(B23006.tract,
                      B19058.tract[2], 
                      B17017.tract[2],
                      B23025.tract[2],
                      B25008.tract[2],
                      B08013.tract[2],
                      B25002.tract[2],
                      check.names = F)

#Load list of tract names and towns. Add the town names to the tract-level data
variables$geo= gsub("Census Tract ", "", variables$geo)
variables$geo= gsub(", (Fairfield|Hartford|Litchfield|Middlesex|New Haven|New London|Tolland|Windham) County, Connecticut","", variables$geo)

mapping <- read.csv('tractstowns2.csv')
variables <- merge(variables, mapping[c("NAME10","NAME10_1")], by.x = "geo", by.y = "NAME10", all.x = T)

variables <- merge(variables, 
                 qcew_t[c("Town","jobchange")], 
                 by.x = "NAME10_1", 
                 by.y = "Town", 
                 all.x = T)

variables <- merge(variables, 
                 cmt[c("Group",
                       "Total.Mathematics.Avg.Scale.Score",
                       "Total.Reading.Average.Scale.Score")], 
                 by.x = "NAME10_1", 
                 by.y = "Group", 
                 all.x = T)

#Create data table using new LAI data
oppdata2 <- merge(variables, 
                 eai[1:2], 
                 by.x = "geo", 
                 by.y = "tract", 
                 all.x = T)

oppdata2 <- merge(oppdata2, 
                  cmt[c("Group",
                        "Total.Mathematics.Avg.Scale.Score",
                        "Total.Reading.Average.Scale.Score")], 
                  by.x = "NAME10_1", 
                  by.y = "Group", 
                  all.x = T)

#Create data table using all LAI variables
variables <- merge(variables, 
                  eai, 
                  by.x = "geo", 
                  by.y = "tract", 
                  all.x = T)

#Calculate z-scores and index values for each data table
oppdata <- variables
oppdata[3:14] <- scale(oppdata[3:14], center = T, scale = T)
oppdata$index = rowMeans(oppdata[c("college",
                                   "poverty",
                                   "publicassistance",
                                   "unemployment",
                                   "owneroccupied",
                                   "commutetime",
                                   "vacancy",
                                   "jobchange",
                                   "Total.Mathematics.Avg.Scale.Score",
                                   "Total.Reading.Average.Scale.Score")], na.rm = T)

#Make a map of the index
library(classInt)
choropleth=merge(CTTracts, oppdata[c("geo","index")], 
                 by.x = "id", by.y="geo")
choropleth=choropleth[order(choropleth$order), ]
breaks <- classIntervals(oppdata$index, n=5, style="quantile")
choropleth$index=cut(choropleth$index, 
                     breaks=breaks$brks,
                     include.lowest=T, dig.lab = T)
#Make the map
win.metafile("Original-w-commute.emf", width = 10, pointsize = 9)
ggplot(data = choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = index)) + 
  geom_path(data = CTTracts, aes(x = long, y = lat, group = group),colour = "lightgrey", alpha = 0.2, size = 0.05) +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  labs(x = NULL, y = NULL, title = "Opportunity index: original Kirwan variables") + 
  coord_equal() +
  scale_fill_brewer(palette = "Purples", name = "Opportunty index\n(quintiles)") +
  theme_minimal(base_size = 14)
dev.off()

#Now recalculate w/out commute time
oppdata2 <- oppdata
oppdata2$index = rowMeans(oppdata2[c("college",
                                   "poverty",
                                   "publicassistance",
                                   "unemployment",
                                   "owneroccupied",
#                                   "commutetime",
                                   "vacancy",
                                   "jobchange",
                                   "Total.Mathematics.Avg.Scale.Score",
                                   "Total.Reading.Average.Scale.Score",
                                   "employment_access_index",
                                   "job_diversity_index")], na.rm = T)

#Make a map of the second index table
library(classInt)
choropleth=merge(CTTracts, oppdata2[c("geo","index")], 
                 by.x = "id", by.y="geo")
choropleth=choropleth[order(choropleth$order), ]
breaks <- classIntervals(oppdata2$index, n=5, style="quantile")
choropleth$index=cut(choropleth$index, 
                     breaks=breaks$brks,
                     include.lowest=T, dig.lab = T)
#Make the map
win.metafile("Updated-no-commute.emf", width = 10, pointsize = 9)
ggplot(data = choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = index)) + 
  geom_path(data = CTTracts, aes(x = long, y = lat, group = group),colour = "lightgrey", alpha = 0.2, size = 0.05) +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  labs(x = NULL, y = NULL, title = "Opportunity index: access + diversity - commute time") + 
  coord_equal() +
  scale_fill_brewer(palette = "Purples", name = "Opportunty index\n(quintiles)") +
  theme_minimal(base_size = 14)
dev.off()

#Find diff between original and updated methods
diff <- merge(oppdata, oppdata2, by = "geo")
diff$diff = diff$index.x- diff$index.y

#Make a map of the differences
choropleth=merge(CTTracts, diff[c("geo","diff")], 
                 by.x = "id", by.y="geo")
choropleth=choropleth[order(choropleth$order), ]
breaks <- classIntervals(diff$diff, n=5, style="quantile")
choropleth$diff=cut(choropleth$diff, 
                     breaks=breaks$brks,
                     include.lowest=T, dig.lab = T)
#Make the map
win.metafile("Difference-in-results.emf", width = 10, pointsize = 9)
ggplot(data = choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = diff)) + 
  geom_path(data = CTTracts, aes(x = long, y = lat, group = group),colour = "lightgrey", alpha = 0.2, size = 0.05) +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  labs(x = NULL, y = NULL, title = "Difference in index values between original and new option") + 
  coord_equal() +
  scale_fill_brewer(palette = "Purples", name = "Difference in index\n(quintiles)") +
  theme_minimal(base_size = 14)
dev.off()

#Run basic principal components for each
x <- subset(oppdata[3:12], commutetime != "NA" & 
              Total.Mathematics.Avg.Scale.Score != "NA" &
              Total.Reading.Average.Scale.Score != "NA" & 
              jobchange != "NA")

pca1 = prcomp(x, scale. = T)

rotation <- data.frame(pca1$rotation[,1])
weights1 <- 
  ggplot(data = rotation, aes(x = pca1.rotation...1., y = row.names(rotation))) + 
  geom_point() + 
  xlim(-0.4,0.3) + 
  labs(x = "Weight in first principal component", y = NULL, title = "Original")

y <- subset(oppdata2[3:14], commutetime != "NA" & 
              Total.Mathematics.Avg.Scale.Score != "NA" &
              Total.Reading.Average.Scale.Score != "NA" & 
              jobchange != "NA")[c(1:5,7:12)]

pca2 = prcomp(y, scale. = T)

rotation2 <- data.frame(pca2$rotation[,1])
weights2 <- 
  ggplot(data = rotation2, aes(x = pca2.rotation...1., y = row.names(rotation2))) + 
  geom_point() + 
  xlim(-0.4,0.3) + 
  labs(x = "Weight in first principal component", y = NULL, title = "With job growth + access + diversity")

library(gridExtra)
win.metafile("Principal-components.emf", width = 10, pointsize = 9)
grid.arrange(weights1, weights2, ncol = 1, nrow = 2)
dev.off()

#write the files to csv exports
write.csv(variables, "variables.csv", row.names = F)
write.csv(oppdata2, "index-values.csv", row.names = F)

#Test need for diversity, commute, access
summary(lm(oppdata4$index ~ oppdata4$commutetime + 
     oppdata4$employment_access_index + 
     oppdata4$job_diversity_index))

cor.test(oppdata4$commutetime, oppdata4$employment_access_index)
cor.test(oppdata4$job_diversity_index, oppdata4$employment_access_index)

plot(oppdata4[c(8,13,14)])

cor.test(oppdata4$commutetime, oppdata4$employment_access_index)
cor.test(oppdata4$job_diversity_index, oppdata4$employment_access_index)
cor.test(oppdata4$job_diversity_index, oppdata4$commutetime)

summary(lm(oppdata4$index ~ 
             oppdata4$poverty + 
             oppdata4$college + 
             oppdata4$publicassistance + 
             oppdata4$unemployment + 
             oppdata4$jobchange + 
             oppdata4$vacancy + 
             oppdata4$commutetime + 
             oppdata4$employment_access_index + 
             oppdata4$job_diversity_index))

cor(y)
symnum(cor(y))