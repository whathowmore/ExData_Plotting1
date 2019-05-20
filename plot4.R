
## load dplyr, lubridate, and ggplot2 packages packages

library(dplyr)
library(lubridate)



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
png(filename = "plot4.png", width = 480, height = 480)

## set up the parameters
par(mfrow = c(2,2))

##plot four seperate graphs
plot(combinedData$datetime,combinedData$Global_active_power, col="black",
     type = "l", xlab = "", ylab = "Global Active Power")
plot(combinedData$datetime,combinedData$Voltage, col="black",type = "l",
     xlab = "datetime",  ylab = "Voltage")
plot(type = "l", x= combinedData$datetime, y= combinedData$Sub_metering_1,
     col= "black", xlab = "", ylab = "Energy sub metering (kilowatts)")
lines(combinedData$datetime,combinedData$Sub_metering_2, col="red", type = "l")
lines(combinedData$datetime,combinedData$Sub_metering_3, col="blue", type = "l")
legend("topright", legend = c("sub_metering_1","sub_metering_2","sub_metering_3"),
       col = c("black", "red", "blue"), pch = "-")
plot(combinedData$datetime,combinedData$Global_reactive_power, col="black",
     type = "l", xlab = "datetime",  ylab = "Global_reactive_power")

dev.off()