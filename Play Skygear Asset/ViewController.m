//
//  ViewController.m
//  Play Skygear Asset
//
//  Created by Ben Lei on 20/6/2016.
//  Copyright © 2016 Oursky. All rights reserved.
//

#import "ViewController.h"

#import <Skykit/Skykit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *signupUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *signupPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTextField;

@property (weak, nonatomic) SKYContainer *skygear;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.skygear = [SKYContainer defaultContainer];
}

- (IBAction)signupButtonDidTap:(UIButton *)btn {
    NSString *username = self.signupUsernameTextField.text;
    NSString *password = self.signupPasswordTextField.text;

    __weak typeof(self) wself = self;
    [self.skygear signupWithUsername:username
                            password:password
                   completionHandler:^(SKYUser *user, NSError *error) {
                       if (error) {
                           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Signup fails"
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
                           NSLog(@"Signup error %@", error);
                       } else {
                           [wself showImagePickerView];
                       }
                   }];
}

- (IBAction)loginButtonDidTap:(UIButton *)btn {
    NSString *username = self.loginUsernameTextField.text;
    NSString *password = self.loginPasswordTextField.text;

    __weak typeof(self) wself = self;
    [self.skygear loginWithUsername:username
                           password:password
                  completionHandler:^(SKYUser *user, NSError *error) {
                      if (error) {
                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login fails"
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
                          [wself showImagePickerView];
                      }
                  }];
}

- (void) showImagePickerView {
    [self performSegueWithIdentifier:@"ShowUploadAssetView" sender:self];
}

@end
