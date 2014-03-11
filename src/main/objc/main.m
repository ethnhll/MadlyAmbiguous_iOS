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

@interface MadHelper : NSObject
+(NSString *)getInputFromUser;
+(NSString *)findNoun:(NSString *)input usingFile:(NSString *)filePath;
@end


/*----------------------------------------------------------------------------------------------*/
/* Function Implementations */
/*----------------------------------------------------------------------------------------------*/

@implementation MadHelper

+(NSString *)getInputFromUser {

	char inputFromUser [MAXSTRING_LENGTH];
	fgets(inputFromUser, MAXSTRING_LENGTH, stdin);

    /* Remove trailing newline, if there is one. */
	if ((strlen(inputFromUser) > 0) && (inputFromUser [strlen (inputFromUser) - 1] == '\n')) {
		inputFromUser[strlen (inputFromUser) - 1] = '\0';
	}
	return [NSString stringWithUTF8String: inputFromUser];
}

+(NSString *)findNoun:(NSString *)input usingFile:(NSString *)filePath {

	NSArray *wordsAndEmptyStrings = [input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
	
	NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSArray *fileLines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	NSUInteger countWord = 0;
	BOOL foundNoun = NO;
	NSString *ret;
	while ((countWord < [words count]) && !foundNoun) {
		
		NSString *word = [words objectAtIndex:countWord];
		NSUInteger countLine = 0;
		BOOL foundWord = NO;
		while ((countLine < [fileLines count]) && !foundWord) {
			NSString *line = [fileLines objectAtIndex:countLine];
			// Trim the line so that new lines are not used in comparisons
			NSString *lineWithoutSpace = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if ([word isEqualToString:lineWithoutSpace]) {
				foundWord = YES;
			}
			countLine++;
		}
		// loop didn't find the word and so we call this word a noun
		if(!foundWord) {
			foundNoun = YES;
			ret = [words objectAtIndex:countWord];
		}	
		countWord++;
	}
	/* 
	 * In the event that all words in the user input are found in the list
	 * of common English words, we want to just select the last word from 
	 * the input
	 */		
	if (!foundNoun){
		ret = [words objectAtIndex:[words count]-1];
	}
	return ret;
}

@end

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

	NSLog(@"\nWelcome to the first MadlyAmbiguous demo!\n");
	NSLog(@"\nComplete the following sentence...\n");
	NSLog(@"\nI ate spaghetti with ");
	
	// Call helper function to get an NSString of the user input
	
	NSString *userInput = [MadHelper getInputFromUser];
	
	

	//Find noun
	NSString *noun = [MadHelper findNoun:userInput usingFile:@ENG_COMMON_PATH];
	NSLog(noun);
/*
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
	
*/
[pool drain];
	return 0;
}
