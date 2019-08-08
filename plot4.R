library(dplyr)
library(stringr)

## download file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","NEI_data.zip",method="curl")

## unzip and read data to dataframe
unzip("NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## select coal combustion-related sources
## Choose EI.Sector contained "Coal"

SCC %>% filter(str_detect(EI.Sector,"Coal")) %>% 
  mutate(SCC=as.character(SCC)) %>% 
  select(SCC) -> filter_scc

NEI %>% semi_join(.,filter_scc,by="SCC") %>%
  group_by(year) %>%
  summarise(TotalEmmisions = sum(Emissions)) -> Q4_df

## plot 

with(Q4_df, plot(year, TotalEmmisions
                 , type = "l"
                 , main = "Total emissions from coal combustion-related sources"))

dev.copy(png, "plot4.png", height=480, width=480)
dev.off()