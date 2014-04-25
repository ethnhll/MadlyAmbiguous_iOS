//
//  OSUIntroViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 4/18/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUIntroViewController.h"

#import "OSUExampleSelectionViewController.h"

@interface OSUIntroViewController ()

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITextView *tempSpeechBubble;
@property NSMutableArray *messages;
@property NSUInteger currentMessage;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *characterImage;
@end

@implementation OSUIntroViewController

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
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {

        [self performSegueWithIdentifier:@"ToExamplesFromIntro" sender:self];
        return YES;
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ToExamplesFromIntro"]){
        if([self.textField.text isEqualToString:@""]){
            self.textField.text = @"Kim the human";
        }
    }
    return YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    OSUExampleSelectionViewController *exampleView = segue.destinationViewController;
    OSUMadHelper *helper = [OSUMadHelper sharedMadHelper];
    [helper resetSession];
    helper.name = self.textField.text;
    exampleView.helper = helper;
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
