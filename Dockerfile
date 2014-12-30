#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM kartoza/qgis-desktop
MAINTAINER Tim Sutton<tim@kartoza.com>

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------


RUN apt-get install -y qgis-mapserver apache2 libapache2-mod-fcgid

EXPOSE 80

ADD apache.conf /etc/apache2/sites-enabled/000-default.conf
ADD fcgid.conf /etc/apache2/mods-available/fcgid.conf

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

# Now launch apache in the foreground
CMD apachectl -D FOREGROUND
