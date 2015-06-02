#! /bin/bash

echo "Serving Work"

./prepare_clients

cat work.txt | while read line; do ./pass.sh $line; sed '0d' work.txt; done