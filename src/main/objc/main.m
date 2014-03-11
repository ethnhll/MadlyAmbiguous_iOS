/*----------------------------------------------------------------------------------------------*
 * Author: Ethan Hill
 * File: main.m
 * Description: This program is a command line demonstration of PPA attachment ambiguity, and 
 * 		how a computer might figure out how to resolve this ambiguity.
 *----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <stdio.h>

#define MAXSTRING_LENGTH 80
#define MAXLINE_LENGTH 1024

#define ARCS_PATH "/home/hill1303/MadlyAmbiguous/src/main/resources/AteSpaghettiArcs"
#define ENG_COMMON_PATH "/home/hill1303/MadlyAmbiguous/src/main/resources/CommonEnglish"

#define PREP_TAG " with/"
#define HEAD_ATE "ate\t"
#define HEAD_SPAG "spaghetti\t"
#define NOUN_LABEL "/NN"

#define HEADS 1

/*----------------------------------------------------------------------------------------------*/
/* Function Definitions */
/*----------------------------------------------------------------------------------------------*/

double conditionalFrequency (char *filePath, char *headWord, char *preposition, 
	char *novelWord);
int getFrequency (NSString *line);
BOOL containsWord (char *expression, NSString *string);
char* findNoun (char * userInput, char* filePath);

/*----------------------------------------------------------------------------------------------*/
/* Function Implementations */
/*----------------------------------------------------------------------------------------------*/

char* findNoun (char * userInput, char* filePath){

	// Break input into an array of strings
	NSString *convertedInput = [NSString stringWithUTF8String: userInput];

	printf("I'm here");

	NSArray *wordsAndEmptyStrings = [convertedInput componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
	
	BOOL seenBefore = false;
	BOOL foundNoun = false;
	int i = 0;

	char *word;
	FILE *file = fopen (filePath, "r");

	printf("Im about to open a file");
	if (file != NULL){
		char line [MAXLINE_LENGTH];
		char *word;

		while ((i < [words count]) && (!foundNoun)){
			NSString *wordAtIndex = [words objectAtIndex: i];
			word = [wordAtIndex UTF8String];

			while (fgets (line, sizeof line, file) != NULL) {
				NSString *string = [NSString stringWithUTF8String: line];
				
				if (containsWord(word, string)){
					seenBefore = true;
					if (containsWord(NOUN_LABEL, string)){
						foundNoun = true;
					}
				}
			}
			/*
			 * If the word was not found in file of English tags,
			 * then assume the word is a noun not yet encountered
			 */
			if (!foundNoun && !seenBefore){
				// Force to be true to break while loop
				foundNoun = true;		 
			}
			i++;
		}
	}
	// In case there was an issue, let us know why
	else {
		perror (filePath);
	}
	fclose (file);


	return word;
}


/**
 * Returns yes if the given string contains a match for the regular expression,
 * no otherwise.
 */
BOOL containsWord (char *expression, NSString *string) {

	NSString *toMatch = [NSString stringWithUTF8String: expression];
	
	if ([string rangeOfString:toMatch].location == NSNotFound){
		return NO;
	}
	else {
		return YES;
	}
}

/**
 * Retrieves the frequency of the particular Ngram from the string of Ngram data
 */
int getFrequency (NSString *line) {
	
	NSRange range = [line rangeOfString:@"\t" options:NSBackwardsSearch];
	NSString *frequencyString = [line substringFromIndex:range.location];
	return [frequencyString intValue];
}

/**
 * Returns the frequency of a word given a prepositional phrase structure found
 * in the given file. 
 */
double conditionalFrequency (char *filePath, char *head, char *prep, 
	char *novelWord) {
 
	int totalPrepCount = 0;
	int wholePhraseTotal = 0;

	FILE *file = fopen (filePath, "r");

	if (file != NULL){
		char line [MAXLINE_LENGTH];

		while (fgets (line, sizeof line, file) != NULL) {
			NSString *string = [NSString stringWithUTF8String: line];
			
			if (containsWord(head, string) && containsWord(prep, string)) {
				int frequency = getFrequency (string);
				totalPrepCount += frequency;
	
				if (containsWord(novelWord, string)) {
					wholePhraseTotal += frequency;
				}
			}
		}
	}
	// In case there was an issue, let us know why
	else {
		perror (filePath);
	}
	fclose (file);

	double frequencyRatio = (double)(wholePhraseTotal)/ (double)(totalPrepCount);

	return frequencyRatio; 
}

/**
 * Prompts the user to complete a sentence with their own novel input and
 * the program parses a syntactic ngram file for frequencies of different
 * attachment variations for that input and determines which is the more 
 * likely attachment.
 */
int main (int argc, const char *argv []) {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	printf("\nWelcome to the first MadlyAmbiguous demo!\n");
	printf("\nComplete the following sentence...\n");
	printf("\nI ate spaghetti with ");
		
	char inputFromUser [MAXSTRING_LENGTH];
	fgets(inputFromUser, MAXSTRING_LENGTH, stdin);

    	/* Remove trailing newline, if there. */
	if ((strlen(inputFromUser)>0) && (inputFromUser[strlen (inputFromUser) - 1] == '\n')){
		inputFromUser[strlen (inputFromUser) - 1] = '\0';
	}


	//Find noun
	char * noun = findNoun (inputFromUser, ENG_COMMON_PATH);

	double ateFrequency = conditionalFrequency(ARCS_PATH, HEAD_ATE, 
		PREP_TAG, noun);
	double spagFrequency = conditionalFrequency(ARCS_PATH, HEAD_SPAG,
		PREP_TAG, noun);

	if (ateFrequency > spagFrequency){
		printf("\nWith %s is how I ate the spaghetti, but of course the spaghetti dish didn't have %s in it!", inputFromUser, inputFromUser);
		printf("\n%F\n", ateFrequency);
	}
	else if (ateFrequency < spagFrequency){
		printf("\nThe spaghetti with %s is what I ate, which of course means the spaghetti dish had %s in it!", inputFromUser, inputFromUser);
		printf("\n%F\n", spagFrequency);
	}
	else {
		printf("\nI don't really know... flipping a coin\n");
		printf("\n%F\n", spagFrequency);
		printf("\n%F\n", ateFrequency);

		int coin = rand() % 2;
		if (coin = HEADS){
			printf("\nWith %s is how I ate the spaghetti, but of course the spaghetti dish didn't have %s in it!", inputFromUser, inputFromUser);
		}
		else {
			printf("\nThe spaghetti with %s is what I ate, which of course means the spaghetti dish had %s in it!", inputFromUser, inputFromUser);
		}
	}
	[pool drain];
	return 0;
}
