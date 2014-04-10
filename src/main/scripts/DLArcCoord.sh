#!/bin/bash

# constants and globals
urlPart1="http://commondatastorage.googleapis.com/books/syntactic-ngrams/eng/arcs."
urlPiece="arcs."
urlPart2="-of-99.gz"
localDir="$HOME/Coord_Example/"
pythonScript="CountNouns.py"
#grepForAdjNouns="^\b[A-Za-z]+\b\s+\b[A-Za-z]+\b/JJ.*/amod/.+\s\b[A-Za-z]+\b/NN.*/.+$"
grepFile="$HOME/Coord_Example/NounRegex"
output="Coord_Example_Adj_Nouns"
countsFile="Coord_Example_Noun_Counts"

# New Files for Fixed Adj and Fixed Noun
fixedRegex="FixedRegex"
fixedOutput="Coord_Example_Fixed"

#
# Builds, verifies, and downloads a file from a link
# @param: a string literal of the url
# @param: filename to save as
#
function download {
	#Check if link is valid
	urlComplete=$1
	urlFileName=$2
	wget -q --spider $urlComplete
	if [ $? = 0 ]; then
		echo "Link exists... downloading."
		wget -O ${urlFileName} ${urlComplete}
	else
		# Link doesn't exist, do nothing
		echo "Link doesn't exist."
	fi
}

#
# Reduces an archived file using various grep rules (ie nothing
# after a comma is kept, only strings containg the keywords are
# written out to the output file 
# @param: a string literal of the .gz input file to be reduced
# @param: a string literal of the output path for the reduced file
#
function reduceFile {
	echo "Reducing file size..."
	inputFile=$1
	outputFile=$2
	
	# Greps for keywords, then substrings from start to the "\tYEAR," (exclusive)
	zgrep -f ${grepFile} -E ${inputFile} | awk 'match($0, "[^,]*"){print substr($0,RSTART,RLENGTH-5)}' >> ${outputFile}
}

#Create a folder for the files to be dumped
mkdir -p ${localDir}
#Create an output file
> ${localDir}${output}
> ${localDir}${fixedOutput}
tens=0
ones=0
# This segment builds the value ranges for the files
while [ $tens -lt 10 ]; do
	digits=${tens}${ones}
	# Download the file
	download ${urlPart1}${digits}${urlPart2} ${localDir}${urlPiece}${digits}${urlPart2}
	# Apply grep rules
	reduceFile ${localDir}${urlPiece}${digits}${urlPart2} ${localDir}${output}
	# Remove the downloaded file to save space
	echo "Removing original download to conserve space..."
	rm ${localDir}${urlPiece}${digits}${urlPart2}
	ones=$((ones+1))
	if [ $ones = 10 ]; then
		ones=0
		tens=$((tens+1))
	fi
done

echo "Counting up nouns..."
# Note here that output is referring to the output of the grep/wgetting, not the output of the python script
python ${localDir}${pythonScript} ${localDir}${output} ${localDir}${countsFile}
grep -f ${localDir}${fixedRegex} -E ${localDir}${output} >> ${localDir}${fixedOutput}

#echo "Cleaning up temp files..."
#rm ${localDir}${output}
