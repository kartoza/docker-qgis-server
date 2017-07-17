docker build -t kartoza/qgis-server:2.14.16 .
docker tag kartoza/qgis-server:2.14.16 kartoza/qgis-server:2.14
docker push kartoza/qgis-server:2.14.16
docker push kartoza/qgis-server:2.14

