#!/bin/bash

Username=$(whoami)
UserDir="~/home/${Username}"

WallpapersDir="/home/${Username}/Wallpapers"
Wallpapers=($(find "$WallpapersDir" -type f -name "*.png" -o -name "*.jpg" -o -name "*.jpeg"))

RandomWallpaper="${Wallpapers[RANDOM % ${#Wallpapers[@]}]}"

feh --bg-scale "$RandomWallpaper"
