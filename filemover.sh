#!/bin/bash

ssd="/media/shef/Extreme SSD/pics all/main branch/"
hhd="/media/shef/CC8A86968A867CA8/pics/"

# hhd="'/media/shef/CC8A86968A867CA8/pics/main branch/2022\ all'"

f1="/home/shef/Desktop/pics fuji/f1"
f2="/home/shef/Desktop/pics fuji/f2"
count=0


diff -r "${f1}" "${f2}"


# for loop file and see if file in ssd directory
# need to cd to dirrectory in order to get file from that dirrectory and use cp
for file in $(ls "${f1}")

do  
    fileCheck="${f2}/${file}"
    cd "${f1}"
    if [[ ! -f "${fileCheck}" ]];
    then
        count=$((count + 1))
        cp ${file} "${f2}"
    fi
done


if [ ${count}== 0 ]
then
    echo "coppied ${count} files"
else
    echo "all files are the same"
fi
