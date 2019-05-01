#!/bin/bash
set -e

cd /build
echo "Checking out tag $DOCKER_TAG"
git clone --depth 1 -b $DOCKER_TAG git://github.com/qgis/QGIS.git

cd QGIS
