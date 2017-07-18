#!/bin/bash

##
## GLOBALS
##
BUGFIX=10
MINOR=18
MAJOR=2
TESTPORT=9999
# $$ at the end will add a random number to the server
TESTSERVER=qgis-server-test$$
URL=http://localhost:${TESTPORT}/
PROJECT=`pwd`/../project
TESTIMAGE=/tmp/test$$.jpg
##
## Build
##

docker build -t kartoza/qgis-server:${MAJOR}.${MINOR}.${BUGFIX} .

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

##
## Decide if we can tag and publish the images
##

if [ "$CAPABILITIES_RESULT" == "3" ]
then
    echo "Test of GetCapabilities Passed"
else
    echo "Searched for <Title>Test</Title> in GetCapabilities, results found: $CAPABILITIES_RESULT"
    echo "Expected: 3"
    exit
fi

if [ "$MIMETYPE" == "image/jpeg" ]
then
    echo "Test of GetMap Passed (verify manually here if needed: ${TESTIMAGE})"
    # Wont work on server, for testing only - comment out
    #open ${TESTIMAGE} || true
else
    echo "Mime Type for GetMap request is: ${MIMETYPE}"
    echo "Expected: image/jpeg"
    exit
fi

##
## Tag and publish
##

docker tag kartoza/qgis-server:2.18.10 kartoza/qgis-server:2.18
docker tag kartoza/qgis-server:2.18.10 kartoza/qgis-server:latest
docker push kartoza/qgis-server:2.18.10
docker push kartoza/qgis-server:2.18
docker push kartoza/qgis-server:latest
