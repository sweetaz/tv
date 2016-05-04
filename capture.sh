#!/bin/bash

ffmpeg="/usr/local/bin/ffmpeg"
output="rtmp://localhost/api/0.1/live"

function list_devices {
	$ffmpeg -f avfoundation -list_devices true -i "" 2>&1 | grep input | cut -d " " -f 6-
}

function capture {
	echo "capturing from ${1}:${2} to ${output}..."
	if [ -f $output ]
	then
		rm $output
	fi
	$ffmpeg -f avfoundation -pixel_format yuyv422 -i "${1}:${2}" -codec:v libx264 -profile:v high422 -pix_fmt yuv422p -b:v 1000k -vf scale=-1:576 -c:a aac -b:a 160k -ar 44100 -threads 0 -f flv $output

	# ffmpeg -f dshow -i video="Virtual-Camera" -vcodec libx264 -tune zerolatency -b 900k -f mpegts udp://10.1.0.102:1234
	#
	# Here is how you stream to twitch.tv or similar services (rtmp protocol), using ffmpeg 1.0 or ffmpeg-git (tested on 2012-11-12), this is also for pulseaudio users: Example 1, no sound:
	# ffmpeg -f x11grab -s 1920x1200 -r 15 -i :0.0                                  -c:v libx264 -preset fast -pix_fmt yuv420p -s 1280x800                              -threads 0 -f flv "rtmp://live.twitch.tv/app/live_********_******************************"
	#
	# Example 2, first screen (on dual screen setup, or if on a single screen):
	# ffmpeg -f x11grab -s 1920x1200 -r 15 -i :0.0        -f pulse -ac 2 -i default -c:v libx264 -preset fast -pix_fmt yuv420p -s 1280x800 -c:a aac -b:a 160k -ar 44100 -threads 0 -f flv "rtmp://live.twitch.tv/app/live_********_******************************"
	#
	# Example 3, second screen (on dual screen setup):
	# ffmpeg -f x11grab -s 1920x1200 -r 15 -i :0.0+1920,0 -f pulse -ac 2 -i default -c:v libx264 -preset fast -pix_fmt yuv420p -s 1280x800 -c:a aac -b:a 160k -ar 44100 -threads 0 -f flv "rtmp://live.twitch.tv/app/live_********_******************************"
	#
	# ffmpeg -f x11grab -s 1920x1200 -r 15 -i :0.0                                  -c:v libx264 -preset fast -pix_fmt yuv420p -s 1280x800                              -threads 0 -f flv "rtmp://live.twitch.tv/app/live_********_******************************"
	# ffmpeg -f x11grab -s 1920x1200 -r 15 -i :0.0        -f pulse -ac 2 -i default -c:v libx264 -preset fast -pix_fmt yuv420p -s 1280x800 -c:a aac -b:a 160k -ar 44100 -threads 0 -f flv "rtmp://live.twitch.tv/app/live_********_******************************"
	# ffmpeg -f x11grab -s 1920x1200 -r 15 -i :0.0+1920,0 -f pulse -ac 2 -i default -c:v libx264 -preset fast -pix_fmt yuv420p -s 1280x800 -c:a aac -b:a 160k -ar 44100 -threads 0 -f flv "rtmp://live.twitch.tv/app/live_********_******************************"

}

if [ ! -f $ffmpeg ]
then
	echo "This script relies on ffmpeg.  Try 'brew install ffmpeg'."
fi

list_devices
capture 0 0
