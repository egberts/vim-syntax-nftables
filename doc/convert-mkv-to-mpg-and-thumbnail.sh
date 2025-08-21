#!/bin/bash


ffmpeg -i $1 -vcodec copy -acodec copy $1.mp4
ffmpeg -i $1.mp4 -vf "select=eq(n\,0)" -vframes 1 $1.thumbnail.jpg











ffmpeg -i $1.mp4 -vf mpdecimate -vsync vfr $1.mpdecimate.mp4

