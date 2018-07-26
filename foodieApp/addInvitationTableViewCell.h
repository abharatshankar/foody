//
//  addInvitationTableViewCell.h
//  foodieApp
//
//  Created by ashwin challa on 12/13/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addInvitationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *profileImg;
@property (strong, nonatomic) IBOutlet UIImageView *checkBoxImg;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLbl;
@property (strong, nonatomic) IBOutlet UILabel *workPhoneNumLbl;
@property (strong, nonatomic) IBOutlet UILabel *mobilePhoneLbl;


@property (weak, nonatomic) IBOutlet UIView *cellView;

@end
