QGIS Server for Docker
========================

A simple docker container that runs QGIS Server

This image uses the [QGIS Desktop docker image](https://github.com/kartoza/docker-qgis-desktop) as its base.

Please see the [canonical documentation](
http://docs.qgis.org/2.14/en/docs/user_manual/working_with_ogc/ogc_server_support.html) 
for QGIS Server if you need more general info on how QGIS Server works.



**Note** You should revise the security
etc. of this implementation before using in a production environment.

# License

[GPL V2](http://www.gnu.org/licenses/old-licenses/gpl-2.0.html)


# QGIS Server documentation

Please see the [canonical documentation](
http://docs.qgis.org/2.14/en/docs/user_manual/working_with_ogc/ogc_server_support.html) 
for QGIS Server if you need more general info on how QGIS Server works.

# Usage

To use the image, either pull the latest trusted build from 
https://registry.hub.docker.com/u/kartoza/qgis-server/ by doing this:

```
docker pull kartoza/qgis-server:LTR
```

Note that the LTR build will always track the most recent QGIS Long
Term Release build.

We use versioned images and highly recommend that you track a specific
version for your orchestrated services since things may break between
versions.

In this repository you will find a subdirectory for each QGIS version
supported. Each directory contains a self contained docker project
and we will maintain all the versioned builds from these containers.

Master should always be considered the latest

You can build the image yourself like this:

```
git clone git://github.com/kartoza/docker-qgis-server
cd docker-qgis-server/2.14
docker build -t kartoza/qgis-server .
```

**Note:** The 'build it yourself' option above will build from the develop branch
wheras the trusted builds are against the master branch.


To run a container do:

```
docker run --name "qgis-server" -p 9999:80 -d -t kartoza/qgis-server
```


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



Apache environment variables
============================

Apache will make of the following environment variables. You can 
tweak these by replacing these options in your docker-compose.yml
or docker run command.

```
APACHE_CONFDIR /etc/apache2
APACHE_ENVVARS $APACHE_CONFDIR/envvars
APACHE_RUN_USER www-data
APACHE_RUN_GROUP www-data
APACHE_RUN_DIR /var/run/apache2
APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
APACHE_LOCK_DIR /var/lock/apache2
APACHE_LOG_DIR /var/log/apache2
LANG C
```

The following variables (with defaults shown) are QGIS specific
options you can tweak by replacing these options in your docker-compose.yml
or docker run command.

```
QGIS_DEBUG 5
QGIS_LOG_FILE /proc/self/fd/1
QGIS_SERVER_LOG_FILE /proc/self/fd/1
QGIS_SERVER_LOG_LEVEL 5
PGSERVICEFILE /project/pg_service.conf
QGIS_PROJECT_FILE /project/project.qgs
QGIS_PLUGINPATH /opt/qgis-server/plugins
```

Probably you will want to mount the /project folder with local volume
that contains some QGIS projects. As you can see above, if no project
file is specified, QGIS will try to server up /projects/project.qgs by
default so if you are looking for an easy to share WMS/WFS url, simply
call your project file project.qgs and mount it in the /projects
directory.

```
./build.sh; docker kill server; docker rm server; 
docker run --name="qgis-server" \
    -d -p 9999:80 \
    kartoza/qgis-server:LTR
 docker logs qgis-server
```

Replace ``<path_to_local_qgis_project_folder>`` with an absolute path on your
filesystem. That folder should contain the .qgs project files you want to
publish and all the data should be relative to the project files and within the
mounted volume. See https://github.com/kartoza/maps.kartoza.com for an example
of a project layout that we use to power http://maps.kartoza.com


Accessing the services:

Simply entering the URL of the docker container with its port number
will respond with a valid OGC response if you use this url in QGIS 
'add WMS layer' dialog.

http://192.168.99.101:9999/


-----------

Authors:

Tim Sutton (tim@linfiniti.com) - May 2014

Acknowledgement:

During the Girona QGIS hackfest in 2016, Patrick Valsecchi did an 
almost complete re-write of this image recipe which I have heavily 
based this and the recipe in docker-qgis-desktop on. Thanks Patrick!
