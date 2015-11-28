//
//  ChooseCategoryViewController.m
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/16/15.
//  Copyright © 2015 KALA. All rights reserved.
//

#import "ChooseCategoryViewController.h"
#import "ParseDataManager.h"

@interface ChooseCategoryViewController ()

@end

@implementation ChooseCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recentPressed:(id)sender {
    [ParseDataManager sharedManager].filterType = 0;
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)popularPressed:(id)sender {
    [ParseDataManager sharedManager].filterType = 1;
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)difficultPressed:(id)sender {
    [ParseDataManager sharedManager].filterType = 2;
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)minePressed:(id)sender {
    [ParseDataManager sharedManager].filterType = 3;
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
