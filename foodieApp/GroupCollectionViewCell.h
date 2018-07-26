//
//  GroupCollectionViewCell.h
//  foodieApp
//
//  Created by Prasad on 17/01/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"


@interface GroupCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *restaurantTitle;
@property (strong, nonatomic) IBOutlet UILabel *restaurantType;
@property (strong, nonatomic) IBOutlet UILabel *areaOfRestaurant;
@property (strong, nonatomic) IBOutlet UIImageView *restaurantImgView;
@property (strong, nonatomic) IBOutlet UIButton *AddtoPreferdBtn;

@property (strong, nonatomic) IBOutlet UILabel *distanceLbl;

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UIView *backView;

@end
