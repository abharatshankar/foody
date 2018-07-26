//
//  EventReadyPageController.m
//  foodieApp
//
//  Created by Bharat shankar on 2/13/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "EventReadyPageController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "SingleTon.h"
#import "eventReadyCollectionCell.h"
#import "homeTabViewController.h"
#import "NSVBarController.h"
#import "myBookingsViewController.h"
#import "GroupCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "KTCenterFlowLayout.h"
#import "PlaceAnnotation.h"
#import "EditEventViewController.h"
#import "EventInviteFrndsViewController.h"
#import "summaryViewController.h"
#import "NSVBarController.h"
#import "UIViewController+ENPopUp.h"
#import "ISMessages.h"
#import "votePopupViewController.h"
#import "voteTableViewCell.h"
#import "UIView+DCAnimationKit.h"
#import "voteTableViewCell.h"
#import "LSFloatingActionMenu.h"
#import "filterViewController.h"
#import "setDateAndTimeController.h"
#import "createNewEventViewController.h"
#import "newCreateEventController.h"
#import "creatingEventViewController.h"
#import "ViewController.h"
#import "imageAndVideoViewController.h"
#import "foodieApp-swift.h"
#import "MyTableViewController.h"
#import "detailRestaurantViewController.h"
#import "menuViewController.h"
#import "RestaurantListViewController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]



@interface EventReadyPageController ()<GMSMapViewDelegate,ServiceHandlerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLLocationCoordinate2D theCoordinate;
    GMSCameraPosition *cameraPosition;
    SingleTon * singleTonInstance;
    GMSMapView * mapView;
    GMSMarker * marker;

    
    UIRefreshControl *refreshControl ;
    
    CGFloat  latiNum ;
    CGFloat longiNum;
    
    NSMutableDictionary * seperateDict,*editEventDict,*optionsDix,*summaryDict;

    NSString * statusNum,*imagseUrlSendToEditEvent;
    
    NSMutableArray * collectionArray, * barsArray,*longitudeArray,*latitudeArray,*markerArray;
    NSMutableArray * chatArray,*allMessages;
    NSMutableArray * pathsaveArray,* pathOptionArray;
    NSInteger * BtnTag;
    GMSMarker *selectedMarker;

    BOOL  isAddToPrefered,isAddToPreferedComeOnce,
          isViewShow,
          isEventView,
          isNearMeRestaurants,
          isDeleteEvent,
          isMapShowing,
          userStatus,
          isChatView,
          isVoteCreated,
          isVoteDisplay,
          eventMembers,
          isvotesVoted,
          isfilter,
          isEventMap, //Getsygnal@123
          isvoteCancelled,
          isSearchHere,
          isEquiDistance;
    
    NSMutableArray * selectedOptionsArray,*voteIdArray;
    NSMutableArray * numbersArr ;
    NSString * option1Select,* option2Select,* option3Select,* option4Select;
    
    NSString * isChatHistoryString;
    int isChatHistory,*voteBtnPath;
}
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (strong, nonatomic) VCFloatingActionButton *addButton;


@end

@implementation EventReadyPageController
@synthesize addButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.iAmReadyButton.hidden = YES;
    
    self.detailScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.descriptionLbl.frame.origin.y + self.descriptionLbl.frame.size.height);
    
    self.mapImage.hidden = YES;
    self.chatView.hidden = YES;
    self.voteView.hidden = YES;
    self.startVoteView.hidden = YES;
    self.friendsView.layer.borderWidth = 0.5;
    self.friendsView.layer.borderColor = [UIColor grayColor].CGColor;
    singleTonInstance = [SingleTon singleTonMethod];
    
    self.GroupCollectionView.delegate = self;
    self.GroupCollectionView.dataSource = self;
    

    self.voteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.voteTableView.allowsSelection = NO;
    
    self.textview.text = @"Text here";
    self.textview.textColor = [UIColor lightGrayColor];
    self.textview.delegate = self;
    
    
    isMapShowing = YES;
    
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    
    
    
    
    
    
    self.eventHighlightLbl.hidden = NO;
    self.chatHighlightLbl.hidden = YES;
    self.detailsHighlightLbl.hidden = YES;
    self.voteHighlightLbl.hidden = YES;
    seperateDict = [[NSMutableDictionary alloc]init];
    
    summaryDict = [[NSMutableDictionary alloc]init];
    
    singleTonInstance.summaryDict = [[NSMutableDictionary alloc]init];
    
    numbersArr = [[NSMutableArray alloc]init];
    
    markerArray  = [[NSMutableArray alloc]init];
    
    chatArray = [[NSMutableArray alloc]init];
    
    allMessages = [[NSMutableArray alloc]init];

    editEventDict = [[NSMutableArray alloc]init];
    
    longitudeArray = [[NSMutableArray alloc]init];
    
    latitudeArray = [[NSMutableArray alloc]init];
    
    collectionArray = [[NSMutableArray alloc]init];
    
    voteIdArray = [[NSMutableArray alloc]init];
    
    pathsaveArray = [[NSMutableArray alloc]init];
    
    pathOptionArray = [[NSMutableArray alloc]init];
    
    selectedOptionsArray = [[NSMutableArray alloc]init];
    
     singleTonInstance.votesArray = [[NSMutableArray alloc]init];
    
    singleTonInstance.filterResultArray = [[NSMutableArray alloc]init];
    
    [self.goingBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
   
    
    [self.interestedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.interestedBtn setBackgroundColor:[UIColor whiteColor]];
    
    [self.cantGoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.cantGoBtn setBackgroundColor:[UIColor whiteColor]];
    
    self.goingBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.goingBtn.layer.borderWidth = 0.5;
    
    self.interestedBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.interestedBtn.layer.borderWidth = 0.5;
    
    self.cantGoBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.cantGoBtn.layer.borderWidth = 0.5;
    
    
    
    
    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreen mainScreen].bounds.size.height - 44 - 20, 44, 44);
    
    addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"plus.png"] andPressedImage:[UIImage imageNamed:@"cross.png"] withScrollview:nil];
    
    
    addButton.imageArray = @[@"createVote.png",@"viewVote.png"];
    addButton.labelArray = @[@"Create Vote",@"View Votes"];
    
    
    
    addButton.hideWhileScrolling = NO;
    addButton.delegate = self;
    
    
    [self.view addSubview:addButton];
    
    addButton.hidden = YES;
    
    
    if (self.presentEventsDict.count)
    {
        if (![[self.presentEventsDict objectForKey:@"member_count"] isKindOfClass:[NSNull class]]) {
            NSString * membersCount = [NSString stringWithFormat:@"%d",[[self.presentEventsDict objectForKey:@"member_count"] intValue]];
            self.totalCountLbl.text  =  [Utilities null_ValidationString:membersCount];
        }
        
        NSString * featuredimages = [self.presentEventsDict objectForKey:@"image"];
        
        NSString *  imageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/events/%@",featuredimages];
        
        NSLog(@"===image url  == %@",imageString);
        
        imagseUrlSendToEditEvent = imageString;
        
        NSURL *url = [NSURL URLWithString:imageString];
        
        self.descriptionLbl.text = [Utilities null_ValidationString:[self.presentEventsDict objectForKey:@"description"]];
        
        [self.eventImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
    }
    else
    {
        
//        if (singleTonInstance.eventImgData.length)
//        {
//            //self.eventImage.image = [UIImage imageWithData:singleTonInstance.eventImgData] ;
//            
//            [self.mapImage sd_setImageWithURL:nil placeholderImage:[UIImage imageWithData:singleTonInstance.eventImgData]];
//        }
        if (singleTonInstance.eventImgData.length)
        {
            self.eventImage.image = [UIImage imageWithData:singleTonInstance.eventImgData] ;
            
        }
        
        self.descriptionLbl.text = [Utilities null_ValidationString:singleTonInstance.descriptionStr];
    }
    
    
    
    [self.descriptionLbl sizeToFit];
    
    
    
    isViewShow = YES;
    
    [self eventViewServiceCall];
    
    [self eventMembersServiceCall];
    
//    
//    //////////////////////////////////////////////////////////////////////////
//    ////////////////  this is to set title in navigation bar  ////////////////
//    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
//    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
//    
//
//    
//    
//    //for right bar buttons
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
//    [arrRightBarItems addObject:barButtonItem3];
//    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [btntitle setTitle:@"Notifications" forState:UIControlStateNormal];
//    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    // [btnh addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
//    self.navigationItem.rightBarButtonItems = arrRightBarItems;
//    //////////////////////////////////////////////////////////////////////////
//    //////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////
    ////////////////////For current location/////////////////////
    /////////////////////////////////////////////////////
    // this code is not needed
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    /////////////////////////////////////////////////////
    /////////////////////////////////////////////////////

    
    
    NSString * eve = [Utilities null_ValidationString:[self.presentEventsDict valueForKey:@"event_name"]];
    if (eve.length) {
        
        self.title = [self.presentEventsDict valueForKey:@"event_name"];
        
        singleTonInstance.eventNameSt = [self.presentEventsDict valueForKey:@"event_name"];
    }
    else
         self.title = singleTonInstance.eventNameSt;
    
//    if (singleTonInstance.eventNameSt.length)
//    {
//        self.title = singleTonInstance.eventNameSt;
//
//    }
//    else
//    {
//        self.title = [self.presentEventsDict valueForKey:@"event_name"];
//
//        singleTonInstance.eventNameSt = [self.presentEventsDict valueForKey:@"event_name"];
//    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //////////////////////////////////////////////////////////
    /////////////////////////////for time and date display////////////////
    if (singleTonInstance.startDateStr)
    {
        ////////////////////////
        // bring month name from date (yyyy/MM/dd ) And day number
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *date = [dateFormat dateFromString:singleTonInstance.startDateStr];
        [dateFormat setDateFormat:@"MMMM"];
        NSString* temp = [dateFormat stringFromDate:date];
        NSLog(@"month is %@",temp);
        self.startMonthLbl.text = temp;
        
        
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *date1 = [dateFormat1 dateFromString:singleTonInstance.startDateStr];
        [dateFormat1 setDateFormat:@"dd"];
        NSString* temp1 = [dateFormat1 stringFromDate:date1];
        NSLog(@"Day is %@",temp1);
        self.startDayLbl.text = temp1;
        
        
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        [dateFormat2 setDateFormat:@"hh:mm a"];
        NSDate *date2 = [dateFormat2 dateFromString:singleTonInstance.showTimeStr];
        [dateFormat2 setDateFormat:@"hh:mm a"];
        NSString* temp2 = [dateFormat2 stringFromDate:date2];
        
        self.startTimeLbl.text = temp2;

        
        //////////////////////////////
        
        
        self.startDayLbl.hidden = NO;
        self.startMonthLbl.hidden = NO;
        self.startTimeLbl.hidden = NO;
        
        

    }
    else
    {
        
      NSString * startDat =  [Utilities null_ValidationString:[self.presentEventsDict objectForKey:@"start_date"]] ;

        

        
        if (startDat.length)
        {
            
            NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"MMMM"];
            [dateFormatter2 setDateFormat:@"dd"];
            
            
            
            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
            [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [dateFormatter3 dateFromString:startDat];
            
            self.startMonthLbl.text = [dateFormatter1 stringFromDate:dateFromString];
            self.startDayLbl.text = [dateFormatter2 stringFromDate:dateFromString];
            
            NSLog(@"date is %@",self.startMonthLbl.text);
            
            self.startMonthLbl.hidden = NO;
            self.startDayLbl.hidden = NO;
        }
        else
        {
            self.startDayLbl.hidden = YES;
            self.startMonthLbl.hidden = YES;
        }
        
        self.startTimeLbl.hidden = YES;
        
        
        
        
    }
    NSLog(@"print time should be %@",self.startTimeFromBookings);
    NSLog(@"print end time should be %@",self.endTimeFromBookings);
    if (self.startTimeFromBookings.length) {
        self.startTimeLbl.hidden = NO;
        self.startTimeLbl.text = [Utilities null_ValidationString:self.startTimeFromBookings];
    }
    
    
    
    if (singleTonInstance.endDateStr)
    {
        
        NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
        [endDateFormat setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *date = [endDateFormat dateFromString:singleTonInstance.endDateStr];
        [endDateFormat setDateFormat:@"MMMM"];
        NSString* endTemp = [endDateFormat stringFromDate:date];
        NSLog(@"month is %@",endTemp);
        self.endMonthLbl.text = endTemp;
        
        
        NSDateFormatter *endDateFormat1 = [[NSDateFormatter alloc] init];
        [endDateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *endDate1 = [endDateFormat1 dateFromString:singleTonInstance.endDateStr];
        [endDateFormat1 setDateFormat:@"dd"];
        NSString* endTemp1 = [endDateFormat1 stringFromDate:endDate1];
        
        self.endDayLbl.text = endTemp1;
        
        
        NSDateFormatter *endDateFormat2 = [[NSDateFormatter alloc] init];
        [endDateFormat2 setDateFormat:@"hh:mm a"];
        NSDate *date3 = [endDateFormat2 dateFromString:singleTonInstance.endTimeStr];
        [endDateFormat2 setDateFormat:@"hh:mm a"];
        NSString* temp3 = [endDateFormat2 stringFromDate:date3];
        
        self.endTimeLbl.text = temp3;


        self.endDayLbl.hidden = NO;
        self.endMonthLbl.hidden = NO;
        self.endTimeLbl.hidden = NO;
        
    }
    else
    {
        
        NSString * endDat =   [Utilities null_ValidationString:[self.presentEventsDict objectForKey:@"end_date"]];
        
        
        if (endDat.length>0)
        {
            
            NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"MMMM"];
            [dateFormatter2 setDateFormat:@"dd"];
            
            
            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
            [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [dateFormatter3 dateFromString:endDat];
            
            self.endMonthLbl.text = [dateFormatter1 stringFromDate:dateFromString];
            self.endDayLbl.text = [dateFormatter2 stringFromDate:dateFromString];
            
            
            self.endMonthLbl.hidden = NO;
            self.endDayLbl.hidden = NO;
            self.endTimeLbl.hidden = YES;

        }
        else
        {
            self.endDayLbl.hidden = YES;
            self.endMonthLbl.hidden = YES;
            self.endTimeLbl.hidden = YES;
        }
        
        
    }
    
    
    if (self.endTimeFromBookings.length) {
        self.endTimeLbl.hidden = NO;
        self.endTimeLbl.text = [Utilities null_ValidationString:self.endTimeFromBookings];
    }
    /////////////////////////////////////////////////////
    /////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    [self.eventMap setDelegate:self];
    
    
    MKMapItem *mapItem = [singleTonInstance.mapItemList objectAtIndex:0];
    
    
    
    if (singleTonInstance.areaName) {
        self.eventArea.text = singleTonInstance.areaName;
        
    }
    else
    {
        self.eventArea.text = [Utilities null_ValidationString:[self.presentEventsDict objectForKey:@"location"]];
    }
    
    [self.eventArea sizeToFit];
    
    if (singleTonInstance.mapItemList.count)
    {
        self.eventMap.hidden = NO;
        
        self.mapImage.hidden = YES;
    }
    else
    {
        self.eventMap.hidden = YES;
        
        self.mapImage.hidden = NO;
        
        //self.mapImage.image = [UIImage imageNamed:@"gmap.png"];
        
        [self.mapImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"gmap.png"]];
        
    }
    
    
    // Add the single annotation to our map.
    PlaceAnnotation * annotation = [[PlaceAnnotation alloc] init];
    annotation.coordinate = mapItem.placemark.location.coordinate;
    annotation.title = mapItem.name;
    annotation.url = mapItem.url;
    
    
    ////////////////////
    ////////////////////
    // to set zoom level of mkmap
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 400, 400);
    MKCoordinateRegion adjustedRegion = [self.eventMap regionThatFits:viewRegion];
    [self.eventMap setRegion:adjustedRegion animated:YES];
    ////////////////////
    ////////////////////
    
    
    [self.eventMap addAnnotation:annotation];
    
    // We have only one annotation, select it's callout.
    [self.eventMap selectAnnotation:[self.eventMap.annotations objectAtIndex:0] animated:YES];
    
    
    
    
    
    
    
    
    
    
    
    
    
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(0, 5, 30, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    //phoneButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    // phoneBarItem.action = @selector(nextAction);
    [arrLeftBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[phoneButton setTitle:singleTonInstance.eventNameSt forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"icons8-left-24.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    

    
    //for  2nd right bar button
    UIButton *phoneButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton1.frame = CGRectMake(0, 5, 30, 25);
    [phoneButton1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    //phoneButton1.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem * phoneBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:phoneButton1];
    // phoneBarItem.action = @selector(nextAction);
    [arrRightBarItems addObject:phoneBarItem1];
    phoneButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneButton1 setImage:[UIImage imageNamed:@"icons8-menu-vertical-24.png"] forState:UIControlStateNormal];
    [phoneButton1 addTarget:self action:@selector(viewShowAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton1 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    
    
    
    
    //////////////////////for filter button/////////////
    
    UIButton *filterButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton1.frame = CGRectMake(275, 5, 28, 25);
    [filterButton1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint22 = [filterButton1.widthAnchor constraintEqualToConstant:26];
    NSLayoutConstraint * HeightConstraint22 =[filterButton1.heightAnchor constraintEqualToConstant:26];
    [widthConstraint22 setActive:YES];
    [HeightConstraint22 setActive:YES];
    
    
    UIBarButtonItem *  meuBarItem12 = [[UIBarButtonItem alloc] initWithCustomView:filterButton1];
    meuBarItem12.action = @selector(menuAction);
    [arrRightBarItems addObject:meuBarItem12];
    filterButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [filterButton1 setImage:[UIImage imageNamed:@"icons8-filter-filled-80.png"] forState:UIControlStateNormal];
    
    [filterButton1 addTarget:self action:@selector(filterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [filterButton1 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    //////////////////////upto here filter button/////////////
    
    
    
    
    
    
    
    
    //////////////////////for menu button/////////////
    
    UIButton *menuButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton1.frame = CGRectMake(275, 5, 28, 25);
    [menuButton1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint222 = [menuButton1.widthAnchor constraintEqualToConstant:26];
    NSLayoutConstraint * HeightConstraint222 =[menuButton1.heightAnchor constraintEqualToConstant:26];
    [widthConstraint222 setActive:YES];
    [HeightConstraint222 setActive:YES];
    
    
    UIBarButtonItem *  meuBarItem122 = [[UIBarButtonItem alloc] initWithCustomView:menuButton1];
    meuBarItem122.action = @selector(menuAction);
    [arrRightBarItems addObject:meuBarItem122];
    menuButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuButton1 setImage:[UIImage imageNamed:@"toogle_menu_icon.png"] forState:UIControlStateNormal];
    
    [menuButton1 addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton1 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    //////////////////////upto here filter button/////////////
    
    
    
    
    
    
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    
    
    
    
    
    
    
    
    
    
    
    
    
    NSMutableArray * latitudeArray = [[NSMutableArray alloc]initWithObjects:@"17.424887",@"17.426719",@"17.427256",@"17.425217",@"17.394047", nil];
    
    NSMutableArray * longitudeArray = [[NSMutableArray alloc]initWithObjects:@"78.447891",@"78.447558",@"78.435420",@"78.425806",@"78.421870", nil];
    
//    cameraPosition=[GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:13];
//    mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
//    mapView.myLocationEnabled = YES;
//    mapView.delegate = self;

    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    for (int i = 0; i<latitudeArray.count; i++) {
//        CGFloat latitude = [[latitudeArray objectAtIndex:i] doubleValue];
//        CGFloat longitude = [[longitudeArray objectAtIndex:i] doubleValue];
//        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
//        // marker.snippet = [self.SPIDArray objectAtIndex:i];
//        marker.appearAnimation = kGMSMarkerAnimationPop;
//        marker.map = mapView;
//        marker.zIndex = (UInt32)i;
//    }
//    
//    
//    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    
    
    [self serviceCall];
    
    
    self.detailView.hidden = NO;
    self.mapShowView.hidden = YES;
    self.detailsHighlightLbl.hidden = NO;
    self.eventHighlightLbl.hidden = YES;
    self.GroupCollectionView.alpha = 0;
    self.GroupCollectionView.tag = 1;
    self.friendsCollection.tag = 2;
    [self.friendsCollection layoutIfNeeded];
    
    
    self.detailScroll.contentSize = CGSizeMake(self.view.frame.size.width,self.descriptionLbl.frame.origin.y + self.descriptionLbl.frame.size.height+20+self.eventMap.frame.size.height);
    
    
    
    //////////////////////////////////////////////////////////////////
              // for on tap on view small view have to hide
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    //////////////////////////////////////////////////////////////////
    
    
    
    self.chatTableView.backgroundColor = [UIColor lightTextColor];
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Refresh Control
    refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(dataFromServer:) forControlEvents:UIControlEventValueChanged];
    [self.chatTableView addSubview:refreshControl];
    
    
    
    
    cameraPosition=[GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:13];

    cameraPosition=[GMSCameraPosition cameraWithLatitude:singleTonInstance.latiNum longitude:singleTonInstance.longiNum zoom:13];

    mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];

    mapView.myLocationEnabled = YES;
    
    mapView.settings.compassButton = YES;

    mapView.delegate = self;


    mapView.frame = CGRectMake(0,0, self.view.frame.size.width,570);

    mapView.frame = CGRectMake(0,0, self.view.frame.size.width,570);

    if (IS_IPHONE_5 || IS_IPHONE_5S || IS_IPHONE_5C)
    {
        mapView.frame = CGRectMake(0,0, self.view.frame.size.width,410);
    }

    else if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6S || IS_STANDARD_IPHONE_7)
    {
        mapView.frame = CGRectMake(0,0,self.view.frame.size.width,490);
    }
    else if (IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS)
    {

        mapView.frame = CGRectMake(0,0, self.view.frame.size.width,480);
    }

    else if( IS_STANDARD_IPHONE_6S_PLUS || IS_STANDARD_IPHONE_7_PLUS)
    {
        mapView.frame = CGRectMake(0,0,self.view.frame.size.width,560);
    }

    else
    {
        mapView.frame = CGRectMake(0,0, self.view.frame.size.width,570);
    }


    self.GroupCollectionView.frame = CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y+mapView.frame.size.height, mapView.frame.size.width, self.GroupCollectionView.frame.size.height);

    self.GroupCollectionView.frame = CGRectMake(mapView.frame.origin.x, self.GroupCollectionView.frame.origin.y, mapView.frame.size.width, self.GroupCollectionView.frame.size.height);
    [self.mapShowView layoutIfNeeded];
    [self.mapShowView addSubview:mapView];
    
    
    
    
}







- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currentLocation = [locations objectAtIndex:0];
    
    
    
    [locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
             
             NSLog(@"------ %@",placemark.name);
             
             self.locationNameLbl.text = placemark.name;
         }
         
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
             //CountryArea = NULL;
         }
         
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}





-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init] ;
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    isViewShow = YES;
    
    self.smallView.hidden = YES;
    
    //Do stuff here...
}

-(void)backAction
{
    [self performSelectorOnMainThread:@selector(doPop) withObject:nil waitUntilDone:NO];

}

-(void)menuButtonAction
{
    NSLog(@"Menu");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantListViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantListViewController"];
    // menu.isfromEventReady = YES;
    
    menu.isEventListFilter = YES;
    
    //    singleTonInstance.barsArrayReady
    if (singleTonInstance.barsArrayReady.count) {
        [self.navigationController pushViewController:menu animated:YES];
    }
    else
    {
        [Utilities displayToastWithMessage:@"Choose Event Location First"];
    }
    
}

-(void)dataFromServer:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Getting previous chats..."];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:3];//for 3 seconds, prevent scrollview from bouncing back down (which would cover up the refresh view immediately and stop the user from even seeing the refresh text / animation)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            
            // after reload table view we have to end refreshing
            
            [refreshControl endRefreshing];
            
            NSLog(@"refresh end");
            
            
            
            //we have to write service call here
            
        });
    });
}

-(void)doPop
{
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    NSVBarController *invite = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
//
//    NSArray *array = [self.navigationController viewControllers];
//
//    [invite setSelectedIndex:2];
//
//    [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
    
    
//
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    homeTabViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
//
//
//    [invite setSelectedIndex:2];
//
//    [self presentViewController:invite animated:YES completion:nil];
//
    
    
     dispatch_async(dispatch_get_main_queue(), ^{
    
//    NSArray * controllers = [self.navigationController viewControllers];
//
//
//    BOOL * isRight;
//
//         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//         homeTabViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
//
//         [invite setSelectedIndex:2];
//
//    for (int i = 0; i < [controllers count]; i++){
//
//      //  [self.navigationController popToViewController:[controllers objectAtIndex:0] animated:YES];
//
//        UIViewController * controllerTest = [controllers objectAtIndex:i];
//
//        if([controllerTest isKindOfClass:invite]){
//            NSLog(@"Class is available");
//            isRight = NO;
//            [self.navigationController popToViewController:invite animated:YES];
//
//            //[self.navigationController popToViewController:[controllers objectAtIndex:0] animated:YES];
//            break;
//        }
//        else
//        {
//            isRight = YES;
//        }
//
//
//    }
//
//    if (isRight == YES) {

         [mapView clear];
         [mapView stopRendering];
         [mapView removeFromSuperview];
         mapView = nil;
         
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            homeTabViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];


            [invite setSelectedIndex:2];

            [self presentViewController:invite animated:YES completion:nil];
         
        // [self.navigationController popToRootViewControllerAnimated:YES];

   // }
         
         
    
     });
    
    
}

-(void)viewShowAction
{

    self.smallView.frame = CGRectMake(self.smallView.frame.origin.x, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.smallView.frame.size.width, self.smallView.frame.size.height);
    if (isViewShow)
    {
        isViewShow = NO;
        self.smallView.hidden = NO;
        [Utilities addShadowtoView:self.smallView];
        self.smallView.layer.cornerRadius = 4;
        [self.view addSubview:self.smallView];
    }
    else
    {
        isViewShow = YES;
        
        self.smallView.hidden = YES;
        [self.smallView removeFromSuperview];
        
        
        
        
    }
    
}


-(void)viewDidAppear:(BOOL)animated
{
    if (isViewShow == YES) {
        addButton.hidden = YES;
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    // this is to close side menu if already opened when navigation to another tab bar
//    if (self.revealViewController.frontViewPosition == FrontViewPositionRight) {
//        [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"DataUpdated"
                                               object:nil];
    
    
    self.tabBarController.tabBar.hidden = YES;
    self.smallView.hidden = YES;
    
     [self.mapShowView bringSubviewToFront:self.trailBtn];
    
   // self.locationNameLbl.text = [Utilities getAddressFromLatLon:<#(double)#> withLongitude:<#(double)#>]

    if (isEventMap == YES && isfilter == YES && singleTonInstance.filterResultArray.count>0) {

        [mapView clear];
        
        [latitudeArray removeAllObjects];
        [longitudeArray removeAllObjects];
        
        /// for bars
        barsArray = [[NSMutableArray alloc]init];
        barsArray = singleTonInstance.filterResultArray ;
        //singleTonInstance.barsArrayReady = [[NSMutableArray alloc]init];
        singleTonInstance.barsArrayReady = barsArray;
        singleTonInstance.barsCountStr = [NSString stringWithFormat:@"- - %lu",barsArray.count];
        if (barsArray.count && markerArray.count) {
            [markerArray removeAllObjects];
        }
        for (int i =0; i<barsArray.count; i++)
        {
            [latitudeArray addObject:[[singleTonInstance.filterResultArray  objectAtIndex:i] objectForKey:@"latitude"]];
            [longitudeArray addObject:[[singleTonInstance.filterResultArray  objectAtIndex:i] objectForKey:@"longitude"]];

            ////////////////////////////////////////////////////////
            /////////////// // to display nearBy bars////////////////
            marker = [[GMSMarker alloc] init];
            CGFloat latitude = [[latitudeArray objectAtIndex:i] doubleValue];
            CGFloat longitude = [[longitudeArray objectAtIndex:i] doubleValue];
            marker.position = CLLocationCoordinate2DMake(latitude, longitude);
            // marker.snippet = [self.SPIDArray objectAtIndex:i];
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.map = mapView;
            marker.zIndex = (UInt32)i;
            marker.title = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"];
            marker.snippet = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_id"];



            UIImageView * imgView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 40, 40)];
            imgView.image = [UIImage imageNamed:@"map_64x64.png"];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 40, 40)];
            label.text = [NSString stringWithFormat:@"%d",i+1];
            [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            // label.layer.cornerRadius = 21;
            label.layer.masksToBounds = YES;
            // label.backgroundColor = [REDCOLOR colorWithAlphaComponent:1];

            //grab it
            UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, [[UIScreen mainScreen] scale]);
            [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
            [label.layer renderInContext:UIGraphicsGetCurrentContext()];

            UIImage * icon = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            marker.icon = icon;


            marker.map = mapView;
            
            
            
            [markerArray addObject:marker];

        }

        [self.GroupCollectionView reloadData];


    }

    if (singleTonInstance.isForEventPage == YES) {
        
        NSLog(@"%@",singleTonInstance.areaNameForEventPage);
        
        self.locationNameLbl.text = [Utilities null_ValidationString:singleTonInstance.areaNameForEventPage];
        [self.locationNameLbl adjustsFontSizeToFitWidth];
        
        
       // GMSCameraUpdate *camera = [GMSCameraUpdate setTarget:[mapView.projection coordinateForPoint:<#(CGPoint)#>]];

        [self searchHereService];
        
        singleTonInstance.isForEventPage = NO;
    }
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
self.tabBarController.tabBar.hidden = YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSUInteger memorySize = 1024 * 1024 * 64;
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:memorySize diskCapacity:memorySize diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    NSLog(@"cap: %ld", [[NSURLCache sharedURLCache] diskCapacity]);
    
    NSInteger sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
    float sizeInMB = sizeInteger / (1024.0f * 1024.0f);
    
    NSLog(@"size: %ld,  %f", (long)sizeInteger, sizeInMB);
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
    sizeInMB = sizeInteger / (1024.0f * 1024.0f);
    NSLog(@"size: %ld,  %f", (long)sizeInteger, sizeInMB);
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
    sizeInMB = sizeInteger / (1024.0f * 1024.0f);
    NSLog(@"size: %ld,  %f", (long)sizeInteger, sizeInMB);
    // Dispose of any resources that can be recreated.
}









// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    eventReadyCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    
//    cell.imgViw.image = [UIImage imageNamed:@"cross.png"];
//    
//    //cell.backgroundColor=[UIColor lightGrayColor];
//    return cell;
//}



- (IBAction)detailsAction:(id)sender {
    
    addButton.hidden = YES;

    isEventMap = NO;
    
    isfilter = NO;
    
    self.iAmReadyButton.hidden = YES;
    self.voteHighlightLbl.hidden = YES;
    self.mapShowView.hidden = YES;
    self.eventHighlightLbl.hidden = YES;
    self.detailsHighlightLbl.hidden = NO;
    self.detailView.hidden = NO;
    [self.view addSubview:self.detailView];
    self.GroupCollectionView.hidden = NO;
    self.GroupCollectionView.alpha = 0;
    self.chatView.hidden = YES;
    self.chatHighlightLbl.hidden = YES;
    if ([singleTonInstance.mapItemList objectAtIndex:0])
    {
        
    }
    else
    {
        //self.eventMap.hidden = YES;
        
        if (![Utilities null_ValidationString:[self.presentEventsDict objectForKey:@"location"]]) {
            self.eventArea.text = @"Location Not Updated ";
        }
        else
        {
            self.eventArea.text = [Utilities null_ValidationString:[self.presentEventsDict objectForKey:@"location"]];
        }
        
        [self.eventArea sizeToFit];
        
    }
    
    
    
    // this is to remove view from self.view if it is aleready in view
    if (isViewShow)
    {
        [self.smallView removeFromSuperview];
    }
    
}


- (IBAction)eventAction:(id)sender {
    if (isMapShowing == YES) {
        [self serviceCall];
        isMapShowing = NO;
    }
    
    self.trailBtn.layer.cornerRadius = self.trailBtn.frame.size.width/2;
    
    isEventMap = YES;
    
    
    addButton.hidden = YES;

    
    self.voteHighlightLbl.hidden = YES;
    
    self.iAmReadyButton.hidden = NO;
    
    self.mapShowView.hidden = NO;
    
    self.detailsHighlightLbl.hidden = YES;
    
    self.eventHighlightLbl.hidden = NO;
    
    self.detailView.hidden = YES;
    
    self.GroupCollectionView.alpha = 1;
    
    self.chatView.hidden = YES;
    
    self.chatHighlightLbl.hidden = YES;
    
    self.voteView.hidden = YES;
    
    
    // this is to remove view from self.view if it is aleready in view
    if (isViewShow)
    {
        [self.smallView removeFromSuperview];
    }
    
}


- (IBAction)chatAction:(id)sender {
    
    addButton.hidden = YES;

    isEventMap = NO;
    
    isfilter = NO;
    
    [self chatHistoryServiceCall];

    self.voteHighlightLbl.hidden = YES;
    self.iAmReadyButton.hidden = YES;
    self.chatHighlightLbl.hidden = NO;
    self.mapShowView.hidden = YES;
    self.eventHighlightLbl.hidden = YES;
    self.detailsHighlightLbl.hidden = YES;
    self.detailView.hidden = YES;
    self.GroupCollectionView.hidden = NO;
    self.GroupCollectionView.alpha = 0;
    self.chatView.hidden = NO;
    self.voteView.hidden = YES;
    self.textview.backgroundColor = [UIColor lightTextColor];
    
}


- (IBAction)chatSend:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
    if (self.chatTextfield.text.length>0) {
        [self groupChatServiceCall];
        
        UIView *newMsg = [self createMessageWithText:self.chatTextfield.text Image:nil DateTime:[Utilities getName] isReceived:0 Time:nil];
        
        [allMessages addObject:newMsg];
        [self.chatTableView reloadData];
        
        [self.chatTextfield resignFirstResponder];
        self.chatTextfield.text = @"";
        [self scrollToTheBottom:YES];
    }
    else
        //[Utilities displayToastWithMessage:@"please enter text"];
    
        
        [ISMessages showCardAlertWithTitle:nil
                                   message:@"Please Enter Some Text"
                                  duration:3.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeInfo
                             alertPosition:ISAlertPositionTop
                                   didHide:^(BOOL finished) {
                                      
                                       
                                   }];
        
        

        
    });

    
}



-(void)filterButtonAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    filterViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"filterViewController"];
    isfilter = YES;
    
     if (isEventMap == YES && isfilter == YES ) {
     
         [self.navigationController pushViewController:menu animated:YES];

     }
}


- (IBAction)changeLocation:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MyTableViewController *notifications = [storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController"];
    
    notifications.iseventPage = YES;
    
    [self.navigationController pushViewController:notifications animated:YES];
}




#pragma mark - vote  view actions

- (IBAction)voteAction:(id)sender {
    
    self.voteQuestionText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.voteQuestionText.layer.borderWidth = 0.5;
    
    [Utilities addShadowtoView:self.voteQuestionText];
    [Utilities addShadowtoButton:self.createBtn];
    self.voteView.hidden = NO;
    self.iAmReadyButton.hidden = YES;
    self.chatHighlightLbl.hidden = YES;
    self.mapShowView.hidden = YES;
    self.eventHighlightLbl.hidden = YES;
    self.detailsHighlightLbl.hidden = YES;
    self.detailView.hidden = YES;
    self.GroupCollectionView.hidden = NO;
    self.GroupCollectionView.alpha = 0;
    self.chatView.hidden = YES;
    self.voteHighlightLbl.hidden = NO;
    self.startVoteView.hidden = YES;
    self.cancelStartVote.hidden = YES;
    
    self.cancelCreateVote.layer.cornerRadius = 5;
    self.createVoteView.layer.cornerRadius = 9;
    self.questionText.layer.borderWidth = 0.5;
    self.questionText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.option1Text.layer.borderWidth = 0.5;
    self.option1Text.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.option1Text.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.option2Text.layer.borderWidth = 0.5;
    self.option2Text.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.option2Text.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.option3Text.layer.borderWidth = 0.5;
    self.option3Text.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.option3Text.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.option4Text.layer.borderWidth = 0.5;
    self.option4Text.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.option4Text.layer.borderColor = [UIColor lightGrayColor].CGColor;
    

    isVoteCreated = NO;
    
    addButton.hidden = NO;
    
    [self usereventvotesService];
}



- (IBAction)createVoteAction:(id)sender {
    
    if ([self.voteQuestionText hasText])
    {
        
        self.startVoteView.hidden = NO;
        self.startVoteView.layer.cornerRadius = 10;
        self.cancelStartVote.layer.cornerRadius = 5;
        self.cancelStartVote.hidden  = NO;
        self.questionText.text = [Utilities null_ValidationString:self.voteQuestionText.text];
        self.questionText.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.cancelCreateVote.hidden = YES;
        self.cancelStartVote.hidden = YES;
        
        
    }
    else
    {
        
       
        
                            [ISMessages showCardAlertWithTitle:nil
                                                       message:@"Ask Something"
                                                      duration:3.f
                                                   hideOnSwipe:YES
                                                     hideOnTap:YES
                                                     alertType:ISAlertTypeInfo
                                                 alertPosition:ISAlertPositionTop
                                                       didHide:^(BOOL finished) {
                                                           NSLog(@"Alert did hide.");
                                                           
                                                       }];
    }
   
    
}


- (IBAction)cancelCreateVoteAction:(id)sender {
    
    [Utilities displayToastWithMessage:@"Work under progress"];
}
- (IBAction)cancelStartVoteAction:(id)sender {
    [Utilities displayToastWithMessage:@"Work under progress"];
}
- (IBAction)startVoteAction:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{

    
    if ([self.option1Text hasText] || [self.option2Text hasText] || [self.option3Text hasText] || [self.option4Text hasText]) {
        
        isVoteCreated = YES;
        
        [self createeventvotingService];
        
//        singleTonInstance.voteOption1 = [Utilities null_ValidationString:self.option1Text.text];
//
//        singleTonInstance.voteOption2 = [Utilities null_ValidationString:self.option2Text.text];
//
//        singleTonInstance.voteOption3 = [Utilities null_ValidationString:self.option3Text.text];
//
//        singleTonInstance.voteOption4 = [Utilities null_ValidationString:self.option4Text.text];
//
//        singleTonInstance.voteQuestion = [Utilities null_ValidationString:self.voteQuestionText.text];
//
//
//        votePopupViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"votePopupViewController"];
//        vc.view.frame = CGRectMake(0, 0, 270.0f, 340.0f);
//
//
//        [self presentPopUpViewController:vc];
//
//
        
        self.startVoteView.hidden = YES;
        self.createVoteView.hidden = YES;
        self.thumbsUpImg.hidden = NO;

    }
    else
    {
        [ISMessages showCardAlertWithTitle:nil
                                   message:@"Create Atleast One Option"
                                  duration:3.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeInfo
                             alertPosition:ISAlertPositionTop
                                   didHide:^(BOOL finished) {
                                       
                                       
                                   }];
        
    }
    });
}



#pragma mark - other  button actions

- (IBAction)readtButtonAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    summaryViewController *eventPage = [storyboard instantiateViewControllerWithIdentifier:@"summaryViewController"];
    
    eventPage.presentDict = self.presentEventsDict;
    eventPage.eventDate =  [Utilities null_ValidationString:[self.presentEventsDict objectForKey:@"start_date"]] ;
    if (singleTonInstance.summaryDict.count) {
        [self.navigationController pushViewController:eventPage animated:YES];
    }
    else
    {
        [Utilities displayToastWithMessage:@"You are not ready yet"];
    }
    

}

- (IBAction)inviteFriendsButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            newCreateEventController *eventPage = [storyboard instantiateViewControllerWithIdentifier:@"newCreateEventController"];
    
    eventPage.eventIdStr = self.eventIdStr;
    
            [self.navigationController pushViewController:eventPage animated:YES];
}



- (IBAction)EditEvent_Btn:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditEventViewController *edit = [storyboard instantiateViewControllerWithIdentifier:@"EditEventViewController"];
    singleTonInstance.eventIdStr = self.eventIdStr;
    edit.imgUrl = imagseUrlSendToEditEvent;
        
        edit.editEventDict = editEventDict;
        
    [self.navigationController pushViewController:edit animated:YES];
    });
}

- (IBAction)deleteEventAction:(id)sender {
    
    [self deleteEventServiceCall];
}

- (IBAction)goingAction:(id)sender {
    
    statusNum = @"1";
    
    userStatus = YES;
    
    [self updateEventStatusServiceCall];
    
    [self.goingBtn setBackgroundColor:[UIColor darkGrayColor]];
    [self.goingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.interestedBtn setBackgroundColor:[UIColor whiteColor]];
    [self.interestedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.cantGoBtn setBackgroundColor:[UIColor whiteColor]];
    [self.cantGoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    
}

- (IBAction)interestedAction:(id)sender {
    
    statusNum = @"2";
    
    userStatus = YES;
    
    [self updateEventStatusServiceCall];
    
    [self.interestedBtn setBackgroundColor:[UIColor darkGrayColor]];
    [self.interestedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.goingBtn setBackgroundColor:[UIColor whiteColor]];
    [self.goingBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.cantGoBtn setBackgroundColor:[UIColor whiteColor]];
    [self.cantGoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}

- (IBAction)cantGoAction:(id)sender {
    
    statusNum = @"3";
    
    userStatus = YES;
    
    [self updateEventStatusServiceCall];
    
    [self.cantGoBtn setBackgroundColor:[UIColor darkGrayColor]];
    [self.cantGoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.goingBtn setBackgroundColor:[UIColor whiteColor]];
    [self.goingBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.interestedBtn setBackgroundColor:[UIColor whiteColor]];
    [self.interestedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    
    
}


-(void)closeVoteAction:(UIButton*)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete vote"
                                                                   message:@"Are you sure to delete this vote?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              isvoteCancelled = YES;
                                                              
                                                              if ([Utilities isInternetConnectionExists]) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                                                                  });
                                                                  
                                                                  NSDictionary *requestDict;
                                                                  NSString *urlStr = [NSString stringWithFormat:@"%@closevote",BASEURL];
                                                                  NSInteger * eventIdNum = [self.eventIdStr intValue];
                                                                  requestDict = @{
                                                                                  @"event_id":[NSString stringWithFormat:@"%d",eventIdNum],
                                                                                  @"voting_id":[[singleTonInstance.votesArray objectAtIndex:sender.tag] objectForKey:@"id"]
                                                                                  };
                                                                  
                                                                  [singleTonInstance.votesArray removeObjectAtIndex:sender.tag] ;
                                                                  
                                                                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                      ServiceManager *service = [ServiceManager sharedInstance];
                                                                      service.delegate = self;
                                                                      
                                                                      
                                                                      [service  handleRequestWithDelegates:urlStr info:requestDict];
                                                                      
                                                                  });
                                                                  
                                                                  
                                                              }
                                                              else
                                                              {
                                                                  [Utilities displayCustemAlertViewWithOutImage:@"Please Check Your Internet connection" :self.view];
                                                              }
                                                              
                                                          }];
    
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:noAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    [self.view endEditing:YES];
    
    
}

- (IBAction)imageSliderAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContentViewController *eventPage = [storyboard instantiateViewControllerWithIdentifier:@"ContentView"];
    
    //eventPage.eventIdStr = self.eventIdStr;
    
    [self.navigationController pushViewController:eventPage animated:YES];
    
}


- (IBAction)equiDistanceFilter:(id)sender {
    
    isEquiDistance = YES;
    [self equiDistanceServiceCall];
}





#pragma mark - collection view delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _GroupCollectionView) {
        
        return singleTonInstance.barsArrayReady.count;
    }
    
    else
        return numbersArr.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
  //  dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        
    
        
        
        if (collectionView == self.GroupCollectionView)
        {
            
            GroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCollectionViewCell" forIndexPath:indexPath];
            
            if (singleTonInstance.filterResultArray.count>0) {
                
                cell.restaurantTitle.text =  [[singleTonInstance.filterResultArray objectAtIndex:indexPath.row ]objectForKey:@"merchant_name"];
                
                NSString * distanceStr = [Utilities null_ValidationString:[[singleTonInstance.filterResultArray objectAtIndex:indexPath.row ]objectForKey:@"distance"]];
                
                cell.distanceLbl.text = [NSString stringWithFormat:@"%@km",distanceStr];
                
                [Utilities addShadowtoView:cell.backView];
                
                NSString * imgName =  [[singleTonInstance.filterResultArray objectAtIndex:indexPath.row ]objectForKey:@"merchant_banner"];
                
                NSString * ImageString = [NSString stringWithFormat:@"http://testingmadesimple.org/buzzed/uploads/merchant_banners/%@",imgName];
                
                NSLog(@"images uploaded string %@",ImageString);
                
                NSURL *url = [NSURL URLWithString:ImageString];
                [ cell.restaurantImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
                
                 cell.areaOfRestaurant.text = [[singleTonInstance.filterResultArray objectAtIndex:indexPath.row ]objectForKey:@"address"];
                
            }
            else
            {
                
                cell.restaurantTitle.text =  [[singleTonInstance.barsArrayReady objectAtIndex:indexPath.row ]objectForKey:@"merchant_name"];
                
                NSString * distanceStr = [Utilities null_ValidationString:[[singleTonInstance.barsArrayReady objectAtIndex:indexPath.row ]objectForKey:@"distance"]];
                
                cell.distanceLbl.text = [NSString stringWithFormat:@"%@km",distanceStr];
                
                [Utilities addShadowtoView:cell.backView];
                
                NSString * imgName =  [[singleTonInstance.barsArrayReady objectAtIndex:indexPath.row ]objectForKey:@"merchant_banner"];
                
                NSString * ImageString = [NSString stringWithFormat:@"http://testingmadesimple.org/buzzed/uploads/merchant_banners/%@",imgName];
                
                NSLog(@"images uploaded string %@",ImageString);
                
                NSURL *url = [NSURL URLWithString:ImageString];
                [ cell.restaurantImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
                
                 cell.areaOfRestaurant.text = [[singleTonInstance.barsArrayReady objectAtIndex:indexPath.row ]objectForKey:@"address"];
                
            }
            
            cell.autoresizingMask = NO;
            
           
            cell.areaOfRestaurant.adjustsFontSizeToFitWidth = YES;
            
            cell.AddtoPreferdBtn.tag=indexPath.row;
            
            [cell.AddtoPreferdBtn addTarget:self action:@selector(addToPreferedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.AddtoPreferdBtn.hidden = YES;
            
            // cell.nameLbl.text = [futuredArray objectAtIndex:indexPath.row];
            
            
            //    cell.imageViw.layer.borderWidth = 2;
            //    cell.imageViw.layer.borderColor = REDCOLOR.CGColor;
            //    cell.imageViw.layer.cornerRadius = 21;
            //    cell.imageViw.clipsToBounds = YES;
            
//            cell.layer.borderWidth = 0.5;
//
//            cell.layer.cornerRadius = 4;
            
            [Utilities addShadowtoView:cell.cellView];
            
            [Utilities addShadowtoView:cell.viewForLastBaselineLayout];
            
            //  });
            return cell;
        }
        else
        {
        
            eventReadyCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"eventReadyCollectionCell" forIndexPath:indexPath];
            
            cell.imgViw.image = [UIImage imageNamed:@"person.png"];
            //http://testingmadesimple.org/foody/uploads/profile_images/
            [Utilities roundCornerImageView:cell.imgViw];
            cell.imgViw.clipsToBounds = YES;
            cell.friendName.text = [Utilities null_ValidationString:[[numbersArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
            [cell.friendName adjustsFontSizeToFitWidth];
            
            
            NSString * imgName =  [[numbersArr objectAtIndex:indexPath.row ]objectForKey:@"profile_image"];
            
            NSString * ImageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/profile_images/%@",imgName];
            
            NSLog(@"images uploaded string %@",ImageString);
            
            NSURL *url = [NSURL URLWithString:ImageString];
            [ cell.imgViw sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"name_icon.png"]];
        
            //cell.imgViw.layer.cornerRadius = cell.imgViw.frame.size.width/2;
            
            [Utilities addShadowtoView:cell.viewForLastBaselineLayout];
            
            //  });
            return cell;
        }
        
    
    
}






- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.GroupCollectionView) {
        return 40;
    }
    else
    {
        return 5;
    }
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.GroupCollectionView) {
        return CGSizeMake(collectionView.frame.size.width - 40, collectionView.frame.size.height);
    }
    else
    {
        return CGSizeMake(40, 40);
    }
    
    
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.GroupCollectionView) {
        return UIEdgeInsetsMake(0, 20, 0, 0);
    }
    else
    {
        return UIEdgeInsetsMake(1, 2, 0, 1);
    }
    
}




//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//
//    GroupCollectionViewCell *cell;
//
//
//
//    CGFloat totalCellWidth = cell.frame.size.width * singleTonInstance.barsArray.count;
//    CGFloat totalSpacingWidth = 1.5 * (((float)singleTonInstance.barsArray.count - 1) < 0 ? 0 :singleTonInstance.barsArray.count - 1);
//    CGFloat leftInset = (self.view.frame.size.width - (totalCellWidth + totalSpacingWidth)) / 1.5;
//    CGFloat rightInset = leftInset;
//    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
//    return sectionInset;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        
        if (collectionView == self.GroupCollectionView) {
            detailRestaurantViewController *detailPage = [storyboard instantiateViewControllerWithIdentifier:@"detailRestaurantViewController"];
            
            detailPage.dict = [singleTonInstance.barsArrayReady objectAtIndex:indexPath.row];
            
            [self.navigationController pushViewController:detailPage animated:YES];

        }
        
        
    });
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    typedef NS_ENUM(NSInteger, ScrollDirection) {
        ScrollDirectionNone,
        ScrollDirectionRight,
        ScrollDirectionLeft,
        ScrollDirectionUp,
        ScrollDirectionDown,
        ScrollDirectionCrazy,
    };
    
    ScrollDirection scrollDirection;

    if (scrollView.tag ==1)
    {
        
        NSLog(@"tag success");
        
        GroupCollectionViewCell * firstCell = [self.GroupCollectionView.visibleCells objectAtIndex:0];
        
        NSIndexPath *firstIndexPath = [self.GroupCollectionView indexPathForCell:firstCell];
        
        NSLog(@"0  0 00 0 %@", firstIndexPath);

        
        for (int i=0; i<markerArray.count; i++) {
            
            GMSMarker *myMarker = markerArray[i];
            
            if ([myMarker.snippet isEqualToString:[[barsArray objectAtIndex:firstIndexPath.row] objectForKey:@"merchant_id"]]){
                
                [self mapView:mapView didTapMarker:myMarker];
                
                singleTonInstance.summaryDict =  [singleTonInstance.barsArrayReady objectAtIndex:i];
                
                //[self highlightMarker:myMarker];
                
                
                
            }
            
        }
        
    }
    
    else
        
    {
        
        NSLog(@"tableview is called here ");
        
    }
    
//    if (self.lastContentOffset > scrollView.contentOffset.x) {
//        scrollDirection = ScrollDirectionRight;
//
//
//        GroupCollectionViewCell * firstCell = [self.GroupCollectionView.visibleCells objectAtIndex:0];
//
//        NSIndexPath *firstIndexPath = [self.GroupCollectionView indexPathForCell:firstCell];
//
//        NSLog(@"0  0 00 0 %@", firstIndexPath);
//
//        if (isEventMap == YES && isfilter == YES && singleTonInstance.filterResultArray.count>0) {
//
//            for (int i=0; i<markerArray.count; i++) {
//                GMSMarker *myMarker = markerArray[i];
//                if ([myMarker.snippet isEqualToString:[[singleTonInstance.filterResultArray objectAtIndex:firstIndexPath.row] objectForKey:@"merchant_id"]]){
//                    [self mapView:mapView didTapMarker:myMarker];
//                    //[self highlightMarker:myMarker];
//
//                }
//            }
//
//        }
//        else
//        {
//            for (int i=0; i<markerArray.count; i++) {
//                GMSMarker *myMarker = markerArray[i];
//                if ([myMarker.snippet isEqualToString:[[singleTonInstance.barsArrayReady objectAtIndex:firstIndexPath.row] objectForKey:@"merchant_id"]]){
//                    [self mapView:mapView didTapMarker:myMarker];
//                    //[self highlightMarker:myMarker];
//
//                }
//            }
//
//        }
//
//
//
//            CGRect visibleRect = (CGRect){.origin = self.GroupCollectionView.contentOffset, .size = firstCell.bounds.size};
//            CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
//            NSIndexPath *visibleIndexPath = [self.GroupCollectionView indexPathForItemAtPoint:visiblePoint];
//
//       // [singleTonInstance.barsArray objectAtIndex:firstIndexPath.row];
//
//        GMSMarker * newMarker = [[GMSMarker alloc] init];
//        CGFloat latitude;
//        CGFloat longitude;
//        if (isEventMap == YES && isfilter == YES && singleTonInstance.filterResultArray.count>0) {
//            latitude = [[[singleTonInstance.filterResultArray objectAtIndex:firstIndexPath.row] objectForKey:@"latitude"] doubleValue];
//            longitude = [[[singleTonInstance.filterResultArray objectAtIndex:firstIndexPath.row] objectForKey:@"longitude"] doubleValue];
//            newMarker.position = CLLocationCoordinate2DMake(latitude, longitude);
//            newMarker.snippet = [[singleTonInstance.filterResultArray objectAtIndex:firstIndexPath.row] objectForKey:@"merchant_id"];
//        }
//        else
//        {
//            latitude = [[[singleTonInstance.barsArrayReady objectAtIndex:firstIndexPath.row] objectForKey:@"latitude"] doubleValue];
//            longitude = [[[singleTonInstance.barsArrayReady objectAtIndex:firstIndexPath.row] objectForKey:@"longitude"] doubleValue];
//            newMarker.position = CLLocationCoordinate2DMake(latitude, longitude);
//            newMarker.snippet = [[singleTonInstance.barsArrayReady objectAtIndex:firstIndexPath.row] objectForKey:@"merchant_id"];
//        }
//
//        marker = newMarker;
//
//        //marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
//
////
////
////
////
//        [self mapView:mapView didTapMarker:marker];
//        //
//        //    [self mapView:mapView markerInfoWindow:marker];
//
//        //   [self highlightMarker:marker];
//
//        // for marker image icon custom resizing i used frame and imageView , imageView displayed in marker.iconView
//        //    CGRect frame = CGRectMake(0, 0, 40, 40);
//        //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//        //
//        //    imageView.image = [UIImage imageNamed:@"map_84x84.png"];
//        //    marker.iconView = imageView;
//        //    marker.iconView.clipsToBounds =YES;
//        // pointMarker.iconView.layer.cornerRadius = 38;
//        //pointMarker.icon = [UIImage imageNamed:@"map_active_icon.png"];
//        marker.map = mapView;
//
//
//    } else if (self.lastContentOffset < scrollView.contentOffset.x) {
//        scrollDirection = ScrollDirectionLeft;
//
//
//        GroupCollectionViewCell * firstCell = [self.GroupCollectionView.visibleCells objectAtIndex:0];
//
//        NSIndexPath *firstIndexPath = [self.GroupCollectionView indexPathForCell:firstCell];
//
//        NSLog(@"0  0 00 0 %@", firstIndexPath);
//
//        //    CGRect visibleRect = (CGRect){.origin = self.GroupCollectionView.contentOffset, .size = firstCell.bounds.size};
//        //    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
//        //    NSIndexPath *visibleIndexPath = [self.GroupCollectionView indexPathForItemAtPoint:visiblePoint];
//
//        GMSMarker * newMarker = [[GMSMarker alloc] init];
//
//        CGFloat latitude;
//
//        CGFloat longitude;
//
//        if (isEventMap == YES && isfilter == YES && singleTonInstance.filterResultArray.count>0) {
//
//
//            [singleTonInstance.filterResultArray objectAtIndex:firstIndexPath.row];
//
//
//            latitude = [[[singleTonInstance.filterResultArray objectAtIndex:firstIndexPath.row] objectForKey:@"latitude"] doubleValue];
//            longitude = [[[singleTonInstance.filterResultArray objectAtIndex:firstIndexPath.row] objectForKey:@"longitude"] doubleValue];
//            newMarker.position = CLLocationCoordinate2DMake(latitude, longitude);
//            newMarker.snippet = [[singleTonInstance.filterResultArray objectAtIndex:firstIndexPath.row] objectForKey:@"merchant_id"];
//            marker = newMarker;
//        }
//        else
//        {
//            [singleTonInstance.barsArrayReady objectAtIndex:firstIndexPath.row];
//
//
//            latitude = [[[singleTonInstance.barsArrayReady objectAtIndex:firstIndexPath.row] objectForKey:@"latitude"] doubleValue];
//            longitude = [[[singleTonInstance.barsArrayReady objectAtIndex:firstIndexPath.row] objectForKey:@"longitude"] doubleValue];
//            newMarker.position = CLLocationCoordinate2DMake(latitude, longitude);
//            newMarker.snippet = [[singleTonInstance.barsArrayReady objectAtIndex:firstIndexPath.row] objectForKey:@"merchant_id"];
//            marker = newMarker;
//
//        }
//
//
//        [self mapView:mapView didTapMarker:marker];
//
//        marker.map = mapView;
//
//    }
//    else
//    {
//
//
//    }
//
//    self.lastContentOffset = scrollView.contentOffset.x;
    
    // [self.GroupCollectionView scrollToItemAtIndexPath:visibleIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


#pragma mark - tableview delegate methods




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (tableView == self.voteTableView) {
        if (!singleTonInstance.votesArray.count) {
            self.voteTableView.hidden = YES;
            addButton.hidden = NO;
            self.createVoteView.hidden = NO;
        }
        else
        {
            self.voteTableView.hidden = NO;
            addButton.hidden  = NO;
        }
        return singleTonInstance.votesArray.count;
    }
    else
    return allMessages.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.voteTableView) {
        
        return 400;
    }
    else
    {
        UIView *bubble = allMessages[indexPath.row];
        return bubble.frame.size.height+20;
    }
    
    
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == self.voteTableView) {
        
        
        
        static NSString *CellIdentifier = @"voteTableViewCell";
        
        voteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[voteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [Utilities addShadowtoView:cell.voteCellView];
        
        
        NSString * option1CountStr = [NSString stringWithFormat:@"%d",[[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option1"] objectForKey:@"count"] intValue]];
    
        cell.option1Count.text = [Utilities null_ValidationString: option1CountStr];
        
        NSString * option2CountStr = [NSString stringWithFormat:@"%d",[[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option2"] objectForKey:@"count"] intValue]];
        
        cell.option2Count.text = [Utilities null_ValidationString: option2CountStr];
        
        NSString * option3CountStr = [NSString stringWithFormat:@"%d",[[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option3"] objectForKey:@"count"] intValue]];
        
        cell.option3Count.text = [Utilities null_ValidationString: option3CountStr];
        
        NSString * option4CountStr = [NSString stringWithFormat:@"%d",[[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option4"] objectForKey:@"count"] intValue]];
        
        cell.option4Count.text = [Utilities null_ValidationString: option4CountStr];
        
        
        NSString * totalCountStr = [NSString stringWithFormat:@"%d",[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"totalcount"] intValue] ] ;
        
        cell.totalVotesCount.text = [NSString stringWithFormat:@"%@ Votes",[Utilities null_ValidationString: totalCountStr]];
        
        [cell.totalVotesCount adjustsFontSizeToFitWidth];
        
        
        cell.questionLabel.text = [Utilities null_ValidationString:[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"question"]] ;
        
        cell.option1.text = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option1"] objectForKey:@"option_name"] ];
        
        cell.option2.text = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option2"] objectForKey:@"option_name"] ];
        
        cell.option3.text = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option3"] objectForKey:@"option_name"] ];
        
        cell.option4.text = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option4"] objectForKey:@"option_name"] ];
        
        if (option1Select.length>0 || ![option1Select isKindOfClass:[NSNull class]]) {
            if ([cell.questionLabel.text isEqualToString:option1Select]) {
                
                [cell.button1 setImage:[UIImage imageNamed:@"mark_active.png"]  forState:UIControlStateSelected];
            }
            else
            {
                [cell.button1 setImage:[UIImage imageNamed:@"mark.png"]  forState:UIControlStateNormal];
            }
        }
        
        [cell.option1 adjustsFontSizeToFitWidth];
        [cell.option2 adjustsFontSizeToFitWidth];
        [cell.option3 adjustsFontSizeToFitWidth];
        [cell.option4 adjustsFontSizeToFitWidth];
        cell.cellVoteBtn.layer.cornerRadius = 4;
        
        [cell.questionLabel adjustsFontSizeToFitWidth];
        
        cell.button1.tag = indexPath.row;
        cell.button2.tag = indexPath.row;
        cell.button3.tag = indexPath.row;
        cell.button4.tag = indexPath.row;
        cell.cellVoteBtn.tag = indexPath.row;
        cell.closeButton.tag = indexPath.row;
        
        [cell.button1 addTarget:self action:@selector(voteButton1Action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button2 addTarget:self action:@selector(voteButton2Action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button3 addTarget:self action:@selector(voteButton3Action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button4 addTarget:self action:@selector(voteButton4Action:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.cellVoteBtn addTarget:self action:@selector(performVote:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.closeButton addTarget:self action:@selector(closeVoteAction:) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        return cell;
        
    }
    else
    {
        
        
        static NSString *CellIdentifier = @"chatCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //    cell.textLabel.text= [Utilities null_ValidationString:[[chatArray objectAtIndex:indexPath.row] valueForKey:@"message"]];
        //
        //    [cell.textLabel sizeToFit];
        //
        //    cell.textLabel.textAlignment = UITextAlignmentLeft;
        //    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //    [cell.textLabel setTextColor:[UIColor grayColor]];
        //
        //    CGSize expectedLabelSize = [[[chatArray objectAtIndex:indexPath.row] valueForKey:@"message"] sizeWithFont:cell.textLabel.font
        //                                constrainedToSize:cell.textLabel.frame.size
        //                                    lineBreakMode:UILineBreakModeWordWrap];
        //
        //    CGRect newFrame = cell.textLabel.frame;
        //    newFrame.size.height = expectedLabelSize.height;
        //    cell.textLabel.frame = newFrame;
        //    cell.textLabel.numberOfLines = 0;
        //    [cell.textLabel sizeToFit];
        
        
        UIView *chatBubble = [allMessages objectAtIndex:indexPath.row];
        chatBubble.tag = indexPath.row;
        
        for (int i=0; i<cell.contentView.subviews.count; i++)
        {
            UIView *subV = cell.contentView.subviews[i];
            
            if (subV.tag != chatBubble.tag)
                [subV removeFromSuperview];
            
        }
        
        [cell.contentView addSubview:chatBubble];
        
        cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        
        // [self.chatTableView setRowHeight:[Utilities getLabelHeight:cell.textLabel]+5];
        
        // cell.imageView.image = [UIImage imageNamed:@"fb_icon.png"];
        
        
        return cell;
        
        
        
    }
    
    
}


//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.voteTableView ) {
//        [pathsaveArray addObject:indexPath.row];
//    }
//
//}




-(void) didSelectMenuOptionAtIndex:(NSInteger)row
{
    NSLog(@"Floating action tapped index %tu",row);
    
    if (row == 0)
    {
        NSLog(@"create vote");
        self.voteTableView.hidden = YES;
        self.createVoteView.hidden = NO;
    }

    else if (row == 1 && singleTonInstance.votesArray.count>0)
    {
        self.voteTableView.hidden = NO;
        self.createVoteView.hidden = YES;
    }
    else
    {
        self.voteTableView.hidden = YES;
        [Utilities displayToastWithMessage:@"No Votes Created Yet"];
    }
    
}



-(void)voteButton1Action:(UIButton*)sender
{
    NSLog(@"rt rt rt rt rt %d",sender.tag);
    
    option1Select = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:sender.tag] objectForKey:@"option1"] objectForKey:@"option_name"] ];
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        if ([[singleTonInstance.votesArray objectAtIndex:sender.tag] objectForKey:@"id"] == [voteIdArray objectAtIndex:sender.tag] ) {
        [selectedOptionsArray removeObject:option1Select];
     //       [pathsaveArray removeObject:sender.tag];
            [pathOptionArray removeObject:@"option1"];
           
        }
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"]  forState:UIControlStateSelected];
        if ([[singleTonInstance.votesArray objectAtIndex:sender.tag] objectForKey:@"id"] == [voteIdArray objectAtIndex:sender.tag] ) {
             [selectedOptionsArray addObject:option1Select];
       //     [pathsaveArray addObject:sender.tag];
            [pathOptionArray addObject:@"option1"];
             
        }
        else
        {
            [selectedOptionsArray removeObject:option1Select];
            
        }
        [sender setSelected:YES];
    }
}
-(void)voteButton2Action:(UIButton*)sender
{
    option2Select = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:sender.tag] objectForKey:@"option2"] objectForKey:@"option_name"] ];
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [selectedOptionsArray removeObject:option2Select];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"]  forState:UIControlStateSelected];
        [selectedOptionsArray addObject:option2Select];
        [sender setSelected:YES];
    }
}
-(void)voteButton3Action:(UIButton*)sender
{
     option3Select = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:sender.tag] objectForKey:@"option3"] objectForKey:@"option_name"] ];
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [selectedOptionsArray removeObject:option3Select];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"]  forState:UIControlStateSelected];
        [selectedOptionsArray addObject:option3Select];
        [sender setSelected:YES];
    }
}
-(void)voteButton4Action:(UIButton*)sender
{
     option4Select = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:sender.tag] objectForKey:@"option4"] objectForKey:@"option_name"] ];
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [selectedOptionsArray removeObject:option4Select];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"]  forState:UIControlStateSelected];
        [selectedOptionsArray addObject:option4Select];
        [sender setSelected:YES];
    }
}


-(void)performVote:(UIButton*)sender
{
    voteBtnPath = sender.tag;
    
    if (selectedOptionsArray.count>0) {
        [Utilities displayToastWithMessage:@"Voted Successfully"];
        

        NSLog(@"votes options are %@",selectedOptionsArray);
        
        isvotesVoted = YES;
        
        [self addusereventvote];
        
    }
    else
    {
        [ISMessages showCardAlertWithTitle:nil
                                   message:@"Select Atleast One Option To Vote"
                                  duration:3.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeInfo
                             alertPosition:ISAlertPositionTop
                                   didHide:^(BOOL finished) {
                                       
                                       
                                   }];
    }
}



- (IBAction)onBottomLeftButtonClicked:(UIButton *)sender {

}




- (void)scrollToTheBottom:(BOOL)animated
{
    if (chatArray.count>0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:chatArray.count-1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}


- (NSString*)getDateTimeStringFromNSDate: (NSDate*)date
{
    NSString *dateTimeString = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM, hh:mm a"];
    dateTimeString = [dateFormatter stringFromDate:date];
    
    return dateTimeString;
}


-(void)handleUpdatedData:(NSNotification *)notification {
    [self chatAction:self];
    
    //[self chatHistoryServiceCall];

}







# pragma mark - Popover Presentation Controller Delegate




- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}

- (void)dismissMe {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // called when a Popover is dismissed
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
    
    // called when the Popover changes position
}













#pragma mark - Message UI creation function(s)

- (UIView*)createMessageWithText: (NSString*)text Image: (UIImage*)image DateTime: (NSString*)dateTimeString isReceived: (BOOL)isReceived Time: (NSString *)TimeStr
{
    //Get screen width
    double screenWidth = self.view.frame.size.width;
    
    CGFloat maxBubbleWidth = screenWidth-50;
    
    UIView *outerView = [[UIView alloc] init];
    
    UIView *chatBubbleView = [[UIView alloc] init];
    chatBubbleView.backgroundColor = [UIColor whiteColor];
    chatBubbleView.layer.masksToBounds = YES;
    chatBubbleView.clipsToBounds = NO;
    chatBubbleView.layer.cornerRadius = 4;
    chatBubbleView.layer.shadowOffset = CGSizeMake(0, 0.7);
    chatBubbleView.layer.shadowRadius = 4;
    chatBubbleView.layer.shadowOpacity = 0.4;
    
    UIView *chatBubbleContentView = [[UIView alloc] init];
    chatBubbleContentView.backgroundColor = [UIColor whiteColor];
    chatBubbleContentView.clipsToBounds = YES;
    
    //Add time
    UILabel *chatTimeLabel;
    if (dateTimeString != nil)
    {
        chatTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
        chatTimeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        chatTimeLabel.textColor = [UIColor colorWithRed:0.63 green:0.03 blue:0.03 alpha:1.0];
        chatTimeLabel.text = dateTimeString;
        chatTimeLabel.textColor = [UIColor darkTextColor];
        
        [chatBubbleContentView addSubview:chatTimeLabel];
    }
    
    //Add Image
    UIImageView *chatBubbleImageView;
    if (image != nil)
    {
        chatBubbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, maxBubbleWidth-30, maxBubbleWidth-30)];
        chatBubbleImageView.image = image;
        chatBubbleImageView.contentMode = UIViewContentModeScaleAspectFill;
        chatBubbleImageView.layer.masksToBounds = YES;
        chatBubbleImageView.layer.cornerRadius = 4;
        
        [chatBubbleContentView addSubview:chatBubbleImageView];
    }
    
   
    
    //Add Text
    UILabel *chatBubbleLabel;
    if (text != nil)
    {
        UIFont *messageLabelFont = [UIFont systemFontOfSize:16];
        
        CGSize maximumLabelSize;
        if (chatBubbleImageView != nil)
        {
            maximumLabelSize = CGSizeMake(chatBubbleImageView.frame.size.width, 1000);
            
            CGSize expectedLabelSize = [text sizeWithFont:messageLabelFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            chatBubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21+chatBubbleImageView.frame.size.height, expectedLabelSize.width, expectedLabelSize.height+10)];
        }
        else
        {
            maximumLabelSize = CGSizeMake(maxBubbleWidth, 1000);
            
            CGSize expectedLabelSize = [text sizeWithFont:messageLabelFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            chatBubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, expectedLabelSize.width, expectedLabelSize.height)];
        }
        
        chatBubbleLabel.frame = CGRectMake(chatBubbleLabel.frame.origin.x, chatBubbleLabel.frame.origin.y+5, chatBubbleLabel.frame.size.width, chatBubbleLabel.frame.size.height+10);
        if (isReceived==0) {
            chatBubbleLabel.textColor = [UIColor whiteColor];
        }
        else
            chatBubbleLabel.textColor = [UIColor lightGrayColor];
        
        chatBubbleLabel.text = text;
        chatBubbleLabel.font = messageLabelFont;
        chatBubbleLabel.numberOfLines = 100;
        
        [chatBubbleContentView addSubview:chatBubbleLabel];
    }
    
    
    
    // add time label
    
    UILabel * chatDetailTime;
    if (TimeStr != nil)
    {
        chatDetailTime = [[UILabel alloc] initWithFrame:CGRectMake(0, chatBubbleLabel.frame.origin.y+chatBubbleLabel.frame.size.height, 110, 16)];
        chatDetailTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        chatDetailTime.textColor = [UIColor colorWithRed:0.63 green:0.03 blue:0.03 alpha:1.0];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date  = [dateFormatter dateFromString:TimeStr];
        
        // Convert to new Date Format
        [dateFormatter setDateFormat:@"EEE MMM dd hh:mm a"];
        
        NSString *newDate = [dateFormatter stringFromDate:date];
        
        
        chatDetailTime.text = newDate;
        
        if (isReceived==0) {
            chatDetailTime.textColor = [UIColor whiteColor];
        }
        else
        chatDetailTime.textColor = [UIColor lightGrayColor];
        
        [chatBubbleContentView addSubview:chatDetailTime];
    }
    
    
    [chatBubbleView addSubview:chatBubbleContentView];
    
    
    CGFloat totalHeight = 0;
    CGFloat decidedWidth = 0;
    for (UIView *subView in chatBubbleContentView.subviews)
    {
        totalHeight += subView.frame.size.height;
        
        CGFloat width = subView.frame.size.width;
        if (decidedWidth < width)
            decidedWidth = width;
    }
    
    chatBubbleContentView.frame = CGRectMake(5, 5, decidedWidth, totalHeight);
    chatBubbleView.frame = CGRectMake(10, 10, chatBubbleContentView.frame.size.width+10, chatBubbleContentView.frame.size.height+10);
    
    
    outerView.frame = CGRectMake(7, 0, chatBubbleView.frame.size.width, chatBubbleView.frame.size.height);
    
    UIImageView *arrowIV = [[UIImageView alloc] init];
    [outerView addSubview:chatBubbleView];
    arrowIV.image = [UIImage imageNamed:@"chat_arrow"];
    arrowIV.clipsToBounds = NO;
    arrowIV.layer.shadowRadius = 4;
    arrowIV.layer.shadowOpacity = 0.4;
    arrowIV.layer.shadowOffset = CGSizeMake(-7.0, 0.7);
    arrowIV.layer.zPosition = 1;
    arrowIV.frame = CGRectMake(chatBubbleView.frame.origin.x-7, chatBubbleView.frame.size.height-10, 11, 14);
    
    if (isReceived == 0)
    {
        chatBubbleContentView.frame = CGRectMake(5, 5, decidedWidth, totalHeight);
        chatBubbleView.frame = CGRectMake(screenWidth-(chatBubbleContentView.frame.size.width+10)-10, 10, chatBubbleContentView.frame.size.width+10, chatBubbleContentView.frame.size.height+10);
        
       /*
         chatBubbleView.backgroundColor = Rgb2UIColor(191,179,183);
         chatTimeLabel.backgroundColor = Rgb2UIColor(191,179,183);
         chatBubbleLabel.backgroundColor = Rgb2UIColor(191,179,183);
         chatBubbleContentView.backgroundColor = Rgb2UIColor(191,179,183);
        */
        
        chatBubbleView.backgroundColor = [UIColor colorWithRed:0.40 green:0.71 blue:0.09 alpha:1.0];
        chatTimeLabel.backgroundColor =  [UIColor colorWithRed:0.40 green:0.71 blue:0.09 alpha:1.0];
        chatBubbleLabel.backgroundColor =  [UIColor colorWithRed:0.40 green:0.71 blue:0.09 alpha:1.0];
        chatBubbleContentView.backgroundColor =  [UIColor colorWithRed:0.40 green:0.71 blue:0.09 alpha:1.0];
        
        arrowIV.transform = CGAffineTransformMakeScale(-1, 1);
        arrowIV.frame = CGRectMake(chatBubbleView.frame.origin.x+chatBubbleView.frame.size.width-4, chatBubbleView.frame.size.height-10, 11, 14);
        
        outerView.frame = CGRectMake(screenWidth-((screenWidth+chatBubbleView.frame.size.width)-chatBubbleView.frame.size.width)-7, 0, chatBubbleView.frame.size.width, chatBubbleView.frame.size.height);
        
        arrowIV.image = [arrowIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
       // [arrowIV setTintColor:Rgb2UIColor(191,179,183)];
        [arrowIV setTintColor:[UIColor colorWithRed:0.40 green:0.71 blue:0.09 alpha:1.0]];
        
    }
    
    [outerView addSubview:arrowIV];
    
    return outerView;
}




#pragma mark - on tap of marker method


-(void)highlightMarker:(GMSMarker *)marker{
    
    //#8B0000
    
    NSString *hexStr3 = @"#8B0000";
    
    
    UIColor *color1 = [Utilities getUIColorObjectFromHexString:hexStr3 alpha:0.9];
    
    
    if([mapView.selectedMarker isEqual:marker]){
        
        
        NSString * labTitle ;
        
        for (int i =0; i<barsArray.count; i++)
        {
//            if ([[[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"] isEqualToString:marker.title]) {
//                labTitle = [NSString stringWithFormat:@"%d",i+1];
//            }
            
            if ([[[barsArray objectAtIndex:i ]objectForKey:@"merchant_id"] isEqualToString:marker.snippet]) {
                labTitle = [NSString stringWithFormat:@"%d",i+1];
            }
        }
        
        
        
        UIImageView * imgView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 40, 40)];
        imgView.image = [UIImage imageNamed:@"map_84x84.png"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 40, 40)];
        label.text = [NSString stringWithFormat:@"%@",labTitle];
        [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        // label.layer.cornerRadius = 21;
        label.layer.masksToBounds = YES;
        // label.backgroundColor = [REDCOLOR colorWithAlphaComponent:1];
        
        
        
        
        //grab it
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, [[UIScreen mainScreen] scale]);
        [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        [label.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * icon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        marker.icon = icon;
        
        
        marker.map = mapView;
        //mapView.selectedMarker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
    }
    
    
    
}

-(void)unhighlightMarker:(GMSMarker* )marker{
    
    NSString * labTitle ;
    
    for (int i =0; i<barsArray.count; i++)
    {
//        if ([[[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"] isEqualToString:marker.title]) {
//            labTitle = [NSString stringWithFormat:@"%d",i+1];
//        }
        if ([[[barsArray objectAtIndex:i ]objectForKey:@"merchant_id"] isEqualToString:marker.snippet]) {
            labTitle = [NSString stringWithFormat:@"%d",i+1];
        }
    }
    
    
    
    UIImageView * imgView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 40, 40)];
    imgView.image = [UIImage imageNamed:@"map_64x64.png"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 40, 40)];
    label.text = [NSString stringWithFormat:@"%@",labTitle];
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    // label.layer.cornerRadius = 21;
    label.layer.masksToBounds = YES;
    // label.backgroundColor = [REDCOLOR colorWithAlphaComponent:1];
    
    //grab it
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    marker.icon = icon;
    
    
    marker.map = mapView;
    
}



- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSLog(@"marker id is %@",marker.snippet);
        
        NSLog(@"my desired array is %@",singleTonInstance.barsArrayReady)  ;
        
        NSString * barIdStr;
        
        int indeXNum;
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        NSMutableArray * latArr = [[NSMutableArray alloc]init];
        
        NSMutableArray * longArr = [[NSMutableArray alloc]init];

        
        if (isEventMap == YES && isfilter == YES && singleTonInstance.filterResultArray.count>0) {

            
            
            for (int i = 0; i<singleTonInstance.filterResultArray.count; i++)
            {
                if ([marker.snippet isEqualToString:[[singleTonInstance.filterResultArray objectAtIndex:i] objectForKey:@"merchant_id"]])
                {
                    barIdStr = marker.snippet;
                    
                    indeXNum = i;
                    
                    seperateDict = [singleTonInstance.filterResultArray objectAtIndex:i];
                    
                    CGRect frame = CGRectMake(0, 0, 70, 70);
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                    
                    
                    CGPoint point = [mapView.projection pointForCoordinate:marker.position];
                    
                    point.x = point.x + 100;
                    
                    GMSCameraUpdate *camera = [GMSCameraUpdate setTarget:[mapView.projection coordinateForPoint:point]];
                    
                    [mapView animateWithCameraUpdate:camera];
                    
                    mapView.selectedMarker = marker    ;
                    
                    
                    
                    self.isMarkerActive = TRUE;
                    
                    [self highlightMarker:marker];
                    
                    
                }
                
                
                
            }
            
            
        }
        else
        {
            
            for (int i = 0; i<singleTonInstance.barsArrayReady.count; i++)
            {
                if ([marker.snippet isEqualToString:[[singleTonInstance.barsArrayReady objectAtIndex:i] objectForKey:@"merchant_id"]])
                {
                    barIdStr = marker.snippet;
                    
                    indeXNum = i;
                    
                    seperateDict = [singleTonInstance.barsArrayReady objectAtIndex:i];
                    
                    CGRect frame = CGRectMake(0, 0, 70, 70);
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                    
                    
                    CGPoint point = [mapView.projection pointForCoordinate:marker.position];
                    
                    point.x = point.x + 100;
                    
                    GMSCameraUpdate *camera = [GMSCameraUpdate setTarget:[mapView.projection coordinateForPoint:point]];
                    
                    [mapView animateWithCameraUpdate:camera];
                    
                    mapView.selectedMarker = marker    ;
                    
                    
                    
                    self.isMarkerActive = TRUE;
                    
                    [self highlightMarker:marker];
                    
                    
                }
                
                
                
            }
            
        }
        
        
        
        UIImageView * imageViw ;
        
        
       

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
          
            
            [super viewDidLayoutSubviews];
            
            [self.GroupCollectionView layoutIfNeeded];
            
            
            [self.GroupCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indeXNum inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        });
        
        
    });
    
    
    return YES;
}




- (void)mapView:(GMSMapView *)amapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    
    if(self.isMarkerActive == TRUE){
        if(amapView.selectedMarker != nil){
            self.isMarkerActive = FALSE;
            [self unhighlightMarker:selectedMarker];
            selectedMarker = nil;
            amapView.selectedMarker = nil;
        }
    }
}


- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    
    
    /// g3 code added
    if(self.isMarkerActive == TRUE){
        [self unhighlightMarker:selectedMarker];
    }
    selectedMarker = marker;
    self.isMarkerActive = TRUE;
    [self highlightMarker:marker];
    marker.infoWindowAnchor = CGPointMake(0.5, 0.2);
    
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    label.frame = CGRectMake(0, 0, 120, 30);
    
   // label.text = [seperateDict objectForKey:@"merchant_name"];
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor clearColor];
    
    label.numberOfLines = 3;
    
    
    
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    
    [label adjustsFontSizeToFitWidth];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    customView.backgroundColor = [UIColor clearColor];
    [Utilities addShadowtoView:customView];
    
    
    
  //  [customView addSubview:label];
    
    
    
    
    
    return customView;
}

- (void) mapView: (GMSMapView *)mapView didChangeCameraPosition: (GMSCameraPosition *)position
{
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    latiNum = latitude;
    longiNum = longitude;
    singleTonInstance.latiNumTomenu = latiNum;
    singleTonInstance.longiNumTomenu = longiNum;
    NSLog(@"testing %f, %f",latiNum,longiNum);
    NSLog(@"lat and long are %f, %f",latitude,longitude);
}




#pragma mark - text view delegates


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.textview.text = @"";
    self.textview.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.textview.text.length == 0){
        self.textview.textColor = [UIColor lightGrayColor];
        self.textview.text = @"Text here";
        [self.textview resignFirstResponder];
    }
}

-(void) textViewShouldEndEditing:(UITextView *)textView
{
    
    if(self.textview.text.length == 0){
        self.textview.textColor = [UIColor lightGrayColor];
        self.textview.text = @"Text here";
        [self.textview resignFirstResponder];
    }
}

#pragma mark - service call and service delegates



-(void)searchHereService
{
    
    
    
    if ([Utilities isInternetConnectionExists])
    {
        isSearchHere = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSString *mylati = [[NSNumber numberWithFloat:singleTonInstance.mapItemForEventPage.placemark.coordinate.latitude] stringValue];
        
        NSString *mylongi = [[NSNumber numberWithFloat:singleTonInstance.mapItemForEventPage.placemark.coordinate.longitude] stringValue];
        
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: singleTonInstance.mapItem.placemark.coordinate.latitude
                                                                longitude: singleTonInstance.mapItem.placemark.coordinate.longitude zoom: 13];
        [mapView animateToCameraPosition: camera];
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@nearMeMerchants",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"latitude":mylati    /*latitude*/,
                        @"longitude":mylongi /*longitude*/
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}



-(void)SearchThisAreaService
{
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSString *mylati = [[NSNumber numberWithFloat:latiNum] stringValue];

        NSString *mylongi = [[NSNumber numberWithFloat:longiNum] stringValue];

        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@nearMeMerchants",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"latitude":mylati    /*latitude*/,
                        @"longitude":mylongi /*longitude*/
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}


-(void)addusereventvote
{
    //    CLLocationCoordinate2D coordinate = [self getLocation];
    //    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //
    NSMutableArray * selectionsArray = [[NSMutableArray alloc]init];
    
    NSMutableArray * selectedVotes = [[NSMutableArray alloc]init];
    
    //[Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:votesArray] objectForKey:@"option1"] objectForKey:@"option_name"] ];
    
    NSString * op1 = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:voteBtnPath] objectForKey:@"option1"] objectForKey:@"option_name"]];
    NSString * op2 = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:voteBtnPath] objectForKey:@"option2"] objectForKey:@"option_name"]];
    NSString * op3 = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:voteBtnPath] objectForKey:@"option3"] objectForKey:@"option_name"]];
    NSString * op4 = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:voteBtnPath] objectForKey:@"option4"] objectForKey:@"option_name"]];
    
    if (op1.length>0) {
        [ selectedVotes addObject: op1  ];

    }
    if (op2.length>0) {
        [ selectedVotes addObject: op2  ];
        
    }
    if (op3.length>0) {
        [ selectedVotes addObject: op3  ];
        
    }
    if (op4.length>0) {
        [ selectedVotes addObject: op4  ];
        
    }
    
    NSMutableArray * actualSelectedOptionsArr = [[NSMutableArray alloc]init];
    
    for (int i=0; i<selectedOptionsArray.count; i++) {
        
        
        for (int j = 0; j<selectedVotes.count; j++) {
            if ([[selectedOptionsArray objectAtIndex:i] isEqualToString:[selectedVotes objectAtIndex:j]]) {
                
                [actualSelectedOptionsArr addObject:[selectedVotes objectAtIndex:j]];
            }
        }
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:actualSelectedOptionsArr options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    

    if ([Utilities isInternetConnectionExists])
    {

        dispatch_async(dispatch_get_main_queue(), ^{



            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });

        NSInteger * eventIdNum = [self.eventIdStr intValue];

        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@addusereventvote",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum],
                        @"options":jsonString,
                        @"voting_id":[NSString stringWithFormat:@"%d",voteBtnPath]
                        };
        
        [requestDict allKeys];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;

            [service  handleRequestWithDelegates:urlStr info:requestDict];

        });

    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];

    }
}






-(void)createeventvotingService
{
    //    CLLocationCoordinate2D coordinate = [self getLocation];
    //    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@createeventvoting",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum],
                        @"question":[Utilities null_ValidationString:self.questionText.text],
                        @"option1":[Utilities null_ValidationString:self.option1Text.text],
                        @"option2":[Utilities null_ValidationString:self.option2Text.text],
                        @"option3":[Utilities null_ValidationString:self.option3Text.text],
                        @"option4":[Utilities null_ValidationString:self.option4Text.text]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}




-(void)usereventvotesService
{
    //    CLLocationCoordinate2D coordinate = [self getLocation];
    //    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        isVoteDisplay = YES;
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@usereventvotes",BASEURL];
        requestDict = @{
                        
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}





-(void)refreshServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
        isChatHistory = 1;
        
        isChatHistoryString = @"showHistory";
        
        NSDictionary * requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@chathistory",BASEURL];
        
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];
        
        
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum]
                        
                        
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
    
}






-(void)chatHistoryServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
             [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        isChatHistory = 1;
        
        isChatHistoryString = @"showHistory";
        
        NSDictionary * requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@chathistory",BASEURL];
        
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];

        
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum]
                        
                        
                        
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
    
}





-(void)groupChatServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
        
        isChatView = YES;
        
        
        NSDictionary * requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@groupchat",BASEURL];
        
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];

        
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum],
                        @"message":self.chatTextfield.text
                        
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
    
}



-(void)eventMembersServiceCall
{
    eventMembers = YES;
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@eventMembers",BASEURL];
        requestDict = @{
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
    
    
}



-(void)updateEventStatusServiceCall
{

    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@updateEventStatus",BASEURL];
        requestDict = @{
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum],
                        @"user_id":[Utilities getUserID],
                        @"status":statusNum
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
    
}

-(void)addToPreferedAction:(UIButton*)sender
{
    
    
    UIButton *btn=(UIButton *)sender;
    BtnTag =btn.tag;
    
    isAddToPrefered = YES;
    
    isAddToPreferedComeOnce = YES;
    
    
    //merchantIdStr = [[barsArray objectAtIndex:BtnTag] objectForKey:@"merchant_id"];
    
    //[self AddToPrefereServiceCall];
    
    
    
    
}


-(void)eventViewServiceCall
{
    //    CLLocationCoordinate2D coordinate = [self getLocation];
    //    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //
    
    isEventView = YES;
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@eventView",BASEURL];
        requestDict = @{
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}


-(void)deleteEventServiceCall
{
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        isDeleteEvent = YES;
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@deleteEvent",BASEURL];
        requestDict = @{
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}


-(void)serviceCall
{
    //    CLLocationCoordinate2D coordinate = [self getLocation];
    //    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //
    
    isNearMeRestaurants = YES;
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        CLLocationCoordinate2D coordinate = [self getLocation];
        
        double  curLat;
        double  curLong;
        curLat = coordinate.latitude;
        curLong = coordinate.longitude;
        
        NSString * curLatStr, *curLongStr;
        
        curLatStr = [NSString stringWithFormat:@"%f",curLat];
        curLongStr = [NSString stringWithFormat:@"%f",curLong];
        
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@nearMeMerchants",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"latitude":curLatStr    /*latitude*/,
                        @"longitude":curLongStr /*longitude*/
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}



-(void)equiDistanceServiceCall
{
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        isDeleteEvent = YES;
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@eventrestaurants",BASEURL];
        requestDict = @{
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum],
                        @"user_id":[Utilities getUserID]
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self handleResponse:info];
        
        
    });
    
    
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
        //[ activityIndicatorView stopAnimating];
        
    });
}

-(void)aMethod
{
    NSLog(@"map button clicked ");
    

    isSearchHere = YES;
    [self SearchThisAreaService];
    
}

-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    NSLog(@"responseInfo EventView:%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                    
                    if (isChatView)
                    {
                        
                        NSLog(@"response of chat servicecall is %@",responseInfo);
                        
                        chatArray = [responseInfo valueForKey:@"chatinfo"];
                        
                        
                        NSMutableArray *bubbles = [[NSMutableArray alloc] init];
                        
                        for (int i=0; i<chatArray.count; i++) {
                            
                            UIView *msg8;
                            
                           
                            
                            if ([[[chatArray objectAtIndex:i] valueForKey:@"status"] intValue]== 1) {
                                NSLog(@"from me only");
                                
                                msg8 = [self createMessageWithText:[[chatArray objectAtIndex:i] valueForKey:@"message"] Image:nil DateTime:[[chatArray objectAtIndex:i] valueForKey:@"name"] isReceived:0 Time:[[chatArray objectAtIndex:i] valueForKey:@"created_on"]];
                            }
                            else
                            {
                                NSLog(@"from otheres");
                                msg8 = [self createMessageWithText:[[chatArray objectAtIndex:i] valueForKey:@"message"] Image:nil DateTime:[[chatArray objectAtIndex:i] valueForKey:@"name"] isReceived:1  Time:[[chatArray objectAtIndex:i] valueForKey:@"created_on"]];
                                
                                
                            }
                            
                            [bubbles addObject:msg8];
                            
                            
                            
                        }
                        
                        
                        
                        //Populate data in the chat table
                        allMessages = bubbles;
                       // [self.chatTableView reloadData];
                        
                        //Scroll the table to bottom
                        //[self scrollToTheBottom:NO];
                        
                        
                        
                        
                        
                        [self.chatTableView reloadData];
                        
                        
                        
                        [self.chatTextfield resignFirstResponder];
                        self.chatTextfield.text = @"";
                        [self scrollToTheBottom:YES];

                        
                        isChatView = NO;
                    }
                    else
                    {
                        
                        
                        if (isEventView == YES)
                        {
                            
                            editEventDict = responseInfo;
                            
                            singleTonInstance.isDateAvailable = NO;
                            
                            singleTonInstance.isLocationAvailable = NO;
                            
                            singleTonInstance.isDescriptionAvailable = YES;
                            
                            int gNum = [[[[editEventDict valueForKey:@"event_info"] valueForKey:@"event_data"] valueForKey:@"going"] intValue];
                            
                            self.goingCountLbl.text = [NSString stringWithFormat:@"%d",gNum];
                            
                            int interestedNum = [[[[editEventDict valueForKey:@"event_info"] valueForKey:@"event_data"] valueForKey:@"interested"] intValue];
                            
                            self.interestedCountLbl.text = [NSString stringWithFormat:@"%d",interestedNum];
                            
                            int cantGoNum = [[[[editEventDict valueForKey:@"event_info"] valueForKey:@"event_data"] valueForKey:@"cant_go"] intValue];
                            
                            //member_count
                            
                            if (![[[[editEventDict valueForKey:@"event_info"] objectForKey:@"event_members"] objectForKey:@"event_members"] isKindOfClass:[NSNull class]]) {
                                 numbersArr = [[[editEventDict valueForKey:@"event_info"] objectForKey:@"event_members"] objectForKey:@"event_members"];
                            }
                            
                           
                            
                            NSLog(@"count of nums %d",numbersArr.count);
                            
                            [self.friendsCollection reloadData];
                            
                           

                          int total =  [[[responseInfo valueForKey:@"event_info"] valueForKey:@"member_count"] intValue];
                      //      self.totalCountLbl.text = [NSString stringWithFormat:@"%d",total];
                            
                         //   self.totalCountLbl.text = [Utilities null_ValidationString:[[[responseInfo valueForKey:@"event_info"] valueForKey:@"event_members"] valueForKey:@"member_count"]];
                            
                            
                            isEventView = NO;
                            
                        }
                        else
                        {
                            if (isAddToPrefered)
                            {
                                [Utilities displayToastWithMessage:@"Successfully added to prefered list"];
                            }
                            else if(isNearMeRestaurants == YES && isEventView == NO)
                            {
                                isNearMeRestaurants = NO;
                                
                                NSString * strLAt = [[[responseInfo objectForKey:@"response"]  objectAtIndex:0] objectForKey:@"latitude"];
                                NSString * strLong = [[[responseInfo objectForKey:@"response"]  objectAtIndex:0] objectForKey:@"longitude"];
                                double  mapLat ;
                                double mapLong;
                                mapLat = [strLAt doubleValue];
                                mapLong = [strLong doubleValue];
                                
                                
                                cameraPosition=[GMSCameraPosition cameraWithLatitude:mapLat longitude:mapLong zoom:13];
                                
                                mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
                            
                                mapView.myLocationEnabled = YES;
                                
                                
                                
                                mapView.delegate = self;
                                
                                mapView.frame = CGRectMake(0,0, self.view.frame.size.width,570);
                                
                                mapView.frame = CGRectMake(0,0, self.view.frame.size.width,570);
                                
                                if (IS_IPHONE_5 || IS_IPHONE_5S || IS_IPHONE_5C)
                                {
                                    mapView.frame = CGRectMake(0,0, self.view.frame.size.width,410);
                                }
                                
                                else if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6S || IS_STANDARD_IPHONE_7)
                                {
                                    mapView.frame = CGRectMake(0,0,self.view.frame.size.width,490);
                                }
                                else if (IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS)
                                {
                                    
                                    mapView.frame = CGRectMake(0,0, self.view.frame.size.width,480);
                                }
                                
                                else if( IS_STANDARD_IPHONE_6S_PLUS || IS_STANDARD_IPHONE_7_PLUS)
                                {
                                    mapView.frame = CGRectMake(0,0,self.view.frame.size.width,560);
                                }
                                
                                else
                                {
                                    mapView.frame = CGRectMake(0,0, self.view.frame.size.width,570);
                                }
                                
                                
                                self.GroupCollectionView.frame = CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y+mapView.frame.size.height, mapView.frame.size.width, self.GroupCollectionView.frame.size.height);
                                
                                self.GroupCollectionView.frame = CGRectMake(mapView.frame.origin.x, self.GroupCollectionView.frame.origin.y, mapView.frame.size.width, self.GroupCollectionView.frame.size.height);
                                [self.mapShowView layoutIfNeeded];
                                [self.mapShowView addSubview:mapView];
                                
                                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                [button addTarget:self
                                           action:@selector(aMethod)
                                 forControlEvents:UIControlEventTouchUpInside];
                                [button setTitle:@"Search Here" forState:UIControlStateNormal];
                                
                                button.backgroundColor = [UIColor whiteColor];
                                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
                                button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
                                 button.frame = CGRectMake(20.0, 25, 135,35);
                               // button.frame = CGRectMake(120.0, self.mapShowView.frame.origin.y+self.mapShowView.frame.size.height - 150, 135,35);
                                
                                [self.mapShowView addSubview:button];
                                [self.mapShowView bringSubviewToFront:button];
                                
                                [self.mapShowView bringSubviewToFront:self.trailBtn];
                                [self.mapShowView bringSubviewToFront:self.equiDistanceButton];
                                
                                
                                [self.view addSubview:self.GroupCollectionView];
                                
                                
                                CGRect frame = CGRectMake(0, 0, 40, 40);
                                UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                                
                                
                                /// for bars
                                barsArray = [[NSMutableArray alloc]init];
                                barsArray = [responseInfo objectForKey:@"response"] ;
                                singleTonInstance.barsArrayReady = [[NSMutableArray alloc]init];
                                singleTonInstance.barsArrayReady = barsArray;
                                
                                // this if condition is to set dixtionary by default as 1st object in array for i am ready button
                                if (singleTonInstance.barsArrayReady.count>0) {
                                    singleTonInstance.summaryDict = [singleTonInstance.barsArrayReady objectAtIndex:0];
                                }
                                
                                
                                singleTonInstance.barsCountStr = [NSString stringWithFormat:@"%lu",barsArray.count];
                                
                                if (barsArray.count && markerArray.count) {
                                    [markerArray removeAllObjects];
                                }
                                
                                for (int i =0; i<barsArray.count; i++)
                                {
                                    [latitudeArray addObject:[[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"latitude"]];
                                    [longitudeArray addObject:[[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"longitude"]];
                                    
                                    ////////////////////////////////////////////////////////
                                    /////////////// // to display nearBy bars////////////////
                                    marker = [[GMSMarker alloc] init];
                                    CGFloat latitude = [[latitudeArray objectAtIndex:i] doubleValue];
                                    CGFloat longitude = [[longitudeArray objectAtIndex:i] doubleValue];
                                    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
                                    // marker.snippet = [self.SPIDArray objectAtIndex:i];
                                    marker.appearAnimation = kGMSMarkerAnimationPop;
                                    marker.map = mapView;
                                    marker.zIndex = (UInt32)i;
                                    marker.title = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"];
                                    marker.snippet = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_id"];
                                    
                                    
                                    
                                    UIImageView * imgView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 40, 40)];
                                    imgView.image = [UIImage imageNamed:@"map_64x64.png"];
                                    
                                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 40, 40)];
                                    label.text = [NSString stringWithFormat:@"%d",i+1];
                                    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
                                    label.textColor = [UIColor whiteColor];
                                    label.textAlignment = NSTextAlignmentCenter;
                                    // label.layer.cornerRadius = 21;
                                    label.layer.masksToBounds = YES;
                                    // label.backgroundColor = [REDCOLOR colorWithAlphaComponent:1];
                                    
                                    //grab it
                                    UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, [[UIScreen mainScreen] scale]);
                                    [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
                                    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
                                    
                                    UIImage * icon = UIGraphicsGetImageFromCurrentImageContext();
                                    UIGraphicsEndImageContext();
                                    
                                    marker.icon = icon;
                                    
                                    [markerArray addObject:marker];
                                    
                                    marker.map = mapView;
                                    
                                }
                                
                                [self.GroupCollectionView reloadData];
                                
                                
                            }
                            
                            else if (isDeleteEvent == YES)
                            {
                                
                                NSLog(@"successfully deleted");
                                
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                homeTabViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
                                
                                
                                [invite setSelectedIndex:2];
                                
                                [self presentViewController:invite animated:YES completion:nil];
                                
                                [Utilities displayToastWithMessage:@"Successfully Deleted Event"];
                                
                                isDeleteEvent = NO;
                            }
                            else if (userStatus == YES)
                            {
                                NSMutableDictionary * statusTempDic = [[NSMutableDictionary alloc]init];
                                statusTempDic =  [responseInfo valueForKey:@"event_data"];
                                
                                
                                self.goingCountLbl.text = [NSString stringWithFormat:@"%@",[statusTempDic valueForKey:@"going"]] ;
                                
                                self.interestedCountLbl.text = [NSString stringWithFormat:@"%@",[statusTempDic valueForKey:@"interested"]] ;
                                
                               
                                
                                
                                
                                if ([[statusTempDic valueForKey:@"going"] intValue] == 1) {
                                    [Utilities displayToastWithMessage:@"Going"];
                                    
                                    
                                }
                                else if ([[statusTempDic valueForKey:@"interested"] intValue] == 1)
                                {
                                    [Utilities displayToastWithMessage:@"Interested"];
                                }
                                else
                                {
                                    [Utilities displayToastWithMessage:@"Can't Go"];
                                }
                                
                                userStatus = NO;
                            }
                            else if (eventMembers == YES)
                            {
                                
                                NSLog(@"eventMembers response \n\n");
                                
                                NSMutableArray * eventMembersArr = [[NSMutableArray alloc]init];
                                NSMutableArray * eventLat = [[NSMutableArray alloc]init];
                                NSMutableArray * eventLong = [[NSMutableArray alloc]init];
                                
                                
                                eventMembersArr =   [responseInfo valueForKey:@"event_members"];
                                
                                for (int i =0; i<eventMembersArr.count; i++)
                                {
                                    [eventLat addObject:[[eventMembersArr  objectAtIndex:i] objectForKey:@"latitude"]];
                                    [eventLong addObject:[[eventMembersArr  objectAtIndex:i] objectForKey:@"longitude"]];
                                    
                                    ////////////////////////////////////////////////////////
                                    /////////////// // to display nearBy bars////////////////
                                    GMSMarker *marker = [[GMSMarker alloc] init];
                                    CGFloat latitude = [[eventLat objectAtIndex:i] doubleValue];
                                    CGFloat longitude = [[eventLong objectAtIndex:i] doubleValue];
                                    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
                                    // marker.snippet = [self.SPIDArray objectAtIndex:i];
                                    marker.appearAnimation = kGMSMarkerAnimationPop;
                                    marker.map = mapView;
                                    marker.zIndex = (UInt32)i;
                                    marker.title = [[eventMembersArr objectAtIndex:i ] objectForKey:@"name"];
                                    
                                    
                                    // for marker image icon custom resizing i used frame and imageView , imageView displayed in marker.iconView
                                    CGRect frame = CGRectMake(0, 0, 40, 40);
                                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                                    
                                    
                                    imageView.image = [UIImage imageNamed:@"pin.png"];
                                    marker.iconView = imageView;
                                    marker.iconView.clipsToBounds =YES;
                                    // marker.iconView.layer.cornerRadius = 38;
                                    
                                    
                                    //to set image for icon
                                    //marker.icon = [UIImage imageNamed:@"beer_mug.png"];
                                    ////////////////////////    upto here   ////////////////////////
                                    ////////////////////////////////////////////////////////////////
                                }
                                
                                eventMembers = NO;
                            }
                            else if (isChatHistory == 1)
                            {
                                
                                    NSLog(@"chat history data is %@",responseInfo);
                                    
                                    chatArray =  [responseInfo valueForKey:@"chatinfo"];
                                    
                                  //  [self.chatTableView reloadData];
                                    
                                
                                
                                
                                
                                NSMutableArray *bubbles = [[NSMutableArray alloc] init];
                                
                                for (int i=0; i<chatArray.count; i++) {
                                    
                                    UIView *msg8;
                                    
                                    if ([[[chatArray objectAtIndex:i] valueForKey:@"status"] intValue]== 1) {
                                        
                                        NSLog(@"from me only");
                                        
                                        msg8 = [self createMessageWithText:[[chatArray objectAtIndex:i] valueForKey:@"message"] Image:nil DateTime:[[chatArray objectAtIndex:i] valueForKey:@"name"] isReceived:0  Time:[[chatArray objectAtIndex:i] valueForKey:@"created_on"]];
                                        
                                        
                                    }
                                    else
                                    {
                                        NSLog(@"from otheres");
                                        msg8 = [self createMessageWithText:[[chatArray objectAtIndex:i] valueForKey:@"message"] Image:nil DateTime:[[chatArray objectAtIndex:i] valueForKey:@"name"] isReceived:1   Time:[[chatArray objectAtIndex:i] valueForKey:@"created_on"]];
                                        
                                        
                                    }
                                    
                                    [bubbles addObject:msg8];
                                   
                                    
                                    
                                }
                                
                                
                                
                                //Populate data in the chat table
                                allMessages = bubbles;
                                [self.chatTableView reloadData];
                                
                                //Scroll the table to bottom
                                [self scrollToTheBottom:YES];
                                
                                
                                isChatHistory = nil;
                                
                                
                                
                                
                                    
                                
                            }
                            else if (isVoteCreated ==YES)
                            {
                                NSLog(@"response printing for vote creation");
                                isVoteCreated = NO;
                                
                                
                                [self usereventvotesService];
                            
                            }
                            else if (isVoteDisplay == YES)
                            {
                                NSLog(@"votes display response printing");
                                
                                
                               
                                
                                singleTonInstance.votesArray = [responseInfo valueForKey:@"usereventvotes"];
                                
                                
                                
                                if (singleTonInstance.votesArray.count)
                                {
                                    isVoteDisplay = NO;
                                    
                                    for (int i = 0; i<singleTonInstance.votesArray.count; i++) {
                                        [voteIdArray addObject:[[singleTonInstance.votesArray objectAtIndex:i] objectForKey:@"id"]];
                                    }
                                    
                                    [self.voteTableView reloadData];
                                    
                                    
                                    
                                    
                                    
                                    
//                                    // grab the view controller we want to show
//                                    votePopupViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"votePopupViewController"];
//
//                                    // configure the Popover presentation controller
//                                    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//                                    popController.permittedArrowDirections = nil;
//
//
//
//                                    UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:controller];/*Here popController is controller you want to show in popover*/
//
//                                    controller.preferredContentSize = CGSizeMake(self.voteView.frame.size.width,self.voteView.frame.size.height);
//                                    destNav.modalPresentationStyle = UIModalPresentationPopover;
//                                    popController = destNav.popoverPresentationController;
//                                    popController.delegate = self;
//                                    popController.sourceView = self.view;
//
//                                    popController.backgroundColor = [UIColor clearColor];
//                                    popController.sourceRect = self.meunVote.frame;
//
//                                    destNav.navigationBarHidden = YES;
//                                    [self presentViewController:destNav animated:YES completion:nil];
                                    
                                    
                                }
                            
                            }
                            else if (isvotesVoted == YES)
                            {
                                NSLog(@"response info for votes voting %@",responseInfo);
                                
                                isvotesVoted = NO;
                                
                                [self.voteTableView reloadData];
                                [self detailsAction:self];
                            }
                            else if (isvoteCancelled == YES)
                            {
                                 NSLog(@"response printing for vote cancellation");
                                
                                
                                
                                isvoteCancelled = NO;
                                
                                [self.voteTableView reloadData];
                                
                            }
                            else if (isSearchHere == YES)
                            {
                                NSLog(@"rsponse is %@",responseInfo);
                                
                                
                                singleTonInstance.filterResultArray = [responseInfo valueForKey:@"response"];
                                
                                isEventMap = YES;  isfilter = YES;
                                    [mapView clear];
                                    
                                    [latitudeArray removeAllObjects];
                                    [longitudeArray removeAllObjects];
                                    
                                    /// for bars
                                    barsArray = [[NSMutableArray alloc]init];
                                    barsArray = singleTonInstance.filterResultArray ;
                                    //singleTonInstance.barsArrayReady = [[NSMutableArray alloc]init];
                                    singleTonInstance.barsArrayReady = barsArray;
                                    singleTonInstance.barsCountStr = [NSString stringWithFormat:@"- - %lu",barsArray.count];
                                if (barsArray.count && markerArray.count) {
                                    [markerArray removeAllObjects];
                                }
                                
                                // this if condition is to set camera postion focus at points on loading service call
                                if (barsArray.count)
                                {
                                    NSString * strLAt = [[singleTonInstance.filterResultArray  objectAtIndex:0] objectForKey:@"latitude"];
                                    NSString * strLong = [[singleTonInstance.filterResultArray  objectAtIndex:0] objectForKey:@"longitude"];
                                    double  mapLat ;
                                    double mapLong;
                                    mapLat = [strLAt doubleValue];
                                    mapLong = [strLong doubleValue];
                                    
                                    
                                   GMSCameraPosition * cameraPosition2=[GMSCameraPosition cameraWithLatitude:mapLat longitude:mapLong zoom:13];
                                    [mapView setCamera:cameraPosition2];
                                }
                                    for (int i =0; i<barsArray.count; i++)
                                    {
                                        [latitudeArray addObject:[[singleTonInstance.filterResultArray  objectAtIndex:i] objectForKey:@"latitude"]];
                                        [longitudeArray addObject:[[singleTonInstance.filterResultArray  objectAtIndex:i] objectForKey:@"longitude"]];
                                        
                                        ////////////////////////////////////////////////////////
                                        /////////////// // to display nearBy bars////////////////
                                        marker = [[GMSMarker alloc] init];
                                        CGFloat latitude = [[latitudeArray objectAtIndex:i] doubleValue];
                                        CGFloat longitude = [[longitudeArray objectAtIndex:i] doubleValue];
                                        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
                                        // marker.snippet = [self.SPIDArray objectAtIndex:i];
                                        marker.appearAnimation = kGMSMarkerAnimationPop;
                                        marker.map = mapView;
                                        marker.zIndex = (UInt32)i;
                                        marker.title = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"];
                                        marker.snippet = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_id"];
                                        
                                        
                                        
                                        UIImageView * imgView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 40, 40)];
                                        imgView.image = [UIImage imageNamed:@"map_64x64.png"];
                                        
                                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 40, 40)];
                                        label.text = [NSString stringWithFormat:@"%d",i+1];
                                        [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
                                        label.textColor = [UIColor whiteColor];
                                        label.textAlignment = NSTextAlignmentCenter;
                                        // label.layer.cornerRadius = 21;
                                        label.layer.masksToBounds = YES;
                                        // label.backgroundColor = [REDCOLOR colorWithAlphaComponent:1];
                                        
                                        //grab it
                                        UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, [[UIScreen mainScreen] scale]);
                                        [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
                                        [label.layer renderInContext:UIGraphicsGetCurrentContext()];
                                        
                                        UIImage * icon = UIGraphicsGetImageFromCurrentImageContext();
                                        UIGraphicsEndImageContext();
                                        
                                        marker.icon = icon;
                                        
                                        
                                        marker.map = mapView;
                                        
                                        
                                       
                                        [markerArray addObject:marker];
                                        
                                    }
                                    
                                    [self.GroupCollectionView reloadData];
                                
                                isSearchHere = NO;
                            }
                            else if (isEquiDistance == YES)
                            {
                                NSLog(@"equi distance service call response is %@",responseInfo);
                                    
                                    singleTonInstance.filterResultArray = [responseInfo valueForKey:@"response"];
                                    
                                
                                    [mapView clear];
                                    
                                    [latitudeArray removeAllObjects];
                                    [longitudeArray removeAllObjects];
                                    
                                    /// for bars
                                    barsArray = [[NSMutableArray alloc]init];
                                    barsArray = singleTonInstance.filterResultArray ;
                                    //singleTonInstance.barsArrayReady = [[NSMutableArray alloc]init];
                                    singleTonInstance.barsArrayReady = barsArray;
                                    singleTonInstance.barsCountStr = [NSString stringWithFormat:@"- - %lu",barsArray.count];
                                    if (barsArray.count && markerArray.count) {
                                        [markerArray removeAllObjects];
                                    }
                                    
                                    // this if condition is to set camera postion focus at points on loading service call
                                    if (barsArray.count)
                                    {
                                        NSString * strLAt = [[singleTonInstance.filterResultArray  objectAtIndex:0] objectForKey:@"latitude"];
                                        NSString * strLong = [[singleTonInstance.filterResultArray  objectAtIndex:0] objectForKey:@"longitude"];
                                        double  mapLat ;
                                        double mapLong;
                                        mapLat = [strLAt doubleValue];
                                        mapLong = [strLong doubleValue];
                                        
                                        
                                        GMSCameraPosition * cameraPosition2=[GMSCameraPosition cameraWithLatitude:mapLat longitude:mapLong zoom:13];
                                        [mapView setCamera:cameraPosition2];
                                    }
                                    for (int i =0; i<barsArray.count; i++)
                                    {
                                        [latitudeArray addObject:[[singleTonInstance.filterResultArray  objectAtIndex:i] objectForKey:@"latitude"]];
                                        [longitudeArray addObject:[[singleTonInstance.filterResultArray  objectAtIndex:i] objectForKey:@"longitude"]];
                                        
                                        ////////////////////////////////////////////////////////
                                        /////////////// // to display nearBy bars////////////////
                                        marker = [[GMSMarker alloc] init];
                                        CGFloat latitude = [[latitudeArray objectAtIndex:i] doubleValue];
                                        CGFloat longitude = [[longitudeArray objectAtIndex:i] doubleValue];
                                        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
                                        // marker.snippet = [self.SPIDArray objectAtIndex:i];
                                        marker.appearAnimation = kGMSMarkerAnimationPop;
                                        marker.map = mapView;
                                        marker.zIndex = (UInt32)i;
                                        marker.title = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"];
                                        marker.snippet = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_id"];
                                        
                                        
                                        
                                        UIImageView * imgView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 40, 40)];
                                        imgView.image = [UIImage imageNamed:@"map_64x64.png"];
                                        
                                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 40, 40)];
                                        label.text = [NSString stringWithFormat:@"%d",i+1];
                                        [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
                                        label.textColor = [UIColor whiteColor];
                                        label.textAlignment = NSTextAlignmentCenter;
                                        // label.layer.cornerRadius = 21;
                                        label.layer.masksToBounds = YES;
                                        // label.backgroundColor = [REDCOLOR colorWithAlphaComponent:1];
                                        
                                        //grab it
                                        UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, [[UIScreen mainScreen] scale]);
                                        [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
                                        [label.layer renderInContext:UIGraphicsGetCurrentContext()];
                                        
                                        UIImage * icon = UIGraphicsGetImageFromCurrentImageContext();
                                        UIGraphicsEndImageContext();
                                        
                                        marker.icon = icon;
                                        
                                        
                                        marker.map = mapView;
                                        
                                        
                                        
                                        [markerArray addObject:marker];
                                        
                                    }
                                    
                                    [self.GroupCollectionView reloadData];
                                
                                
                                
                                isEquiDistance = NO;
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                
                
                
                
            });
            
            // [Utilities SaveUserID:[responseInfo objectForKey:@"user_id"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                //                            barsList_vc *barsList = [storyboard instantiateViewControllerWithIdentifier:@"barsList_vc"];
                //                            [self.navigationController pushViewController:barsList animated:YES];
                
                
            });
            
            
        }
        else if ([[responseInfo valueForKey:@"status"] intValue] == 3)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isAddToPreferedComeOnce==YES)
                {
                    isAddToPreferedComeOnce = NO;
                    
                   // [cusViewWindow removeFromSuperview];
                    
                    [Utilities displayToastWithMessage:@"Alerady added to prefered list"];
                    
                    //                    [ISMessages showCardAlertWithTitle:nil
                    //                                               message:@"Alerady added to prefered list"
                    //                                              duration:3.f
                    //                                           hideOnSwipe:YES
                    //                                             hideOnTap:YES
                    //                                             alertType:ISAlertTypeWarning
                    //                                         alertPosition:ISAlertPositionBottom
                    //                                               didHide:^(BOOL finished) {
                    //                                                   NSLog(@"Alert did hide.");
                    //
                    //                                                       [Utilities removeLoading:self.view];
                    //                                                       //[ activityIndicatorView stopAnimating];
                    //
                    //                                               }];
                    
                }
                
                if (isChatHistory == 1)
                {
                    [Utilities displayToastWithMessage:@"No chat history found"];
                    isChatHistory = nil;
                    
                }
                
                
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
//                
//                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction * ok  = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                    homeTabViewController * home = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
//                    
//                    
//                    [home setSelectedIndex:3];
//                    //[self.navigationController pushViewController:home animated:YES];
//                    [self presentViewController:home animated:YES completion:nil];
//                }];
//                [alert addAction:ok];
//                [self presentViewController:alert animated:YES completion:^{
                
                //}];
                 if (isSearchHere == YES|| isEquiDistance == YES)
                {
                    [mapView clear];
                    [barsArray removeAllObjects];
                    [latitudeArray removeAllObjects];
                    [longitudeArray removeAllObjects];
                    [self.GroupCollectionView reloadData];
                    
                    [self scrollToTheBottom:YES];
                    [Utilities displayToastWithMessage:[Utilities null_ValidationString:[responseInfo valueForKey:@"result"]]];
                    
                    isSearchHere = NO;
                    isEquiDistance = NO;
                    
                    
                    
                    CLLocationCoordinate2D coordinate = [self getLocation];
                    
                    double  curLat;
                    double  curLong;
                    curLat = coordinate.latitude;
                    curLong = coordinate.longitude;
                    
                    GMSCameraPosition * cameraPosition2=[GMSCameraPosition cameraWithLatitude:curLat longitude:curLong zoom:13];
                    [mapView setCamera:cameraPosition2];
                }
                
                
                
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
            //[ activityIndicatorView stopAnimating];
        });
        
    }
    
    @catch (NSException *exception) {
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[ activityIndicatorView stopAnimating];
            [Utilities removeLoading:self.view];
        });
        [self.view endEditing:YES];
    }
    
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
