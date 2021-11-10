# Sea Surface Temperature Anomaly Animation script

usage:

To download and animate 30 days of sea surface temperature data:

```bash
sst.sh 30
```

Output will be written to the `/home/$USER/science/sst` directory.

![example animation](img/example.gif)

To convert mp4 to gif:

```bash
ffmpeg -i ssta-20211109-60d.mp4 -filter_complex "[0:v] palettegen" palette.png
ffmpeg -i ssta-20211109-60d.mp4 -i palette.png -r 12 -filter_complex "[0:v][1:v] paletteuse" example.gif
```