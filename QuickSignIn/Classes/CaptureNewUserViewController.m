/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 File:   CaptureNewUserViewController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Thursday, January 26, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "CaptureNewUserViewController.h"

@interface CaptureNewUserViewController ()
@property (nonatomic, retain) NSMutableDictionary *engageUser;
@property (nonatomic, retain) JRCaptureUser       *captureUser;
@property (nonatomic, retain) UITextView          *firstResponder;
@property (nonatomic, retain) NSDate              *myBirthdate;
@end

@implementation CaptureNewUserViewController
@synthesize myLocationTextView;
@synthesize myGenderIdentitySegControl;
@synthesize myBirthdayButton;
@synthesize myBirthdayPicker;
@synthesize myPickerToolbar;
@synthesize engageUser;
@synthesize myEmailTextView;
@synthesize myPickerView;
@synthesize myScrollView;
@synthesize myKeyboardToolbar;
@synthesize firstResponder;
@synthesize myBirthdate;
@synthesize captureUser;
@synthesize myAboutMeTextView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary *user   = [[UserModel getUserModel] currentUser];
    NSString *identifier = [user objectForKey:@"identifier"];
    self.engageUser      = [NSMutableDictionary dictionaryWithDictionary:
                                   [[[UserModel getUserModel] userProfiles] objectForKey:identifier]];
    self.captureUser     = [[UserModel getUserModel] captureUser];

    [myPickerView setFrame:CGRectMake(0, 416, 320, 260)];
    [self.view addSubview:myPickerView];

    [myEmailTextView setInputAccessoryView:myKeyboardToolbar];
    [myLocationTextView setInputAccessoryView:myKeyboardToolbar];
    [myAboutMeTextView setInputAccessoryView:myKeyboardToolbar];
}

- (void)slidePickerUp
{
    [UIView beginAnimations:@"slidePickerUp" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelay:0.9];
    [myPickerView setFrame:CGRectMake(0, 156, 320, 260)];
    [UIView commitAnimations];
}

- (void)sliderPickerDown
{
    [UIView beginAnimations:@"slidePickerDown" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelay:0.9];
    [myPickerView setFrame:CGRectMake(0, 416, 320, 260)];
    [UIView commitAnimations];

}

- (void)scrollUpBy:(NSInteger)scrollOffset
{
    [myScrollView setContentOffset:CGPointMake(0, scrollOffset)];
    [myScrollView setContentSize:CGSizeMake(320, 416 + scrollOffset)];
}

- (void)scrollBack
{
    [myScrollView setContentOffset:CGPointZero];
    [myScrollView setContentSize:CGSizeMake(320, 416)];
}

- (IBAction)birthdayButtonClicked:(id)sender
{
    [self slidePickerUp];
    [self scrollUpBy:40];
}

- (IBAction)hidePickerButtonPressed:(id)sender
{
    [self sliderPickerDown];
    [self scrollBack];
}

- (IBAction)birthdayPickerChanged:(id)sender
{
    DLog(@"");
    [myBirthdayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    }

    NSDate   *pickerDate = myBirthdayPicker.date;
    NSString *dateString = [dateFormatter stringFromDate:pickerDate];

    [myBirthdayButton setTitle:dateString forState:UIControlStateNormal];

    self.myBirthdate = pickerDate;
}

- (IBAction)doneEditingButtonPressed:(id)sender
{
    [firstResponder resignFirstResponder];
    [self setFirstResponder:nil];
}

- (void)populateCaptureUser
{
    if (myEmailTextView.text && ![myEmailTextView.text isEqualToString:@""])
        captureUser.email       = myEmailTextView.text;
//    captureUser.currentLocation = myLocationTextView.text;
    captureUser.testerUniqueString = myLocationTextView.text;
    captureUser.aboutMe         = myAboutMeTextView.text;
    captureUser.birthday        = myBirthdate;

    if (myGenderIdentitySegControl.selectedSegmentIndex == 0)
        captureUser.gender = @"female";
    else if (myGenderIdentitySegControl.selectedSegmentIndex == 1)
        captureUser.gender = @"male";
}

- (IBAction)doneButtonPressed:(id)sender
{
    DLog(@"engageUser: %@", [engageUser description]);

    [self populateCaptureUser];

    if ([[UserModel getUserModel] latestAccessToken] || [[UserModel getUserModel] isNewRecord])
    {
        [JRCaptureInterface updateCaptureUser:[captureUser dictionaryFromObject]
                              withAccessToken:[[UserModel getUserModel] latestAccessToken]
                                  forDelegate:self];
    }
    else
    {
        [JRCaptureInterface createCaptureUser:[captureUser dictionaryFromObject]
                            withCreationToken:[[engageUser objectForKey:@"captureCredentials"] objectForKey:@"creation_token"]
                                  forDelegate:self];
    }
}

#define ABOUT_ME_TEXT_VIEW_TAG 20

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];

    self.firstResponder = textView;
    if (textView.tag == ABOUT_ME_TEXT_VIEW_TAG)
    {
        [self scrollUpBy:210];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self scrollBack];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text { return YES; }
- (void)textViewDidChange:(UITextView *)textView { }
- (void)textViewDidChangeSelection:(UITextView *)textView { }
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView { return YES; }
- (BOOL)textViewShouldEndEditing:(UITextView *)textView { return YES; }

- (void)handleSuccessfulResult:(NSString *)result withMessage:(NSString *)message
{
    DLog(@"%@", result);
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success"
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil] autorelease];
    [alert show];

    [[UserModel getUserModel] updateCaptureUserFromCaptureResult:result];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleFailedResult:(NSString *)result withMessage:(NSString *)message
{
    DLog(@"%@", result);
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Failure"
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"Dismiss"
                                           otherButtonTitles:nil] autorelease];
    [alert show];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createCaptureUserDidSucceedWithResult:(NSString *)result
{
    [self handleSuccessfulResult:result withMessage:@"Profile created"];
}

- (void)createCaptureUserDidFailWithResult:(NSString *)result
{
    [self handleFailedResult:result withMessage:@"Profile not created"];
}

- (void)updateCaptureUserDidSucceedWithResult:(NSString *)result
{
    [self handleSuccessfulResult:result withMessage:@"Profile updated"];
}

- (void)updateCaptureUserDidFailWithResult:(NSString *)result
{
    [self handleFailedResult:result withMessage:@"Profile not updated"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (void)viewDidUnload { [super viewDidUnload]; }

- (void)dealloc
{
    [myLocationTextView release];
    [myGenderIdentitySegControl release];
    [myBirthdayButton release];
    [myBirthdayPicker release];
    [myPickerToolbar release];
    [myEmailTextView release];
    [myPickerView release];
    [myScrollView release];
    [myKeyboardToolbar release];
    [firstResponder release];
    [engageUser release];
    [myBirthdate release];
    [captureUser release];
    [myAboutMeTextView release];
    [super dealloc];
}
@end
