library(dplyr)

## download file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","NEI_data.zip",method="curl")

## unzip and read data to dataframe
unzip("NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Q1 plot

NEI %>% filter(year %in% c("1999","2002","2005","2008")) %>% 
  group_by(year) %>%
  summarise(TotalEmmisions = sum(Emissions)) -> Q1_df

with(Q1_df, plot(year, TotalEmmisions, type="l"))

dev.copy(png, "plot1.png", height=480, width=480)
dev.off()