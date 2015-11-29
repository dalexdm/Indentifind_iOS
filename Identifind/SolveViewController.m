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


@interface SolveViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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
