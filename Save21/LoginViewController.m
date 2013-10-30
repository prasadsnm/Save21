//
//  LoginViewController.m
//  Save21
//
//  Created by feiyang chen on 13-10-09.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, weak) IBOutlet UIButton * forgotButton;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic, weak) IBOutlet UILabel * subTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonConstraint;

@end

@implementation LoginViewController
@synthesize emailAddressField = _emailAddressField;
@synthesize passwordField = _passwordField;
@synthesize loginButton = _loginButton;
@synthesize forgotButton = _forgotButton;
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;

#define kOFFSET_FOR_KEYBOARD 80.0

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:7.0/255 green:61.0/255 blue:48.0/255 alpha:1.0f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    
    self.emailAddressField.backgroundColor = [UIColor whiteColor];
    self.emailAddressField.layer.cornerRadius = 3.0f;
    self.emailAddressField.placeholder = @"Email Address";
    self.emailAddressField.font = [UIFont fontWithName:fontName size:16.0f];
    
    
    UIImageView* usernameIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 24, 24)];
    usernameIconImage.image = [UIImage imageNamed:@"mail"];
    UIView* usernameIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    usernameIconContainer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [usernameIconContainer addSubview:usernameIconImage];
    
    self.emailAddressField.leftViewMode = UITextFieldViewModeAlways;
    self.emailAddressField.leftView = usernameIconContainer;
    
    
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    
    
    UIImageView* passwordIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 24, 24)];
    passwordIconImage.image = [UIImage imageNamed:@"lock"];
    UIView* passwordIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    passwordIconContainer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [passwordIconContainer addSubview:passwordIconImage];
    
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = passwordIconContainer;
    
    self.loginButton.backgroundColor = darkColor;
    self.loginButton.layer.cornerRadius = 3.0f;
    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.forgotButton.backgroundColor = [UIColor clearColor];
    self.forgotButton.titleLabel.font = [UIFont fontWithName:fontName size:12.0f];
    [self.forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:darkColor forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    self.titleLabel.text = @"GOOD TO SEE YOU";
    
    self.subTitleLabel.textColor =  [UIColor whiteColor];
    self.subTitleLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.subTitleLabel.text = @"Welcome back, please login below";
    
    self.emailAddressField.delegate = self;
    self.passwordField.delegate = self;
    
    self.passwordField.secureTextEntry = YES;
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
    self.buttonConstraint.constant = 55 + kOFFSET_FOR_KEYBOARD;
    
    [self animateConstraints];
}

-(void)pushDown {
    self.buttonConstraint.constant = 55;
    
    [self animateConstraints];
}

- (void)animateConstraints
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
