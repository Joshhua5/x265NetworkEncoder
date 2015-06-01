#! /bin/bash

# First we ask for a host to connect to
HOST_ADDR="10.0.0.117"
HOST_PORT=21
OS=osx
CLIENT_NAME=$HOSTNAME
CLIENT_FILES="Clients"
FTP_USER="client"
FTP_PASS="clientpass"

# busy.txt means the client is current encoding/downloading
# tast.txt contains the file name of what needs to be encoded
# if both done.txt and busy.txt exist it's okay for the server to
# issue a new task and delete busy.txt and done.txt

# The client computer must have a executable version of ffmpeg
# in the directory of the script of globally accessible

#Connect to server

ftp -n << END_SCRIPT 
open $HOST_ADDR
user $FTP_USER $FTP_PASS
cd $CLIENT_FILES
mkdir $CLIENT_NAME
get $CLIENT_NAME/done.txt
get $CLIENT_NAME/task.txt 
get ffmpegflags.txt
quit
END_SCRIPT

if [ "$(ls done.txt)" != "" ]; then
	echo "Still waititng on new task"
	sleep 1m
	./client.sh
fi

if [ "$(ls task.txt)" == "" ]; then
	echo "No task has been provided"
	sleep 1m
	./client.sh
fi

# Analyse the status.txt for a file name

file=$("more task.txt")
echo "busy" |& busy.txt

ftp
open $HOST_ADDR
$FTP_USER
$FTP_PASS
put $CLIENT_FILES/$CLIENT_NAME/busy.txt
get $CLIENT_FILES/$CLIENT_NAME/$file
quit 

## encode here
# Requires ffmpeg https://www.ffmpeg.org/download.html
ffmpeg $("more ffmpegflags.txt")

echo "done" |& tee done.txt

ftp
open $HOST_ADDR
$FTP_USER
$FTP_PASS
put $CLIENT_FILES/$CLIENT_NAME/done.txt
quit

rm -f busy.txt
rm -f done.txt

# Repeat process after 1m
sleep 1m
./client.sh
