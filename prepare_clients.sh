#! /bin/bash

cd enc_ftp/Clients

./prepare_clients

#Cycle through all clients
for dir in $(ls)
do
	cd dir
	if[ $(ls done.txt) != "" ]; then 
			mv -f "$(more task.txt)" "$(more original_path.txt).mp4"
			rm -rf *
	fi 
	cd ..
done

cd ../..