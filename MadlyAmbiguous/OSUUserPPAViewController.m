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
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITextView *phraseBeginTextView;
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
    self.helper = [OSUMadHelper sharedMadHelper];
    self.phraseBeginTextView.text = [NSString stringWithFormat:NSLocalizedString(@"PPA_BEGIN_DEFAULT", nil), self.helper.name];
    [self.phraseBeginTextView setFont:[UIFont systemFontOfSize:20]];
    [self.phraseBeginTextView setTextAlignment:NSTextAlignmentRight];
    [self.doneButton setEnabled:FALSE];
}
- (IBAction)textEntered:(id)sender {
    if ([self.textField.text isEqualToString:@""]){
        [self.doneButton setEnabled:FALSE];
    }
    else {
        [self.doneButton setEnabled:TRUE];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([self.textField.text isEqualToString:@""]){
        return NO;
    }
    else {
        [self performSegueWithIdentifier:@"ToConsiderationFromPPA" sender:self];
        return YES;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

        OSUConsiderationDataViewController *considerationView = segue.destinationViewController;
        NSString *userInputPhrase = self.textField.text;
        [self.helper ppaExampleUsingPhrase:userInputPhrase];
        self.helper.choiceSentence = [NSString stringWithFormat:@"%@ %@", self.phraseBeginTextView.text, userInputPhrase];
        considerationView.helper = self.helper;
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
