//
//  EditEventViewController.h
//  foodieApp
//
//  Created by Prasad on 12/03/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LcnManager.h"
#import <MapKit/MapKit.h>

@interface EditEventViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UISwitch *inviteSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *voteSwitch;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UIView *eventOptionsView;

@property NSString * imgUrl;

@property NSMutableDictionary * editEventDict;

@property (strong, nonatomic) IBOutlet UISwitch *paymentSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *previewSwitch;
- (IBAction)PreviewswitchBtn:(id)sender;
- (IBAction)paymentSwitchBtn:(id)sender;
- (IBAction)voteSwitchBtn:(id)sender;
- (IBAction)inviteSwitchBtn:(id)sender;
- (IBAction)DatenTimeBtn:(id)sender;
- (IBAction)LocatnBtn:(id)sender;
- (IBAction)EventDesBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closebtn1;

@property (strong, nonatomic) IBOutlet UIButton *closebtn2;
@property (strong, nonatomic) IBOutlet UIButton *closebtn3;
@property (strong, nonatomic) IBOutlet UIButton *closebtn4;
@property (strong, nonatomic) IBOutlet UIView *datentimeView;
@property (strong, nonatomic) IBOutlet UIView *mapview;
@property (strong, nonatomic) IBOutlet UIView *descrpview;
@property (strong, nonatomic) IBOutlet UIButton *AddLocatn;
@property (strong, nonatomic) IBOutlet UIButton *AddEventDes;
@property (strong, nonatomic) IBOutlet UILabel *eventoptnslbl;
@property (strong, nonatomic) IBOutlet UIButton *dateNtime;
@property (strong, nonatomic) IBOutlet UITextField *eventNameTxtField;
@property (strong, nonatomic) IBOutlet UIView *inviteFrndsViw;
@property (strong, nonatomic) IBOutlet UIView *createVotes;
@property (strong, nonatomic) IBOutlet UIView *eventNameViw;

@property (strong, nonatomic) IBOutlet UILabel *startDateMonth;
@property (strong, nonatomic) IBOutlet UILabel *startDateDay;
@property (strong, nonatomic) IBOutlet UILabel *startDateTime;

@property (strong, nonatomic) IBOutlet UILabel *endDateMonth;
@property (strong, nonatomic) IBOutlet UILabel *endDateDay;
@property (strong, nonatomic) IBOutlet UILabel *endDateTime;

@property (strong, nonatomic) IBOutlet UILabel *locaationNameLbl;


@end
