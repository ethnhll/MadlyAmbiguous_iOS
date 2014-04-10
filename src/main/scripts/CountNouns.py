import sys
import re

fileToParse = sys.argv[1]
outputFile = sys.argv[2]

fp = open(fileToParse)
out = open(outputFile, 'w')

# Get a list of all the nouns
wordsDict = dict()
for line in fp:
	wordGroups = re.split('\t', line)
	word = wordGroups[0]
	count = int(wordGroups[len(wordGroups)-1])
	if word not in wordsDict:
		wordsDict[word] = count
	else:
		wordsDict[word] += count

for key in wordsDict:
	out.write(key + "\t" + key +"/NN_/---\tall_adjectives/JJ_/---\t" + str(wordsDict[key]) + "\n");
fp.close()
out.close()
