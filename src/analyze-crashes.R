
# This script is for exploratory data analysis
# It makes a variety of quick & dirty plots to 
# look at potentially interesting combinations 
# variables
#
# Chris Hefele 10/20/2016

USE.LOCAL         <- FALSE # use just local data, or all of NJ?

CRASHES.LOCAL     <- "../data/crashes-local.Rda"
CRASHES.NJ        <- "../data/crashes-NJ.Rda"
PLOT.PDF          <- "../plots/analyze-crashes.pdf"

DAYS.OF.WEEK      <- c("M","TU", "W", "TH", "F", "SA", "S")

# Read the data

crashes.file <- if(USE.LOCAL) CRASHES.LOCAL else CRASHES.NJ
cat("Reading data from: ", crashes.file, "\n")
crashes <- readRDS(crashes.file)
print(summary(crashes))

# Fields that are available for plotting are:

if(FALSE) {
    "Crash.Date"             
    "Crash.Day.Of.Week"      
    "Crash.Time"            
    "Crash.Hour"             
    "Crash.Weekday"         
    "Crash.Weekend"         
    "Year"                  

    "Driver.DOB"             
    "Driver.Sex"             
    "Driver.Age"             

    "County.Name"           
    "Municipality.Name"      

    "Total.Killed"           
    "Total.Injured"         
    "Total.Vehicles.Involve" 

    "Alcohol.Involved"       
    "Alcohol.Test.Given"    
    "Alcohol.Test.Results"   

    "Cell.Phone.In.Use.Flag" 

    "Crash.Location"        
    "Latitude"               
    "Longitude"              
}

# Lots of basic/messy plots follow...

cat("Making plots\n")
pdf(file=PLOT.PDF)

tbl <- table(crashes$Crash.Day.Of.Week, crashes$Alcohol.Involved)
tbl <- tbl[DAYS.OF.WEEK,]
percent.alcohol.involved <- 100*(tbl/rowSums(tbl))[,"Y"]
mx <- max(percent.alcohol.involved)
barplot(percent.alcohol.involved, ylim=c(0,mx), main="% of Crashes with Alcohol Involved")

tbl <- table( crashes$Total.Killed, crashes$Crash.Hour)
barplot(tbl, main="Accidents by Hour of Day")


teens.mask   <- crashes$Driver.Age < 20 
under30.mask <- crashes$Driver.Age < 30 
over30.mask  <- crashes$Driver.Age > 30 
teens.counts <- table(crashes[teens.mask, "Crash.Hour"])
under30.counts <- table(crashes[under30.mask, "Crash.Hour"])
over30.counts <- table(crashes[over30.mask, "Crash.Hour"])
plot(   teens.counts/sum(teens.counts)
        ,type="b", col="red"
        ,main="Accidents vs Hour vs AgeGroup"
        ,xlab="Hour of Day"
        ,ylab="Percent of Age Group's Accidents")
lines(under30.counts/sum(under30.counts), type="b", col="green")
lines(over30.counts/sum(over30.counts), type="b", col="blue")


tbl <- table(crashes$Driver.Sex, crashes$Crash.Hour)[c("M","F"),]
barplot(tbl, main="Crashes by Sex by Hour of Day"
        ,xlab="Hour of Day"
        ,col=c("darkblue","pink")
        ,legend = rownames(tbl)
        ,beside=TRUE
)


tbl <- table(crashes$Crash.Weekend, crashes$Crash.Hour)[c(1,2),]
tbl <- tbl / rowSums(tbl)
barplot(tbl, main="Crashes by Weekend Flag and Hour of Day"
        ,xlab="Hour of Day"
        ,col=c("red","green")
        ,legend = rownames(tbl)
        ,beside=TRUE
)


tbl <- table(crashes$Driver.Sex, crashes$Total.Killed > 0)[c("F","M"),2]
barplot(tbl, main="Crashes with any Fatalities, by Sex"
        ,xlab="Sex"
        ,col=c("pink","darkblue")
        ,legend = rownames(tbl)
        ,beside=TRUE
)


tbl <- table(crashes$Driver.Sex, crashes$Alcohol.Involved)[c("F","M"),c("Y")]
barplot(tbl, main="Crashes with Alcohol Involved, by Sex"
        ,xlab="Sex"
        ,col=c("pink","darkblue")
        ,legend = rownames(tbl)
        ,beside=TRUE
)


tbl <- table(crashes$Driver.Sex, crashes$Cell.Phone.In.Use.Flag)[c("F","M"),c("Y")]
barplot(tbl, main="Crashes with Cell Phone In Use, by Sex"
        ,xlab="Sex"
        ,col=c("pink","darkblue")
        ,legend = rownames(tbl)
        ,beside=TRUE
)


tbl <- table(crashes$Driver.Age,  crashes$Total.Vehicles.Involve==1)
age.range <- 17:80
ages <- as.character(age.range)
single.car.crash.percent <- 100 * tbl[ages, 2] / (tbl[ages, 1] + tbl[ages, 2])
single.car.crash.count   <-       tbl[ages, 2] 

plot(   age.range, single.car.crash.percent
        , xlab="Age" , ylab="% of Crashes that are Single-Car" , type="b"
        , main="% of Crashes that are Single Car, by Age")
plot(   age.range, single.car.crash.count
        , xlab="Age" , ylab="Count of Crashes that are Single-Car" , type="b"
        , main="Count of Crashes that are Single Car, by Age")


tbl <- table(crashes$Driver.Age)
age.range <- 17:80
ages <- as.character(age.range)
plot(   age.range, as.vector(tbl[ages])
        , xlab="Age" 
        , ylab="Count of Crashes" 
        , type="b"
        , ylim=c(0, max(tbl[ages]))
        , main="Count of Crashes, by Age")


alcohol.use <- table(crashes$Year, crashes$Alcohol.Involved)[,c("Y")]
phone.use   <- table(crashes$Year, crashes$Cell.Phone.In.Use.Flag)[,c("Y")]
years       <- sort(unique(c(names(alcohol.use), names(phone.use))))
plot( years, alcohol.use
        , ylim=c(0, max(alcohol.use))
        , main="Alcohol vs Phone Use vs Year"
        , type="b"
        , ylab="Accident Count")
lines(years, phone.use, type="b", pch=0)

teens <- crashes$Driver.Age < 20 
alcohol.use <- table(crashes[teens,]$Year, crashes[teens,]$Alcohol.Involved)[,c("Y")]
phone.use   <- table(crashes[teens,]$Year, crashes[teens,]$Cell.Phone.In.Use.Flag)[,c("Y")]
years       <- sort(unique(c(names(alcohol.use), names(phone.use))))
plot( years, alcohol.use
        , ylim=c(0, max(alcohol.use))
        , main="TEENS Only: Alcohol vs Phone Use vs Year"
        , type="b"
        , ylab="Accident Count")
lines(years, phone.use, type="b", pch=0)


tbl <- table(crashes$Crash.Hour, crashes$Alcohol.Involved)
pct.alcohol.involved <- 100 * tbl[,"Y"] / (tbl[,"N"] + tbl[,"Y"])
hours <- as.integer(rownames(tbl))
plot(hours 
    ,pct.alcohol.involved
    ,main="% of Crashes Involving Alcohol"
    ,xlab="Hour of Day"
    ,ylab="Count of Accidents"
    ,type="b"
)


