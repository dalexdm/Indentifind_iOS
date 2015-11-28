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


@end

@implementation PuzzleBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadPuzzles];
    if ([[ParseDataManager sharedManager] isUserLoggedIn]) self.title = [NSString stringWithFormat:@"%@ | %@ Points", [PFUser currentUser].username, [[PFUser currentUser] objectForKey:@"Points"]];
    else self.title = @"No user logged in!";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"%d", [ParseDataManager sharedManager].filterType);
    PFQuery *query = [PFQuery queryWithClassName:@"Puzzle"];
    switch ([ParseDataManager sharedManager].filterType) {
        case 0:
            [query orderByDescending:@"createdAt"];
            break;
        case 1:
            [query orderByDescending:@"Views"];
            break;
        default:
            [query orderByDescending:@"Difficulty"];
            break;
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            self.puzzles = [objects mutableCopy];
            NSLog(@"%@", [self.puzzles[0] objectForKey:@"Title"]);
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
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    
    //UIImageView *img = (UIImageView *)[cell viewWithTag:2];
    PFObject *currentPuzzle = self.puzzles[indexPath.row];
    UILabel *lbl = (UILabel *)[cell viewWithTag:1];
    lbl.text = [currentPuzzle objectForKey:@"Title"];
    
    //img
    PFImageView *pfimg = (PFImageView *)[cell viewWithTag:2];
    pfimg = (PFImageView *)[cell viewWithTag:2];//[[PFImageView alloc] init];
    pfimg.image = [UIImage imageNamed:@""];
    pfimg.file = (PFFile *)[currentPuzzle objectForKey:@"Image"];
    
    
    [pfimg loadInBackground];

    //set image
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", [self.puzzles[0] objectForKey:@"Title"]);
    if ([segue.identifier isEqualToString:@"getDetails"]) {
        PuzzleDetailsViewController *pdvc = (PuzzleDetailsViewController *)segue.destinationViewController;
        //pdvc.puzzle = _selectedPuzzle;
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
