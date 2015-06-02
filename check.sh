#! /bin/bash

ffmpeg -i "$1" > temp.txt

if[ ($grep -o "hevc" temp.txt != "" ]; then
	# add this file to the list if it matches hevc
	$1 > ../work.txt
fi
