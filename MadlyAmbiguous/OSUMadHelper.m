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
+(NSUInteger)getPPAFrequency:(NSString *)regexPatternOfNoun usingFile:(NSString *)filePath;
+(NSString *)findNounInPhrase:(NSString *)phrase usingFile:(NSString *)filePath;
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

+(NSUInteger)getPPAFrequency:(NSString *)regexPatternOfNoun usingFile:(NSString *)filePath {
    
	NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSRange searchRange = NSMakeRange(0, [fileContents length]);
	NSError *error = nil;
	
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPatternOfNoun options:NSRegularExpressionAnchorsMatchLines error:&error];
	NSArray *nounMatches = [regex matchesInString:fileContents options:0 range:searchRange];
    
	NSUInteger nounTotal = 0;
	for (NSTextCheckingResult *match in nounMatches) {
		NSString *matchText = [fileContents substringWithRange:[match range]];
		nounTotal += [OSUMadHelper lineFrequency:matchText];
	}
	return nounTotal;
}

+(NSString *)findNounInPhrase:(NSString *)phrase usingFile:(NSString *)filePath {
    
    // possibly deprecated in favor of NSLinguisticTagger
	
	NSArray *wordsAndEmptyStrings = [phrase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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



-(NSString *)reportTotalScoreInString {
    
    return (@"TEST");
}

-(NSMutableArray *)reportListOfConsideratiins{
    
    NSMutableArray *test = [[NSMutableArray alloc] init];
    
    return test;
}
-(NSString *)reportExampleResult {
    
    return [self.exampleResult copy];
}

-(void)ppaExampleUsingPhrase:(NSString *)phrase {
    
    NSString *commonEngPath = [[NSBundle mainBundle] pathForResource:@"CommonEnglish" ofType:nil inDirectory:@"resources.bundle"];
    NSString *ppaArcs = [[NSBundle mainBundle] pathForResource:@"AteSpaghettiArcs" ofType:nil inDirectory:@"resources.bundle"];
    
    NSString *headVerbRegex = NSLocalizedString(@"HEAD_VERB_REGEX", nil);
    NSString *headNounRegex = NSLocalizedString(@"HEAD_NOUN_REGEX", nil);
    NSString *regexTail = NSLocalizedString(@"POST_PPA_REGEX", nil);
    
    //Find noun
    NSString *noun = [OSUMadHelper findNounInPhrase:phrase usingFile:commonEngPath];
    
    NSString *verbPPNounPattern = [NSString stringWithFormat:@"%@%@%@", headVerbRegex, noun, regexTail];
    NSString *nounPPNounPattern = [NSString stringWithFormat:@"%@%@%@", headNounRegex, noun, regexTail];
    
    NSUInteger headVerbFrequency = [OSUMadHelper getPPAFrequency:verbPPNounPattern usingFile:ppaArcs];
    NSUInteger headNounFrequency = [OSUMadHelper getPPAFrequency:nounPPNounPattern usingFile:ppaArcs];
        
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
@end
