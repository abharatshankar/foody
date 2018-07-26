//
//  editProfileViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/13/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UITextField *nameTxtField;
@property (strong, nonatomic) IBOutlet UITextField *emailTxtField;
@property (strong, nonatomic) IBOutlet UITextField *mobileTxtField;



@property NSString * nameStr,
                   *mobileStr,
                   *emailStr;

@property BOOL * isfromSideMenu,*isSideEdit;

@property NSString * imageStrFromSideMenu;


@end
