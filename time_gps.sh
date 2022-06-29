#!/bin/bash



# undating time to UTC format because all time stampss are in .gpx file in UTC format
# need check that new time doesnt't exceed 24 hour parameter as well

convert_time(){
	hour=$(echo $(( ${hour#0} + 4 )))
	if [ "$hour" -gt 23 ] 
	then
		hour=$(echo $hour - 24 )
	fi	
}


# conver analog time into timestamp
# need to determine what time is closests to that time
clock_timestamp(){
	echo $(($hour*60 + $minutes))
}



# get ranking to what pic time is ranked in all times
# get time before and after the time that want to compare to
# add time to all times, sort and see what adjacent times are
get_rank(){	
	appended_time="$time_found $time_string"
	around_time=`echo sort $appended_time | grep -E -o ".{0,6}$time_string.{0,6}"`
	echo $around_time
}


# get location from time when time provided, time has to exist in time_and_line variable
# location time is 2 limes fore the time line
# going to get both longitude and latitude
# get line num by looking for first match and extract only number from it
get_location(){	
	line_with_time=`echo $line_and_time | grep -o -m 1 "[0-9]\+:${time_string}" | head -1 | cut -d ':' -f1`
	echo $line_with_time
	echo $time_string

}



# opening the most recet .gpx file from download folder
# store line  num and time from text so that can compare the times to them and determine where
# time of the picture belongs
# use line data to jump to line that have location for found timestamp
cd /home/shef/Downloads/
gpx_file=`ls -t *.gpx | head -1`
file_text=`cat $gpx_file`
line_and_time=`grep -on [0-9][0-9]:[0-9][0-9]  $gpx_file`
time_found=`grep -o [0-9][0-9]:[0-9][0-9]  $gpx_file`



# grep time $gpx_file
# echo $line_time





# get into folder with pictures and do all needed calculations over them
# get a times stamp, convert it to UTC then find closeset time in .gpx file
# need UTC time because .gpx file time in UTC format
# apply only if gps position is unknown


cd /home/shef/Desktop/pics_fuji/scripts/input_gps/
for picture in *;
do
	# get hour and minutes from current picture
	echo $picture
	location=$(exiftool -n $picture | grep 'GPS Position')

	if [ -z "$location" ]
    	then

		time=`exiftool -time:DateTimeOriginal -s $picture | awk '{print$4}'`
		hour=`echo $time | cut -c 1-2`
		minutes=`echo $time | cut -c 4-5`
		convert_time 
		time_string="${hour}:${minutes}"

		# check if time already in all times found
		if [[ "$time_found" == *"$time_string"* ]]
		then
			
			echo time exists
			get_location
		else
			echo need to find time
		fi

	#	get_rank
		# adjacent_times=$(get_rank)
		echo $time_string
		# echo $adjacent_times
		echo ---------------------	
	fi

done


