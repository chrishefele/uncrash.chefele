# get-osm-intersections
#
# Script to read OSM (Open Street Map) files & find 
# where US 1 intersects with cross streets.
#
# Note this is incomplete, but this script is no longer needed.
# (I took another approach for the US 1 viz, making this script moot).
# But parsing OSM data could be useful for other projects.
# 
# This code was derived in part from:
# http://stackoverflow.com/questions/14716497/how-can-i-find-a-list-of-street-intersections-from-openstreetmap-data 
#
# Chris Hefele, 10/20/2016

import sys
from collections import defaultdict

try:
    from xml.etree import cElementTree as ET
except ImportError, e:
    from xml.etree import ElementTree as ET

def extract_intersections(osm, verbose=True):

    # This function takes an osm file as an input. It then goes through each xml 
    # element and searches for nodes that are shared by two or more ways.
    #
    # Parameter:
    # - osm: An xml file that contains OpenStreetMap's map information
    # - verbose: If true, print some outputs to terminal.

    tree = ET.parse(osm)
    root = tree.getroot()
    counter = defaultdict(list)
    for child in root:
        if child.tag == 'way':

            road_name = "_"
            for item in child: # find road name tag in the way
                if item.tag=='tag' and item.attrib['k']=='name':
                   road_name = item.attrib['v'] 

            for item in child: # store each node in the way
                if item.tag == 'nd':
                    nd_ref = item.attrib['ref']
                    counter[nd_ref].append(road_name)

    for nd_ref in counter:
        if len(counter[nd_ref]) > 1 and "Brunswick Pike" in counter[nd_ref]:
            print nd_ref, counter[nd_ref]

    # Find nodes that are shared with more than one way, which
    # might correspond to intersections

    intersections = filter(lambda x: len(counter[x]) > 1,  counter)

    # Extract intersection coordinates

    intersection_coordinates = []
    for child in root:
        if child.tag == 'node' and child.attrib['id'] in intersections:
            coordinate = child.attrib['lat'] + ',' + child.attrib['lon']
            if verbose:
                print coordinate
            intersection_coordinates.append(coordinate)

    return intersection_coordinates

if __name__ == '__main__':
    osm_filename = sys.argv[1]
    print "Finding intersections in OSM file:", osm_filename
    extract_intersections(osm_filename, verbose=True)

