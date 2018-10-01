# using ARG in FROM requires min v17.05.0-ce
ARG DOCKER_TAG=final-3_2_3
# To enable Debug Info build with --build-arg CMAKE_BUILD_TYPE=RelWithDebInfo
ARG CMAKE_BUILD_TYPE=Release

FROM qgis/qgis3-build-deps:${DOCKER_TAG}

# Based off work by
# Patrick Valsecchi<patrick.valsecchi@camptocamp.com>
MAINTAINER Tim Sutton<tim@kartoza.com>

# Variables for building qgis-server
ENV CC=/usr/lib/ccache/clang
ENV CXX=/usr/lib/ccache/clang++
ENV QT_SELECT=5
ENV LANG=C.UTF-8

# A few variables needed by apache
ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2

COPY build /build/scripts
RUN /build/scripts/getDeps.sh && \
    /build/scripts/apache.sh

# Build QGIS-server after apache to reuse image layers
RUN /build/scripts/getCode.sh && \
    /build/scripts/make.sh && \
    /build/scripts/clean.sh && \
    mv /usr/bin/qgis_mapserv.fcgi /usr/lib/cgi-bin/


#
# Add any qgis server plugins we want to ship by default
#

# Add QGIS Server on the fly project creation support
# see https://github.com/kartoza/otf-project

# Not supported yet, needs python 3 

#WORKDIR /opt/qgis-server/plugins
#ARG OTF_PROJECT_TAG=master
#RUN git clone --branch ${OTF_PROJECT_TAG} --depth 1 https://github.com/kartoza/otf-project.git

#
# End of server plugins section
#


# A few tunable variables for QGIS
ENV FCGI_IO_TIMEOUT 120
ENV QGIS_SERVER_CACHE_SIZE 50
ENV QGIS_DEBUG 5
ENV QGIS_LOG_FILE /proc/self/fd/1
ENV QGIS_SERVER_LOG_FILE /proc/self/fd/1
ENV QGIS_SERVER_LOG_LEVEL 5
ENV PGSERVICEFILE /project/pg_service.conf
ENV QGIS_PROJECT_FILE /project/project.qgs
ENV QGIS_PLUGINPATH /opt/qgis-server/plugins

COPY runtime /

EXPOSE 80

CMD ["apache2", "-DFOREGROUND"]
