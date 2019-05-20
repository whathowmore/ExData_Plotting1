
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
png(filename = "plot2.png", width = 480, height = 480)

## plot graph with weekday name on the x axis and global active power on the y axis
ggplot(data=combinedData, aes(x= datetime, y= Global_active_power ))+
  geom_line()+
  labs(y= "Global Active Power (kilowatts)", x="")+
  scale_x_datetime(date_breaks = 'day', date_labels = "%a", labels = T)

dev.off()

