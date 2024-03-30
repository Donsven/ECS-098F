#!/usr/bin/bash

artistName=""
songName=""
currentFile=""

#Take an argument and set global variable to artist name with whitespace removed
getArtistName() {
    output=$(ffprobe -show_entries format_tags=artist -of csv=p=0 -loglevel quiet "${currentFile}")

    artistName=${output//" "/""}

}


#Take an argument and set global variable to song name with whitespace removed

getSongName() {
    output=$(ffprobe -show_entries format_tags=title -of csv=p=0 -loglevel quiet "${currentFile}")

    songName=${output//" "/""}
    songName=${songName//"\""/""}
}

#Perform conversion on a single file
doConversion() {
    ffmpeg -loglevel error -i "${currentFile}" "${TARGET_DIR}"/"${artistName}"_"${songName}".mp3
}

# Takes one argument, that being a directory
TARGET_DIR=$1

# Now we should iterate over every file in the directory and do the conversion
# for each file

for file in "${TARGET_DIR}"/*
do
  currentFile=${file}
  getArtistName
  getSongName
  doConversion
  rm "${currentFile}"
done

exit 0
