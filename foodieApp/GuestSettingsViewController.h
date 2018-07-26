//
//  GuestSettingsViewController.h
//  foodieApp
//
//  Created by PossibillionTech on 2/1/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestSettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *eventImage;


@property (strong, nonatomic) IBOutlet UILabel *startMonthLbl;
@property (strong, nonatomic) IBOutlet UILabel *startDayLbl;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLbl;

@property (strong, nonatomic) IBOutlet UILabel *endMonthLbl;
@property (strong, nonatomic) IBOutlet UILabel *endDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLbl;

@property (strong, nonatomic) IBOutlet UIView *inviteFndsViw;

@property (strong, nonatomic) IBOutlet UIView *createVotesViw;
@property (strong, nonatomic) IBOutlet UIView *addPreferencesViw;


@property (strong, nonatomic) IBOutlet UISwitch *inviteSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *voteSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *preferenceSwitch;

@end
