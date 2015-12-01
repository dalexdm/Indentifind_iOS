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

@interface DetailsAndSubmissionViewController () <UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextView *cluesField;

@end

@implementation DetailsAndSubmissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_cluesField setDelegate:self];
    [_titleField setDelegate:self];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    if (_latitude == 0 && _longitude == 0) [self.locationManager startUpdatingLocation];
    
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
    [[ParseDataManager sharedManager] scorePoints:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //deals with undo and paste, may be unnecessary but doesn't seem to mess anything up
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLen = [textField.text length] + [string length] - range.length;
    return newLen <= 25;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else if ([[textView text] length] - range.length + text.length > 140) {
        return NO;
    }
    
    return YES;
}
- (IBAction)submitButtonPressed:(id)sender {
    [self puzzleCreationFinalized:self];
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
