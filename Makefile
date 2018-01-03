.PHONY: run shell

build:
	docker build -t unidata/thredds-docker:4.6.11 .

run:
	VERSION=4.6.11 docker-compose up thredds-production

run5:
	VERSION=5.0-SNAPSHOT docker-compose up thredds-production

dev:
	VERSION=dev docker-compose up thredds-production

shell:
	docker exec -it thredds bash

update-data:
	cd data; ./update-data.sh

check-data:
	docker exec -it thredds sh -c "cd /usr/local/tomcat/content/thredds/public; ./check-data.sh"

cataloginit:
	 docker exec -it thredds cat /usr/local/tomcat/content/thredds/logs/catalogInit.log

slog:
	 docker exec -it thredds cat /usr/local/tomcat/content/thredds/logs/threddsServlet.log
