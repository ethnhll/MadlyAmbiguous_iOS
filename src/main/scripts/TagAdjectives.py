# Simple python program to find the most common English words (excluding nouns) 
# and their most frequent part of speech tag.

import nltk
from nltk.corpus import brown
freqDist = nltk.FreqDist(brown.words())
condFreqDist = nltk.ConditionalFreqDist(brown.tagged_words())
mostFreqWords = freqDist.keys()
likelyTags = dict((word, condFreqDist[word].max()) for word in mostFreqWords)
# Now we only want to print non-nouns
file = open('AdjectiveList', 'w')
for word in likelyTags:
    if "JJ" in likelyTags[word]:
    	file.write(word.lower() + "\n")
file.close()
