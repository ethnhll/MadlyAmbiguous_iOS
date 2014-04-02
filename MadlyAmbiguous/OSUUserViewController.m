//
//  OSUUserViewController.m
//  MadlyAmbiguous
//
//  Created by Ethan Hill on 3/28/14.
//  Copyright (c) 2014 Ethan Hill. All rights reserved.
//

#import "OSUUserViewController.h"
#import "OSUConsiderationDataViewController.h"
#import "OSUMadHelper.h"

@interface OSUUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation OSUUserViewController

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
    if (self.textField.text != nil){
        OSUConsiderationDataViewController *considerationView = segue.destinationViewController;
        OSUMadHelper *helper = [OSUMadHelper sharedMadHelper];
        NSString *userInputPhrase = self.textField.text;
        [helper ppaExampleUsingPhrase:userInputPhrase];
        considerationView.helper = helper;
    }
    else {
        //show tool tip explaining that the text field must be filled...
        
    }
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
