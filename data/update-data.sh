#!/bin/bash 

outputdir="fx3/gbr1_2.0"

mkdir -p "${outputdir}"

year="2017"
for month in $(seq -w 12 -1 11); do
	for day in $(seq -w 31 -1 1); do
		file="http://dapds00.nci.org.au/thredds/fileServer/fx3/gbr1_2.0/gbr1_simple_${year}-${month}-${day}.nc"

		filename="${outputdir}/gbr1_simple_${year}-${month}-${day}.nc"
		tmpfilename="${filename}.unchecked"
		headerfilename="${filename}.header"

		if [ -e "${headerfilename}" ]; then
			echo "Skipping ${filename}, there's header file"
			continue
		fi

		if [ -e "${filename}" ]; then
			echo "Already have ${filename}"
			continue
		fi

		echo "getting ${file}"
		wget -O ${tmpfilename} -t 1 --continue ${file}
		if [ ! -e ${tmpfilename} ]; then
			echo "$file didn't download"
			continue
		fi
		# TODO: use ncdump to check its ok
		pushd .
		cd ..
		HEADER=$(VERSION=4.6.11 docker-compose run thredds-production \
			ncdump -h "/usr/local/tomcat/content/thredds/public/${tmpfilename}")
		OK=$?
		echo "are we $OK"
		popd
		echo "$HEADER" > "$headerfilename"
	       	if [ "$OK" == "0" ]; then
			echo "OK: ${filename}"
			mv ${tmpfilename} ${filename}
		else
			echo "BROKEN: ${filename}"
		fi
	done
done
