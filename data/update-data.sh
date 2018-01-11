#!/bin/bash 

function main() {
	# GBR1
	dir="fx3/gbr1_2.0"
	mkdir -p "${dir}"
	year="2017"
	for month in $(seq -w 12 -1 1); do
		for day in $(seq -w 31 -1 1); do
			filename="gbr1_simple_${year}-${month}-${day}.nc"

			outputpath="${dir}/${filename}"
			file="http://dapds00.nci.org.au/thredds/fileServer/${dir}/${filename}"

			get_netcdf_file $outputpath $file
		done
	done

	# GBR4
	dir="fx3/gbr4_v2"
	mkdir -p "${dir}"
	year="2017"
	for month in $(seq -w 12 -1 1); do
		filename="gbr4_simple_${year}-${month}.nc"

		outputpath="${dir}/${filename}"
		file="http://dapds00.nci.org.au/thredds/fileServer/${dir}/${filename}"

		get_netcdf_file $outputpath $file
	done
}


################################################################
function get_netcdf_file() {
	local outputpath=$1
	local fileurl=$2

	local tmpoutputpath="${outputpath}.unchecked"
	local headeroutputpath="${outputpath}.header"

	if [ -e "${headeroutputpath}" ]; then
		echo "Skipping ${outputpath}, there's header file"
		return 0
	fi

	if [ -e "${outputpath}" ]; then
		echo "Already have ${outputpath}"
		return 0
	fi

	echo "getting ${fileurl}"
	wget -O ${tmpoutputpath} -t 1 --continue 9 ${fileurl}
	if [ ! -e ${tmpoutputpath} ]; then
		echo "$fileurl didn't download"
		return 9
	fi
	# TODO: use ncdump to check its ok
	pushd .
	cd ..
	local HEADER=$(VERSION=4.6.11 docker-compose run thredds-production \
		ncdump -h "/usr/local/tomcat/content/thredds/public/${tmpoutputpath}")
	local OK=$?
	echo "are we $OK"
	popd
	echo "$HEADER" > "$headeroutputpath"
       	if [ "$OK" == "0" ]; then
		echo "OK: ${outputpath}"
		mv ${tmpoutputpath} ${outputpath}
	else
		echo "BROKEN: ${outputpath}"
		return $OK
	fi
	return 0
}

main
