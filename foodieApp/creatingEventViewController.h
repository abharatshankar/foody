//
//  creatingEventViewController.h
//  foodieApp
//
//  Created by ashwin challa on 1/31/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LcnManager.h"
#import <MapKit/MapKit.h>


@interface creatingEventViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISwitch *timeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *mapSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *textSwitch;

@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2MapView;
@property (strong, nonatomic) IBOutlet UIView *view3textView;

@property (strong, nonatomic) IBOutlet MKMapView * mapView;
@property (strong, nonatomic) IBOutlet UILabel *startDateMonth;
@property (strong, nonatomic) IBOutlet UILabel *startDate;
@property (strong, nonatomic) IBOutlet UILabel *startTime;
@property (strong, nonatomic) IBOutlet UILabel *endDateMonth;
@property (strong, nonatomic) IBOutlet UILabel *endDate;
@property (strong, nonatomic) IBOutlet UILabel *endTime;

@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLbl;
@property (strong, nonatomic) IBOutlet UIImageView *eventImage;

@property (weak, nonatomic) IBOutlet UITextField *eventNameText;
@property (strong, nonatomic) IBOutlet UILabel *areaName;

@property (strong, nonatomic) IBOutlet UIScrollView *createEventScroll;

@property (weak, nonatomic) IBOutlet UIView * guestSettings;
// settings views
@property (strong, nonatomic) IBOutlet UIView *setting1View;
@property (strong, nonatomic) IBOutlet UIView *setting2view;
@property (strong, nonatomic) IBOutlet UIView *setting3view;

@property (strong, nonatomic) IBOutlet UISwitch *inviteSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *voteSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *preferenceSwitch;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menu;




@end
