//
//  OSUUserViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 3/28/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUUserPPAViewController.h"
#import "OSUConsiderationDataViewController.h"
#import "OSUMadHelper.h"

@interface OSUUserPPAViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation OSUUserPPAViewController

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
        NSString *userInputPhrase = self.textField.text;
        [helper ppaExampleUsingPhrase:userInputPhrase];
        considerationView.helper = helper;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ToConsiderationFromPPA"]){
        if([self.textField.text isEqualToString:@""]){
            UIAlertView *notAllowed = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please be sure to fill in the box with a phrase before continuing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [notAllowed show];
                return NO;
        }
    }
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if (touch.phase == UITouchPhaseBegan){
        [self.textField resignFirstResponder];
    }
}
@end
