QGIS Server for Docker
========================

A simple docker container that runs QGIS Server

This image uses the [QGIS Desktop docker image](https://github.com/kartoza/docker-qgis-desktop) as its base.

**Note** You should revise the security
etc. of this implementation before using in a production environment.

# QGIS Server documentation

Please see the [canonical documentation](
http://docs.qgis.org/2.18/en/docs/user_manual/working_with_ogc/ogc_server_support.html)
for QGIS Server if you need more general info on how QGIS Server works.


# License

[GPL V2](http://www.gnu.org/licenses/old-licenses/gpl-2.0.html)


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

You can build the image yourself like this:

```
git clone git://github.com/kartoza/docker-qgis-server
cd docker-qgis-server/2.18
docker build -t kartoza/qgis-server .
```

To run a container do:

```
docker run --name "qgis-server" -p 8080:80 -d -t kartoza/qgis-server
```

`http://localhost:8080` should show QGIS Server, with an error because it 
couldn't find a QGIS project to parse.

**NOTE:** Again we would like to recommend you run a tagged version rather
than just the latest since your configuration may break if we change something.

If you have a single QGIS project on your host to publish, you can use this command:
```
docker run --name "qgis-server" -v /path/to/your/project_folder/:/project -p 8080:80 -d -t kartoza/qgis-server:LTR

# Use the default test project provided by this repository in the project folder:
docker run --name "qgis-server" -v $(PWD)/project/:/project -p 8080:80 -d -t kartoza/qgis-server:LTR
```
The container will try to load the project located in `/project` called `project.qgs`.
You can override this setting using environment variable, see below about apache configuration.
`http://localhost:8080` should show QGIS Server with your correct project.
`http://localhost:8080/?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities` should give the GetCapabilities.

However, if you have many QGIS projects, you need to give the path to the project in the URL:
We mount our project folder in `/gis` in this example to show that the name is not important.
**Be careful, you need to set the environment variable `QGIS_PROJECT_FILE` to none,
as your project won't be found under `/project/project.qgs`.
```
docker run --name "qgis-server" -e QGIS_PROJECT_FILE='' -v /path/to/your/project_folder:/gis -p 8080:80 -d -t kartoza/qgis-server:LTR

# Use the default test project provided by this repository in the project folder:
docker run --name "qgis-server" -e QGIS_PROJECT_FILE='' -v $(PWD)/project/:/gis -p 8080:80 -d -t kartoza/qgis-server:LTR
```
`http://localhost:8080/?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities&MAP=/gis/project.qgs` should give the GetCapabilities.


# Example use with docker compose

Here is a contrived example showing how you can run QGIS Server
from in a docker container using docker-compose. Example ``docker-compose`` follows:

```
db:
  image: kartoza/postgis:9.6-2.4
  environment:
    - USERNAME=docker
    - PASS=docker

qgisserver:
  image: kartoza/qgis-server:LTR
  hostname: qgis-server
  volumes:
    # Wherever you want to mount your data from
    - ./project:/project
  links:
    - db:db
  ports:
    - "8080:80"
```

To run the example do:

```
docker-compose up
```

You should see QGIS server start up. For more detailed approaches
to using and building the QGIS Server container, see below.

`http://localhost:8080` should show QGIS Server.

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
file is specified, QGIS will try to serve up /project/project.qgs by
default so if you are looking for an easy to share WMS/WFS url, simply
call your project file project.qgs and mount it in the /project
directory.

```
./build.sh; docker kill server; docker rm server;
docker run --name="qgis-server" \
    -d -p 8080:80 \
    kartoza/qgis-server:LTR
 docker logs qgis-server
```

Replace ``<path_to_local_qgis_project_folder>`` with an absolute path on your
filesystem. That folder should contain the .qgs project files you want to
publish and all the data should be relative to the project files and within the
mounted volume. See https://github.com/kartoza/maps.kartoza.com for an example
of a project layout that we use to power http://maps.kartoza.com

An example project folder is provided here for convenience (and we
use it for validation testing).

Accessing the services:

Simply entering the URL of the docker container with its port number
will respond with a valid OGC response if you use this url in QGIS
'add WMS layer' dialog.

`http://localhost:8080` should show QGIS Server.

-----------

Authors:

Tim Sutton (tim@kartoza.com) - May 2014

Acknowledgement:

During the Girona QGIS hackfest in 2016, Patrick Valsecchi did an
almost complete re-write of this image recipe which I have heavily
based this and the recipe in docker-qgis-desktop on. Thanks Patrick!
