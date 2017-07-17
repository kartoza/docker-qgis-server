docker build -t kartoza/qgis-server:2.18.10 .
docker tag kartoza/qgis-server:2.18.10 kartoza/qgis-server:2.18
docker tag kartoza/qgis-server:2.18.10 kartoza/qgis-server:latest
docker push kartoza/qgis-server:2.18.10
docker push kartoza/qgis-server:2.18
docker push kartoza/qgis-server:latest
