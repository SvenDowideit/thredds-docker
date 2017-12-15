.PHONY: run shell


run:
	VERSION=4.6.11 docker-compose up thredds-production

run5:
	VERSION=5.0-SNAPSHOT docker-compose up thredds-production

shell:
	docker exec -it thredds bash
