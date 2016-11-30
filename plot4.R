#
#         Programming Assingnment Week 1 - Explanatory Analysis
#                             Graph 4
#

## Load the libraries

library(dplyr)
library(lubridate)
library(stringr)


####################################################

#  Download the file. The raw datafile is downloaded into the set working directory.
#  Thereafter it is unzipped into its .txt format and the zip file is deleted.
#   The file is read into a data table using the read.table. The file first line
#  is a header containing the variable names. The seperator used is the ;. 
#  Also the NA character, ?, is converted in the read statement to NA. 

# The zip file is downloaded, unzip, and deleted.
# 
###################################################

tmpfile <- "/tmpfile.zip"
f_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
wd <- getwd()
wdf <- paste0(wd,tmpfile)
download.file(f_url, wdf)
unzip(wdf) 
file.remove(wdf)

###################################################
#
# Read-in the file information using read.table. The file is re-titled
# hpc for household_power_consumption.  The file first line
#  is a header containing the variable names. The seperator used is the ;. 
#  Also the NA character, ?, is converted in the read statement to NA. 
#
###################################################

# Read the column names of the train and test data sets
hpc <- read.table(paste0(wd,"/household_power_consumption.txt"),
                  header = TRUE,
                  sep = ";",
                  na.string = "?",
                  stringsAsFactors = FALSE)

###################################################
#
# Using the dplyr library modify the data and time variables to the correct
# format and only select the observations needed. These cover the period of
# 2007-02-01 to 2007-02-02.
#
###################################################

hpc <- hpc %>%
        filter( Date == "1/2/2007" | Date == "2/2/2007" ) %>%
        mutate( Datetime = str_c(Date, " ", Time ) ) %>%
        mutate( Datetime = dmy_hms(Datetime) )%>%
        arrange(Date, Time)

##################################################
#
# Create fourth graphic
#
##################################################



png("plot4.png", width=480, height=480)
par(mfrow = c(2, 2)) 

with( hpc, { 
        
        plot(Datetime,Global_active_power, type = "l", xlab = "Datetime", ylab = "Global Active Power")
        
        plot(Datetime,Voltage, type = "l", xlab = "Datetime", ylab = "Voltage")
        
        plot(  Datetime, Sub_metering_1, type="l", ylab="Energy Submetering", xlab="")
        lines( Datetime, Sub_metering_2, type="l", col="red")
        lines( Datetime, Sub_metering_3, type="l", col="blue")
        legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))
        
        plot(Datetime,Global_reactive_power, type = "l", xlab = "Datetime",
             ylab = "Global_Reactive_Power")
        
})
dev.off()
