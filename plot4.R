#' ---
#' title: "plot 1"
#' author: "AO"
#' date: "14/01/2020"
#' output: html_document
#' ---
#' 
## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

#' 
#' Check if file exists and download it if not
#' 
## ------------------------------------------------------------------------
library(data.table)

#' 
#' 
## ------------------------------------------------------------------------
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data/household_power_consumption.zip",method="curl") 

# Unzipping the UNI HAR dataset folder.
if (!file.exists("Household Dataset")) { 
  unzip(zipfile="./data/household_power_consumption.zip",exdir="./data") 
}

#' 
#' Read the table, select the data required by date. Changing variable types.
#' 
#' 
## ------------------------------------------------------------------------
DataSet <- file("./data/household_power_consumption.txt")
DataSubset <- fread(text = grep("^[1,2]/2/2007", readLines(File), value = TRUE), col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), sep = ";", header = TRUE, na.strings = "?")

#' 
#' 
## ------------------------------------------------------------------------
head(DataSubset)

#' 
#' Date format and combine with time
#' Convert to Date-time
## ------------------------------------------------------------------------
DataSubset$Date <- as.Date(DataSubset$Date, "%d/%m/%Y")
DateandTime <- paste(DataSubset$Date, DataSubset$Time)
DateandTime <- setNames(DateandTime, "DateandTime")
DataSubset <- cbind(DateandTime, DataSubset)
DataSubset$DateandTime <- as.POSIXct(DateandTime)

#' 
#' 
#' 
#
#' Plot 4
#' Create plot, copy it to a png file
#' 
## ------------------------------------------------------------------------
 par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
  with(DataSubset, {
    plot(Global_active_power~DateandTime, type="l", 
         ylab="Global Active Power", xlab="")
    plot(Voltage~DateandTime, type="l", 
         ylab="Voltage", xlab="datetime")
    plot(Sub_metering_1~DateandTime, type="l", 
         ylab="Global sub metering", xlab="")
    lines(Sub_metering_2~DateandTime,col='Red')
    lines(Sub_metering_3~DateandTime,col='Blue')
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(Global_reactive_power~DateandTime, type="l", 
         ylab="Global_rective_power",xlab="datetime")
  })
dev.copy(png, file = "plot4.png")
dev.off() 

#' 
