//
//  OSUMadHelper.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 3/21/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUMadHelper.h"


@interface OSUMadHelper ()
+(NSUInteger)lineFrequency:(NSString *)line;
+(NSUInteger)getFrequencyUsingRegex:(NSString *)regexPattern usingFile:(NSString *)filePath;
+(NSString *)findNounInPhrase:(NSString *)phrase usingFile:(NSString *)filePath;
+(double)conditionalFrequencyOfAdjNoun:(NSString *)adjective givenNoun:(NSString *)noun;
@end


@implementation OSUMadHelper

@synthesize wins;
@synthesize losses;
@synthesize considerations;
@synthesize exampleResult;


-(id)init {
    self = [super init];
    return self;
}
+(id)sharedMadHelper {
    static OSUMadHelper *sharedHelper = nil;
    @synchronized (self) {
        if (sharedHelper == nil){
            sharedHelper = [[self alloc] init];
        }
    }
    return sharedHelper;
}

+(NSUInteger)lineFrequency:(NSString *)line {
    
	NSRange range = [line rangeOfString:@"\t" options:NSBackwardsSearch];
	NSString *frequencyString = [line substringFromIndex:range.location];
	return [frequencyString intValue];
}

+(NSUInteger)getFrequencyUsingRegex:(NSString *)regexPattern usingFile:(NSString *)filePath {
    
	NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSRange searchRange = NSMakeRange(0, [fileContents length]);
	NSError *error = nil;
	
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionAnchorsMatchLines error:&error];
	NSArray *nounMatches = [regex matchesInString:fileContents options:0 range:searchRange];
    
	NSUInteger nounTotal = 0;
	for (NSTextCheckingResult *match in nounMatches) {
		NSString *matchText = [fileContents substringWithRange:[match range]];
		nounTotal += [OSUMadHelper lineFrequency:matchText];
	}
	return nounTotal;
}


+(double)conditionalFrequencyOfAdjNoun:(NSString *)adjective givenNoun:(NSString *)noun {
	
    NSString *nounCountsPath = [[NSBundle mainBundle] pathForResource:@"ALL_ADJ_NOUN_COUNTS" ofType:nil inDirectory:@"resources.bundle"];
    NSString *fixedNounFixedAdjPath = [[NSBundle mainBundle] pathForResource:@"FIXED_NOUN_FIXED_ADJ" ofType:nil inDirectory:@"resources.bundle"];
	
	NSString *nounPattern = [NSString stringWithFormat:(NSLocalizedString(@"HEAD_NOUN_REGEX_COORD", nil)), noun];
	NSString *adjNounPattern = [NSString stringWithFormat:(NSLocalizedString(@"ADJ_NOUN_REGEX_COORD", nil)), noun, adjective];
    
    NSUInteger nounTotal = [OSUMadHelper getFrequencyUsingRegex:nounPattern usingFile:nounCountsPath];
    NSUInteger adjNounTotal = [OSUMadHelper getFrequencyUsingRegex:adjNounPattern usingFile:fixedNounFixedAdjPath];
    
	return (((double) adjNounTotal)/((double) nounTotal));
    
    
}

+(NSString *)findNounInPhrase:(NSString *)phrase usingFile:(NSString *)filePath {
    // possibly deprecated in favor of NSLinguisticTagger
	
	NSArray *wordsAndEmptyStrings = [phrase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
	
	NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSArray *fileLines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	NSUInteger countWord = 0;
	BOOL foundNoun = NO;
	NSString *noun;
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
			noun = [words objectAtIndex:countWord];
		}
		countWord++;
	}
	/*
     * In the event that all words in the user input are found in the list
	 * of common English words, we want to just select the last word from
	 * the input
	 */
	if (!foundNoun){
		noun = [words objectAtIndex:[words count]-1];
	}
    return noun;
    // Only get words from a string of text
    //NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation;
    // Create an english tagger
    //NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes: [NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:options];
    //[tagger setString:phrase];
     
}

-(void)incrementWins {
    self.wins++;
}

-(void)incrementLosses {
    self.losses++;
}

-(NSUInteger)getWins {
    
    return self.wins;
}
-(NSUInteger)getLosses {
    return self.losses;
}

-(NSMutableArray *)reportListOfConsideratiins{
    
    return [self.considerations copy];
}
-(NSString *)reportExampleResult {
    
    return [self.exampleResult copy];
}

-(void)ppaExampleUsingPhrase:(NSString *)phrase {
    
    // Fill in the considerations array
    self.considerations = [NSMutableArray arrayWithObjects:
                           [NSString stringWithFormat:NSLocalizedString(@"VERB_ATTACH_PARAPHRASE", nil), phrase, phrase],
                           [NSString stringWithFormat:NSLocalizedString(@"NOUN_ATTACH_PARAPHRASE", nil), phrase, phrase], nil];
    
    NSString *commonEngPath = [[NSBundle mainBundle] pathForResource:@"CommonEnglish" ofType:nil inDirectory:@"resources.bundle"];
    NSString *ppaArcs = [[NSBundle mainBundle] pathForResource:@"AteSpaghettiArcs" ofType:nil inDirectory:@"resources.bundle"];
    
    //Find noun
    NSString *noun = [OSUMadHelper findNounInPhrase:phrase usingFile:commonEngPath];
    NSString *verbPPNounPattern = [NSString stringWithFormat:NSLocalizedString(@"HEAD_VERB_REGEX_PPA", nil),  noun];
    NSString *nounPPNounPattern = [NSString stringWithFormat:NSLocalizedString(@"HEAD_NOUN_REGEX_PPA", nil),  noun];
    
    NSUInteger headVerbFrequency = [OSUMadHelper getFrequencyUsingRegex:verbPPNounPattern usingFile:ppaArcs];
    NSUInteger headNounFrequency = [OSUMadHelper getFrequencyUsingRegex:nounPPNounPattern usingFile:ppaArcs];
    
    if (headVerbFrequency > headNounFrequency){
        self.exampleResult = [NSString stringWithFormat:NSLocalizedString(@"VERB_ATTACH_PARAPHRASE", nil), phrase, phrase];
    }
    else if (headVerbFrequency < headNounFrequency){
        self.exampleResult = [NSString stringWithFormat:NSLocalizedString(@"NOUN_ATTACH_PARAPHRASE", nil), phrase, phrase];
    }
    else {
        int coin = rand() % 2;
        if (coin == 1){
            self.exampleResult = [NSString stringWithFormat:NSLocalizedString(@"VERB_ATTACH_PARAPHRASE", nil), phrase, phrase];
        }
        else {
            self.exampleResult = [NSString stringWithFormat:NSLocalizedString(@"NOUN_ATTACH_PARAPHRASE", nil), phrase, phrase];
        }
    }
}

-(void)coordExampleUsingAdjNouns:(NSString *)adjective leftNoun:(NSString *)leftNoun rightNoun:(NSString *)rightNoun {
        // Fill in considerations
        self.considerations = [NSMutableArray arrayWithObjects:
                               [NSString stringWithFormat:NSLocalizedString(@"ADJ_BOTH_NOUN_ATTACH_PARAPHRASE", nil), adjective, leftNoun, adjective, rightNoun],
                               [NSString stringWithFormat:NSLocalizedString(@"LEFT_NOUN_ADJ_RIGHT_NOUN_ATTACH_PARAPHRASE", nil), rightNoun, adjective, leftNoun], nil];
                               
        
        double leftNounFreq = [OSUMadHelper conditionalFrequencyOfAdjNoun:adjective givenNoun:leftNoun];
        double rightNounFreq = [OSUMadHelper conditionalFrequencyOfAdjNoun:adjective givenNoun:rightNoun];
        
        if ((rightNounFreq*10) >= leftNounFreq) {
            self.exampleResult = [NSString stringWithFormat:NSLocalizedString(@"ADJ_BOTH_NOUN_ATTACH_PARAPHRASE", nil), adjective, leftNoun, adjective, rightNoun];
        }
        else {
            self.exampleResult = [NSString stringWithFormat:NSLocalizedString(@"LEFT_NOUN_ADJ_RIGHT_NOUN_ATTACH_PARAPHRASE", nil), rightNoun, adjective, leftNoun];
        }
    
}


@end
