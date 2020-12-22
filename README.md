# Project "Uncrash"

This work creates visualizations using the data compiled by the "Uncrash" project run by Code For Princeton.
The data is in in the [Uncrash github repository] (https://github.com/codeforprinceton/uncrash)

The "Uncrash" team won 1st place in the "Data & Art Hackathon" at the West Windsor Arts Center in 10/23/2016. Some of the visualizations in this repo were used as part of the team's prize-winning entry.

If you're just interested in the visualizations, look in the ./plots ./screenshots and ./presentation directories!

The code used to create these plots/visualizations are (mostly) in R. Also, this repository does not include the original data; the scripts here assume that they can access the original "Uncrash" /data directory using the path "../../uncrash/data"

## ./plots:

The visualizations! (.PDF & .PNG files)

## ./screenshots: 

Various screenshots from a GIS tool (carto.com) that created visualizations using the .csv files written by make-crashes-files.R

## ./presentation:

The best plots/images/screenshots, used for the "Uncrash" team presentation at the Oct 2016 Arts & Data Hackathon. 

## ./src:

* make-crashes-files.R - Reformats the data to suit my personal analysis needs. Needs to be run first.
* analyze-crashes.R - Various exploratory data analysis plots, looks for possible variable correlations
* map-NJ-from-crashes.R - Plots one point per fatal accident; creates a NJ map
* treemap-crashes-local.R - Treemap of names of crash locations in the Princeton area
* US1-visualization.R - Plots accident density vs position on US 1 in the Princeton area
* get-osm-intersections.py - Parse an Open Street Map file of the Princeton area & determine which streets intersect with Route 1 (not currently used, but perhaps useful in the future).  
* top-crash-latlong-stats.R - Calculates various statistics & demographics about the top crash latitude/longitude pairs and writes a .csv for importing into a GIS tool. 
* top-crash-location-stats.R - Calculates various statistics & demographics about the top crash locations (by street name) & prints out tables.

## ./data: 

Stores the reformatted, intermediate data used for the visualizations (in .csv and .Rda format). Also includes misc other working data. Specifically: 

* crashes-local.csv - Crash information for Princeton, Princeton Township & West Windsor. Contains just those crashes with GPS latitude/longitude information (about 20% of all crashes). This is used to import to a GIS tool for visualization. 
* crashes-local.Rda - Same as above, but with all crashes (even those without GPS location). In ".Rda" format for importing in R.
* crashes-NJ.Rda - Same as above, but for all of NJ
* map-US1-pton-area.osm - Open Street Map (.osm) formatted data for a map of the Princeton/WW area. 
* top-crash-latlong-stats.csv - Mean/distributions of crash data for the top latitude/longitude pairs that had mutiple crashes. Used to import into a GIS tool for visualization. 
* US1-intersections.csv - Latitude & longitude of major cross-streets on Route 1. Used by US1-visualization.R


