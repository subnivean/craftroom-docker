#!/usr/bin/env bash

# Check the temperature in the 'Craft Room' and turn the space 
# heater's smart switch on/off as necessary to maintain the temp
# between 'LOTEMP` and `HITEMP`.

# Called via cron job - use `sudo crontab -e`

# Smart switch IP address
SSIP=25

# Database location and query
TEMPSDB=/awdata/ambientweather.db
TEMPQRY="SELECT temp1f FROM dbtable0 ORDER BY ROWID DESC LIMIT 1;"

# Set temperature limits
hour=$(date "+%H")
range=$(grep $hour= ./craft_room_schedule |cut -d"=" -f2)
LOTEMP=$(echo "$range" | cut -d"," -f1)
HITEMP=$(echo "$range" | cut -d"," -f2)

# Read the latest room temperature
roomtemp=$(sqlite3 $TEMPSDB "$TEMPQRY")
msg="hour:$hour HITEMP:$HITEMP LOTEMP:$LOTEMP roomtemp:$roomtemp"

# Check and act as necessary
if (( $(echo "$roomtemp >= $LOTEMP" | bc -l) && $(echo "$roomtemp <= $HITEMP" | bc -l) ))
then
  msg="$msg -- Temperature OK"
elif (( $(echo "$roomtemp < $LOTEMP" | bc -l) ))
then
  msg="$msg -- Turning heater on"
  curl -s http://192.168.1.$SSIP/cm?cmnd=Power%20On >/dev/null
elif (( $(echo "$roomtemp > $HITEMP" | bc -l) ))
then
  msg="$msg -- Turning heater off"
  curl -s http://192.168.1.$SSIP/cm?cmnd=Power%20Off >/dev/null
fi

if [ -t 1 ] # i.e. not running under cron
then
  echo $msg
fi

echo "$(date)" > /data/lastrun
echo "$msg" >> /data/lastrun
