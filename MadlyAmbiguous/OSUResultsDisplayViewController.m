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
