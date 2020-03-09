## The purpose of this series of scripts is to analyse how household energy    ##
## usage varies over the period 1 February 2007 - 2 February 2007. This script ##
## generates a time plot of how energy sub metering changes over the two days. ##

## Set packages ##

library(tidyverse)
library(ggplot2)
library(lubridate)
# etc.

# Unzip data file

zip_file <- "exdata_data_household_power_consumption.zip"
data_file <- "household_power_consumption.txt"

if(!file.exists(data_file)) {
  # If the file doesn't exist we'll unzip the zip file
  unzip(zip_file, setTimes = TRUE) # This is a massive file!
}

# Read data into R for 2007-02-01 and 2007-02-02 only

data <- read_delim(data_file, delim = ";", na = "?")

# strip out the data we want

data[, 1] <- as.Date(data$Date, "%d/%m/%Y")
data$period <- data$Date %in% as.Date(c("2007-02-01", "2007-02-02"))
new_data <- data[data$period, ]

# Merge date and time together
new_data$DateTime <- as.POSIXct(paste(new_data$Date, new_data$Time), format = "%Y-%m-%d %H:%M:%S")

# plot data
with(new_data, plot(DateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
lines(new_data$DateTime, new_data$Sub_metering_2, type = "l", col = "red")
lines(new_data$DateTime, new_data$Sub_metering_3, type = "l", col = "blue")

legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, lwd = 2, col = c("black", "red", "blue"))

# copy onto graphics driver
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()