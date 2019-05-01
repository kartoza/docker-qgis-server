#!/bin/bash
set -e

mkdir /build/release
cd /build/release

cmake /build/QGIS \
    -GNinja \
        -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DWITH_DESKTOP=OFF \
	-DWITH_SERVER=ON \
        -DWITH_3D=ON \
        -DWITH_BINDINGS=ON \
        -DBINDINGS_GLOBAL_INSTALL=ON \
	-DWITH_STAGED_PLUGINS=ON \
	-DWITH_GRASS=ON \
	-DSUPPRESS_QT_WARNINGS=ON \
	-DDISABLE_DEPRECATED=ON \
	-DENABLE_TESTS=OFF \
	-DWITH_QSPATIALITE=ON \
	-DWITH_APIDOC=OFF \
	-DWITH_ASTYLE=OFF 

ninja install