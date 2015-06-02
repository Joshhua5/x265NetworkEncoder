#! /bin/bash



#The server script manages the FTP server and coordinates the files

# Before this may be executed the FTP server has to setup 
# /$CLIENT_FILES/ffmpegflags.txt


#Directory to scan for videos to encode relative to FTP root directory
SCAN_DIR=("Movies" "TV shows" "Recently Added")
TARGET_FILES=("avi" "mkv" "mp4")
CLIENT_FILES="clients"

FTP_USER="client"
FTP_PASS="clientpass"
FTP_SERVER="10.0.0.117"

# Get video information
# ffmpeg -i video.avi

mkdir enc_ftp
#Mount the FTP in the script directory
umount enc_ftp
curlftpfs $FTP_USER:$FTP_PASS@$FTP_SERVER enc_ftp/

#Index the whole ftp server
#If a file is found which isn't x265 then it's added to the queue
#and the new file will replace it's current position and delete the old file
# unless an error occured with encoding, incase a list of faulty videos will
# be produced

while :
do
	echo "Cleaning working directories"
	rm -f work.txt

	echo "Scanning Directories"
	cd enc_ftp
	for dir in "${SCAN_DIR[@]}"
	do
		for ext in "${TARGET_FILES[@]}"
		do
			# Check will use ffmpeg to check the format and append it to 
			# word.txt
			echo "searching for $ext"
			find . -type f -name "*.$ext" -exec ./../check.sh {} \;
		done
	done
	cd ..

	./continue_serving.sh

done

umount enc_ftp

