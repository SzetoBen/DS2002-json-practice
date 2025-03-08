#!/bin/bash

# Fetch METAR data
URL="https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85"
DATA=$(curl -s "$URL")

#Print the first 6 times
echo "$DATA" | jq -r '.[].receiptTime' | head -n 6

#calculate averages and sums
TEMP_SUM=$(echo "$DATA" | jq -r '.[].temp' | awk '{sum+=$1; count++} END {if (count>0) print sum; else print 0}')
COUNT=$(echo "$DATA" | jq -r '.[].temp' | awk 'END {print NR}')
AVG_TEMP=$(awk "BEGIN {if ($COUNT > 0) print $TEMP_SUM / $COUNT; else print 0}")
echo "Average Temperature: $AVG_TEMP"

CLOUDY_COUNT=0
TOTAL_COUNT=0

#Calculate if it was mostly cloudy
echo "$DATA" | jq -r '.[].clouds[0].cover' | while read cover; do
    ((TOTAL_COUNT++))
    if [[ "$cover" != "CLR" ]]; then
        ((CLOUDY_COUNT++))
    fi

done

MOSTLY_CLOUDY=false
if (( CLOUDY_COUNT > TOTAL_COUNT / 2 )); then
    MOSTLY_CLOUDY=true
fi

echo "Mostly Cloudy: $MOSTLY_CLOUDY"
