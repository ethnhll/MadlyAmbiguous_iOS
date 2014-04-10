# Simple python program to find the most common English nouns from
# the brown corpus and create a list of regular expressions for use
# with the DLArcCoord.sh script

import nltk
import re
from nltk.corpus import brown
freqDist = nltk.FreqDist(brown.words())
condFreqDist = nltk.ConditionalFreqDist(brown.tagged_words())
mostFreqWords = freqDist.keys()
likelyTags = dict((word, condFreqDist[word].max()) for word in mostFreqWords)

# Now we only want to print nouns with a regex pattern for the bash script
file = open('NounRegex', 'w')
for word in likelyTags:
    if "NN" in likelyTags[word]:
	match = re.match(r'^[A-Za-z]+$', word, re.M|re.I)
	if match:
		file.write("^\\b")
    		file.write(word.lower() + "\\b\\s+\\b[A-Za-z]+\\b/JJ.*/amod/.+\\s\\b[A-Za-z]+\\b/NN.*/.+$\n")
file.close()
