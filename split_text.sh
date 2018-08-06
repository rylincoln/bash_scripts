#!/usr/local/bin/bash

shopt -s extglob

echo -e "\n-What is the filename you would like to split?"

while [[ "$inputfile" == '' ]]
do
    ls -G
    read -e -p "Input file:" inputfile
    if [ "$inputfile" == '' ]; then
      echo "Enter a file name"
    fi
done

header=$(head -n 1 "$inputfile")

echo -e "\n-Output file root"
while [[ "$outfile" == '' ]]
do
    read -e -p "Root name:" outfile
    if [ "$outfile" == '' ]; then
    echo "blank is not valid"
    fi
done

if [ ! -f "$inputfile" ]; then
    echo -e "\nFile not found!"
else
    echo "$inputfile exists! Good job."
fi

echo -e "\n-How many lines do you want in each file?"

while ! [[ "$lines" =~ ^[0-9]+$ ]]
do 
    read -e -p "Enter an integer greater than zero:" lines
    if ! [[ "$lines" =~ ^[0-9]+$ ]]
        then
            echo "Sorry integers only"
    fi
done

mkdir temp

tail -n +2 "$inputfile" >> temp/tempfile.csv

split -l $lines temp/tempfile.csv temp/$outfile

for f in temp/$outfile*; do mv $f $f.csv; done

for i in temp/*.csv; do 
    sed -i "1i$header" $i;
done 

rm temp/tempfile.csv
