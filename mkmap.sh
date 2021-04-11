#!/bin/bash
#
# run the script and create eps
asy -f eps -v -v -o hexmap.eps ./hexmap.asy
# cut the eps to US letter and A4 format
poster -v -v -i145.26x125.5cm -mLet -p8x6Let -c1x1cm -o ./hexmap_Let.eps ./hexmap.eps
poster -v -v -i145.26x125.5cm -mA4 -p8x6A4 -c1x1cm -o ./hexmap_A4.eps ./hexmap.eps
# create pdfs
ps2pdf ./hexmap_A4.eps
ps2pdf ./hexmap_Let.eps
# remove eps
rm ./hexmap.eps ./hexmap_Let.eps ./hexmap_A4.eps
