//
//  frontViewController.m
//  foodieApp
//
//  Created by Bharat shankar on 12/11/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "frontViewController.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "notificationViewController.h"
#import "menuViewController.h"
#import "addInvitationViewController.h"
#import "homeTabViewController.h"
#import "SingleTon.h"
#import "detailRestaurantViewController.h"
#import "detectAddressViewController.h"
#import "ISMessages.h"
#import "GroupCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "KTCenterFlowLayout.h"
#import "HWViewPager.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LSFloatingActionMenu.h"
#import "MyTableViewController.h"
#import "filterViewController.h"



#define SEPARATOR_WIDTH 0.4f
#define SEPARATOR_COLOR [UIColor whiteColor]

@interface frontViewController ()<GMSMapViewDelegate>
{
CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLLocationCoordinate2D theCoordinate;
    GMSCameraPosition *cameraPosition;
    GMSMapView *mapView;
    GMSMarker * marker;
    SingleTon * singleTonInstance;
    NSMutableArray * longitudeArray,*latitudeArray;
    UIView * cusViewWindow;
    BOOL * isWindowVisible;
    UIButton * buttonOnMapWindow,*star1,*star2,*star3,*star4,*star5;
    NSString * buttonIdStr;
    UILabel * subLab,*areaLbl,*DistanceLbl;
    UIButton * addInviteBtn;
    UINavigationBar *navBar;
    UIButton * btnLocation;
    NSString * merchantIdStr;
    BOOL * isAddToPrefered,*isAddToPreferedComeOnce;
    UIAlertView *alertForFollwing;
    NSMutableArray * collectionArray, * barsArray, *markerArray;
    NSInteger * BtnTag;
    NSMutableDictionary * seperateDict;
    
    CGFloat  latiNum ;
    CGFloat longiNum;
    BOOL * isSearchHere;
    BOOL * isDidLoad;
    NSString * addressNameStr ;
    GMSMarker *selectedMarker;
    BOOL isMarkerActive,*isFromDidScroll;
    
    
    
}

@property (strong, nonatomic) UIView *displayedInfoWindow;
@property (strong, nonatomic) VCFloatingActionButton *addButton;

@end

@implementation frontViewController
@synthesize addButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isWindowVisible = YES;
    
   
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    singleTonInstance.barsArray = [[NSMutableArray alloc]init];
    longitudeArray = [[NSMutableArray alloc]init];
    latitudeArray = [[NSMutableArray alloc]init];
    
    collectionArray = [[NSMutableArray alloc]init];
    
    seperateDict = [[NSMutableDictionary alloc]init];
    
    
    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 60, [UIScreen mainScreen].bounds.size.height - 44 -280, 44, 44);

    
    addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"plus.png"] andPressedImage:[UIImage imageNamed:@"cross.png"] withScrollview:nil];
    
    
    addButton.imageArray = @[@"createVote.png",@"viewVote.png"];
    addButton.labelArray = @[@"Create Vote",@"View Votes"];
    
    
    
    addButton.hideWhileScrolling = NO;
    addButton.delegate = self;

    
    
    
    //this is to get seperator lines in tabbar
    //[self setupTabBarSeparators];
    
    cusViewWindow = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+5, self.view.frame.size.height/1.45, self.view.frame.size.width-10, 140)];
    
    self.GroupCollectionView.delegate = self;
    
    
    
    SWRevealViewController*sw=[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    _menu.target=sw.revealViewController;
    _menu.action=@selector(revealToggle:);
    sw.frontViewShadowRadius = 5;
    [self.menu setImage:[UIImage imageNamed:@"toogle_menu_icon.png"]];
    
    //[self.view addGestureRecognizer:sw.panGestureRecognizer];

    // this is for background color of navigation bar
    self.navigationController.navigationBar.barTintColor = REDCOLOR;
    
    // this is for navigation bar title color
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor yellowColor]}];
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 28, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    //phoneButton.showsTouchWhenHighlighted=YES;
    
   UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    phoneBarItem.action = @selector(phoneAction);
    [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneButton setImage:[UIImage imageNamed:@"invite_icon.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(addInvitationAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(275, 5, 15, 25);
    [menuButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint = [menuButton.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[menuButton.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
    //menuButton.showsTouchWhenHighlighted=YES;
    
  UIBarButtonItem *  meuBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [arrRightBarItems addObject:meuBarItem];
    menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    [menuButton setImage:[UIImage imageNamed:@"notificationWhite.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(bellAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
   
    
    UIButton *menuButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton1.frame = CGRectMake(275, 5, 28, 25);
    [menuButton1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint2 = [menuButton1.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint2 =[menuButton1.heightAnchor constraintEqualToConstant:30];
    [widthConstraint2 setActive:YES];
    [HeightConstraint2 setActive:YES];

    //menuButton1.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem *  meuBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:menuButton1];
    meuBarItem1.action = @selector(menuAction);
    [arrRightBarItems addObject:meuBarItem1];
    menuButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuButton1 setImage:[UIImage imageNamed:@"list_view_icon.png"] forState:UIControlStateNormal];
   
     [menuButton1 addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton1 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    
    
    
    UIButton *menuButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton2.frame = CGRectMake(275, 5, 28, 25);
    [menuButton2 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint3 = [menuButton2.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint3 =[menuButton2.heightAnchor constraintEqualToConstant:30];
    [widthConstraint3 setActive:YES];
    [HeightConstraint3 setActive:YES];

   // menuButton2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //menuButton2.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem *  meuBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton2];
    meuBarItem2.action = @selector(menuAction);
    [arrRightBarItems addObject:meuBarItem2];
    menuButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuButton2 setImage:[UIImage imageNamed:@"map_active_icon.png"] forState:UIControlStateNormal];
    [menuButton2 addTarget:self action:@selector(showMapAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton2 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    
    
   
    
    
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
    NSLayoutConstraint * widthConstraint4 = [btntitle.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint4 =[btntitle.heightAnchor constraintEqualToConstant:30];
    [widthConstraint4 setActive:YES];
    [HeightConstraint4 setActive:YES];

    
    [btntitle addTarget:sw.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addGestureRecognizer:sw.panGestureRecognizer];

    
    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
//    UIView * sampView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 49)];
//    sampView.backgroundColor = [UIColor blueColor];
//    [arrLeftBarItems addObject:sampView];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    
    
    /////////////////////////////////////////////////////
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
    
    
    
    
    /////////////////////////////////////////////////////
    ////////////////////location button and label/////////////////////
    /////////////////////////////////////////////////////
    NSString *hexStr3 = @"#ca1d31";
    
    UIColor *color1 = [Utilities getUIColorObjectFromHexString:hexStr3 alpha:.9];
    
    navBar = [[UINavigationBar alloc] initWithFrame:
                               CGRectMake(btntitle.frame.origin.x+btntitle.frame.size.width+15,0,150,self.navigationController.navigationBar.frame.size.height)];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navBar.backgroundColor = [UIColor clearColor];
    
    navBar.barTintColor = color1;
    navBar.tintColor = [UIColor clearColor];
    
    
    
    
   // [self.navigationController.navigationBar addSubview:navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:
                      CGRectMake(10,2,200-20,14)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.text = @"Location";
    label.textColor = WHITECOLOR;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = UITextAlignmentLeft;
    [navBar addSubview:label];
       //
    NSString * locaionStr = [USERDEFAULTS valueForKey:@"placemark.name"];
    
    
    btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLocation.frame = CGRectMake(10, 18, 100, 26);
    [btnLocation setTitle:locaionStr forState:UIControlStateNormal];
    btnLocation.backgroundColor = [UIColor clearColor];
    [btnLocation setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btnLocation.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    [btnLocation.titleLabel adjustsFontSizeToFitWidth];
    btnLocation.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnLocation.titleLabel.numberOfLines = 0;
    btnLocation.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    btnLocation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnLocation addTarget:self action:@selector(btnLocationAction) forControlEvents:UIControlEventTouchUpInside];
  //  [navBar addSubview:btnLocation];

    
    
    /////////////////////////////////////////////////////
    ////////////////////location button and label/////////////////////
    /////////////////////////////////////////////////////
    
    
    
    // if status 3 came this alert will come
    alertForFollwing = [[UIAlertView alloc] initWithTitle:nil message:@"Already added" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    isDidLoad = YES;
    [self serviceCall];
    
     self.callView.hidden= YES;
    [mapView addSubview:self.callView];
    _GroupCollectionView.delegate = self;
    _GroupCollectionView.dataSource = self;
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////
    // to load mapview
    
    /////////////////
    //this is to get curent location lat and long
    CLLocationCoordinate2D coordinate = [self getLocation];
    double  curLat;
    double  curLong;
    curLat = coordinate.latitude;
    curLong = coordinate.longitude;
    ////////////////
    
    [self.view layoutIfNeeded];
    cameraPosition=[GMSCameraPosition cameraWithLatitude:curLat longitude:curLong zoom:13];
    mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
    mapView.myLocationEnabled = YES;
    mapView.delegate = self;
    mapView.frame = CGRectMake(0,130, self.view.frame.size.width,430);
    
    if (IS_IPHONE_5 || IS_IPHONE_5S || IS_IPHONE_5C)
    {
        mapView.frame = CGRectMake(0,130, self.view.frame.size.width,270);
    }
    else if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6S || IS_STANDARD_IPHONE_7)
    {
        mapView.frame = CGRectMake(0,130,self.view.frame.size.width,350);
    }
    else if (IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS)
    {
        
        mapView.frame = CGRectMake(0,130, self.view.frame.size.width,340);
    }
    else if( IS_STANDARD_IPHONE_6S_PLUS || IS_STANDARD_IPHONE_7_PLUS)
    {
        mapView.frame = CGRectMake(0,130,self.view.frame.size.width,420);
    }
    else
    {
        mapView.frame = CGRectMake(0,130, self.view.frame.size.width,440);
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    self.GroupCollectionView.frame = CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y+mapView.frame.size.height, mapView.frame.size.width, self.GroupCollectionView.frame.size.height);
    
    [self.view addSubview:mapView ];
    
    [self.view insertSubview:self.searchHere aboveSubview:mapView];
    [self.view insertSubview:self.filterButton aboveSubview:mapView];

    [mapView bringSubviewToFront:self.searchHere];
    [mapView bringSubviewToFront:self.filterButton];
    
    
    [self.view addSubview:self.GroupCollectionView];
}








/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
//////////////  if user denined access to current location    ////////////////////
/////////////////////////////////////////////////////////////////////////////////

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //NSLog(@"Location access Enabled");
        //[NOTIFICATIONCENTER postNotificationName:LOCATIONSTATUS_NOTIFY object:self userInfo:nil];
        
    }
    else if (status == kCLAuthorizationStatusDenied)
    {
        //NSLog(@"Location access denied");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:self
                                              cancelButtonTitle:@"Settings"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if (&UIApplicationOpenSettingsURLString != NULL) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
        else {
            // Present some dialog telling the user to open the settings app.
        }
    }
    
}

/////////////////////////////////////////////////////////////////////////////////
///////////////////////////--------end of code-----------////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////





- (IBAction)changeLocationAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    detectAddressViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"detectAddressViewController"];
    
    [self.navigationController pushViewController:invite animated:YES];
    
}




-(void)btnLocationAction
{
   
}


-(void)viewWillDisappear:(BOOL)animated
{
    navBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    // this is to close side menu if already opened when navigation to another tab bar
    if (self.revealViewController.frontViewPosition == FrontViewPositionRight) {
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide];
    }
    
    if (singleTonInstance.isMostPopularClicked == YES) {
        
        latiNum = singleTonInstance.mostPopLatiNum;
        longiNum = singleTonInstance.mostPopLongiNum;
        
        [self searchHereAction:self];
        
        singleTonInstance.isMostPopularClicked = NO;
    }
    
    if (singleTonInstance.isHomeFilter == YES) {
        
        
            NSLog(@"rsponse is %@",singleTonInstance.filterResultArray);
            
            [mapView clear];
            [barsArray removeAllObjects];
            [latitudeArray removeAllObjects];
            [longitudeArray removeAllObjects];
            [singleTonInstance.barsArray removeAllObjects];
            
            barsArray = singleTonInstance.filterResultArray ;
            
            // singleTonInstance.barsArray = barsArray;
            singleTonInstance.barsCountStr = [NSString stringWithFormat:@"%lu",barsArray.count];
            
            CGRect frame = CGRectMake(0, 0, 40, 40);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            
            
            NSLog(@"bars array count is %d",barsArray.count);
            
            for (int i =0; i<barsArray.count; i++)
            {
                NSString * checkLat = [[singleTonInstance.filterResultArray  objectAtIndex:i] objectForKey:@"latitude"];
                
                
                
                if ([checkLat isKindOfClass:[NSNull class]]) {
                    
                }
                
                [latitudeArray addObject:[[singleTonInstance.filterResultArray  objectAtIndex:i] objectForKey:@"latitude"]];
                [longitudeArray addObject:[[singleTonInstance.filterResultArray  objectAtIndex:i] objectForKey:@"longitude"]];
                
                ////////////////////////////////////////////////////////
                /////////////// // to display nearBy bars///////////////
                marker = [[GMSMarker alloc] init];
                marker.zIndex = (UInt32)i;
                
                CGFloat latitude , longitude;
                
                if ([checkLat isKindOfClass:[NSNull class]]) {
                    NSLog(@"no lat long for index %d",i);
                }
                else
                {
                    
                    latitude = [[latitudeArray objectAtIndex:i] doubleValue];
                    longitude = [[longitudeArray objectAtIndex:i] doubleValue];
                    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
                    // marker.snippet = [self.SPIDArray objectAtIndex:i];
                    marker.appearAnimation = kGMSMarkerAnimationPop;
                    marker.map = mapView;
                    
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
                    
                    if (markerArray == nil) {
                        markerArray = [[NSMutableArray alloc] init];
                    }
                    [markerArray addObject:marker];
                }
                
            }
            
            [self.GroupCollectionView reloadData];
            
        
        singleTonInstance.isHomeFilter = NO;
        
    }
    
    if (singleTonInstance.isLocationChanged == YES) {
        
        if ( singleTonInstance.areaName != [NSNull class]) {
            self.locationAddressLbl.text = singleTonInstance.areaName ;
            
            NSLog(@" - - lati - - %f",singleTonInstance.mapItem.placemark.coordinate.latitude);
            NSLog(@" - - longi - - %f",singleTonInstance.mapItem.placemark.coordinate.longitude);
            
            
            [self searchHereService];
        }
        
        else
        {
            self.locationAddressLbl.text = @"Set Location";
        }
        
        singleTonInstance.isLocationChanged = NO;
    }
    
    navBar.hidden = NO;
    
    self.tabBarController.tabBar.hidden = NO;
    
    if (singleTonInstance.toDetectLocationStr.length) {
        [btnLocation setTitle:singleTonInstance.toDetectLocationStr forState:UIControlStateNormal]  ;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLabelStr:) name:@"UpdateLabel" object:nil];
    
}


- (void)updateLabelStr:(NSNotification*)notification
{
    // Update the UILabel's text to that of the notification object posted from the other view controller
    
    
    [btnLocation setTitle:notification.object forState:UIControlStateNormal];
    btnLocation.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    
    
    
}



//- (void) setupTabBarSeparators {
//    CGFloat itemWidth = floor(self.tabBar.frame.size.width/self.tabBar.items.count);
//    
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
//    for (int i=0; i<self.tabBar.items.count - 1; i++) {
//        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * (i +1) - SEPARATOR_WIDTH/2, 0, SEPARATOR_WIDTH, self.tabBar.frame.size.height)];
//        [separator setBackgroundColor:SEPARATOR_COLOR];
//        [bgView addSubview:separator];
//    }
//    
//    UIGraphicsBeginImageContext(bgView.bounds.size);
//    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *tabBarBackground = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
//}



-(void)showMapAction
{

    
}

-(void)addInvitationAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    addInvitationViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"addInvitationViewController"];
    [self.navigationController pushViewController:invite animated:YES];
}

-(void)menuAction
{
    NSLog(@"Menu");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    menuViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
    [self.navigationController pushViewController:menu animated:YES];

}


- (IBAction)filterAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    filterViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"filterViewController"];
        
        [self.navigationController pushViewController:menu animated:YES];

    
}



- (IBAction)searchHereAction:(id)sender {
    
    
    
    
    if ([Utilities isInternetConnectionExists])
    {
        isSearchHere = YES;
        
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




-(CLLocationCoordinate2D) getLocation{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
   
    // [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
     dispatch_async(dispatch_get_main_queue(), ^{
    
         
         NSLog(@"marker id is %@",marker.snippet);
         
         
         
         NSString * barIdStr;
         
         int indeXNum;
         
         NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
         
         
         
         NSMutableArray * latArr = [[NSMutableArray alloc]init];
         
         NSMutableArray * longArr = [[NSMutableArray alloc]init];
         
         
         
         for (int i = 0; i<barsArray.count; i++)
         {
             if ([marker.snippet isEqualToString:[[barsArray objectAtIndex:i] objectForKey:@"merchant_id"]])
             {
                 
                 NSLog(@"my desired array is %@",[barsArray objectAtIndex:i])  ;
                 
                 barIdStr = marker.snippet;
                 
                 indeXNum = i;
                 
                 seperateDict = [barsArray objectAtIndex:i];
                
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
         
         
         UIImageView * imageViw ;
         
         
           dispatch_async(dispatch_get_main_queue(), ^{
         
         
    
         [super viewDidLayoutSubviews];
         
        
         [self.GroupCollectionView layoutIfNeeded];
               
                [self.GroupCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indeXNum inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
               
           });
         
     });
    
    
    return YES;
}


- (void) mapView: (GMSMapView *)mapView didChangeCameraPosition: (GMSCameraPosition *)position
{
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    latiNum = latitude;
    longiNum = longitude;
    singleTonInstance.latiNum = latiNum;
    singleTonInstance.longiNum = longiNum;
    NSLog(@"lat and long are %f, %f",latitude,longitude);
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    NSLog(@"willMove called");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    GroupCollectionViewCell * firstCell = [self.GroupCollectionView.visibleCells objectAtIndex:0];
    
    NSIndexPath *firstIndexPath = [self.GroupCollectionView indexPathForCell:firstCell];
    
    NSLog(@"0  0 00 0 %@", firstIndexPath);
    
//    CGRect visibleRect = (CGRect){.origin = self.GroupCollectionView.contentOffset, .size = firstCell.bounds.size};
//    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
//    NSIndexPath *visibleIndexPath = [self.GroupCollectionView indexPathForItemAtPoint:visiblePoint];
    
    //[singleTonInstance.barsArray objectAtIndex:firstIndexPath.row];
    
    
    
    for (int i=0; i<markerArray.count; i++) {
        GMSMarker *myMarker = markerArray[i];
        if ([myMarker.snippet isEqualToString:[[barsArray objectAtIndex:firstIndexPath.row] objectForKey:@"merchant_id"]]){
            [self mapView:mapView didTapMarker:myMarker];
            //[self highlightMarker:myMarker];
        
        }
    }
    
    
    
    
//    GMSMarker * newMarker = [[GMSMarker alloc] init];
//
//    CGFloat latitude = [[[singleTonInstance.barsArray objectAtIndex:firstIndexPath.row] objectForKey:@"latitude"] doubleValue];
//    CGFloat longitude = [[[singleTonInstance.barsArray objectAtIndex:firstIndexPath.row] objectForKey:@"longitude"] doubleValue];
//    newMarker.position = CLLocationCoordinate2DMake(latitude, longitude);
//    newMarker.snippet = [[singleTonInstance.barsArray objectAtIndex:firstIndexPath.row] objectForKey:@"merchant_id"];
//    marker = newMarker;
//
//    marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
//
//
//    [self mapView:mapView didTapMarker:marker];
    
    
    
    
    
//    
//    [self mapView:mapView markerInfoWindow:marker];
    
    //[self highlightMarker:marker];
    
    // for marker image icon custom resizing i used frame and imageView , imageView displayed in marker.iconView
//    CGRect frame = CGRectMake(0, 0, 40, 40);
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//    
//    imageView.image =
   // marker.icon = [UIImage imageNamed:@"map_84x84.png"];
//    marker.iconView.clipsToBounds =YES;
    // pointMarker.iconView.layer.cornerRadius = 38;
    //pointMarker.icon = [UIImage imageNamed:@"map_active_icon.png"];
    //marker.map = mapView;
    
    
    
    
    
    
    
    
    
    
    
    
   // [self.GroupCollectionView scrollToItemAtIndexPath:visibleIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


- (void)mapView:(GMSMapView *)amapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    
    if(self.isMarkerActive == TRUE){
        if(amapView.selectedMarker != nil)
        {
            self.isMarkerActive = FALSE;
            [self unhighlightMarker:selectedMarker];
            selectedMarker = nil;
            amapView.selectedMarker = nil;
        }
    }
}

-(void)highlightMarker:(GMSMarker *)marker{
    
    //#8B0000
    
    NSString *hexStr3 = @"#8B0000";
    
    
    UIColor *color1 = [Utilities getUIColorObjectFromHexString:hexStr3 alpha:.9];

   // mapView.selectedMarker =  marker ;
    
    if([mapView.selectedMarker.snippet isEqual:marker.snippet]){
        
        
        NSString * labTitle ;
        
        for (int i =0; i<barsArray.count; i++)
        {
            if ([[[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"] isEqualToString:marker.title]) {
                labTitle = [NSString stringWithFormat:@"%d",i+1];
                break;
            }
        }
        
        if ([Utilities null_ValidationString:labTitle] ) {
            for (int i =0; i<barsArray.count; i++)
            {
                if ([[[barsArray objectAtIndex:i ]objectForKey:@"merchant_id"] isEqualToString:marker.snippet]) {
                    labTitle = [NSString stringWithFormat:@"%d",i+1];
                    break;
                }
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
        if ([[[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"] isEqualToString:marker.title]) {
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



-(void)addToPreferedAction:(UIButton*)sender
{
    
    NSURL *phoneNumber = [NSURL URLWithString:@"telprompt://8885631854"];
    if ([[UIApplication sharedApplication] canOpenURL:phoneNumber]){
        [[UIApplication sharedApplication] openURL:phoneNumber];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed!" message:@"Device not supporting to call" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
  
}



-(void)AddToPrefereServiceCall
{
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@addPreferedMerchant",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"merchant_id":merchantIdStr
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





-(void)mapButtonAction:(UIButton *)sender
{
    NSLog(@"------ %@",buttonIdStr);
    NSLog(@"-----tag is %d",sender.tag);
    
    
     dispatch_async(dispatch_get_main_queue(), ^{
    
    if (sender.tag == [buttonIdStr intValue]) {
        
    
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i<barsArray.count; i++)
        {
            if ([buttonIdStr isEqualToString:[[barsArray objectAtIndex:i] objectForKey:@"merchant_id"]])
            {
                
                dict = [barsArray objectAtIndex:i];
            }
        }
       
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                   detailRestaurantViewController *detailPage = [storyboard instantiateViewControllerWithIdentifier:@"detailRestaurantViewController"];
        detailPage.dict = dict;
                                    [self.navigationController pushViewController:detailPage animated:YES];
       
    }
          });

}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    
    
    
    if(self.isMarkerActive == TRUE){
        [self unhighlightMarker:selectedMarker];
    }
    selectedMarker = marker;
    self.isMarkerActive = TRUE;
    [self highlightMarker:marker];
    marker.infoWindowAnchor = CGPointMake(0.5, 0.2);
    
    
    
    
    
    NSString * labTitle ;
    
    for (int i =0; i<barsArray.count; i++)
    {
        if ([[[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"] isEqualToString:marker.title]) {
            labTitle = [NSString stringWithFormat:@"%d",i+1];
            break;
        }
    }
    
    
    
    

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    label.frame = CGRectMake(0, 0, 120, 30);
    
  //  label.text = [seperateDict objectForKey:@"merchant_name"];
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor clearColor];
    
    label.numberOfLines = 3;
    
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    
    [label adjustsFontSizeToFitWidth];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    customView.backgroundColor = [UIColor clearColor];
   // [Utilities addShadowtoView:customView];
    

   // [customView addSubview:label];


   // [self mapView:mapView didTapMarker:marker];
    
    
    return customView;
}


-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    //info window tapped
    //    NSArray *addressInfo = [marker.snippet componentsSeparatedByString:@","];.
    
    NSLog(@"********------------------*****************");
    @try {
        if([self.displayedInfoWindow isDescendantOfView:self.view]) {
            [self.displayedInfoWindow removeFromSuperview];
            self.displayedInfoWindow = nil;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
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
             
             addressNameStr = placemark.name;
             self.locationAddressLbl.text = addressNameStr;
             
             [USERDEFAULTS setObject:placemark.name forKey:@"placemark.name"];
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



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    
   
    
        GMSMarker *pointMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)];
        pointMarker.icon = [UIImage imageNamed:@"point.png"];
        pointMarker.map = mapView;
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

-(void)bellAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    notificationViewController *notifications = [storyboard instantiateViewControllerWithIdentifier:@"notificationViewController"];
    [self.navigationController pushViewController:notifications animated:YES];
}



- (IBAction)menu:(id)sender
{
    
}


-(void)timedAlert
{
    [self performSelector:@selector(dismissAlert:) withObject:alertForFollwing afterDelay:2];
}




-(void)serviceCall
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






-(void)searchHereService
{
    
    
    
    if ([Utilities isInternetConnectionExists])
    {
        isSearchHere = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSString *mylati = [[NSNumber numberWithFloat:singleTonInstance.mapItem.placemark.coordinate.latitude] stringValue];
        
        NSString *mylongi = [[NSNumber numberWithFloat:singleTonInstance.mapItem.placemark.coordinate.longitude] stringValue];
        
        
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

-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    NSLog(@"responseInfo nearMeMerchants:%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (isSearchHere == YES)
                {
                    
                    NSLog(@"rsponse is %@",responseInfo);
                    
                    [mapView clear];
                    [barsArray removeAllObjects];
                    [latitudeArray removeAllObjects];
                    [longitudeArray removeAllObjects];
                    [singleTonInstance.barsArray removeAllObjects];
                    
                    barsArray = [responseInfo objectForKey:@"response"] ;
                    
                   // singleTonInstance.barsArray = barsArray;
                    singleTonInstance.barsCountStr = [NSString stringWithFormat:@"%lu",barsArray.count];
                    
                    CGRect frame = CGRectMake(0, 0, 40, 40);
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                    
                    
                    NSLog(@"bars array count is %d",barsArray.count);
                    
                    for (int i =0; i<barsArray.count; i++)
                    {
                        NSString * checkLat = [[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"latitude"];
                        
                        
                        
                        if ([checkLat isKindOfClass:[NSNull class]]) {
                            
                        }
                        
                        [latitudeArray addObject:[[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"latitude"]];
                        [longitudeArray addObject:[[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"longitude"]];
                        
                        ////////////////////////////////////////////////////////
                        /////////////// // to display nearBy bars///////////////
                        marker = [[GMSMarker alloc] init];
                        marker.zIndex = (UInt32)i;
                        
                        CGFloat latitude , longitude;
                        
                        if ([checkLat isKindOfClass:[NSNull class]]) {
                            NSLog(@"no lat long for index %d",i);
                        }
                        else
                        {
                            
                            latitude = [[latitudeArray objectAtIndex:i] doubleValue];
                            longitude = [[longitudeArray objectAtIndex:i] doubleValue];
                            marker.position = CLLocationCoordinate2DMake(latitude, longitude);
                            // marker.snippet = [self.SPIDArray objectAtIndex:i];
                            marker.appearAnimation = kGMSMarkerAnimationPop;
                            marker.map = mapView;
                            
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
                            
                            if (markerArray == nil) {
                                markerArray = [[NSMutableArray alloc] init];
                            }
                            [markerArray addObject:marker];
                        }
                        
                    }
                    
                    [self.GroupCollectionView reloadData];
                    
                    
                    isSearchHere = NO;
                }
                else
                {
                    
                    
                    if (isAddToPrefered)
                    {
                        [Utilities displayToastWithMessage:@"Successfully added to prefered list"];
                    }
                    else if (isDidLoad == YES)
                    {
                      NSString * strL =  [[[responseInfo objectForKey:@"response"]  objectAtIndex:0] objectForKey:@"latitude"];
                      NSString * strLon =  [[[responseInfo objectForKey:@"response"]  objectAtIndex:0] objectForKey:@"longitude"];
                        
                        double strDblLat = [strL doubleValue];
                        double strDblLong = [strLon doubleValue];
                        
                        [self.view layoutIfNeeded];
                        cameraPosition=[GMSCameraPosition cameraWithLatitude:strDblLat longitude:strDblLong zoom:13];
                        mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
                        mapView.myLocationEnabled = YES;
                        mapView.delegate = self;
                        
                        
                        mapView.frame = CGRectMake(0,130, self.view.frame.size.width,430);
                        
                        if (IS_IPHONE_5 || IS_IPHONE_5S || IS_IPHONE_5C)
                        {
                            mapView.frame = CGRectMake(0,130, self.view.frame.size.width,270);
                        }
                        
                        else if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6S || IS_STANDARD_IPHONE_7)
                        {
                            mapView.frame = CGRectMake(0,130,self.view.frame.size.width,350);
                        }
                        else if (IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS)
                        {
                            
                            mapView.frame = CGRectMake(0,130, self.view.frame.size.width,340);
                        }
                        
                        else if( IS_STANDARD_IPHONE_6S_PLUS || IS_STANDARD_IPHONE_7_PLUS)
                        {
                            mapView.frame = CGRectMake(0,130,self.view.frame.size.width,420);
                        }
                        
                        else
                        {
                            mapView.frame = CGRectMake(0,130, self.view.frame.size.width,440);
                        }
                        
                        
                        self.GroupCollectionView.frame = CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y+mapView.frame.size.height, mapView.frame.size.width, self.GroupCollectionView.frame.size.height);
                        
                        self.GroupCollectionView.frame = CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y+mapView.frame.size.height, mapView.frame.size.width, self.GroupCollectionView.frame.size.height);
                        
                        [self.view addSubview:mapView ];
                        
                        
                        [self.view insertSubview:self.searchHere aboveSubview:mapView];
                        [self.view insertSubview:self.filterButton aboveSubview:mapView];
                        
                        [mapView bringSubviewToFront:self.searchHere];
                        [mapView bringSubviewToFront:self.filterButton];
                        
                        
                        [self.view addSubview:self.GroupCollectionView];
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        NSString *hexStr3 = @"#ca1d31";
                        
                        UIColor *color1 = [Utilities getUIColorObjectFromHexString:hexStr3 alpha:.9];
                        
                        
                        
                        
                        /// for bars
                        barsArray = [[NSMutableArray alloc]init];
                        barsArray = [responseInfo objectForKey:@"response"] ;
                        
                       // singleTonInstance.barsArray = barsArray;
                        singleTonInstance.barsCountStr = [NSString stringWithFormat:@"%lu",barsArray.count];
                        
                        CGRect frame = CGRectMake(0, 0, 40, 40);
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                        
                        
                        NSLog(@"bars array count is %d",barsArray.count);
                        
                        for (int i =0; i<barsArray.count; i++)
                        {
                            NSString * checkLat = [[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"latitude"];
                            
                            
                            
                            if ([checkLat isKindOfClass:[NSNull class]]) {
                                
                            }
                            
                            [latitudeArray addObject:[[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"latitude"]];
                            [longitudeArray addObject:[[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"longitude"]];
                            
                            ////////////////////////////////////////////////////////
                            /////////////// // to display nearBy bars///////////////
                            marker = [[GMSMarker alloc] init];
                            marker.zIndex = (UInt32)i;
                            
                            CGFloat latitude , longitude;
                            
                            if ([checkLat isKindOfClass:[NSNull class]]) {
                                NSLog(@"no lat long for index %d",i);
                            }
                            else
                            {
                                
                                latitude = [[latitudeArray objectAtIndex:i] doubleValue];
                                longitude = [[longitudeArray objectAtIndex:i] doubleValue];
                                marker.position = CLLocationCoordinate2DMake(latitude, longitude);
                                // marker.snippet = [self.SPIDArray objectAtIndex:i];
                                marker.appearAnimation = kGMSMarkerAnimationPop;
                                marker.map = mapView;
                                
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
                                
                                
                                if (markerArray == nil) {
                                    markerArray = [[NSMutableArray alloc] init];
                                }
                                [markerArray addObject:marker];
                            }
                            
                        }
                        
                        [self.GroupCollectionView reloadData];
                        
                        isDidLoad = NO;
                    }
                    
                    
                    
                }
                
                
            });
            
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
                    
                    [cusViewWindow removeFromSuperview];
        
                    [Utilities displayToastWithMessage:@"Alerady added to prefered list"];
                    
                }
                
                
                 });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                
                [mapView clear];
                [barsArray removeAllObjects];
                [latitudeArray removeAllObjects];
                [longitudeArray removeAllObjects];
                [self.GroupCollectionView reloadData];
                [Utilities displayToastWithMessage:@"No Data Found"];
                
//                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction * ok  = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                    homeTabViewController * home = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
//
//
//                    [home setSelectedIndex:3];
//                    //[self.navigationController pushViewController:home animated:YES];
//                   // [self presentViewController:home animated:YES completion:nil];
//                }];
//                [alert addAction:ok];
//                [self presentViewController:alert animated:YES completion:^{
//
//                }];
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



#pragma mark collectionview delegates


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return barsArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCollectionViewCell" forIndexPath:indexPath];
    
     dispatch_async(dispatch_get_main_queue(), ^{
    
   // [Utilities addShadowtoView:cell];

         [Utilities addShadowtoView:cell.cellView];
         UICollectionViewScrollPositionCenteredVertically;
         
         self.row = indexPath.row;
    
    cell.restaurantTitle.text =  [[barsArray objectAtIndex:indexPath.row ]objectForKey:@"merchant_name"];
    
         NSString * distanceStr = [Utilities null_ValidationString:[[barsArray objectAtIndex:indexPath.row ]objectForKey:@"distance"]];
         
         cell.distanceLbl.text = [NSString stringWithFormat:@"%@km",distanceStr];
    
   NSString * imgName = [Utilities null_ValidationString:[[barsArray objectAtIndex:indexPath.row ]objectForKey:@"merchant_banner"]] ;
    
         if (imgName.length>0)
         {
NSString * ImageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/merchant_banners/%@",imgName];
             
             NSLog(@"images uploaded string %@",ImageString);
             
             NSURL *url = [NSURL URLWithString:ImageString];
             [ cell.restaurantImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
         }
         
         
         cell.autoresizingMask = NO;
         
         cell.areaOfRestaurant.text = [Utilities null_ValidationString:[[barsArray objectAtIndex:indexPath.row ]objectForKey:@"address"]];
         cell.areaOfRestaurant.adjustsFontSizeToFitWidth = YES;
    
    cell.AddtoPreferdBtn.tag=indexPath.row;
    
    [cell.AddtoPreferdBtn addTarget:self action:@selector(addToPreferedAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    cell.layer.borderWidth = 0.5;
//    
//    cell.layer.cornerRadius = 4;
    
    
    //[Utilities addShadowtoView:cell.contentView];
    
     });
    return cell;
    
}




- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width - 20, collectionView.frame.size.height);
   
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

     dispatch_async(dispatch_get_main_queue(), ^{
         
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         
    detailRestaurantViewController *detailPage = [storyboard instantiateViewControllerWithIdentifier:@"detailRestaurantViewController"];
    
    detailPage.dict = [barsArray objectAtIndex:indexPath.row];
         
    [self.navigationController pushViewController:detailPage animated:YES];
     });
}








@end
