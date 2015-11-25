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
    if ([_usrField.text length] > 0 && [_pwdField.text length] > 0 && [_emlField.text length] > 0) {
        [[ParseDataManager sharedManager] signUp:_usrField.text withEmail:_emlField.text withPassword:_pwdField.text];
        [self dismissViewControllerAnimated:TRUE completion:^(void){}];
    }
}

@end
