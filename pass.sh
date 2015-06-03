#! /bin/bash

# Check for finished clients

./prepare_clients

#Check/Wait for a avaliable Client

cd enc_ftp/Clients

#Cycle through all clients
for dir in $(ls)
do
	cd dir
	if ls done.txt
		then
		if ls tast.txt
			then
			# pass the file
			mv "$1" "$(basename $1)"
			"$1" | original_path.txt
			"$(basename $1)" | tast.txt
			exit
		fi
	fi 
	cd ..
done

cd ../..
