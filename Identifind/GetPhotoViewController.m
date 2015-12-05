//
//  GetPhotoViewController.m
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/16/15.
//  Copyright © 2015 KALA. All rights reserved.
//

#import "GetPhotoViewController.h"
#import "DetailsAndSubmissionViewController.h"
#import <Parse/Parse.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface GetPhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic)UIImage *image;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@end

@implementation GetPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _continueButton.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takeButtonPressed:(id)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        controller.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        [self presentViewController:controller animated:YES completion:nil];
    }
    
}

- (IBAction)saveButtonHit:(id)sender {
    if (_image != nil) [self performSegueWithIdentifier:@"gotPhoto" sender:self];
}

- (IBAction)chooseButtonPressed:(id)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    _image = image;
    _continueButton.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    if (url == nil) return;
    NSArray<NSURL*> *urls = [NSArray arrayWithObject:url];
    PHFetchResult *fetch = [PHAsset fetchAssetsWithALAssetURLs:urls options:nil];
    PHAsset *asset = fetch.firstObject;
    if (asset.location != nil) {
        _longitude = asset.location.coordinate.longitude;
        _latitude = asset.location.coordinate.latitude;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                   message:@"You did not select an image."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Sorry!"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [alert removeFromParentViewController];
                                                        }];
    [alert addAction:alertAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotPhoto"]) {
        DetailsAndSubmissionViewController *vc = (DetailsAndSubmissionViewController *)segue.destinationViewController;
        vc.image = _image;
        vc.longitude = _longitude;
        vc.latitude = _latitude;
    }
}

- (IBAction)puzzleCreationInitiated:(id)sender {
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
