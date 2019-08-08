library(dplyr)
library(ggplot2)

## download file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","NEI_data.zip",method="curl")

## unzip and read data to dataframe
unzip("NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Q3 plot
## new column 'Country' indicates Boltimore OR other cities

NEI %>% mutate(Country = if_else(fips=="24510","Boltimore","Other")) %>% 
    group_by(type,Country,year) %>% 
    summarise(TotalEmmision=sum(Emissions)) -> Q3_df


ggplot(Q3_df, aes(x=year, y=TotalEmmision, colour = type))  + 
  geom_line(size=3) +
  facet_wrap(~Country,scales = "free") +
  labs(title = "Total Emissions by source in Boltimore and Other Cities,USA")

ggsave("plot3.png")



