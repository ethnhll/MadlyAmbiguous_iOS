//
//  OSUWinViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 4/4/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUWinLoseViewController.h"

@interface OSUWinLoseViewController ()
@property (weak, nonatomic) IBOutlet UITextView *messageOutput;
@end

@implementation OSUWinLoseViewController

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
    if (self.wasRight){
        self.messageOutput.text = [NSString stringWithFormat:NSLocalizedString(@"WAS_RIGHT", nil), [self.helper getSessionWins], [self.helper getSessionLosses]];
    }
    else {
        self.messageOutput.text = [NSString stringWithFormat:NSLocalizedString(@"WAS_WRONG", nil), [self.helper getSessionWins], [self.helper getSessionLosses]];;
    }
    [self.messageOutput setFont:[UIFont systemFontOfSize:30]];
    [self.messageOutput setTextAlignment:NSTextAlignmentCenter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
