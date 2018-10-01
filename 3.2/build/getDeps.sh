#!/bin/bash
set -e

apt-get -y update

# #-------------Application Specific Stuff ----------------------------------------------------
LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get update &&  \
    apt-get install -y  spawn-fcgi xauth xfonts-100dpi xfonts-75dpi \
        xfonts-base xfonts-scalable xvfb \
        apache2 libapache2-mod-fcgid git

