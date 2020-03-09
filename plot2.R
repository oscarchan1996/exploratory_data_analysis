## The purpose of this series of scripts is to analyse how household energy    ##
## usage varies over the period 1 February 2007 - 2 February 2007. This script ##
## generates a time plot of how power changes over the two days.               ##

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
plot(new_data$DateTime, new_data$Global_active_power, type = "l", main = "Global Active Power",
     xlab = "", ylab = "Global Active Power (kilowatts)")

# copy onto graphics driver
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()