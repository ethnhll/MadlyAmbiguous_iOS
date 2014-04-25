//
//  OSUResultsDisplayViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 4/4/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUResultsDisplayViewController.h"
#import "OSUWinLoseViewController.h"
@interface OSUResultsDisplayViewController ()
@property (weak, nonatomic) IBOutlet UITextView *resultBox;
@property (weak, nonatomic) IBOutlet UITextView *messageBox;
@property (weak, nonatomic) IBOutlet UITextView *askUserField;

@end

@implementation OSUResultsDisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.resultBox.text = [self.helper reportExampleResult];
    [self.resultBox setFont:[UIFont systemFontOfSize:20]];
    [self.resultBox setTextAlignment:NSTextAlignmentCenter];
    
    self.messageBox.text = [NSString stringWithFormat:NSLocalizedString(@"RESULTS_INTRO", nil), self.helper.choiceSentence];
    
    [self.messageBox setFont:[UIFont systemFontOfSize:25]];
    [self.messageBox setTextAlignment:NSTextAlignmentCenter];
    
    self.askUserField.text = [NSString stringWithFormat:NSLocalizedString(@"ASK_USER", nil), self.helper.name];
    
    [self.askUserField setFont:[UIFont systemFontOfSize:25]];
    [self.askUserField setTextAlignment:NSTextAlignmentCenter];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender {
        [self performSegueWithIdentifier:@"ToScoreFromResults" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender{
    OSUWinLoseViewController *winLoseView = segue.destinationViewController;
    if (sender.tag == 1){
        [self.helper incrementWins];
        winLoseView.wasRight = YES;
    }
    else {
        [self.helper incrementLosses];
        winLoseView.wasRight = NO;
    }
    winLoseView.helper = self.helper;
}


@end
