#!/bin/bash

# get deffault longitude and latitude
lat=$(cat deffault_location.txt | awk '{print $1}' | sed 's/,//')
long=$(cat deffault_location.txt | awk '{print $2}')


# all counts that is going to be used for final output to check if everything worked
total_found=0
added_locations=0
have_locaction=0


# get into directory with pictures want to update
cd input_gps


# for loop all files in this directory
# going to add gps metadata to files that dont have it
# grep for location is this output -> GPS Position : 40.0081539408861 -75.0427127171417
# -n flag allows to get decimal value for the coordinates
for picture in *; 
do
    echo ----------------------------------------------------
    echo $picture
    location=$(exiftool -n $picture | grep 'GPS Position')
    echo $location
    total_found=`expr $total_found + 1`


    # true if no loacation so update picture data
    # othewise  overite lask knows coordinates
    if [ -z "$location" ]
    then
        echo Updating data
        added_locations=`expr $added_locations + 1`
        exiftool -GPSLongitudeRef=W -GPSLongitude=$long  -GPSLatitudeRef=N -GPSLatitude=$lat $picture
    else
        echo GPS data been reset
        lat=``$location | awk -F'[ ]' '{print $4}'``
        long=``$location | awk -F'[ ]' '{print $5}'``
        have_locaction=`expr $have_locaction + 1`

    fi
done

# mooving all files with GPS location to output directory
cp *.jpg ../output_gps


echo ----------------------------------------------------
echo FILES BEED COPIED
echo ADDED LOCATIONS:       $added_locations
echo HAD LOCATION:          $have_locaction
echo PICTURES IS DIRECTORY: $total_found




