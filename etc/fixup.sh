#!/bin/sh
# this is a shell script to create a local configuration for Apache to run
# with PHP and MYSQL.
#
# this is based upon work in the ircan.gc.ca's ITERation project.
#

while [ ! -d public ]
do
	cd ..
done

if [ -d public ]
then
    TOPDIR=$(pwd)
else
    echo it seems that I can not find the top-level htdocs
    exit 2
fi
	
PORT=$(./etc/portnum.sh)
VERSION=1

export LANG=C
export LC_TIME=C

APACHE2_MODDIR=$(if [ -d /usr/lib/apache2/modules ]; then echo /usr/lib/apache2/modules; else echo WHERE IS APACHE; fi; )
WEBSERVER=$(if [ -x /usr/sbin/httpd2 ]; then echo  /usr/sbin/httpd2; elif [ -x /usr/sbin/apache2 ]; then echo /usr/sbin/apache2; fi)
PHP5_MODDIR=${APACHE2_MODDIR}
CONFFILES="apache2.conf php.ini runweb.sh"
SYSTEMPORT=$(./etc/portnum.sh )
IPADDRESS=127.0.0.1
MIMETYPES=$(if [ -f /etc/apache2/mime.types ]; then echo /etc/apache2/mime.types; elif [ -f /etc/mime.types ]; then echo /etc/mime.types; fi)
SYSTEMURL=$(echo 'http://localhost:'${SYSTEMPORT}'/')

# now create all the relevant files.

localize() {
    file=$1
    echo Processing $file
	sed -e 's,@TOPDIR@,'${TOPDIR}',g' \
            -e 's,@APACHE2_MODDIR@,'${APACHE2_MODDIR}',g' \
            -e 's,@WEBSERVER@,'${WEBSERVER}',g' \
            -e 's,@MIMETYPES@,'${MIMETYPES}',g' \
            -e 's,@PHP5_MODDIR@,'${PHP5_MODDIR}',g' \
            $file.in >$file
	if [ -x $file.in ]; then chmod +x $file; fi
}

mkdir -p $TOPDIR/run/log
mkdir -p $TOPDIR/run/log/apache2
mkdir -p $TOPDIR/run/lock

localize etc/apache2.conf
localize etc/runweb.sh
localize etc/php.ini
localize etc/shutit.sh
localize etc/initdb.sh
localize etc/rundb.sh
localize etc/shutdb.sh
localize etc/shutit.sh
if [ -f php/install-settings.php.in ]; then
    localize php/install-settings.php
fi


