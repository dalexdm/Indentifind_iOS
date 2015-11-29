//
//  PuzzleDetailsViewController.m
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/16/15.
//  Copyright © 2015 KALA. All rights reserved.
//

#import "PuzzleDetailsViewController.h"
#import <ParseUI/ParseUI.h>

@interface PuzzleDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet PFImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextView *clueField;
@property (weak, nonatomic) IBOutlet UILabel *userText;

@end

@implementation PuzzleDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleText.text = [_puzzle objectForKey:@"Title"];
    //img
    PFImageView *pfimg = _imgView;
    pfimg.image = [UIImage imageNamed:@""];
    pfimg.file = (PFFile *)[_puzzle objectForKey:@"Image"];
    _clueField.text = [_puzzle objectForKey:@"Clues"];
    _userText.text = [_puzzle objectForKey:@"User"];
    NSNumber *num = [_puzzle objectForKey:@"Viewed"];
    [_puzzle setObject:[NSNumber numberWithInt:[num integerValue] + 1] forKey:@"Viewed"];
    [_puzzle saveInBackground];
    [pfimg loadInBackground];
}
- (IBAction)solveButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"solve" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
