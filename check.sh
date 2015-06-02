#! /bin/bash
ffmpeg -i "$1" > ../temp.txt

echo "Checking file $file"
if ! grep -o "$1" ../temp.txt
then
	# add this file to the list if it matches hevc
	echo "$1" >> ../work.txt
	echo "Fount Match: $1"
fi
