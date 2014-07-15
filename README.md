docker-qgis-server
==================

A simple docker container that runs QGIS MapServer.


**Note** this is a demonstrator project only and you should
revise the security etc of this implementation before
using in a production environment.

To build the image do:

```
docker build -t kartoza/docker-qgis-server git://github.com/kartoza/docker-qgis-server
```

To run a container do:

```
docker run --name "qgis-server" -p 2222:22 -p 8080:80 -d -t kartoza/docker-qgis-server
```

To log into your container do:

```
ssh root@localhost -p 2222
```

Default password will appear in docker logs:

```
docker logs <container name> | grep root login password
```

-----------

Tim Sutton (tim@linfiniti.com)
May 2014
