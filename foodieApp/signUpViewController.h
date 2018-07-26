//
//  signUpViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/8/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *fbBtn;
@property (strong, nonatomic) IBOutlet UIButton *gmailBtn;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UIImageView *pswdIconImage;

@property (strong, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITextField *PasswordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@end
