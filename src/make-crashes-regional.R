
# Script to read all the NJ crash data & just output a file
# of the latitude & longitude of crashes within a bounding
# box centered on the Princeton/WW region, but with very wide margins. 
# This will be used for an experimental heatmap 
# plot of the region using carto.com
#
# Chris Hefele 10/24/2016

CRASHES.NJ.FILE           <- "../data/crashes-NJ.Rda"
CRASHES.REGIONAL.CSV.FILE <- "../data/crashes-regional.csv"

# Princeton region lat/long bounding box with a wide margin

LAT.MIN  <-  40.10
LAT.MAX  <-  40.50
LONG.MIN <- -75.00
LONG.MAX <- -74.30

cat("reading : ", CRASHES.NJ.FILE, "\n")
crashes <- readRDS(CRASHES.NJ.FILE)

mask <- !is.na(crashes$Latitude)  & 
        !is.na(crashes$Longitude) & 
        crashes$Latitude  > LAT.MIN  &
        crashes$Latitude  < LAT.MAX  & 
        crashes$Longitude > LONG.MIN & 
        crashes$Longitude < LONG.MAX

col.select       <- c("Latitude", "Longitude")
crashes.regional <- crashes[mask, col.select]

cat("writing: ", CRASHES.REGIONAL.CSV.FILE, "\n")
write.csv(crashes.regional, file=CRASHES.REGIONAL.CSV.FILE, row.names=FALSE)
cat("wrote  : ", CRASHES.REGIONAL.CSV.FILE, "\n")

