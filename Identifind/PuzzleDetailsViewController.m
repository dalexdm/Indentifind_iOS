//
//  PuzzleDetailsViewController.m
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/16/15.
//  Copyright © 2015 KALA. All rights reserved.
//

#import "PuzzleDetailsViewController.h"
#import <ParseUI/ParseUI.h>
#import "SolveViewController.h"

@interface PuzzleDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet PFImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextView *clueField;
@property (weak, nonatomic) IBOutlet UILabel *userText;
@property (weak, nonatomic) IBOutlet UIButton *solveButton;

@end

@implementation PuzzleDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleText.text = [_puzzle objectForKey:@"Title"];
    
    //img
    PFImageView *pfimg = _imgView;
    pfimg.file = (PFFile *)[_puzzle objectForKey:@"Image"];
    _clueField.text = [_puzzle objectForKey:@"Clues"];
    _userText.text = [_puzzle objectForKey:@"User"];
    [pfimg loadInBackground];
    
    //see if the user has viewed this already
    NSArray *solverArray = (NSArray *) [_puzzle objectForKey:@"UsersSolved"];
    //if so, go ahead and increment views. Then add user to viewed List
    if ([solverArray containsObject:[PFUser currentUser].username]) {
        _solveButton.enabled = false;
        [_solveButton setTitle:@"Already Solved!" forState:UIControlStateNormal];
    }
}
- (IBAction)solveButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"solve" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"solve"]) {
        SolveViewController *vc = (SolveViewController *)segue.destinationViewController;
        vc.puzzle = _puzzle;
    }
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
