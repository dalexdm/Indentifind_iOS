//
//  SignUpViewController.m
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/24/15.
//  Copyright © 2015 KALA. All rights reserved.
//

#import "SignUpViewController.h"
#import "ParseDataManager.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usrField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *emlField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendSignUpCredentials:(id)sender {
    if ([_usrField.text length] > 0 && [_pwdField.text length] > 0) {
        [[ParseDataManager sharedManager] signUp:_usrField.text withEmail:@"a@b.c" withPassword:_pwdField.text];
        [self dismissViewControllerAnimated:TRUE completion:^(void){}];
    }
}
- (IBAction)sendLogOnCredentials:(id)sender {
    [PFUser logInWithUsernameInBackground:_usrField.text password:_pwdField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                           message:@"A user does not exist with that username and password. Please try again."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [alert removeFromParentViewController];
                                                                }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:nil];
            _pwdField.text = @"";
        } else {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    }];
}

@end
