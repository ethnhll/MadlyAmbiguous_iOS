//
//  OSUUserCoordViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 4/4/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUUserCoordViewController.h"
#import "OSUConsiderationDataViewController.h"
#import "OSUMadHelper.h"

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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OSUConsiderationDataViewController *considerationView = segue.destinationViewController;
    OSUMadHelper *helper = [OSUMadHelper sharedMadHelper];
    NSString *adjective = self.adjectiveField.text;
    NSString *leftNoun = self.leftNounField.text;
    NSString *rightNoun = self.rightNounField.text;
    [helper coordExampleUsingAdjNouns:adjective leftNoun:leftNoun rightNoun:rightNoun];
    considerationView.helper = helper;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ToConsiderationFromCoord"]){
        if([self.adjectiveField.text isEqualToString:@""] | [self.leftNounField.text isEqualToString:@""] | [self.rightNounField.text isEqualToString:@""]){
            UIAlertView *notAllowed = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please be sure to fill in the text boxes before continuing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [notAllowed show];
            return NO;
        }
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if (touch.phase == UITouchPhaseBegan){
        [self.adjectiveField resignFirstResponder];
        [self.leftNounField resignFirstResponder];
        [self.rightNounField resignFirstResponder];
    }
}
@end
