#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM kartoza/qgis-desktop:master
MAINTAINER Tim Sutton<tim@kartoza.com>

#-------------Application Specific Stuff ----------------------------------------------------


# Set up the postgis services file
# On the client side when referencing postgis
# layers, simply refer to the database using
# Service: gis
# instead of filling in all the host etc details.
# In the container this service will connect 
# with no encryption for optimal performance
# on the client (i.e. your desktop) you should
# connect using a similar service file but with
# connection ssl option set to require

ADD pg_service.conf /etc/pg_service.conf
# This is so the qgis mapserver uses the correct
# pg service file
ENV PGSERVICEFILE /etc/pg_service.conf

# Configuration for spawning FCGI with 15 listeners and a backlog of 1024
# you can override this in your docker.conf
ENV FCGI_CHILDREN 15
ENV FCGI_BACKLOG 1024 

EXPOSE 9999

USER www-data

CMD spawn-fcgi -F FCGI_CHILDREN -b FCGI_BACKLOG -d /gis -p 9999 -n -- /usr/lib/qgis_mapserv.fcgi && tail -f /dev/null
#CMD ["spawn-fcgi", "-F FCGI_CHILDREN", "-b FCGI_BACKLOG", "-d /gis", "-p 9999", "-n", "--", "/usr/lib/qgis_mapserv.fcgi", '&&', 'cat', '/dev/null']
#CMD ["spawn-fcgi", "-u www-data", "-G www-data", "-F FCGI_CHILDREN", "-b FCGI_BACKLOG", "-d /gis", "-p 9999", "--", "/usr/lib/qgis_mapserv.fcgi"]
