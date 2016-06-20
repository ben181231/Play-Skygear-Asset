//
//  ShowUploadAssetViewController.m
//  Play Skygear Asset
//
//  Created by Ben Lei on 20/6/2016.
//  Copyright © 2016 Oursky. All rights reserved.
//

#import "ShowUploadAssetViewController.h"

#import <SKYKit/SKYKit.h>

@interface ShowUploadAssetViewController () <
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) SKYContainer *skygear;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *image;

@end

@implementation ShowUploadAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.skygear = [SKYContainer defaultContainer];

    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.delegate = self;
}

- (IBAction)closeButtonDidTap:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loadButtonDidTap:(UIButton *)btn {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)uploadButtonDidTap:(UIButton *)btn {
    if (self.image) {
        NSData *data = UIImagePNGRepresentation(self.image);
        SKYAsset *asset = [SKYAsset assetWithName:@"my-image" data:data];

        __weak typeof(self) wself = self;
        [self.skygear uploadAsset:asset completionHandler:^(SKYAsset *asset, NSError *error) {
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload fails"
                                                                               message:error.localizedDescription
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                        }]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself presentViewController:alert animated:YES completion:nil];
                });
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Success"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Done"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                        }]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself presentViewController:alert animated:YES completion:nil];
                });
            }
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if(!image) {
        NSLog(@"No Image Loaded");
        return;
    }

    self.image = image;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView setImage:image];
    });
}

@end
