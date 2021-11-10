#!/bin/bash

odir="/home/$USER/science/sst"
mkdir -p $odir

# get data for past $1 days
for i in $( eval echo {1..$1} ); do
  d=$(date +%Y%m%d -d "today -$i days")
  y=$(date +%Y -d "today -$i days")
  # download this day's data
  wget -nc -P "$odir/img" \
  "https://www.ospo.noaa.gov/data/cb/ssta/daily/$y/ct5km_ssta_v3.1_global_$d.png"
done

# get today's data
t=$(date +%Y%m%d -d "today")
wget -nc -O "$odir/img/ct5km_ssta_v3.1_global_$t.png" \
  "https://www.ospo.noaa.gov/data/cb/ssta/ssta.daily.current.png"

# if [ -z ${2+x} ]; then
#   f=$2
# else
#   f=15
# fi

ffmpeg -framerate 15 -pattern_type glob -i "$odir/img/*.png" \
  -c:v libx264 -vf "scale='bitand(oh*dar,65534)':'min(720,ih)'" \
  -profile:v high -crf 20 -pix_fmt yuv420p \
  "$odir/ssta-$t-$1d.mp4"