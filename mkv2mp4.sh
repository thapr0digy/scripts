#!/bin/bash
#
# This script will change mkv files with AC3 audio to mp4 files with AAC audio
#
# Usage: mkv2mp4.sh <mkv_file.mkv> <mp4_file.mp4>
#
#

mkv_file=$1
mp4_file=$2

echo Changing mkv file to mp4....

# Input the mkv file and output to mp4_file

ffmpeg -i $mkv_file -vcodec copy -acodec aac -ab 256000 -sn -strict -2 $mp4_file

