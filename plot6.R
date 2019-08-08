library(dplyr)
library(stringr)
library(ggplot2)

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

NEI %>% filter(fips=="24510" | fips=="06037") %>%
  semi_join(.,filter_scc,by="SCC") %>%
  mutate(Country = if_else(fips=="24510","Boltimore City","LosAngeles")) %>%
  group_by(year,Country) %>%
  summarise(TotalEmmision = sum(Emissions)) -> Q6_df

ggplot(Q6_df, aes(x=year, y=TotalEmmision, colour = Country))  + 
  geom_line(size=2) +
  labs(title = "Total Emissions from motor vehicle in Boltimore City and LosAngeles Country")

ggsave("plot6.png")
