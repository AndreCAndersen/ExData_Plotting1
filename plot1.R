# Download and unzip files

hpc_data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
hpc_data_dir <- file.path(getwd(), "data")
dir.create(hpc_data_dir, showWarnings = FALSE)
hpc_data_zip <- file.path(hpc_data_dir, "household_power_consumption.zip")
hpc_data_txt <- file.path(hpc_data_dir, "household_power_consumption.txt")
if (!file.exists(hpc_data_zip)) 
  download.file(hpc_data_url, hpc_data_zip, quiet = TRUE)
if (!file.exists(hpc_data_txt)) 
  unzip(hpc_data_zip, exdir = hpc_data_dir)

stopifnot(file.exists(hpc_data_txt))

# Load files into memory

if(!exists("hpc_data")) {
  hpc_all_data <- read.table(hpc_data_txt, header = TRUE, sep = ";", dec = ".", na.strings = c("?"))
  hpc_all_data$Date <- as.Date(hpc_all_data$Date, "%d/%m/%Y")
}
valid_start_date = as.Date("2007-02-01")
valid_end_date = as.Date("2007-02-02")

hpc_data <- subset(hpc_all_data, valid_start_date <= Date & Date <= valid_end_date)
hpc_data$DateTime <- strptime(paste0(hpc_data$Date, hpc_data$Time), '%Y-%m-%d %T')

hpc_data$Global_active_power[hpc_data$Global_active_power == "?"] <- NA
hpc_data$Global_reactive_power[hpc_data$Global_reactive_power == "?"] <- NA
hpc_data$Voltage[hpc_data$Voltage == "?"] <- NA
hpc_data$Global_intensity[hpc_data$Global_intensity == "?"] <- NA

hpc_data$Global_active_power <- as.numeric(hpc_data$Global_active_power)
hpc_data$Global_reactive_power <- as.numeric(hpc_data$Global_reactive_power)
hpc_data$Voltage <- as.numeric(hpc_data$Voltage)
hpc_data$Global_intensity <- as.numeric(hpc_data$Global_intensity)

# Actually building the graph
png('plot1.png', width = 480, height = 480)
par(mfrow=c(1,1))
hist(hpc_data$Global_active_power, breaks = seq(0,10,0.5), xaxp = c(0, 6, 3), xlim = c(0, 8), ylim = c(0, 1200), xlab = 'Global Active Power (kilowatts)', main = 'Global Active Power', col='red')

dev.off()

