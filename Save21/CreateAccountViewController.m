//
//  CreateAccountViewController.m
//  Save21
//
//  Created by Feiyang Chen on 13-10-06.
//  Copyright (c) 2013 Feiyang Chen. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "keysAndUrls.h"
#import "Save21AppDelegate.h"

@interface CreateAccountViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *genderField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *postalField;

@property (strong, nonatomic) UIToolbar *mypickerToolbar;
@property (strong, nonatomic) UIPickerView *genderPicker;
@property (strong, nonatomic) UIPickerView *cityPicker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation CreateAccountViewController
@synthesize genderChoices = _genderChoices;
@synthesize cityChoices = _cityChoices;

@synthesize titleLabel = _titleLabel;
@synthesize firstNameField = _firstNameField;
@synthesize lastNameField = _lastNameField;
@synthesize emailAddressField = _emailAddressField;
@synthesize passwordField = _passwordField;
@synthesize postalField = _postalField;

@synthesize doneButton = _doneButton;

@synthesize genderPicker = _genderPicker;
@synthesize cityPicker = _cityPicker;

@synthesize flOperation = _flOperation;

- (void)viewDidLoad
{ 
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    //UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:7.0/255 green:61.0/255 blue:48.0/255 alpha:1.0f];
     
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
     
    //self.view.backgroundColor = mainColor;
    
    self.firstNameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.lastNameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.emailAddressField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    self.genderField.font = [UIFont fontWithName:fontName size:16.0f];
    self.cityField.font = [UIFont fontWithName:fontName size:16.0f];
    self.postalField.font = [UIFont fontWithName:fontName size:16.0f];
     
    self.doneButton.backgroundColor = darkColor;
    self.doneButton.layer.cornerRadius = 3.0f;
    self.doneButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
     
    self.titleLabel.textColor =  darkColor;
    self.titleLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    
    [self.firstNameField setDelegate:self];
    [self.lastNameField setDelegate:self];
    [self.emailAddressField setDelegate:self];
    [self.passwordField setDelegate:self];
    [self.genderField setDelegate:self];
    [self.cityField setDelegate:self];
    [self.postalField setDelegate:self];
    
    self.passwordField.secureTextEntry = YES;
    
    
    self.genderChoices = @[@"Choose gender", @"Male", @"Female"];
    self.cityChoices = @[@"Choose city",
                         @"Toronto",
                         @"Ottawa",
                         @"Hamilton",
                         @"Scarborough",
                         @"Mississauga",
                         @"Brampton",
                         @"Kitchener",
                         @"London",
                         @"Windsor",
                         @"Markham",
                         @"Vaughan",
                         @"Oshawa",
                         @"Richmond Hill",
                         @"Oakville",
                         @"Barrie" ];
    

    
    // Set up the initial state of the gender picker.
    self.genderPicker = [[UIPickerView alloc] init];
    self.genderPicker.delegate = self;
    self.genderPicker.dataSource = self;
    self.genderPicker.showsSelectionIndicator = YES;
    
    self.genderField.inputView = self.genderPicker;
    
    // Set up the initial state of the city picker.
    self.cityPicker = [[UIPickerView alloc] init];
    self.cityPicker.delegate = self;
    self.cityPicker.dataSource = self;
    self.cityPicker.showsSelectionIndicator = YES;
    
    self.cityField.inputView = self.cityPicker;
    
    // Create done button in UIPickerView
    
    
    self.mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    
    //self.mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    
    [self.mypickerToolbar sizeToFit];
    
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    
    [barItems addObject:doneBtn];
    
    
    [self.mypickerToolbar setItems:barItems animated:YES];
    
    
    self.genderField.inputAccessoryView = self.mypickerToolbar;
    self.cityField.inputAccessoryView = self.mypickerToolbar;
}


-(void)pickerDoneClicked {
    [self.genderField resignFirstResponder];
    [self.cityField resignFirstResponder];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.genderPicker)
        return self.genderChoices.count;
    
    if (pickerView == self.cityPicker)
        return self.cityChoices.count;
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.genderPicker)
        return self.genderChoices[row];
    
    if (pickerView == self.cityPicker)
        return self.cityChoices[row];
    
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row != 0) { //not the first default row
    
        if (pickerView == self.genderPicker) {
            self.genderField.text = self.genderChoices[row];
        }
        
        if (pickerView == self.cityPicker) {
            self.cityField.text = self.cityChoices[row];
        }

    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.firstNameField && self.firstNameField.text.length) {
        self.firstNameField.text = [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.firstNameField.text = [self.firstNameField.text lowercaseString];
        self.firstNameField.text = [self.firstNameField.text stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.firstNameField.text substringToIndex:1] uppercaseString]];

    }
    
    if (textField == self.lastNameField && self.lastNameField.text.length) {
        self.lastNameField.text = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.lastNameField.text = [self.lastNameField.text lowercaseString];
        self.lastNameField.text = [self.lastNameField.text stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.lastNameField.text substringToIndex:1] uppercaseString]];
    }
    
    if (textField == self.emailAddressField && self.emailAddressField.text.length) {
        self.emailAddressField.text = [self.emailAddressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.emailAddressField.text = [self.emailAddressField.text lowercaseString];
    }
    
    if (textField == self.postalField && self.postalField.text.length) {
        self.postalField.text = [self.postalField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.postalField.text = [self.postalField.text uppercaseString];
    }
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

-(BOOL) NSStringIsCanadianPostalCode:(NSString *)checkString
{
    NSString *filterString = @"^[ABCEGHJKLMNPRSTVXYabceghjklmnprstvxy]{1}\\d{1}[A-Za-z]{1} *\\d{1}[A-Za-z]{1}\\d{1}$";
    NSPredicate *postalTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterString];
    return [postalTest evaluateWithObject:checkString];
}

//check all fields are entered and valid before sending them to the server for further verification
-(BOOL)checkAllFields {
    //check password length
    if (self.passwordField.text.length < 6) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Password too short. Must be 6 or more characters.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return NO;
    }
    
    
    //check of email is valid
    if (![self NSStringIsValidEmail:self.emailAddressField.text]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Make sure you fill out email address properly.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return NO;
    }
    
    //check of postal is valid
    if (![self NSStringIsCanadianPostalCode:self.postalField.text]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Make sure the postal code is correct.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return NO;
    }
    
    // Check if both fields are completed
    if (self.firstNameField.text.length &&
        self.lastNameField.text.length  &&
        self.emailAddressField.text.length  &&
        self.passwordField.text.length  &&
        self.postalField.text.length  ) {
        // Begin signup process
        return YES;
        
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return NO;
    }
    
    return NO;
}


- (IBAction)doneButtonPressed {
    if ([self checkAllFields]) {
        [self.doneButton setTitle:@"SIGNING UP..." forState:UIControlStateNormal];
        self.doneButton.enabled = NO;
        
        PFUser *user = [PFUser user];
        
        //the username is the email
        user.username = self.emailAddressField.text;
        user.password = self.passwordField.text;
        user.email = self.emailAddressField.text;
        
        [user setObject:self.firstNameField.text forKey:@"firstName"];
        [user setObject:self.lastNameField.text forKey:@"lastName"];
        [user setObject:[NSNumber numberWithInt:0] forKey:@"numberOfReceiptsInProcess"];
        [user setObject:[NSNumber numberWithDouble:0.0] forKey:@"accountBalance"];
        [user setObject:[NSNumber numberWithDouble:0.0] forKey:@"totalSaved"];
        [user setObject:self.genderField.text forKey:@"Sex"];
        [user setObject:self.cityField.text forKey:@"City"];
        [user setObject:self.postalField.text forKey:@"postal"];
        
        __weak typeof(self) weakSelf = self;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                
                //tell our file server to set up this user's directories
                NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.emailAddressField.text,@"user_email", nil];
                self.flOperation = [ApplicationDelegate.communicator postDataToServer:postParams path: WEB_API_FILE];
                
                [self.flOperation addCompletionHandler:^(MKNetworkOperation *operation){
                    NSLog(@"user added success!");
                    //handle a successful 200 response
                    NSDictionary *responseDict = [operation responseJSON];
                    NSNumber *userid = [responseDict objectForKey:@"new user"];
                    NSLog(@"new user's id is %d", [userid intValue]);
                    
                    [weakSelf.parentViewController performSegueWithIdentifier:@"finish SignUp" sender:weakSelf.parentViewController];
                }
                                          errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
                 {
                     NSLog(@"%@", error);
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                     [alert show];
                 }];
                
                [ApplicationDelegate.communicator enqueueOperation:self.flOperation];
                
                
            } else {
                NSString *errorMessage;
                if ([error code] == kPFErrorUsernameTaken) {
                    errorMessage = @"Username has already been taken";
                } else if ([error code] == kPFErrorUserEmailTaken) {
                    errorMessage = @"Email has already been taken";
                } else if ([error code] == kPFErrorConnectionFailed) {
                    errorMessage = @"It appears you are not online. This app requires that you are online in order to use it. Please connect to internet and try again.";
                } else if (error) {
                    errorMessage = [error userInfo][@"error"];
                }
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
            }
            
            [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
            self.doneButton.enabled = YES;

        }];
        
    }

}

- (void)viewDidUnload
{
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setEmailAddressField:nil];
    [self setPasswordField:nil];
    [self setGenderPicker:nil];
    [self setPostalField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
