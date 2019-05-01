#!/bin/bash

##
## GLOBALS
##
source globals.sh

##
## Test
##
docker run -d -p ${TESTPORT}:80 --volume=${PROJECT}:/project --name ${TESTSERVER} kartoza/qgis-server:${MAJOR}.${MINOR}.${BUGFIX}
CAPABILITIES_RESULT=`wget -qO- "${URL}?service=WMS&request=GetCapabilities" | grep "<Title>Test</Title>" | wc -l | sed 's/ //g'`
MAP_RESULT=`wget -O ${TESTIMAGE} "${URL}?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=-0.6900370000000000115,-1.542440000000000033,1.309960000000000013,1.036899999999999933&CRS=EPSG:4326&WIDTH=977&HEIGHT=758&LAYERS=Test&STYLES=&FORMAT=image/jpeg&DPI=72&MAP_RESOLUTION=72&FORMAT_OPTIONS=dpi:72" > /dev/null`
MIMETYPE=`file -b --mime-type - ${TESTIMAGE} | tail -1`

##
## Clean up
##

docker kill ${TESTSERVER}
docker rm ${TESTSERVER}


