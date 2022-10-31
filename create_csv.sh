#!/bin/bash
echo Converting "$1" to "$2"
name="$(grep "<name>" $1)"
lat="$(grep "<lat>" $1)"
lon="$(grep "<lon>" $1)"
minSea="$(grep "<minSeaLevelPres>" $1)"
intensity="$(grep "<intensity>" $1)"

#NAME
echo finding names
for ((index=0; index<${#name}; index++))
do
        if [ "${name:$index:6}" == "<name>" ] && [ "${name:$((index + 21)):7}" == "</name>" ]
        then
                names+=("${name:$((index + 6)):15}")
        fi
done

#LAT
echo finding latitudes
for ((index=0; index<${#lat}; index++))
do
        if [ "${lat:$index:5}" == "<lat>" ]
        then
                i=$((index + 5))
                press=""
                while [ "${lat:$i:1}" != "<" ]
                do
                           press="$press${lat:$i:1}"
                           i=$((i + 1))
                           if [ "${lat:$i:1}" == "<" ]
                           then
                                   lats+=("$press N")
                           fi
                done
        fi
done

#LONG

echo finding longitudes
for ((index=0; index<${#lon}; index++))
do
        if [ "${lon:$index:5}" == "<lon>" ]
        then
                i=$((index + 5))
                press=""
                while [ "${lon:$i:1}" != "<" ]
                do
                           press="$press${lon:$i:1}"
                           i=$((i + 1))
                           if [ "${lon:$i:1}" == "<" ]
                           then
                                  longs+=("$press W")
                           fi
                done
        fi
done

#MINSEALEVELPRESSURE
echo finding minimum sea level pressure
for ((index=0; index<${#minSea}; index++))
do
        if [ "${minSea:$index:17}" == "<minSeaLevelPres>" ]
        then
                i=$((index + 17))
                press=""
                while [ "${minSea:$i:1}" != "<" ]
                do
                        press="$press${minSea:$i:1}"
                        i=$((i + 1))
                        if [ "${minSea:$i:1}" == "<" ]
                        then
                                minSeaLevels+=("$press mb")
                        fi
                done
        fi
done

#MAXINTENSITY
echo finding max wind intensity
for ((index=0; index<${#intensity}; index++))
do
        if [ "${intensity:$index:11}" == "<intensity>" ]
        then
                i=$((index + 11))
                press=""
                while [ "${intensity:$i:1}" != "<" ]
                do
                        press="$press${intensity:$i:1}"
                        i=$((i + 1))
                        if [ "${intensity:$i:1}" == "<" ]
                        then
                                maxIntensitys+=("$press knots")
                        fi
                done
        fi
done
echo Timestamp,Latitude,Longitude,MinSeaLevelPressure,MaxIntensity > $2
i=0
while [ $i -lt ${#names[@]} ]
do
        echo ${names[$i]},${lats[$i]},${longs[$i]},${minSeaLevels[$i]},${maxIntensitys[$i]} >> $2
        i=$((i + 1))
done
echo Complete
