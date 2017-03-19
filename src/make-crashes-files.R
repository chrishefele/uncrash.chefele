
# Script for preparing the "Uncrash" project data 
# for GIS plotting & further analysis
#
# Data for the "Uncrash" project (by "Code For Princeton") is at
# https://github.com/codeforprinceton/uncrash
# 
# Overall, it prepares datafile(s) in a more convenient form 
# for my personal analysis & visualization needs. 
# The script extracts a subset of fields interest from the
# the original set of filtered data.  
# It also combines the data from seperate years; in the original
# dataset, each year's data is in a seperate file.
# 
# The output of this script is a set of 4 files: 
# 1. One .Rda with NJ crash 
# 2. One .Rda with local town crash data
# 3. One .csv of just the NJ crash data with GPS coordinates (for mapping)
# 4. One .csv of just the local town crash data with GPS coordinates (for mapping)
#
# Chris Hefele, 10/20/2016
#

# Source / input data files 

FILTERED.DATA.DIR <- "../../uncrash/data/"

# Output data files 

CRASHES.LOCAL     <- "../data/crashes-local.Rda"
CRASHES.LOCAL.CSV <- "../data/crashes-local.csv"
CRASHES.NJ        <- "../data/crashes-NJ.Rda"
#CRASHES.NJ.CSV   <- "../data/crashes-NJ.csv"


# Extract crash data for only these years  

YEARS         <- 2001:2014

# Definition of "local" for creating the local datasets

local.towns <- c( 
     "PRINCETON" 
    ,"PRINCETON BORO"
    ,"PRINCETON TWP"
    ,"WEST WINDSOR TWP"
)

# For each crash, extract this subset of all fields

col.select <- c(
     "Crash.Date"                    
    ,"Crash.Day.Of.Week"              
    ,"Crash.Time"                    
    ,"Driver.DOB"                     
    ,"Driver.Sex"                    
    ,"County.Name"                   
    ,"Municipality.Name"              
    ,"Total.Killed"                  
    ,"Total.Injured"                  
    ,"Total.Vehicles.Involve"         
    ,"Alcohol.Involved"              
    ,"Alcohol.Test.Given"             
    ,"Alcohol.Test.Results"           
    ,"Cell.Phone.In.Use.Flag"        
    ,"Crash.Location"                
    ,"Cross.Street.Name"                
    ,"Latitude"                      
    ,"Longitude"                      
)

# Misc constants 

WEEKDAY.DAYS <- c("M","TU","W","TH","F")
WEEKEND.DAYS <- c("SA","S")

# Let's begin ... 

cat("\nExtracting crash data from these files:\n\n")

# Load each year's data & accumulate the subset of fields of interest

df.years <- NULL
for(year in YEARS) {
    year.file <- paste(FILTERED.DATA.DIR, "FilteredData", year, ".Rda", sep="")
    cat(" ", year.file, "\n")
    load(year.file)  # loads a dataframe named "FilteredData"
    df.year      <- FilteredData[,col.select]
    df.year$Year <- year 
    df.years     <- rbind(df.years, df.year)
}

cat("\nUpdating/creating additional data set features")

# Longitude is reporated as positive in the dataset, 
# but west longitude is negative by convention

df.years$Longitude <- -1 * df.years$Longitude

# Derive the driver's age (in years)

crash.date <- strptime(df.years$Crash.Date, format="%m/%d/%Y")
birth.date <- strptime(df.years$Driver.DOB, format="%m/%d/%Y")
SECS.PER.YEAR <- 365*24*60*60 # because strptime converts to seconds 
df.years$Driver.Age <- as.integer((crash.date - birth.date)/SECS.PER.YEAR)
df.years$Driver.Age <- pmax(0, pmin(120, df.years$Driver.Age)) 

# Derive crash hour

crash.time <- strptime(df.years$Crash.Time, format="%H:%M")
df.years$Crash.Hour <- as.integer(strftime(crash.time, format="%H"))

# Weekday flag

df.years$Crash.Weekday <- df.years$Crash.Day.Of.Week %in% WEEKDAY.DAYS
df.years$Crash.Weekend <- df.years$Crash.Day.Of.Week %in% WEEKEND.DAYS

# Text fields in data set can be fixed length, so remove excess whitespace

for(trimws.col in c( "County.Name"
                    ,"Municipality.Name"
                    ,"Crash.Day.Of.Week"              
                    ,"Cross.Street.Name"              
                    ,"Crash.Location")  ) {
    df.years[,trimws.col] <- trimws(df.years[,trimws.col])
}

# Save all of the assembled data

cat("\nWriting crash data files")

is.local       <- trimws(df.years$Municipality.Name) %in% local.towns
has.lat.long   <- !is.na(df.years$Latitude) & !is.na(df.years$Longitude)

# Save .Rda files with all the data (not just those with GPS coordinates)
# To read, use:  df <- readRDS(file="filename.Rda")

saveRDS(  df.years                            ,file=CRASHES.NJ)
saveRDS(  df.years[is.local,]                 ,file=CRASHES.LOCAL)

# Write .csv files of crashes that also have GPS coordinates (about 20% of the data).
# The .csv format can be easily imported into a GIS tool for plotting on a map.

#write.csv(df.years[has.lat.long,]            ,file=CRASHES.NJ.CSV,       row.names=FALSE)
write.csv(df.years[has.lat.long & is.local,]  ,file=CRASHES.LOCAL.CSV,    row.names=FALSE)

cat("\nDone\n")

