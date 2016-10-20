
# treemap-crashes-local
#
# This script creates a treemap of the top crash
# locations, as reported in the crash data.
# The number of locations to use is configurable, 

library(treemap)

N.LOCATIONS     <- 100 # 100 yields good results; captures 75% of crashes
CRASHES.LOCAL   <- "../data/crashes-local.Rda"
PLOT.PDF        <- "../plots/treemap-crashes-local.pdf"

# For debugging, can do the following plot of cumulative crashes vs N.LOCATIONS
# plot(cumsum(df$Crash.Count), type ="l", 
# main="Cumulative Crashes vs Number of locations")

# Read the crash data & sort by the frequency each crash location is repoted

cat("Reading local crash data from: ", CRASHES.LOCAL, "\n")

crashes <- readRDS(CRASHES.LOCAL)
tbl <- table(crashes$Crash.Location)
df  <- as.data.frame(tbl)
names(df) <- c("Crash.Location", "Crash.Count")
df  <- df[order(df$Crash.Count, decreasing=TRUE),]
df.top <- df[1:N.LOCATIONS,]

# make the treemap of the top locations

cat("Writing treemap to : ", PLOT.PDF, "\n")
pdf(file=PLOT.PDF)

#plot.title <- paste("Treemap of Top", as.character(N.LOCATIONS), "Crash Locations")
plot.title <- ""

treemap(df.top, 
    index=c("Crash.Location"), # tuples 
    vSize = "Crash.Count",  # variable for box size
    type="index",           # sets the organization & color scheme 
    palette = "Oranges",       
    title=plot.title,
    fontsize.title = 14,     # font size of the title
    fontsize.labels= 36,
    lowerbound.cex.labels=0, 
    inflate.labels=FALSE
)


