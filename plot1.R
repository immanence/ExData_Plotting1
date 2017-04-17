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
png(filename = "plot1.png", width = 480, height = 480)
hist(newnewdata$Global_active_power, main = "Global Active Power",xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "red")
dev.off()