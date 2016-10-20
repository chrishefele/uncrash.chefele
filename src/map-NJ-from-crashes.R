
# map-NJ-from-crashes
#
# This script plots a red point on a white background
# for every crash with a fatality for every crash
# in the dataset with the latitude/longitude recorded.
# It uses the statewide crash data, so the result is the
# shape of the state of NJ, with the major highways
# particularly dense.
#
# Chris Hefele, 10/20/2016

CRASHES.NJ <- "../data/crashes-NJ.Rda"
PLOT.PDF   <- "../plots/map-NJ-from-crashes.pdf"
PLOT.PNG   <- "../plots/map-NJ-from-crashes.png"

make.plot <- function(crashes, pch, cex) {

    killed.mask <- (crashes$Total.Killed > 0)
    plot( crashes[killed.mask,"Longitude"]
         ,crashes[killed.mask,"Latitude"]
         ,type="p"
         ,pch = pch
         ,col="red"
         ,main=""
         ,xlab=""
         ,ylab=""
         ,frame.plot=FALSE
         ,axes=FALSE
         ,asp =  1.2
         ,cex = cex 
    )
}

cat("Reading NJ crash data from: ", CRASHES.NJ, "\n")
crashes <- readRDS(CRASHES.NJ)

pdf(file=PLOT.PDF)
cat("Writing PDF plot to: ", PLOT.PDF, "\n")
make.plot(crashes, ".", 1)

cat("Writing PNG plot to: ", PLOT.PNG, "\n")
png(filename=PLOT.PNG, width = 3000, height = 3000*1.5 )
make.plot(crashes, 20, 3)


