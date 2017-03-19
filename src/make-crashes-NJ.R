
# Script to read all the NJ crash data & just output a file
# of the latitude & longitude of the crashes for all of NJ
#
# Original code by Chris Hefele 10/24/2016
# Updated 1/30/2017 - to create a crashes-NJ.csv file for ALL of NJ

CRASHES.NJ.FILE           <- "../data/crashes-NJ.Rda"
CRASHES.NJ.CSV.FILE       <- "../data/crashes-NJ.csv"

cat("reading : ",  CRASHES.NJ.FILE, "\n")
crashes <- readRDS(CRASHES.NJ.FILE)

mask <- !is.na(crashes$Latitude)  & 
        !is.na(crashes$Longitude) 

col.select       <- c("Latitude", "Longitude")
crashes.regional <- crashes[mask, col.select]

cat("writing: ", CRASHES.NJ.CSV.FILE, "\n")
write.csv(crashes.regional, file=CRASHES.NJ.CSV.FILE, row.names=FALSE)
cat("wrote  : ", CRASHES.NJ.CSV.FILE, "\n")

