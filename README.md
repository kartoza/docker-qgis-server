QGIS Server for Docker
========================

A simple docker container that runs QGIS Server

This image uses the [QGIS Desktop docker image](https://github.com/kartoza/docker-qgis-desktop).

# License

[GPL V2](http://www.gnu.org/licenses/old-licenses/gpl-2.0.html)


**Note** this is a demonstrator project only and you should revise the security
etc of this implementation before using in a production environment.


# Example use with docker compose

Here is a contrived example showing how you can run QGIS Server
from in a docker container using docker-compose. Example ``docker-compose`` follows:

```
db:
  image: kartoza/postgis:9.4-2.1
  environment:
    - USERNAME=docker
    - PASS=docker
  
qgisserver:
  image: kartoza/qgis-server:2.14
  hostname: qgis-server
  volumes:
    # Wherever you want to mount your data from
    - ./web:/web
  links:
    - db:db
  ports:
    - "80801:80"
```

To run the example do:

```
docker-compose up
```

You should see QGIS server start up. For more detailed approaches 
to using and building the QGIS Server container, see below.

**Note:** The database in the above example is stateless (it will be deleted when
running ``docker-compose rm``). If you want to connect to the PG database from docker
use the following info:

* host: db
* database: gis
* user: docker
* password: docker


# More details

To use the image, either pull the latest trusted build from 
https://registry.hub.docker.com/u/kartoza/docker-qgis-server/ by doing this:

```
docker pull kartoza/qgis-server
```

or build the image yourself like this:

```
docker build -t kartoza/qgis-server git://github.com/kartoza/docker-qgis-server
```

**Note:** The 'build it yourself' option above will build from the develop branch
wheras the trusted builds are against the master branch.


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

Tim Sutton (tim@kartoza.com)
May 2014
