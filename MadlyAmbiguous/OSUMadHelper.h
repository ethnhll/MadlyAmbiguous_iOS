//
//  OSUMadHelper.h
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 3/21/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HEADS 1

@interface OSUMadHelper : NSObject

@property NSUInteger wins;
@property NSUInteger losses;
@property NSMutableArray *considerations;
@property NSString *exampleResult;

-(id)init;

-(NSString *)reportTotalScoreInString;
-(NSString *)reportExampleResult;
-(NSMutableArray *)reportListOfConsideratiins;
+(id)sharedMadHelper;
-(void)ppaExampleUsingPhrase:(NSString *)phrase;
-(void)coordExampleUsingAdjNouns:(NSString *)adjective leftNoun:(NSString *)leftNoun rightNoun:(NSString *)rightNoun;
-(void)incrementWins;
-(void)incrementLosses;
-(NSUInteger)getWins;
-(NSUInteger)getLosses;
@end
