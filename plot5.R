library(dplyr)
library(stringr)

## download file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","NEI_data.zip",method="curl")

## unzip and read data to dataframe
unzip("NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## select motor vehicle sources

filter_scc <-
  filter(SCC,SCC.Level.One=="Mobile Sources" & str_detect(EI.Sector,"Vehicles")) %>% 
  select(SCC) %>%
  mutate(SCC=as.character(SCC))

NEI %>% filter(fips=="24510") %>% 
  semi_join(.,filter_scc,by="SCC") %>%
  group_by(year) %>%
  summarise(TotalEmmisions = sum(Emissions)) -> Q5_df

with(Q5_df, plot(year, TotalEmmisions
                 , type = "l"
                 , main = "Total Emission from motor vehicle sources"))

dev.copy(png, "plot5.png", height=480, width=480)
dev.off()                 