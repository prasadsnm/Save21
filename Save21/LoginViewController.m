//
//  LoginViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-09.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoConstraint;


@end

@implementation LoginViewController
@synthesize emailAddressField = _emailAddressField;
@synthesize passwordField = _passwordField;
@synthesize loginButton = _loginButton;
@synthesize forgotButton = _forgotButton;
@synthesize signUpButton = _signUpButton;

#define kOFFSET_FOR_KEYBOARD 85.0

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    UIColor* bgColor = [UIColor whiteColor];
    UIColor* textFieldColor = ApplicationDelegate.textfieldColor;
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBar.barTintColor = ApplicationDelegate.darkColor;
    
    
    NSString* fontName = @"Avenir-Book";
    
    self.view.backgroundColor = bgColor;
    
    self.emailAddressField.backgroundColor = textFieldColor;
    self.emailAddressField.layer.cornerRadius = 3.0f;
    self.emailAddressField.placeholder = @"Your email address";
    self.emailAddressField.font = [UIFont fontWithName:fontName size:16.0f];
    
    
    UIImageView* usernameIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 15, 22.2, 13.4)];
    usernameIconImage.image = [UIImage imageNamed:@"Email Login Icon"];
    UIView* usernameIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    usernameIconContainer.backgroundColor = ApplicationDelegate.darkColor;
    [usernameIconContainer addSubview:usernameIconImage];
    
    self.emailAddressField.leftViewMode = UITextFieldViewModeAlways;
    self.emailAddressField.leftView = usernameIconContainer;
    
    self.passwordField.backgroundColor = textFieldColor;
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    
    UIImageView* passwordIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 12, 24, 14)];
    passwordIconImage.image = [UIImage imageNamed:@"Password Login Icon"];
    UIView* passwordIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    passwordIconContainer.backgroundColor = ApplicationDelegate.darkColor;
    [passwordIconContainer addSubview:passwordIconImage];
    
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = passwordIconContainer;
    
    self.loginButton.backgroundColor = ApplicationDelegate.darkColor;
    self.loginButton.layer.cornerRadius = 3.0f;
    self.loginButton.titleLabel.font = [UIFont fontWithName:ApplicationDelegate.boldFontName size:20.0f];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.forgotButton.backgroundColor = [UIColor clearColor];
    self.forgotButton.titleLabel.font = [UIFont fontWithName:fontName size:12.0f];
    [self.forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    self.emailAddressField.delegate = self;
    self.passwordField.delegate = self;
    
    self.passwordField.secureTextEntry = YES;
}

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goToSignup" sender:self];
}

//when the user finish editing a text field, push the view down back to normal
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self pushDown];
    return NO;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (IBAction)loginButtonPressed {
    //check of email is valid
    if (![self NSStringIsValidEmail:self.emailAddressField.text]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Make sure you fill out your email address properly.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    
    // Check if both fields are completed
    if (self.emailAddressField.text && self.passwordField.text && self.emailAddressField.text.length && self.passwordField.text.length) {
        
        [self.loginButton setTitle:@"LOGGING IN..." forState:UIControlStateNormal];
        self.loginButton.enabled = NO;
        
        // Begin login process
        [PFUser logInWithUsernameInBackground:self.emailAddressField.text password:self.passwordField.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                // Do stuff after successful login.
                                                [self performSegueWithIdentifier:@"login Success" sender:self];
                                            } else {
                                                NSString *errorMessage = @"We can't login using these credentials, please verify them and try again.";

                                                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
                                            }
                                            
                                            [self.loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
                                            self.loginButton.enabled = YES;
                                        }];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
    }
}

- (IBAction)forgotPasswordPressed {
    //check of email is valid
    if (![self NSStringIsValidEmail:self.emailAddressField.text]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Make sure you fill out email address properly so we can send you a email to reset your password.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
        return;
    }
    // Check if both fields are completed
    if (self.emailAddressField.text && self.emailAddressField.text.length) {
        [PFUser requestPasswordResetForEmailInBackground:self.emailAddressField.text block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email Sent", nil) message:NSLocalizedString(@"Please now go to your email box to reset your password using our email.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            } else {
                NSString *errorMessage;
                if ([error code] == kPFErrorUserWithEmailNotFound) {
                    errorMessage = @"A user with the specified email was not found";
                } else if ([error code] == kPFErrorConnectionFailed) {
                    errorMessage = @"It appears you are not online. This app requires that you are online in order to use it. Please connect to internet and try again.";
                } else if (error) {
                    errorMessage = [error userInfo][@"error"];
                }
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
            }
        }];
    }
}

- (void)viewDidUnload
{
    [self setEmailAddressField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//when the user start to edit a text field, push the view up to make room for the keyboard
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self pushUp];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.emailAddressField && self.emailAddressField.text.length) {
        self.emailAddressField.text = [self.emailAddressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.emailAddressField.text = [self.emailAddressField.text lowercaseString];
    }
}

-(void)pushUp {
    //push the logo up only on 3.5" iphones
    if (!IsIphone5) {
        self.logoConstraint.constant = 13 - kOFFSET_FOR_KEYBOARD;
    }
    
    self.buttonConstraint.constant = 25 + kOFFSET_FOR_KEYBOARD;
    
    [self animateConstraints];
}

-(void)pushDown {
    if (!IsIphone5) {
        self.logoConstraint.constant = 13;
    }
    
    self.buttonConstraint.constant = 10;
    
    [self animateConstraints];
}

- (void)animateConstraints
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
