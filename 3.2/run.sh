#!/bin/bash

source globals.sh

##
## Test
##
docker run -d -p ${TESTPORT}:80 --volume=${PROJECT}:/project --name ${TESTSERVER} kartoza/qgis-server:${MAJOR}.${MINOR}.${BUGFIX}

