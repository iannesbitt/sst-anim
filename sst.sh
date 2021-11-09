#!/bin/bash

mkdir -p "/home/$USER/science/sst/img"

# get data for past $1 days
for i in $( eval echo {1..$1} ); do
  d=$(date +%Y%m%d -d "today -$i days")
  y=$(date +%Y -d "today -$i days")
  # download this day's data
  wget -nc -P "/home/$USER/science/sst/img" \
  "https://www.ospo.noaa.gov/data/cb/ssta/daily/$y/ct5km_ssta_v3.1_global_$d.png"
done

# get today's data
t=$(date +%Y%m%d -d "today")
wget -nc -O "/home/$USER/science/sst/img/ct5km_ssta_v3.1_global_$t.png" \
  "https://www.ospo.noaa.gov/data/cb/ssta/ssta.daily.current.png"

if [ -z ${2+x} ]; then
  f=$2
else
  f=15
done

ffmpeg -framerate $f -pattern_type glob -i "/home/$USER/science/sst/img/*.png" \
  -c:v libx264 -vf "scale='bitand(oh*dar,65534)':'min(720,ih)'" \
  -profile:v high -crf 20 -pix_fmt yuv420p \
  "ssta-$t-$1d.mp4"