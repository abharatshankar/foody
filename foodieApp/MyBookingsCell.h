//
//  MyBookingsCell.h
//  foodieApp
//
//  Created by Prasad on 18/12/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBookingsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *RestaurantNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *ConfirmationLbl;
@property (strong, nonatomic) IBOutlet UILabel *Placelbl;
@property (strong, nonatomic) IBOutlet UILabel *RefNmbLbl;
@property (strong, nonatomic) IBOutlet UILabel *DayNDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *TimeLbl;
@property (strong, nonatomic) IBOutlet UIView *lineview;

@property (strong, nonatomic) IBOutlet UILabel *eventNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *numberOfMembersLbl;
@property (strong, nonatomic) IBOutlet UIImageView *eventImgView;

@property (strong, nonatomic) IBOutlet UILabel *startMonthLbl;
@property (strong, nonatomic) IBOutlet UILabel *startDayLbl;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLbl;

@property (strong, nonatomic) IBOutlet UILabel *endMonthLbl;
@property (strong, nonatomic) IBOutlet UILabel *endDayLbl;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *eventStatusLbl;



// /////////////////////////////////////////////////////////////
            //these are for present events
@property (strong, nonatomic) IBOutlet UIImageView *yourEventImg;
@property (strong, nonatomic) IBOutlet UILabel *yourEventNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *yourTotalNums;
@property (strong, nonatomic) IBOutlet UILabel *yourStartMonth;
@property (strong, nonatomic) IBOutlet UILabel *yourStartDate;
@property (strong, nonatomic) IBOutlet UILabel *yourStartTime;
@property (strong, nonatomic) IBOutlet UILabel *yourEndMonth;
@property (strong, nonatomic) IBOutlet UILabel *yourEndDate;
@property (strong, nonatomic) IBOutlet UILabel *yourEndTime;

@property (strong, nonatomic) IBOutlet UILabel *yourEventStatusLbl;

@end
