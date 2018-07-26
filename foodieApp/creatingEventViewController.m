//
//  creatingEventViewController.m
//  foodieApp
//
//  Created by Bharat shankar on 1/31/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "creatingEventViewController.h"
#import "MyTableViewController.h"
#import "SingleTon.h"
#import "PlaceAnnotation.h"
#import "setDateAndTimeController.h"
#import "GuestSettingsViewController.h"
#import "descriptionViewController.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "Constants.h"
#import <MapKit/MapKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "EventReadyPageController.h"
#import "UIView+DCAnimationKit.h"
#import "SWRevealViewController.h"


@interface creatingEventViewController ()<SWRevealViewControllerDelegate>
{
   SingleTon *  singleTonInstance;
    NSDictionary *requestDict,*imageDataDict;

    NSString * inviteString , *votesString, *preferencesString;
    BOOL *sidebarMenuOpen;



}
@end

@implementation creatingEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.revealViewController.delegate = self;
    self.title  = @"Set Details";
    
    SWRevealViewController*sw=[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    
    self.menu.target=sw.revealViewController;
    
    [sw panGestureRecognizer];
    [sw tapGestureRecognizer];
    
    sidebarMenuOpen = NO;
    
    
    
    _menu.action=@selector(revealToggle:);
    
    [self.menu setImage:[UIImage imageNamed:@"toogle_menu_icon.png"]];
    
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    [self.view addGestureRecognizer:sw.tapGestureRecognizer];
    
   // singleTonInstance.mapItemsForcreateEventPage = [[NSMutableArray alloc]init];
    
    self.eventNameText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.eventNameText.layer.borderWidth = 0.5;
    
    self.eventNameText.delegate = self;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    self.navigationController.navigationBar.barTintColor = REDCOLOR;
    
    self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+90);
    
    
    
    self.setting1View.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.setting1View.layer.borderWidth = 0.5;
    self.setting2view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.setting2view.layer.borderWidth = 0.5;
    self.setting3view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.setting3view.layer.borderWidth = 0.5;
    
    
    
    
    
   NSLog(@"to make dix name %@ \n mobile num %@ \n userId %@",[Utilities getName],[Utilities getPhoneno],[Utilities getUserID]) ;
   

   
    
    
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    
    
    //////////////////
    
    
    
   
    
    //--right buttons--//
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(0, 0, 30, 22);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    //btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[btntitle setTitle:@"Nearby Bars" forState:UIControlStateNormal];
    [btntitle setImage:[UIImage imageNamed:@"toogle_menu_icon.png"] forState:UIControlStateNormal];
    
    [btntitle addTarget:sw.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    
    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    NSLayoutConstraint * widthConstraint = [btntitle.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[btntitle.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
//    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
//    btntitle.frame = CGRectMake(30, 0, 120, 30);
//    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    btntitle.showsTouchWhenHighlighted=YES;
//    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
//    [arrLeftBarItems addObject:barButtonItem3];
//    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [btntitle setTitle:@"Set Details" forState:UIControlStateNormal];
//    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
    
    //for right bar buttons
//    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    menuButton.frame = CGRectMake(275, 5, 28, 25);
//    [menuButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    menuButton.showsTouchWhenHighlighted=YES;
//    
//    
//    //--right buttons--//
//    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
//    btntitle.frame = CGRectMake(30, 0, 120, 30);
//    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    btntitle.showsTouchWhenHighlighted=YES;
//    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
//    [arrLeftBarItems addObject:barButtonItem3];
//    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [btntitle setTitle:@"Notifications" forState:UIControlStateNormal];
//    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // [btnh addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    singleTonInstance.startDateStr = nil;
    singleTonInstance.showTimeStr = nil;
   // [singleTonInstance.mapItemsForcreateEventPage removeAllObjects];
    singleTonInstance.descriptionStr = nil;
    
    singleTonInstance.eventImgData = [[NSData alloc]init];
    
     imageDataDict = [[NSMutableDictionary alloc] init];
    
    self.timeView.hidden = YES;
    self.view2MapView.hidden = YES;
    self.view3textView.hidden = YES;
    
//    self.view1.layer.borderWidth = 0.5;
//    self.view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
//
//    self.view2.layer.borderWidth = 0.5;
//    self.view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
//
//    self.view3.layer.borderWidth = 0.5;
//    self.view3.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.view1.backgroundColor = [UIColor colorWithRed:1.00 green:0.97 blue:0.97 alpha:1.0];
    self.view2.backgroundColor = [UIColor colorWithRed:1.00 green:0.97 blue:0.97 alpha:1.0];
    self.view3.backgroundColor = [UIColor colorWithRed:1.00 green:0.97 blue:0.97 alpha:1.0];
    

   
    
     self.view2.frame = CGRectMake(self.view2.frame.origin.x, self.view1.frame.origin.y+self.view1.frame.size.height+3, self.view2.frame.size.width, self.view2.frame.size.height);
    
    self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view2.frame.origin.y+self.view2.frame.size.height+3, self.view3.frame.size.width, self.view3.frame.size.height);
    
    
//    self.guestSettings.frame = CGRectMake(self.guestSettings.frame.origin.x, self.view3.frame.size.height+self.view3.frame.origin.y, self.guestSettings.frame.size.width, self.guestSettings.frame.size.height);
//
//    [self.createEventScroll addSubview:self.guestSettings];
    
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Create"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(nextButton)];
    [nextButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                          forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    NSLog(@"date and time \n %@ \n %@",singleTonInstance.startDateStr,singleTonInstance.showTimeStr) ;
    
    // Do any additional setup after loading the view.
    NSDateFormatter *monthFormat = [[NSDateFormatter alloc] init];
    [monthFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *month = [monthFormat dateFromString:singleTonInstance.startDateStr];
    [monthFormat setDateFormat:@"MMMM"];
    NSString* temp = [monthFormat stringFromDate:month];
    self.startDateMonth.text = temp;
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *date = [dateFormat dateFromString:singleTonInstance.startDateStr];
    [dateFormat setDateFormat:@"dd"];
    NSString* dateTemp = [dateFormat stringFromDate:date];
    self.startDate.text = dateTemp;
    self.startTime.hidden = NO;
   
    
   
    
    
    
    NSDateFormatter *endMonthFormat = [[NSDateFormatter alloc] init];
    [endMonthFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *endmonth = [endMonthFormat dateFromString:singleTonInstance.endDateStr];
    [endMonthFormat setDateFormat:@"MMMM"];
    NSString* endtemp = [monthFormat stringFromDate:endmonth];
    _endDateMonth.text = endtemp;
    
    
    NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
    [endDateFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *endDate = [endDateFormat dateFromString:singleTonInstance.endDateStr];
    [endDateFormat setDateFormat:@"dd"];
    NSString* endDateTemp = [endDateFormat stringFromDate:endDate];
    _endDate.text = endDateTemp;
    
    

    
    }

-(void)nextButton
{
        GuestSettingsViewController * firstview =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GuestSettingsViewController"];
    
    
    singleTonInstance.eventNameSt = self.eventNameText.text ;
    
    
    
    if (self.eventNameText.text.length<1) {
       // [Utilities displayCustemAlertViewWithOutImage:@"Please enter event name" :self.view];
        
        [self.eventNameText tada:nil];
        
        self.eventNameText.layer.borderColor= REDCOLOR.CGColor ;
        
        self.eventNameText.layer.borderWidth = 2;
        
        
    }
    else
       //[self.navigationController pushViewController:firstview animated:YES];
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // [ activityIndicatorView stopAnimating];
            
            [self createEventServiceCall];
            
            
        });
        
    }
    
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{

    // this is to close side menu if already opened when navigation to another tab bar
    if (self.revealViewController.frontViewPosition == FrontViewPositionRight) {
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide];
    }
    
    self.tabBarController.tabBar.hidden = NO;
    
    if (singleTonInstance.mapItemsForcreateEventPage.count)
    {
        self.view2MapView.hidden = NO;
        
        self.view2MapView.frame = CGRectMake(self.view2MapView.frame.origin.x, self.view2.frame.origin.y+self.view2.frame.size.height, self.view2MapView.frame.size.width, self.view2MapView.frame.size.height);
        
        self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view2MapView.frame.origin.y+self.view2MapView.frame.size.height, self.view2MapView.frame.size.width, self.view3.frame.size.height);
        
        if (singleTonInstance.descriptionStr.length>0) {
            
        }
        
        [self.mapView setDelegate:self];
        
        MKMapItem *mapItem = [singleTonInstance.mapItemsForcreateEventPage objectAtIndex:0];
        
        if (singleTonInstance.areaNameForCreateEvent) {
            self.areaName.text = singleTonInstance.areaNameForCreateEvent;
            
            if (self.timeSwitch.isOn == YES && self.mapSwitch.isOn == YES && self.textSwitch.isOn == NO) {
                self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+800);
            }
            else if (self.timeSwitch.isOn == NO && self.mapSwitch.isOn == YES && self.textSwitch.isOn == NO)
            {
                self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+600);
            }
            
        }
        
        
        // Add the single annotation to our map.
        PlaceAnnotation * annotation = [[PlaceAnnotation alloc] init];
        annotation.coordinate = mapItem.placemark.location.coordinate;
        annotation.title = mapItem.name;
        annotation.url = mapItem.url;
        
        
        ////////////////////
        ////////////////////
        // to set zoom level of mkmap 
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
         [self.mapView setRegion:adjustedRegion animated:YES];
        ////////////////////
        ////////////////////
        
        [self.mapSwitch setOn:YES animated:YES];
        
        [self.mapView addAnnotation:annotation];
        
        // We have only one annotation, select it's callout.
        [self.mapView selectAnnotation:[self.mapView.annotations objectAtIndex:0] animated:YES];
        
    }
    else
    {
        [self.mapSwitch setOn:NO animated:YES];
        //self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+10);

    }
    
    if (singleTonInstance.startDateStr)
    {
        self.timeView.hidden  = NO;
        
        self.timeView.frame = CGRectMake(self.timeView.frame.origin.x, self.view1.frame.origin.y+self.view1.frame.size.height, self.view1.frame.size.width, self.view1.frame.size.height);
        
        self.view2.frame = CGRectMake(self.view2.frame.origin.x, self.timeView.frame.origin.y+self.timeView.frame.size.height, self.view2.frame.size.width, self.view2.frame.size.height);
        
        if (singleTonInstance.mapItemsForcreateEventPage.count) {
            self.view2MapView.hidden = NO;
            self.view2MapView.frame = CGRectMake(self.view2MapView.frame.origin.x, self.view2.frame.origin.y+self.view2.frame.size.height, self.view2MapView.frame.size.width, self.view2MapView.frame.size.height);
            
            self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view2MapView.frame.origin.y+self.view2MapView.frame.size.height, self.view3.frame.size.width,  self.view3.frame.size.height);
            
            
        }
        else
        {
        self.view2MapView.hidden = YES;
            self.view3.frame = CGRectMake( self.view3.frame.origin.x , self.view2.frame.origin.y+self.view2.frame.size.height , self.view3.frame.size.width,  self.view3.frame.size.height );
        }
        
        
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *date1 = [dateFormat1 dateFromString:singleTonInstance.startDateStr];
        [dateFormat1 setDateFormat:@"dd"];
        NSString* temp1 = [dateFormat1 stringFromDate:date1];
        NSLog(@"Day is %@",temp1);
        self.startDate.text = temp1;
        
        self.startDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.startDate.layer.borderWidth = 0.5;
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *date = [dateFormat dateFromString:singleTonInstance.startDateStr];
        [dateFormat setDateFormat:@"MMMM"];
        NSString* temp = [dateFormat stringFromDate:date];
        NSLog(@"month is %@",temp);
        self.startDateMonth.text = temp;
        self.startDate.hidden = NO;
        self.startDateMonth.hidden = NO;
        
         self.startTime.text = [Utilities null_ValidationString:singleTonInstance.showTimeStr] ;
    }
    else
    {
        self.startDate.hidden = YES;
        self.startDateMonth.hidden = YES;
    }
    
    
    
    
    
    
    
    if (singleTonInstance.endDateStr)
    {
        ////////////////////////
        // bring month name from date (yyyy/MM/dd ) And day number
        NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
        [endDateFormat setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *date = [endDateFormat dateFromString:singleTonInstance.endDateStr];
        [endDateFormat setDateFormat:@"MMMM"];
        NSString* endTemp = [endDateFormat stringFromDate:date];
        NSLog(@"month is %@",endTemp);
        
        self.endDateMonth.text = endTemp;
        
        
        NSDateFormatter *endDateFormat1 = [[NSDateFormatter alloc] init];
        [endDateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *endDate1 = [endDateFormat1 dateFromString:singleTonInstance.endDateStr];
        [endDateFormat1 setDateFormat:@"dd"];
        NSString* endTemp1 = [endDateFormat1 stringFromDate:endDate1];
        
        self.endDate.text = endTemp1;
        
        self.endDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.endDate.layer.borderWidth = 0.5;
        self.endDate.hidden = NO;
        self.endDateMonth.hidden = NO;
        self.endTime.text = [Utilities null_ValidationString:singleTonInstance.endTimeStr];
    }
    else
    {
        self.endDate.hidden = YES;
        self.endDateMonth.hidden = YES;
        
    }
    
    
    
    
    if (!singleTonInstance.endDateStr && !singleTonInstance.startDateStr)
    {
        self.endDate.hidden = YES;
        self.endDateMonth.hidden = YES;
        self.startDate.hidden = YES;
        self.startDateMonth.hidden = YES;
        [self.timeSwitch setOn:NO animated:YES];
    }
    
    
    if (singleTonInstance.descriptionStr.length)
    {
        self.view3textView.hidden = NO;
        
        self.descriptionTextLbl.text = singleTonInstance.descriptionStr;
        
        
       // [self.descriptionTextLbl sizeToFit];
        
        
        
         self.descriptionTextLbl.frame = CGRectMake(self.descriptionTextLbl.frame.origin.x, 12, self.view3.frame.size.width, [self getHeightForLabels:self.descriptionTextLbl]);
        
        
        
    CGSize widthOfLbl = CGSizeMake(self.descriptionTextLbl.frame.size.width, self.descriptionTextLbl.frame.size.height);
        
        if (widthOfLbl.height == 2.5)
        {
            self.descriptionTextLbl.frame = CGRectMake(self.descriptionTextLbl.frame.origin.x, 12, self.view3.frame.size.width, self.descriptionTextLbl.frame.size.height+12);
        }
        
        NSLog(@"height of view %f",[self getHeightForText:singleTonInstance.descriptionStr withFont:[UIFont systemFontOfSize:13] andWidth:self.descriptionTextLbl.frame.size.width]);
        
        self.view3textView.frame = CGRectMake(self.view3.frame.origin.x, self.view3.frame.origin.y+self.view3.frame.size.height+5, self.view3textView.frame.size.width,  [self getHeightForText:singleTonInstance.descriptionStr withFont:[UIFont systemFontOfSize:13] andWidth:self.descriptionTextLbl.frame.size.width]/*self.descriptionTextLbl.frame.size.height+10*/);
        
        
        [self.view3textView addSubview:self.descriptionTextLbl];
        
         [self.descriptionTextLbl sizeToFit];
        
        
        
        self.view3textView.frame = CGRectMake(self.view3.frame.origin.x, self.view3.frame.origin.y+self.view3.frame.size.height, self.view3textView.frame.size.width,  [self getHeightForText:singleTonInstance.descriptionStr withFont:[UIFont systemFontOfSize:13] andWidth:self.descriptionTextLbl.frame.size.width]+20/*self.descriptionTextLbl.frame.size.height+10*/);
        
        self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+self.view3textView.frame.size.height+20);
        
        
       // self.guestSettings.frame = CGRectMake(self.guestSettings.frame.origin.x, self.descriptionTextLbl.frame.size.height+20+self.view3textView.frame.origin.y, self.guestSettings.frame.size.width, self.guestSettings.frame.size.height);
        
        self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+self.view3textView.frame.origin.y+self.view3textView.frame.size.height+20);

        
        if (self.timeSwitch.isOn == YES && self.mapSwitch.isOn == YES && self.textSwitch.isOn == YES) {
            
            self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+self.view3textView.frame.origin.y+self.view3textView.frame.size.height+200);
        }
        else if (self.timeSwitch.isOn == NO && self.mapSwitch.isOn == YES)
        {
            self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+self.view3textView.frame.origin.y+self.view3textView.frame.size.height+200);//CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+self.view3textView.frame.size.height+20);
        }
        
       // self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.guestSettings.frame.size.height+self.view.frame.size.height+self.descriptionTextLbl.frame.size.height+self.guestSettings.frame.origin.y);
        
    }
    else
    {
    self.view3textView.hidden = YES;
        [self.textSwitch setOn:NO animated:YES];
        
        
     //   self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,/*self.descriptionTextLbl.frame.size.height*/ self.view.frame.size.height+90);
        
    }
    
    
    if (self.timeSwitch.isOn == NO && self.view2MapView.hidden == YES && self.textSwitch.isOn == NO) {
        self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    }
    
    
}


-(CGFloat) getHeightForLabels : (UILabel *) label
{
    
    CGSize widthMaxHeight = CGSizeMake(label.frame.size.width, 100);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingRect = [label.text boundingRectWithSize:widthMaxHeight
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:label.font}
                                                   context:context].size;
    
    size = CGSizeMake(ceil(boundingRect.width), ceil(boundingRect.height));
    
    return size.height;
}

-(float) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    float totalHeight;
    
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    } else {
        title_size = [text sizeWithFont:font
                      constrainedToSize:constraint
                          lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight = title_size.height ;
    }
    
    CGFloat height = MAX(totalHeight, 40.0f);
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)timeSwitchAct:(id)sender
{
    if(self.timeSwitch.isOn){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        setDateAndTimeController *dateAndTime = [storyboard instantiateViewControllerWithIdentifier:@"setDateAndTimeController"];
        [self.navigationController pushViewController:dateAndTime animated:YES];

        
//        self.timeView.hidden = NO;
//        self.timeView.frame = CGRectMake(self.timeView.frame.origin.x, self.timeView.frame.origin.y, self.timeView.frame.size.width, self.timeView.frame.size.height);
//        self.view2.frame = CGRectMake(self.view2.frame.origin.x, self.timeView.frame.origin.y+self.timeView.frame.size.height, self.view2.frame.size.width, self.view2.frame.size.height);
//        self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view2.frame.origin.y+self.view2.frame.size.height+2, self.view3.frame.size.width, self.view3.frame.size.height);
        
        
    }else{
        
        singleTonInstance.startDateStr = nil;
        singleTonInstance.endDateStr = nil;
        
        self.timeView.hidden = YES;
        self.view2.frame = CGRectMake(self.view2.frame.origin.x, self.view1.frame.origin.y+self.view1.frame.size.height+3, self.view2.frame.size.width, self.view2.frame.size.height);
        if(singleTonInstance.mapItemsForcreateEventPage.count)
        {
            self.view2MapView.hidden = NO;
            self.view2MapView.frame = CGRectMake(self.view2MapView.frame.origin.x , self.view2.frame.origin.y + self.view2.frame.size.height , self.view2.frame.size.width, self.view2MapView.frame.size.height);
            self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view2MapView.frame.origin.y+self.view2MapView.frame.size.height, self.view2MapView.frame.size.width, self.view3.frame.size.height);
        }
        else
        self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view2.frame.origin.y+self.view2.frame.size.height+2, self.view3.frame.size.width, self.view3.frame.size.height);
    }
}


- (IBAction)mapSwitch:(id)sender {
    if (self.mapSwitch.isOn) {
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyTableViewController *searchLocation = [storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController"];
        searchLocation.isFromCreatingEvent = YES;
        [self.navigationController pushViewController:searchLocation animated:YES];
        
       // self.view2MapView.hidden = NO;
        
//        if (self.timeSwitch.isOn == YES)
//        {
        
            
//            self.view2.frame = CGRectMake(self.view2.frame.origin.x, self.timeView.frame.origin.y+self.timeView.frame.size.height, self.view2.frame.size.width, self.view2.frame.size.height);
//            
//            self.view2MapView.frame = CGRectMake(self.view2MapView.frame.origin.x, self.view2.frame.size.height+self.view2.frame.origin.y, self.view2MapView.frame.size.width, self.view2MapView.frame.size.height);
//            self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view2MapView.frame.size.height+self.view2MapView.frame.origin.y, self.view3.frame.size.width, self.view3.frame.size.height);
            
//        }
//        else
//        {
        
//            self.view2.frame = CGRectMake(self.view2.frame.origin.x, self.view1.frame.origin.y+self.view1.frame.size.height+3, self.view2.frame.size.width, self.view2.frame.size.height);
//            
//             self.view2MapView.frame = CGRectMake(self.view2MapView.frame.origin.x, self.view2.frame.size.height+self.view2.frame.origin.y, self.view2MapView.frame.size.width, self.view2MapView.frame.size.height);
//            self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view2MapView.frame.size.height+self.view2MapView.frame.origin.y, self.view3.frame.size.width, self.view3.frame.size.height);
    //    }
        
        
    }
    else
    {
//        if (singleTonInstance.mapItemsForcreateEventPage.count >0 || ![singleTonInstance.mapItemsForcreateEventPage isKindOfClass:[NSNull  class]]) {
//            singleTonInstance.mapItemsForcreateEventPage ;
//        }
        
       // [singleTonInstance.mapItemsForcreateEventPage removeAllObjects];
        
        self.view2MapView.hidden = YES;
        
        self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view2.frame.size.height+self.view2.frame.origin.y+2, self.view3.frame.size.width, self.view3.frame.size.height);
        self.view3textView.frame = CGRectMake(self.view3textView.frame.origin.x, self.view3.frame.origin.y+self.view3.frame.size.height, self.view3textView.frame.size.width, self.view3textView.frame.size.height);
        
//        if (singleTonInstance.descriptionStr.length)
//        {
//            self.guestSettings.frame = CGRectMake(self.guestSettings.frame.origin.x, self.descriptionTextLbl.frame.origin.y+self.descriptionTextLbl.frame.size.height+2, self.guestSettings.frame.size.width, self.guestSettings.frame.size.height);
//        }
//        else
//        {
//
//            self.guestSettings.frame = CGRectMake(self.guestSettings.frame.origin.x, self.view3.frame.origin.y+self.view3.frame.size.height+2, self.guestSettings.frame.size.width, self.guestSettings.frame.size.height);
//        }
        
    }
}
- (IBAction)textSwitch:(id)sender {
    if (self.textSwitch.isOn) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        descriptionViewController *addDescription = [storyboard instantiateViewControllerWithIdentifier:@"descriptionViewController"];
        //self.descriptionTextLbl.hidden = NO;
        [self.navigationController pushViewController:addDescription animated:YES];
    }
    else
    {
        singleTonInstance.descriptionStr = nil;
        self.view3textView.hidden = YES;
        self.guestSettings.frame = CGRectMake(self.guestSettings.frame.origin.x, self.view3.frame.origin.y+self.view3.frame.size.height+2, self.guestSettings.frame.size.width, self.guestSettings.frame.size.height);
        
         self.createEventScroll.contentSize = CGSizeMake(self.view.frame.size.width,/*self.descriptionTextLbl.frame.size.height*/ self.guestSettings.frame.origin.y+self.guestSettings.frame.size.height+self.view.frame.size.height);
    }
}




- (IBAction)inviteFrndsSwitch:(id)sender {
    if (self.inviteSwitch.isOn)
    {
        inviteString = @"1";
    }
    else
    {
        inviteString = @"0";
    }
    
}
- (IBAction)votesSwitch:(id)sender {
    if (self.voteSwitch.isOn)
    {
        votesString = @"1";
    }
    else
    {
        votesString = @"0";
    }
}
- (IBAction)preferencesSwitch:(id)sender {
    
    if (self.preferenceSwitch.isOn)
    {
        preferencesString = @"1";
    }
    else
    {
        preferencesString = @"0";
    }
}






//helper method for color hex values
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

//helper method for color hex values
- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}



-(NSData *)returnCompressedImageData :(UIImage *)image
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    // int maxFileSize = 320*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while (compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}


- (IBAction)changeImage:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Add Photo!" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // take photo button tapped.
        
        [self takePhoto];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose photo from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // choose photo button tapped.
        [self choosePhoto];
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
}





/////////////// TAKING PHOTO FROM CAMERA ////////////////////

-(void)takePhoto{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        
    }
    else
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
    
}

////////////////// CHOOSE PHOTO FROM GALLERY//////////////

-(void)choosePhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
/////////// FUNCTION FOR PICK IMAGE /////////////////

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    //  singleTonInstance.profilePicData = UIImagePNGRepresentation(chosenImage);
    
    
    
    self.eventImage.image = chosenImage;

    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.9);
    
    singleTonInstance.eventImgData = imageData;
    
    
    //    UIGraphicsBeginImageContextWithOptions(self.profileImageView.bounds.size, NO, 1.0);
    //    // Add a clip before drawing anything, in the shape of an rounded rect
    //    [[UIBezierPath bezierPathWithRoundedRect:self.profileImageView.bounds
    //                                cornerRadius:50.0] addClip];
    //    // Draw your image
    //    [chosenImage drawInRect:self.profileImageView.bounds];
    //
    //    // Get the image, here setting the UIImageView image
    //    self.profileImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //    self.profileImageView.backgroundColor = [UIColor darkGrayColor];
    //
    //    // Lets forget about that we were drawing
    //    UIGraphicsEndImageContext();
    
    
    
    [self updateCoverPic];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}





-(void)updateCoverPic

{
    
    @try {
        
        NSString *hexStr3 = @"#ca1d31";
        
        UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:.9];
        
//        activityIndicatorView  = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallPulse tintColor:color1];
//        
//        
//        activityIndicatorView.frame = self.view.frame ;
//        [self.view addSubview:activityIndicatorView];
//        [activityIndicatorView startAnimating];
        [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        
        requestDict = @{
                        
                        @"user_id":[Utilities getUserID], /*totalBubblesArray*/
                        };
        [imageDataDict setValue:[self returnCompressedImageData:self.eventImage.image] forKey:@"image"];
        [imageDataDict setValue:[Utilities getUserID] forKey:@"user_id"];
        NSString  *urlStr = [NSString stringWithFormat:@"%@eventImage",BASEURL];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *fileName1 = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // BASIC AUTH (if you need):
            manager.securityPolicy.allowInvalidCertificates = YES;
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"foo" password:@"bar"];
            
            [manager POST:urlStr parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if ([imageDataDict valueForKey:@"image"]!= nil) {
                    [formData appendPartWithFileData:[imageDataDict valueForKey:@"image"] name:@"image" fileName:fileName1 mimeType:@"image/jpeg"];
                }
                //                if ([imageDataDict valueForKey:@"cover_photo"]!= nil) {
                //                    [formData appendPartWithFileData:[imageDataDict valueForKey:@"cover_photo"] name:@"cover_photo" fileName:fileName1 mimeType:@"image/jpeg"];
                //                }
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //[ activityIndicatorView stopAnimating];
                [Utilities removeLoading:self.view];
               
                
                NSDictionary *response = (NSDictionary *)responseObject;
                NSUInteger status = [[response valueForKey:@"status"] integerValue];
                NSString *resultMessage = [response valueForKey:@"result"];
                
                singleTonInstance.eventUploadedImageName = [response valueForKey:@"image"];
                //                if(status == 30 )
                //                {
                //                    [APPDELEGATE showAlertBlockOrAuthenticationCheck:resultMessage];
                //                }
                //
                //                else if(status == 32)
                //                {
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                //                        [APPDELEGATE showAlertBlockOrAuthenticationCheck:resultMessage];
                //
                //                    });
                //                    return;
                //                }
                
                if ([[response valueForKey:@"status"] integerValue] == 1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[ activityIndicatorView stopAnimating];
                         [Utilities removeLoading:self.navigationController.view];
                        NSString *billIdStrVAl = [response valueForKey:@"billuploadid"];
                        //@"sucessssssss.....");
                        
                        [Utilities displayToastWithMessage:@"Image added successfully"];
                        
                        
                        
                        
                    });
                    
                    
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[ activityIndicatorView stopAnimating];
                        [Utilities removeLoading:self.navigationController.view];
                    });
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[ activityIndicatorView stopAnimating];
                         [Utilities removeLoading:self.view];
                        
                        NSLog(@"alert from here");
//                        CustomAlertView *alert = [[CustomAlertView alloc]initWithAlertType:ImageWithSingleButtonType andMessage:[response valueForKey:@"result"] andImageName:AlertVpanicImage andCancelTitle:nil andOtherTitle:@"OK" andDisplayOn:self.view];
//                        alert.delegate =self;
//                        [self.view addSubview:alert];
                                                [Utilities displayCustemAlertView:[response valueForKey:@"result"] :self.view];
                        //[self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 //@"Failure.....");
                 //@"Failure %@, %@", error, operation.responseString);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[ activityIndicatorView stopAnimating];
                     [Utilities removeLoading:self.navigationController.view];
                     
                 });
                 
                 
             }];
            
        });
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
    }
    
}





//////////////////// DISMISS AFTER PICKING IMAGE ////////////////

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}











- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    if (self.eventNameText.text.length>0) {
        self.eventNameText.backgroundColor = CLEARCOLOR;
        
        
        self.eventNameText.layer.borderColor = CLEARCOLOR.CGColor ;
        
        self.eventNameText.layer.borderWidth = 0.1;
    }
    else
    {
       
        self.eventNameText.layer.borderColor= REDCOLOR.CGColor ;
        
        self.eventNameText.layer.borderWidth = 2;
    }
}







# pragma mark - Webservice Delegates

-(void)createEventServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *hexStr3 = @"#6dbdba";
            UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:.9];
            
            //            activityIndicatorView  = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallPulse tintColor:color1];
            //
            //
            //            activityIndicatorView.frame = self.view.frame ;
            //            [self.view addSubview:activityIndicatorView];
            //            [activityIndicatorView startAnimating];
            //[Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        //as samata asked to send our id to server we are creating format
        
        NSMutableDictionary * mobileDic = [[NSMutableDictionary alloc]init];
        NSMutableDictionary* myDict = [[NSMutableDictionary alloc]init];
        
        [mobileDic setValue:[Utilities getPhoneno] forKey:@"mobile"];
        
        [myDict setObject:[Utilities getName] forKey:@"name"];
        [myDict setObject:[Utilities getUserID] forKey:@"user_id"];
        [myDict setObject:[Utilities getMobileno] forKey:@"mobilenumber"];
        singleTonInstance.contactsSendArray = [[NSMutableArray alloc]init];
        
        [singleTonInstance.contactsSendArray  addObject:myDict];
        
        NSLog(@"array of sending is %@",singleTonInstance.contactsSendArray);
        
        NSMutableArray * myDetailsArr = [[NSMutableArray alloc]init];
        
        [myDetailsArr addObject:myDict];
        
        NSError * error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:myDetailsArr options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        
        if (!inviteString.length) {
            inviteString = @"0";
        }
        
        if (!votesString.length) {
            votesString = @"0";
        }
        
        if (!preferencesString.length) {
            preferencesString = @"0";
        }
        
        
        
        NSDictionary * requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@createEvent",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"event_name":[Utilities null_ValidationString:singleTonInstance.eventNameSt],
                        @"event_members":[Utilities null_ValidationString:jsonString],
                        @"start_date":[Utilities null_ValidationString:singleTonInstance.startDateToServer],
                        @"start_time":[Utilities null_ValidationString:singleTonInstance.startTimeToServer],
                        @"end_date":[Utilities null_ValidationString:singleTonInstance.endDateToServer],
                        @"end_time":[Utilities null_ValidationString:singleTonInstance.endTimeToServer],
                        @"description":[Utilities null_ValidationString:singleTonInstance.descriptionStr],
                        @"location":[Utilities null_ValidationString:singleTonInstance.addressToServer],
                        @"image":[Utilities null_ValidationString:singleTonInstance.eventUploadedImageName],
                        @"invite_friends":[Utilities null_ValidationString:inviteString],
                        @"votes":[Utilities null_ValidationString:votesString],
                        @"preferences":[Utilities null_ValidationString:preferencesString]
                        
                        
                        };
        
        
        
        
        NSMutableDictionary * dictToSend = [[NSMutableDictionary alloc]init];
        
        
        [dictToSend setObject:[Utilities getUserID] forKey:@"user_id"];
        
        [dictToSend setObject:[Utilities null_ValidationString:singleTonInstance.eventNameSt] forKey:@"event_name"];
        
        [dictToSend setObject:[Utilities null_ValidationString:inviteString] forKey:@"invite_friends"];
        
        [dictToSend setObject:[Utilities null_ValidationString:votesString] forKey:@"votes"];
        
        [dictToSend setObject:[Utilities null_ValidationString:preferencesString] forKey:@"preferences"];
        
        [dictToSend setObject:[Utilities null_ValidationString:singleTonInstance.eventUploadedImageName] forKey:@"image"];
        
        if (jsonString.length) {
            [dictToSend setObject:jsonString forKey:@"event_members"];
        }
        if (singleTonInstance.startDateToServer.length) {
            
            [dictToSend setObject:singleTonInstance.startDateToServer forKey:@"start_date"];
        }
        if (singleTonInstance.startTimeToServer.length) {
            
            [dictToSend setObject:singleTonInstance.startTimeToServer forKey:@"start_time"];
        }
        if (singleTonInstance.endDateToServer.length) {
            
            [dictToSend setObject:singleTonInstance.endDateToServer forKey:@"end_date"];
        }
        if (singleTonInstance.endTimeToServer.length) {
            
            [dictToSend setObject:singleTonInstance.endTimeToServer forKey:@"end_time"];
        }
        if (singleTonInstance.descriptionStr.length) {
            
            [dictToSend setObject:singleTonInstance.descriptionStr forKey:@"description"];
        }
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:dictToSend];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
    
}


- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
    
    
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        // [ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
        
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    NSLog(@"responseInfo createEvent:%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            EventReadyPageController * guestView =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EventReadyPageController"];
            
            guestView.eventIdStr = [responseInfo valueForKey:@"event_id"];
            
            [self.navigationController pushViewController:guestView animated:YES];
            
        });
        
    }
    
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
        });
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // [ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
    });
    
    
}
























/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
