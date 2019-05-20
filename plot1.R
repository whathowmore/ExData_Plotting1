
## load dplyr, lubridate, and ggplot2 packages packages

library(dplyr)
library(lubridate)
library(ggplot2)


## check if folder exists, if not download file
fileURL<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datafile<- "ElectricPowerConsumption.zip"


if (!file.exists(datafile)) {
  download.file(fileURL, datafile, method = "curl")
}

##Unzip file if data does not already exist
fileLocation<- "household_power_consumption.txt"
if(!file.exists(fileLocation)) {
  unzip(dataFile)
}


## read table swapping "?" for NA
data<- read.table("household_power_consumption.txt", header = T, na.strings = "?", sep = ";")

## change "Date" coloumn so values are now in date format
dates<- data$Date
betterDates<- as.Date(dates, format = "%d/%m/%Y")
data$Date<- betterDates

## select the data covering the two days from 2007-02-01 to 2007-02-02
periodData<- filter(data, Date == "2007-02-01" | Date == "2007-02-02")

## make a new coloumn that combines date and time into one value
combinedData<- mutate(periodData, datetime = as.POSIXct(ymd(Date) + hms(Time)))

## set graphics device and file name
png(filename = "plot1.png", width = 480, height = 480)

## plot histogram
qplot(combinedData$Global_active_power, 
            geom = "histogram",
            binwidth= 0.5,
            main = "Global Active Power",
            xlab = "Global Active Power (kilowatts)",
           ylab = "Frequency",
            fill= I("red"),
           col= I("black"),
           breaks= seq(0,6, by=0.5))

dev.off()