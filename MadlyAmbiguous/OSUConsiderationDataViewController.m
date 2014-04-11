//
//  OSUConsiderationDataViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 3/28/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUConsiderationDataViewController.h"
#import "OSUResultsDisplayViewController.h"
#import "CMPopTipView.h"
@interface OSUConsiderationDataViewController ()
@property (weak, nonatomic) IBOutlet UITextView *considerationLeft;
@property (weak, nonatomic) IBOutlet UITextView *considerationRight;
@property (weak, nonatomic) IBOutlet CMPopTipView *topSpeechBubble;
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
