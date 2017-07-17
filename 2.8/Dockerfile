FROM ubuntu:16.04
MAINTAINER Patrick Valsecchi<patrick.valsecchi@camptocamp.com>

# A few variables needed by apache
ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C

COPY build /build/scripts
RUN /build/scripts/getDeps.sh && \
    /build/scripts/apache.sh

# A few tunable variables for QGIS
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
