#!/bin/bash 

mkdir -p fx3/gbr1_2.0
cd fx3/gbr1_2.0

year="2017"
for month in $(seq -w 12 -1 12); do
	for day in $(seq -w 31 -1 1); do
		file="http://dapds00.nci.org.au/thredds/fileServer/fx3/gbr1_2.0/gbr1_simple_${year}-${month}-${day}.nc"
		echo "getting ${file}"
		wget -t 1 --continue ${file}
	done
done
