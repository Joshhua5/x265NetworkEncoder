#! /bin/bash

# First we ask for a host to connect to
HOST_ADDR="www.protheus.com.au"
HOST_PORT=21
OS=osx
CLIENT_NAME=${hostname} 

# busy.txt means the client is current encoding/downloading
# tast.txt contains the file name of what needs to be encoded
# if both done.txt and busy.txt exist it's okay for the server to
# issue a new task and delete busy.txt and done.txt
#Connect to server

ftp 
open $HOST_ADDR
mkdir $CLIENT_NAME
cd $CLIENT_NAME
get /$CLIENT_NAME/done.txt
get /$CLIENT_NAME/task.txt
get ffmpeg_$OS.exe
get ffmpegflags.txt
close

if [ $(ls done.txt) != ""]; then
	sleep(1m)
	./client.sh
fi

if($(ls tast.txt) == ""]; then
	sleep(1m)
	./client.sh
fi

# Analyse the status.txt for a file name

file=$("more task.txt")
echo "busy" |& busy.txt

ftp
open $HOST_ADDR
put /$CLIENT_NAME/busy.txt
get /$CLIENT_NAME/$file
close 

## encode here
ffmpeg_$OS $("more ffmpegflags.txt")

echo "done" |& tee done.txt

ftp
open $HOST_ADDR
put /$CLIENT_NAME/done.txt
close

rm -f busy.txt
rm -f done.txt

# Repeat process after 1m
sleep(1m)
./client.sh
