

# WORK IN PROGRESS

# Script to analyze differenes in variable distributions by location.
# This script picks the top N accident locations (either by 
# location name, or by GPS coordinates) and then prints out the
# mean of several variables (driver age, number killed, etc.) 
# and the distribution of categorical variable (e.g. male/female).
#
# TODO: Plots, etc.

TOP.N.LATLONG      <- 100
CRASHES.LOCAL.FILE <- "../data/crashes-local.Rda"
LATLONG.CSV.FILE   <- "../data/top-crash-latlong-stats.csv"
DEBUG              <- FALSE

# Get & prep the crash data...

cat("\nReading: ", CRASHES.LOCAL.FILE, "\n\n")
crashes                 <- readRDS(CRASHES.LOCAL.FILE)
crashes$Crash.Location  <- NULL # trimws(crashes$Crash.Location)
crashes$Latitude        <- round(crashes$Latitude,  4)
crashes$Longitude       <- round(crashes$Longitude, 4)
crashes$LatLong         <- paste(crashes$Latitude, crashes$Longitude)

# calculate features for the numeric variables first

numeric.vars <- c(
     "Driver.Age"
    ,"Total.Injured"
    ,"Total.Killed"
    ,"Total.Vehicles.Involve"
    ,"Crash.Hour"
)

mean.na.rm     <- function(x) { mean(x,  na.rm=TRUE) }
median.na.rm   <- function(x) { median(x,na.rm=TRUE) }
sum.na.rm      <- function(x) { sum(x,   na.rm=TRUE) }

numeric.feature <- function(crashes, col.name.in, col.name.out, agg.func) { 
    cat("Processing: ", col.name.out, "\n")
    agg.stats <- aggregate(crashes[,col.name.in], list(crashes$LatLong), agg.func)
    agg.stats <- as.data.frame(agg.stats)
    stopifnot(ncol(agg.stats)==2)
    colnames(agg.stats)[2] <- col.name.out
    rownames(agg.stats) <- agg.stats[,1] # move grouping variable (LatLong in col 1) to rownames
    agg.stats[,1] <- NULL
    # print(head(agg.stats))
    # print(dim(agg.stats))
    return(agg.stats)
}

numeric.features <- data.frame(init.feature=0)
for(var.name in numeric.vars) {
    # calculate the mean, median and sum for each numeric variable
    numeric.features <- cbind(numeric.features
    ,numeric.feature(crashes, var.name, paste(var.name, ".Mean",  sep=""), mean.na.rm) 
    ,numeric.feature(crashes, var.name, paste(var.name, ".Median",sep=""), median.na.rm) 
    ,numeric.feature(crashes, var.name, paste(var.name, ".Sum",   sep=""), sum.na.rm) 
    )
}
numeric.features$init.feature <- NULL

# calculate features for the categorical variables next 

category.feature <- function(crashes, category.var, target.values) {
    # calculate the crash count & percentage for each category var's target value
    cat("Processing: ", category.var,"\n")
    tbl <- table(crashes$LatLong, crashes[,category.var])
    category.stats <- as.data.frame.matrix(tbl)
    category.stats <- category.stats[,target.values]
    colnames(category.stats) <- paste(category.var, ".", colnames(category.stats), sep="")
    percents <- round(100 * category.stats / rowSums(category.stats), 4)
    names(percents) <- paste( names(percents), ".pct", sep="")
    category.stats <- cbind(category.stats, percents)
    #print(head(category.stats))
    return(category.stats)
}

category.features <- cbind(
     category.feature(crashes, "Driver.Sex",             c("M","F"))
    ,category.feature(crashes, "Alcohol.Involved",       c("Y","N"))
    ,category.feature(crashes, "Cell.Phone.In.Use.Flag", c("Y","N"))
    ,category.feature(crashes, "Crash.Day.Of.Week",      c("M","TU","W","TH","F","SA","S"))
    ,category.feature(crashes, "Crash.Weekend",          c("TRUE", "FALSE"))
    ,category.feature(crashes, "Crash.Weekday",          c("TRUE", "FALSE"))
)
category.features$init.feature <- NULL

# Find the latitude, longitude pairs with the highest crash counts

latlong.counts <- as.data.frame(table(crashes$Latitude, crashes$Longitude))
names(latlong.counts) <- c("Latitude", "Longitude", "Crash.Count")
latlong.counts <- latlong.counts[ order(latlong.counts$Crash.Count, decreasing=TRUE) ,]
# hack: make rownames a lat&long string to index[] data by latlong 
latlong.counts$LatLong <- paste(latlong.counts$Latitude, latlong.counts$Longitude)
rownames(latlong.counts) <- latlong.counts$LatLong
top.latlong <- latlong.counts[1:TOP.N.LATLONG, "LatLong"]
latlong.counts$LatLong <- NULL

# bundle all the features together & write the .csv

all.features <- cbind(  numeric.features[top.latlong,]
                       ,category.features[top.latlong,]
                       ,latlong.counts[top.latlong,]
                )

write.csv(all.features, file=LATLONG.CSV.FILE, row.names=FALSE)
cat("\nWrote:", LATLONG.CSV.FILE, "\n\n")

# debug prints

if(DEBUG) {
    cat("\n---- TOP LATLONG\n")
    print(head(top.latlong))
    print(dim(top.latlong))

    cat("\n---- NUMERIC FEATURES\n")
    print(head(numeric.features[ top.latlong,]))
    print(dim(numeric.features))

    cat("\n---- CATEGORY FEATURES\n")
    print(head(category.features[top.latlong,]))
    print(dim(category.features))

    cat("\n---- LATLONG FEATURES\n")
    print(head(latlong.counts[   top.latlong,]))
    print(dim(latlong.counts))

    cat("\n---- ALL FEATURES\n")
    print(head(all.features))
    print(dim(all.features))
}

