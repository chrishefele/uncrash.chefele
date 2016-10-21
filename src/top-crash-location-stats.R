

# WORK IN PROGRESS

# Script to analyze differenes in variable distributions by location.
# This script picks the top N accident locations (either by 
# location name, or by GPS coordinates) and then prints out the
# mean of several variables (driver age, number killed, etc.) 
# and the distribution of categorical variable (e.g. male/female).
#
# TODO: Plots, etc.


TOP.N.LOCATIONS <- 30
CRASHES.LOCAL.FILE <- "../data/crashes-local.Rda"

number.vars <- c(
     "Driver.Age"
    ,"Total.Injured"
    ,"Total.Killed"
    ,"Total.Vehicles.Involve"
    ,"Crash.Hour"
)

category.vars <- c(
     "Driver.Sex"
    ,"Alcohol.Involved"
    ,"Cell.Phone.In.Use.Flag"
    ,"Crash.Day.Of.Week"
    ,"Crash.Weekend"
    ,"Crash.Weekday"
)

crashes                 <- readRDS(CRASHES.LOCAL.FILE)
crashes$Crash.Location  <- trimws(crashes$Crash.Location)
crashes$Latitude        <- round(crashes$Latitude,  4)
crashes$Longitude       <- round(crashes$Longitude, 4)
crashes$LatLong         <- paste(crashes$Latitude, crashes$Longitude)

# Find the locations with the highest crash count

tbl <- as.data.frame(table(crashes$Crash.Location)) 
names(tbl) <- c("Crash.Location", "Crash.Count")
tbl <- tbl[order(tbl$Crash.Count, decreasing=TRUE),]
top.locations <- tbl[1:TOP.N.LOCATIONS,"Crash.Location"]

# calculate mean statistics by location for the numeric variables

mean.na.rm   <- function(x) { mean(x, na.rm=TRUE) }

agg.stats <- aggregate(crashes[,number.vars], 
                       list(crashes$Crash.Location), mean.na.rm)

colnames(agg.stats)[1] <- "Crash.Location"   # replaces "Group.1"
rownames(agg.stats) <- agg.stats$Crash.Location
agg.stats[,"Crash.Location"] <- NULL

cat("\n-----MEAN STATS PER LOCATION---------\n")
print(agg.stats[top.locations[1:30],])

# calculate discrete distributions by location for the category variables

cat("\n-----CATEGORY COUNTS PER LOCATION---------\n")
for(category.var in category.vars) {
    tbl <- table(crashes$Crash.Location, crashes[,category.var])
    category.stats <- as.data.frame.matrix(tbl)
    category.stats <- category.stats[top.locations,]
    cat("\n----------", category.var, "----------\n")
    print(head(category.stats, 30))
}

