//
//  PuzzleBrowserTableViewController.m
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/16/15.
//  Copyright © 2015 KALA. All rights reserved.
//

#import "PuzzleBrowserTableViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PuzzleDetailsViewController.h"
#import "ParseDataManager.h"

@interface PuzzleBrowserTableViewController ()
//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *puzzles;
@property PFObject *selectedPuzzle;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;


@end

@implementation PuzzleBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ParseDataManager sharedManager].mainView = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadPuzzles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wannaLogOut:(id)sender {
    if (![[ParseDataManager sharedManager] isUserLoggedIn]) {
        [self performSegueWithIdentifier:@"signUpSegue" sender:self];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Out"
                                                                   message:@"Would you like to log out this user?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *affirmative = [UIAlertAction actionWithTitle:@"Yes"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [[ParseDataManager sharedManager] logout];
                                                            [alert removeFromParentViewController];
                                                        }];
    [alert addAction:affirmative];
    UIAlertAction *negative = [UIAlertAction actionWithTitle:@"No"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [alert removeFromParentViewController];
                                                        }];
    [alert addAction:negative];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)filterChosen:(id)sender {
}

- (IBAction)startNewPuzzle:(id)sender {
    if (![[ParseDataManager sharedManager] isUserLoggedIn]) {
        [self performSegueWithIdentifier:@"signUpSegue" sender:self];
        return;
    }
    [self performSegueWithIdentifier:@"newPuzzle" sender:self];
}

-(void)loadPuzzles {
    if ([[ParseDataManager sharedManager] isUserLoggedIn]) [_titleButton setTitle:[NSString stringWithFormat:@"%@ | %@ Points", [PFUser currentUser].username, [[PFUser currentUser] objectForKey:@"Points"]] forState:UIControlStateNormal];
    else [_titleButton setTitle:@"No user logged in!" forState:UIControlStateNormal];
    PFQuery *query = [PFQuery queryWithClassName:@"Puzzle"];
    switch ([ParseDataManager sharedManager].filterType) {
        case 0:
            [query orderByDescending:@"createdAt"];
            break;
        case 1:
            [query orderByDescending:@"Views"];
            break;
        case 2:
            [query orderByDescending:@"Difficulty"];
            break;
        case 3:
            [query whereKey:@"User" equalTo:[PFUser currentUser].username];
            break;
        default:
            [query orderByDescending:@"createdAt"];
            break;
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            self.puzzles = [objects mutableCopy];
            [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _puzzles.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[ParseDataManager sharedManager] isUserLoggedIn]) {
        [self performSegueWithIdentifier:@"signUpSegue" sender:self];
        return;
    }
    _selectedPuzzle = (PFObject *) _puzzles[indexPath.row];
    [self performSegueWithIdentifier:@"getDetails" sender:self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"myCell"];
    }
    
    //UIImageView *img = (UIImageView *)[cell viewWithTag:2];
    PFObject *currentPuzzle = self.puzzles[indexPath.row];
    
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:4];
    lbl.text = [currentPuzzle objectForKey:@"Title"];
    
    UILabel *usr = (UILabel *)[cell viewWithTag:3];
    usr.text = [NSString stringWithFormat:@"by %@",[currentPuzzle objectForKey:@"User"]];
    
    UILabel *vws = (UILabel *)[cell viewWithTag:5];
    vws.text = [NSString stringWithFormat:@"Views: %@",[currentPuzzle objectForKey:@"Views"]];
    
    UILabel *diff = (UILabel *)[cell viewWithTag:6];
    int difVal = [(NSNumber*)[currentPuzzle objectForKey:@"Difficulty"] intValue];
    diff.text = [NSString stringWithFormat:@"Point Value: %d", difVal];
    
    //img
    PFImageView *pfimg = (PFImageView *)[cell viewWithTag:2];
    pfimg = (PFImageView *)[cell viewWithTag:2];//[[PFImageView alloc] init];
    pfimg.file = (PFFile *)[currentPuzzle objectForKey:@"Image"];
    
    
    [pfimg loadInBackground];

    //set image
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"getDetails"]) {
        
        PuzzleDetailsViewController *pdvc = (PuzzleDetailsViewController *)segue.destinationViewController;
        pdvc.puzzle = _selectedPuzzle;
        
        //see if the user has viewed this already
        NSArray *viewerArray = (NSArray *) [_selectedPuzzle objectForKey:@"UsersViews"];
        //if so, go ahead and increment views. Then add user to viewed List
        if (![viewerArray containsObject:[PFUser currentUser].username]) {
            NSNumber *prev = [_selectedPuzzle objectForKey:@"Views"];
            NSNumber *newz = [NSNumber numberWithInt:1 + [prev intValue]];
            [_selectedPuzzle setObject:newz forKey:@"Views"];
            [_selectedPuzzle saveInBackground];
            
            NSNumber *prevD = [_selectedPuzzle objectForKey:@"Difficulty"];
            NSNumber *newD = [NSNumber numberWithInt:1 + [prevD intValue]];
            [_selectedPuzzle setObject:newD forKey:@"Difficulty"];
            
            [_selectedPuzzle addObject:[PFUser currentUser].username forKey:@"UsersViews"];
            [_selectedPuzzle saveInBackground];
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
