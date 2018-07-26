//
//  profileViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/11/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface profileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menu;
@property (strong, nonatomic) IBOutlet UIButton *editProfileBut;
@property (strong, nonatomic) IBOutlet UIButton *logOutBut;
@property (strong, nonatomic) IBOutlet UIButton *callUsBut;
@property (strong, nonatomic) IBOutlet UIButton *rateUsBut;

- (IBAction)editProfileBtn:(id)sender;
- (IBAction)logoutBtn:(id)sender;
- (IBAction)callusBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *callView;
- (IBAction)cancelViewBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *placeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@end
