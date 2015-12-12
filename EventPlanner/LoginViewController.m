//
//  LoginViewController.m
//  EventPlanner
//
//  Created by Xin Suo on 11/5/15.
//  Copyright © 2015 Thunder Labs. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import "HomeViewController.h"
#import "Constants.h"
#import "User.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *alreadyHaveAccountButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeColor];
    [self initializeControls];
}

- (void)initializeColor {
    self.titleLabel.textColor = [[Constants sharedInstance] themeColor];
    self.facebookButton.backgroundColor = [[Constants sharedInstance] facebookColor];
    [self.facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [[Constants sharedInstance] themeColor];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.createAccountButton setTitleColor:[[Constants sharedInstance] themeColor] forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitleColor:[[Constants sharedInstance] themeColor] forState:UIControlStateNormal];
    [self.alreadyHaveAccountButton setTitleColor:[[Constants sharedInstance] themeColor] forState:UIControlStateNormal];
}

- (void)initializeControls {
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.alreadyHaveAccountButton.hidden = YES;
}

- (IBAction)onLogin:(id)sender {
    if ([self validateInput]) {
        if ([self.loginButton.currentTitle isEqualToString:@"Log In"]) {
            [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    
                                                } else {
                                                    NSString *errorString = [error userInfo][@"error"];
                                                    [self presentAlertMessageWithTitle:@"Failed to log in" message:errorString];
                                                }
                                            }];
        } else {
            PFUser *user = [PFUser user];
            user.username = self.emailTextField.text;
            user.password = self.passwordTextField.text;
            user.email = self.emailTextField.text;
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (!error) {
                    
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    [self presentAlertMessageWithTitle:@"Cannot create account" message:errorString];
                }
            }];
        }
    }
}

- (IBAction)onLoginWithFacebook:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
        } else {
            if (result.token) {
                [self getFacebookProfileInfo];
            }
        }
    }];
}

- (void)getFacebookProfileInfo {
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture, name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
             dictionary[@"username"] = [result objectForKey:@"name"];
             dictionary[@"profileUrl"] = [result objectForKey:@"picture"][@"data"][@"url"];
             [dictionary setValue:@(FACEBOOK) forKey:@"userType"];
             [User setCurrentUser:[[User alloc] initWithDictionary:dictionary]];
             NSLog(@"%@ %@", dictionary[@"username"], dictionary[@"profileUrl"]);
         } else{
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}

- (BOOL)validateInput {
    if ([self.emailTextField.text length] == 0) {
        [self presentAlertMessageWithTitle:@"Email address is blank" message:@"Please enter an email address."];
        return FALSE;
    } else if (![self validateEmail:self.emailTextField.text]) {
        [self presentAlertMessageWithTitle:@"Email address is invalid" message:@"Please enter a valid email address."];
        return FALSE;
    } else if ([self.passwordTextField.text length] == 0) {
        [self presentAlertMessageWithTitle:@"Password is blank" message:@"Please enter a password."];
        return FALSE;
    } else {
        return TRUE;
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void)presentAlertMessageWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)onCreateAccount:(id)sender {
    self.createAccountButton.hidden = YES;
    self.forgetPasswordButton.hidden = YES;
    self.alreadyHaveAccountButton.hidden = NO;
    [self.loginButton setTitle:@"Sign Up" forState:UIControlStateNormal];
}

- (IBAction)onAlreadyHaveAccount:(id)sender {
    self.alreadyHaveAccountButton.hidden = YES;
    self.createAccountButton.hidden = NO;
    self.forgetPasswordButton.hidden = NO;
    [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
