# uncrash

This work examines the data compiled by the "Uncrash" project done by "Code For Princeton." 
A few visualizations are created based on this data. 

The data used is from the uncrash/data directory in the Code For Princeton [Uncrash github repository] (https://github.com/codeforprinceton/uncrash)

An overview of this visualization work is as follows.  Most code is in R.

Note: The original data is not included in this repository; it's assumed to be in ../../uncrash/data 

##./src:
* make-crashes-files.R - Reformats the data to suit my personal analysis needs. Needs to be run first.
* analyze-crashes.R - Various exploratory data analysis plots, looks for possible variable correlations
* map-NJ-from-crashes.R - Plots one point per fatal accident; creates a NJ map
* treemap-crashes-local.R - Treemap of names of crash locations in the Princeton area
* US1-visualization.R - Plots accident density vs position on US 1 in the Princeton area

##./data: 
* Stores the reformatted, intermediate data used for the visualizations. Also includes misc other working data.

##./screenshots: 
* Various screenshots from a GIS tool that created visualizations using the .csv files written by make-crashes-files.R

