//
//  loginViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/8/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface loginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *fbLogin;
@property (strong, nonatomic) IBOutlet UIButton *gmailLogin;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end
