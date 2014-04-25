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

@property NSUInteger dailyWins;
@property NSUInteger dailyLosses;
@property NSUInteger sessionWins;
@property NSUInteger sessionLosses;
@property NSMutableArray *considerations;
@property NSString *exampleResult;
@property (nonatomic) NSString *name;
@property NSString *choiceSentence;

-(id)init;
-(NSString *)reportExampleResult;
-(NSMutableArray *)reportListOfConsideratiins;
+(id)sharedMadHelper;
-(void)ppaExampleUsingPhrase:(NSString *)phrase;
-(void)coordExampleUsingAdjNouns:(NSString *)adjective leftNoun:(NSString *)leftNoun rightNoun:(NSString *)rightNoun;
-(void)incrementWins;
-(void)incrementLosses;
-(NSUInteger)getSessionWins;
-(NSUInteger)getSessionLosses;
-(NSUInteger)getDailyWins;
-(NSUInteger)getDailyLosses;
-(void)resetSession;
-(NSString *)getChoiceSentence;

@end
