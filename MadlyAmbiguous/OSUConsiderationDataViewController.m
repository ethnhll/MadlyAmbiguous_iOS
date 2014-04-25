//
//  OSUConsiderationDataViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 3/28/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUConsiderationDataViewController.h"
#import "OSUResultsDisplayViewController.h"
@interface OSUConsiderationDataViewController ()
@property (weak, nonatomic) IBOutlet UITextView *considerationLeft;
@property (weak, nonatomic) IBOutlet UITextView *considerationRight;
@property (weak, nonatomic) IBOutlet UITextView *introMessage;

@end

@implementation OSUConsiderationDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custome initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    self.considerationLeft.text = [[self.helper reportListOfConsideratiins] objectAtIndex:0];
    self.considerationRight.text = [[self.helper reportListOfConsideratiins] objectAtIndex:1];
    [self.considerationLeft setFont:[UIFont systemFontOfSize:20]];
    [self.considerationRight setFont:[UIFont systemFontOfSize:20]];
    [self.considerationLeft setTextAlignment:NSTextAlignmentCenter];
    [self.considerationRight setTextAlignment:NSTextAlignmentCenter];
    
    
    self.introMessage.text = [NSString stringWithFormat:NSLocalizedString(@"POSSIBILITIES_INTRO", nil), [self.helper getChoiceSentence]];
    [self.introMessage setFont:[UIFont systemFontOfSize:25]];
    [self.introMessage setTextAlignment:NSTextAlignmentCenter];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        OSUResultsDisplayViewController *resultsView = segue.destinationViewController;
        resultsView.helper = self.helper;
}

@end
