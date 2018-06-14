#! /bin/sh

CURRDIR=`pwd`

rm -f $HOME/snapshot*.jpg

#check if they exist
[ -c /dev/video1 ] || exit
[ -c /dev/video2 ] || exit

#$CURRDIR/motion_cam_parse.pl > $HOME/snapshot.jpg
ffmpeg -f video4linux2 -i /dev/video1 -vframes 1 snapshot1.jpg -y > /dev/null 2>&1
ffmpeg -f video4linux2 -i /dev/video2 -vframes 1 snapshot2.jpg -y > /dev/null 2>&1
