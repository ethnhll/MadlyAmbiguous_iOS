/*----------------------------------------------------------------------------------------------*
 * Author: Ethan Hill
 * File: main.m
 * Description: This program is a command line demonstration of PPA attachment ambiguity, and 
 * 		how a computer might figure out how to resolve this ambiguity.
 *----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import <Foundation/NSRegularExpression.h>
#import <Foundation/NSTextCheckingResult.h>
#include <stdlib.h>
#include <stdio.h>

#define MAXSTRING_LENGTH 100 
#define MAXLINE_LENGTH 1024

#define PPA_ARCS_PATH "/home/hill1303/MadlyAmbiguous/src/main/resources/AteSpaghettiArcs"
#define COORD_ARCS_PATH "/home/hill1303/MadlyAmbiguous/src/main/resources/AdjNounArcs"
#define ENG_COMMON_PATH "/home/hill1303/MadlyAmbiguous/src/main/resources/CommonEnglish"
#define PREP_TAG " with/"
#define ATE_WITH_REGEX "^\\bate\\b\\s.+\\s\\bwith\\b/.+"
#define PRE_REGEX "\\s\\b"
#define POST_REGEX "\\b/.+$"
#define SPAG_WITH_REGEX "^\\bspaghetti\\b\\s.+\\s\\bwith\\b/.+"

#define HEADS 1


/*----------------------------------------------------------------------------------------------*/
/* Function Definitions */
/*----------------------------------------------------------------------------------------------*/

@interface MadHelper : NSObject
+(NSString *)getInputFromUser;
+(NSString *)findNoun:(NSString *)input usingFile:(NSString *)filePath;
+(NSUInteger)getPPAFrequency:(NSString *)noun givenRegex:(NSString *)pattern usingFile:(NSString *)filePath;
+(double)conditionalFrequencyOfAdjNoun:(NSString *)adjective givenNoun:(NSString *)noun usingFile:(NSString *)filePath;
+(NSUInteger)lineFrequency:(NSString *)line;
+(NSString *)prepPhraseExample;
+(NSString *)coordinationExample;
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


+(double)conditionalFrequencyOfAdjNoun:(NSString *)adjective givenNoun:(NSString *)noun usingFile:(NSString *)filePath {
	


	NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSRange searchRange = NSMakeRange(0, [fileContents length]);
	NSError *error = nil;
	
	NSString *nounPattern = [NSString stringWithFormat: @"^\\b%@\\b\\s.+$", noun];

	NSRegularExpression *regexNoun = [NSRegularExpression regularExpressionWithPattern:nounPattern options:NSRegularExpressionAnchorsMatchLines error:&error];
	NSArray *nounMatches = [regexNoun matchesInString:fileContents options:0 range:searchRange];

	NSString *adjNounPattern = [NSString stringWithFormat: @"^\\b%@\\b\\s+\\b%@\\b/JJ.*$", noun, adjective];
	NSRegularExpression *regexAdjNoun = [NSRegularExpression regularExpressionWithPattern:adjNounPattern options:NSRegularExpressionAnchorsMatchLines error:&error];
	NSArray *adjNounMatches = [regexAdjNoun matchesInString:fileContents options:0 range:searchRange];

	NSUInteger nounTotal = 0;
	for (NSTextCheckingResult *match in nounMatches) {
		NSString *matchText = [fileContents substringWithRange:[match range]];
		nounTotal += [MadHelper lineFrequency:matchText];
	}
	NSUInteger adjNounTotal = 0;
	for (NSTextCheckingResult *match in adjNounMatches) {
		NSString *matchText = [fileContents substringWithRange:[match range]];
		adjNounTotal += [MadHelper lineFrequency:matchText];
	}

	return (((double) adjNounTotal)/((double) nounTotal)); 


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
		NSString *word = [[words objectAtIndex:countWord] lowercaseString];
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

+(NSUInteger)lineFrequency:(NSString *)line {

	NSRange range = [line rangeOfString:@"\t" options:NSBackwardsSearch];
	NSString *frequencyString = [line substringFromIndex:range.location];
	return [frequencyString intValue];
}

+ (NSString *)coordinationExample {
	NSLog(@"Complete the following sentence by filling in words separated by spaces for each blank.");
	NSLog(@"The (ADJ) (NOUN) and (NOUN) made such a mess!");

	NSString *userInput = [MadHelper getInputFromUser];


	NSArray *wordsAndEmptyStrings = [userInput componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];

	// Split input into array, space delimited
	
	NSString *adjective = [[words objectAtIndex:0] lowercaseString];
	NSString *leftNoun = [[words objectAtIndex:1] lowercaseString];
	NSString *rightNoun = [[words objectAtIndex:2] lowercaseString];
	
	double leftNounFreq = [MadHelper conditionalFrequencyOfAdjNoun:adjective givenNoun:leftNoun usingFile:@COORD_ARCS_PATH];
	double rightNounFreq = [MadHelper conditionalFrequencyOfAdjNoun:adjective givenNoun:rightNoun usingFile:@COORD_ARCS_PATH];
	
	NSString *output;

	if ((rightNounFreq*10) >= leftNounFreq) {
		output = [NSString stringWithFormat: @"The %@ %@ and the %@ %@ made a mess!", adjective, leftNoun, adjective, rightNoun];
	}
	else {
		output = [NSString stringWithFormat: @"The %@ and the %@ %@ made a mess!", rightNoun, adjective, leftNoun];
	}
	return output;
}

+(NSString *)prepPhraseExample {
	
	NSLog(@"Complete the following sentence...\n");
	NSLog(@"I ate spaghetti with");
	
	NSString *userInput = [MadHelper getInputFromUser];
	
	//Find noun
	NSString *noun = [MadHelper findNoun:userInput usingFile:@ENG_COMMON_PATH];

	NSUInteger ateFrequency = [MadHelper getPPAFrequency:noun givenRegex:@ATE_WITH_REGEX usingFile:@PPA_ARCS_PATH];
	NSUInteger spagFrequency = [MadHelper getPPAFrequency:noun givenRegex:@SPAG_WITH_REGEX usingFile:@PPA_ARCS_PATH];
	NSString *output;

	if (ateFrequency > spagFrequency){
		output = [NSString stringWithFormat: @"With %@ is how I ate the spaghetti, but of course the spaghetti dish didn't have %@ in it!", userInput, userInput];
	}
	else if (ateFrequency < spagFrequency){
		output = [NSString stringWithFormat: @"The spaghetti with %@ is what I ate, which of course means the spaghetti dish had %@ in it!", userInput, noun];
	}
	else {
		int coin = rand() % 2;
		if (coin = HEADS){
			output = [NSString stringWithFormat: @"With %@ is how I ate the spaghetti, but of course the spaghetti dish didn't have %@ in it!", userInput, userInput];
		}
		else {
			output = [NSString stringWithFormat: @"The spaghetti with %@ is what I ate, which of course means the spaghetti dish had %@ in it!", userInput, noun];
		}
	}
	return output;
}

+(NSUInteger)getPPAFrequency:(NSString *)noun givenRegex:(NSString *)pattern usingFile:(NSString *)filePath {

	NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSRange searchRange = NSMakeRange(0, [fileContents length]);
	NSError *error = nil;
	
	NSString *nounPattern = [NSString stringWithFormat: @"%@%@%@%@",pattern ,@PRE_REGEX, noun, @POST_REGEX];
	NSRegularExpression *regexNoun = [NSRegularExpression regularExpressionWithPattern:nounPattern options:NSRegularExpressionAnchorsMatchLines error:&error];
	NSArray *nounMatches = [regexNoun matchesInString:fileContents options:0 range:searchRange];

	NSUInteger nounTotal = 0;
	for (NSTextCheckingResult *match in nounMatches) {
		NSString *matchText = [fileContents substringWithRange:[match range]];
		nounTotal += [MadHelper lineFrequency:matchText];
	}
	return nounTotal;
}
@end


/**
 * Prompts the user to complete a sentence with their own novel input and
 * the program parses a syntactic ngram file for frequencies of different
 * attachment variations for that input and determines which is the more 
 * likely attachment.
 */
int main (int argc, const char *argv []) {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"Welcome to the first MadlyAmbiguous demo!");
	
	NSLog(@"Would you like to test it out?: Y/N)");
	NSString *test = [MadHelper getInputFromUser];

	while ([test isEqualToString: @"Y"] ||[test isEqualToString: @"y"]) {
		NSLog(@"Which example do you want to try?");
		NSLog(@"Prepositional Phrase Attachment Ambiguity: Enter PPA");
		NSLog(@"Coordination Ambiguity: Enter CA");
		
		NSString *ex = [MadHelper getInputFromUser];

		if ([ex isEqualToString: @"PPA"]){
			NSString *output = [MadHelper prepPhraseExample];
			NSLog(output);
		}
		else if ([ex isEqualToString: @"CA"]){
			 NSString *output = [MadHelper coordinationExample];
			 NSLog (output);
		}

		NSLog(@"Would you like to test it again?: Y/N)");
		test = [MadHelper getInputFromUser];
	}
	[pool drain];
	return 0;
}
