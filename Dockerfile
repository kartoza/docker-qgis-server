#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM debian:stable
MAINTAINER Tim Sutton<tim@linfiniti.com>
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN echo "deb     http://qgis.org/debian wheezy main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv 47765B75
RUN gpg --export --armor 47765B75 | apt-key add -

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------


RUN apt-get install -y qgis qgis-mapserver apache2 libapache2-mod-fcgid

EXPOSE 80

# Run any additional tasks here that are too tedious to put in
# this dockerfile directly.
ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh


# Called on first run of docker - will run supervisor
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.s
