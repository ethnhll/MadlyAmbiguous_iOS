//
//  OSUUserCoordViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 4/4/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUUserCoordViewController.h"

@interface OSUUserCoordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *adjectiveField;
@property (weak, nonatomic) IBOutlet UITextField *leftNounField;
@property (weak, nonatomic) IBOutlet UITextField *rightNounField;
@end

@implementation OSUUserCoordViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
