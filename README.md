# uncrash

This work creates visualizations using the data compiled by the "Uncrash" project run by Code For Princeton.
The data is in in the [Uncrash github repository] (https://github.com/codeforprinceton/uncrash)

The code in this repository is (mostly) in R. Also, this repository does not include the original data; the scripts here assume that they can access the original "Uncrash" /data directory using the path "../../uncrash/data"


##./src:
* make-crashes-files.R - Reformats the data to suit my personal analysis needs. Needs to be run first.
* analyze-crashes.R - Various exploratory data analysis plots, looks for possible variable correlations
* map-NJ-from-crashes.R - Plots one point per fatal accident; creates a NJ map
* treemap-crashes-local.R - Treemap of names of crash locations in the Princeton area
* US1-visualization.R - Plots accident density vs position on US 1 in the Princeton area
* get-osm-intersections.py - Parse an Open Street Map file of the Princeton area & determine which streets intersect with Route 1 (not currently used, but perhaps useful in the future).  

##./data: 
* Stores the reformatted, intermediate data used for the visualizations. Also includes misc other working data.

##./screenshots: 
* Various screenshots from a GIS tool that created visualizations using the .csv files written by make-crashes-files.R

