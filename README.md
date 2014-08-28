docker-qgis-server
==================

A simple docker container that runs QGIS MapServer.


**Note** this is a demonstrator project only and you should revise the security
etc of this implementation before using in a production environment.

To build the image do:

```
docker build -t kartoza/qgis-server git://github.com/kartoza/qgis-server
```

To run a container do:

```
docker run --name "qgis-server" -p 2222:22 -p 8080:80 -d -t kartoza/docker-qgis-server
```

Probably you will want to mount the /web folder with local volume
that contains some QGIS projects. Also consider looking at
https://github.com/kartoza/docker-qgis-orchestration which
provides a cloud infrastructure including QGIS Server.

-----------

Tim Sutton (tim@linfiniti.com)
May 2014
