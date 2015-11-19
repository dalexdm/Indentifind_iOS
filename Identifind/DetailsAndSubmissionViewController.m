//
//  DetailsAndSubmissionViewController.m
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/16/15.
//  Copyright © 2015 KALA. All rights reserved.
//
#import "ParseDataManager.h"
#import "DetailsAndSubmissionViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface DetailsAndSubmissionViewController () <UITextViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextView *cluesField;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;


@end

@implementation DetailsAndSubmissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_cluesField setDelegate:self];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    _latitude = 0.0f;
    _longitude = 0.1f;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)puzzleCreationFinalized:(id)sender {
    //[self.locationManager startUpdatingLocation];
    if (_titleField.text.length == 0 || _cluesField.text.length ==0) return;
    NSData *imageData = UIImageJPEGRepresentation(_image, 0.5f);
    PFFile *file = [PFFile fileWithData:imageData];
    [[ParseDataManager sharedManager] postImage:file fromUser:@"No Users Yet" withTitle:_titleField.text withClues:_cluesField.text withLat:_latitude withLong:_longitude];
    _titleField.text = @"";
    _cluesField.text = @"";
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self puzzleCreationFinalized:self];
        return NO;
    }
    
    return YES;
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
