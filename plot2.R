library(dplyr)

## download file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","NEI_data.zip",method="curl")

## unzip and read data to dataframe
unzip("NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Q2 plot
## select Baltimore City, Maryland (fips == "24510") 

NEI %>% filter(fips=="24510") %>% 
  group_by(year) %>%
  summarise(TotalEmmisions = sum(Emissions)) -> Q2_df

with(Q2_df, plot(year, TotalEmmisions
                 , type = "l"
                 , main = "Total emissions from PM2.5 in the Baltimore City, Maryland"))

dev.copy(png, "plot2.png", height=480, width=480)
dev.off()