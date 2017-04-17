library(dplyr)  ## one call to mutate function
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url,destfile = "power.zip", method = "curl")
unzip("power.zip")
con <- file("household_power_consumption.txt", "r")
indices <- (grep("^[12]/2/2007", readLines(con)))-1
## readLines seems to advance the current line before grep has matched the date, so the indices returned are all to high by 1 (starting at 12:01am on 1 February 2007 and ending at 12:00am on 3 February 2007 instead of starting at 12:00am on 1 February 2007 and ending at 11:59pm on 2 February 2007).  Therefore I subtract 1 from the whole vector.
close(con)
rm(con)
con <- file("household_power_consumption.txt", "r")
data <- read.table(con, sep = ";", header = TRUE, na.strings = "?", stringsAsFactors = FALSE)[indices,]
close(con)
rm(con)
newdata <- mutate(data, datetime = paste(Date, Time))
## make new datetime column with string combining Date and Time columns
posix = strptime(newdata$datetime, format = "%d/%m/%Y %H:%M:%S")
## mutate doesn't work with POSIXlt columns, so make a new vector changing the datetime column cloass to POSIXlt
newnewdata <- cbind(newdata, posix)
## add the POSIXlt class column to the dataframe
rm(data)
rm(newdata)
rm(posix)
## clean up intermediate data frames
## plotting:
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))
## set up the plots to appear in a grid, filling in row-wise

##1
plot(newnewdata$posix,newnewdata$Global_active_power,type = "n",ylab="Global Active Power",xlab = "")
lines(newnewdata$posix, newnewdata$Global_active_power, type = "l")

##2
plot(newnewdata$posix, newnewdata$Voltage, type = "n", ylab = names(newnewdata)[5], xlab = "datetime")
lines(newnewdata$posix, newnewdata$Voltage, type = "l")

##3

plot(newnewdata$posix,newnewdata[,7],type = "n",ylab="Energy sub metering",xlab = "")
lines(newnewdata$posix, newnewdata[,7], type = "l")
lines(newnewdata$posix, newnewdata[,8], type = "l", col = "red")
lines(newnewdata$posix, newnewdata[,9], type = "l", col = "blue")
legend("topright", bty = "n", cex = .94, legend = names(newnewdata)[7:9], lwd = 1, col = c("black", "red", "blue"))

##4
plot(newnewdata$posix,newnewdata$Global_reactive_power, type = "n",xlab = "datetime", ylab = names(newnewdata)[4])
lines(newnewdata$posix, newnewdata$Global_reactive_power, type = "l")

dev.off()