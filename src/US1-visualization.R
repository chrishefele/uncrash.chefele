# US-visualization.R
#
# Script to create a plot showing the accidents on US 1
# On the bottom is a "subway-line" style graphic, with
# the stops being the cross streets connecting to US 1, 
# and on top is a density plot, showing the density of
# accidents reported at that spot on US 1. 
#
# Chris Hefele, 10/20/2016
#

library(ggplot2)

# Input files
INTERSECTIONS.FILE  <- "../data/US1-intersections.csv"
CRASHES.LOCAL.CSV   <- "../data/crashes-local.csv" 

# Output files
VIZ.PDF.FILE       <- "../plots/US1-visualization.pdf"
VIZ.PNG.FILE       <- "../plots/US1-visualization.png"

# Plot margins, in degrees latitude
LAT.MARGIN.LEFT     <- 0.0015
LAT.MARGIN.RIGHT    <- 0.005

# Get lat/long of US1 intersections with other streets
# & slightly modify the data for better plotting & labeling  
intersections <- read.csv(INTERSECTIONS.FILE, stringsAsFactors=FALSE)
intersections$Street <- paste(format(intersections$Street, justify="right"), "   ")
lat.low <- min(intersections$Latitude) - LAT.MARGIN.LEFT
lat.high<- max(intersections$Latitude) + LAT.MARGIN.RIGHT
intersections <- intersections[2:nrow(intersections),]

cat("Read US1 intersections from :", INTERSECTIONS.FILE, "\n")
cat("\nWill plot the following US 1 intersections:\n")
print(intersections)
cat("\n")

# Get crashes data along US 1
crashes    <- read.csv(CRASHES.LOCAL.CSV)
US1.select <- trimws(crashes$Crash.Location) %in% c("US 1", "RT 1")
crashes    <- crashes[US1.select,]


make.viz <- function(crashes, intersections) {

    # Since US 1 is a straight line locally, can use
    # just latitude to uniquely identify a position
    df.crashes <- data.frame(xvar=crashes$Latitude)

    plt <- ggplot( df.crashes, aes(x=xvar) ) + 
           geom_density(color="red", fill="red", adjust=0.2) + 
           theme( panel.background=element_blank()
                , axis.text.x =element_blank()
                , axis.ticks.x=element_blank()
                , axis.title.x=element_blank()
                , axis.text.y =element_blank()
                , axis.ticks.y=element_blank()
                , axis.title.y=element_blank()
           ) +
           geom_hline(yintercept=0, size=2) + 
           geom_point(  aes(x=Latitude, y=0)
                      , data=intersections
                      , size=3
                      , shape = 21
                      , colour = "black"
                      , fill = "white"
                      , stroke = 2
           ) +
           geom_text(aes(x=Latitude, y=0, label=Street)
                    , data=intersections
                    , angle=45
                    , hjust=1
                    , vjust=0.5
           ) +
           ylim(-100, 200) + 
           xlim(lat.low, lat.high)

    print(plt)
}

# make both a PDF & PNG version of the plot

pdf(file=VIZ.PDF.FILE)
make.viz(crashes, intersections) 
cat("Wrote US 1 visualization to: ", VIZ.PDF.FILE, "\n")

# TODO: font size comes out really small in 3000x3000 image; fix? 
png(filename=VIZ.PNG.FILE, width = 3000, height = 3000)
make.viz(crashes, intersections) 
cat("Wrote US 1 visualization to: ", VIZ.PNG.FILE, "\n")


