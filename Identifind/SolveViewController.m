//
//  SolveViewController.m
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/28/15.
//  Copyright © 2015 KALA. All rights reserved.
//

#import "SolveViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ResultsViewController.h"

@interface SolveViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property float distance;
@end

@implementation SolveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILongPressGestureRecognizer *gestureRec = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    gestureRec.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:gestureRec];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRec
{
    if (gestureRec.state == UIGestureRecognizerStateBegan) {
     
        if (_mapView.annotations.count == 1) {
            [_mapView removeAnnotations:_mapView.annotations];
        }
        CGPoint pointTouched = [gestureRec locationInView:self.mapView];
        CLLocationCoordinate2D touchedCoord =
        [self.mapView convertPoint:pointTouched toCoordinateFromView:self.mapView];
    
        MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        pin.coordinate = touchedCoord;
        [self.mapView addAnnotation:pin];
    
    } else {
        return;
    }
}



- (IBAction)submitButtonPressed:(id)sender {
    //first get the coordinates of the puzzle
    double puzzleLatitude = [[_puzzle objectForKey:@"Latitude"] doubleValue];
    double puzzleLongitude = [[_puzzle objectForKey:@"Longitude"] doubleValue];
    //now compare it to the annotation
    CLLocationCoordinate2D guess = _mapView.annotations[0].coordinate;
    double guessLatitude = guess.latitude;
    double guessLongitude = guess.longitude;
    

    double d1 = puzzleLatitude - guessLatitude;
    double d2 = puzzleLongitude - guessLongitude;
    double euDistance = sqrt(pow(d1, 2) + pow(d2, 2));
    self.distance = euDistance;
    if (euDistance <= 0.01) {
        [self performSegueWithIdentifier:@"win" sender:self];
    } else {
        PFUser *current = [PFUser currentUser];
        int points = [(NSNumber*)[current objectForKey:@"Points"] intValue] - 1;
        [current setObject:[NSNumber numberWithInt:points] forKey:@"Points"];
        [current saveInBackground];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                       message:@"You guessed wrong. You lose a point."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        if (points <= 0) [alert setMessage:@"You guessed wrong. Now you're out of points!"];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [alert removeFromParentViewController];
                                                                if (points <= 0) [self.navigationController popToRootViewControllerAnimated:YES];
                                                            }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"win"]) {
        
        //ascertain and update puzzle difficulty
        ResultsViewController *rvc = (ResultsViewController *)segue.destinationViewController;
        rvc.distance = self.distance;
        rvc.points = (int) [(NSNumber*)[self.puzzle objectForKey:@"Difficulty"] integerValue] - 1;
        int new = fmax(3,[(NSNumber*)[self.puzzle objectForKey:@"Difficulty"] intValue] / 2);
        [self.puzzle setObject:[NSNumber numberWithInt:new] forKey:@"Difficulty"];
        [self.puzzle saveInBackground];
        
        //assign points accordingly
        PFUser *current = [PFUser currentUser];
        int points = [(NSNumber*)[current objectForKey:@"Points"] intValue] + rvc.points;
        [current setObject:[NSNumber numberWithInt:points] forKey:@"Points"];
        [current saveInBackground];
        
        [_puzzle addObject:[PFUser currentUser].username forKey:@"UsersSolved"];
        [_puzzle saveInBackground];
    }
                  
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
