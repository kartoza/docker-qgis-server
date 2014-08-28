docker-qgis-server
==================

A simple docker container that runs QGIS MapServer.


**Note** this is a demonstrator project only and you should revise the security
etc of this implementation before using in a production environment.

To build the image do:

```
docker build -t kartoza/qgis-server git://github.com/kartoza/docker-qgis-server
```

To run a container do:

```
docker run --name "qgis-server" -p 8081:80 -d -t kartoza/qgis-server
```

Probably you will want to mount the /web folder with local volume
that contains some QGIS projects. 

```
docker run --name "qgis-server" \
    -v <path_to_local_qgis_project_folder>:/web \
    -p 8081:80 -d -t kartoza/qgis-server
```

Replace ``<path_to_local_qgis_project_folder>`` with an absolute path on your
filesystem. That folder should contain the .qgs project files you want to
publish and all the data should be relative to the project files and within the
mounted volume. See https://github.com/kartoza/maps.kartoza.com for an example
of a project layout that we use to power http://maps.kartoza.com


Also consider looking at https://github.com/kartoza/docker-qgis-orchestration
which provides a cloud infrastructure including QGIS Server.

-----------

Tim Sutton (tim@linfiniti.com)
May 2014
