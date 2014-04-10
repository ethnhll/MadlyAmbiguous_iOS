//
//  OSUResultsDisplayViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 4/4/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUResultsDisplayViewController.h"

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

- (IBAction)buttonPressed:(id)button {
}


@end
