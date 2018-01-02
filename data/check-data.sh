#!/bin/bash

for f in $(ls fx3/gbr1_2.0/*.nc); do 
	ncdump -h $f > /dev/null
	#pushd .
	#HEADER=$(VERSION=4.6.11 docker-compose run thredds-production ncdump -h /usr/local/tomcat/content/thredds/public/$f)
	#popd
      	#echo $HEADER > "${filename}.header"
done
