//
//  OSUConsiderationDataViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 3/28/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUConsiderationDataViewController.h"

@interface OSUConsiderationDataViewController ()
@property (weak, nonatomic) IBOutlet UITextView *exampleResult;


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
    self.exampleResult.text = [self.helper reportExampleResult];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
