#!/bin/bash

./build.sh 
docker kill fcgiserver 
docker rm fcgiserver 

WORKDIR=`pwd`/gis
echo $WORKDIR
docker run --name=fcgiserver -v $WORKDIR:/gis -p 9999:9999  -ti kartoza/qgis-server:latest 
