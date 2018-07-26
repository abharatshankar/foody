//
//  CreateEventViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/11/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "CreateEventViewController.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "createEventCollectionViewCell.h"
#import "eventsMenuViewController.h"
#import "SingleTon.h"
#import "createNewEventViewController.h"
#import "creatingEventViewController.h"

#import "filterViewController.h"



@interface CreateEventViewController ()<GMSMapViewDelegate,ServiceHandlerDelegate>
{
CLLocationManager * locationManager;
    NSMutableArray * eventArray;
    
    CLGeocoder *geocoder;
    CLLocationCoordinate2D theCoordinate;
    GMSCameraPosition *cameraPosition;
    GMSMapView *mapView;
    SingleTon * singleTonInstance;
     NSMutableArray * longitudeArray,*latitudeArray;
    NSDictionary *requestDict;

}
@property (strong, nonatomic) VCFloatingActionButton *addButton;

@end

@implementation CreateEventViewController
@synthesize addButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
     singleTonInstance=[SingleTon singleTonMethod];
    
    
    longitudeArray = [[NSMutableArray alloc]init];
    latitudeArray = [[NSMutableArray alloc]init];
    
    

    
    ///////////////////////////////////////////////////////////////////
    ///////////////////////this is for side menu////////////////////////
    ///////////////////////////////////////////////////////////////////
    SWRevealViewController*sw=[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    _menu.target=sw.revealViewController;
    _menu.action=@selector(revealToggle:);
    [self.menu setImage:[UIImage imageNamed:@"toogle_menu_icon.png"]];
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    // this is for navigation bar background color
    self.navigationController.navigationBar.barTintColor = REDCOLOR;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    ///////////////////////////////////////////////////////////////////
    ///////////////////////----- side menu -----////////////////////////
    ///////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    //for right bar buttons
//    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    phoneButton.frame = CGRectMake(275, 5, 28, 25);
//    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    phoneButton.showsTouchWhenHighlighted=YES;
//    
//    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
//    phoneBarItem.action = @selector(phoneAction);
//    [arrRightBarItems addObject:phoneBarItem];
//    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [phoneButton setImage:[UIImage imageNamed:@"invite_icon.png"] forState:UIControlStateNormal];
//    //[phoneButton addTarget:self action:@selector(addInvitationAction) forControlEvents:UIControlEventTouchUpInside];
//    [phoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(275, 5, 28, 25);
    [menuButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    menuButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem *  meuBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    //meuBarItem.action = @selector(menuAction);
    [arrRightBarItems addObject:meuBarItem];
    menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuButton setImage:[UIImage imageNamed:@"icons8-filter-filled-80.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(bellAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    UIButton *menuButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton1.frame = CGRectMake(275, 5, 28, 25);
    [menuButton1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    menuButton1.showsTouchWhenHighlighted=YES;
    
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
    menuButton2.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem *  meuBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton2];
    meuBarItem2.action = @selector(menuAction);
    [arrRightBarItems addObject:meuBarItem2];
    menuButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuButton2 setImage:[UIImage imageNamed:@"map_active_icon.png"] forState:UIControlStateNormal];
    //[menuButton2 addTarget:self action:@selector(showMapAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton2 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    
    //--right buttons--//
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(0, 0, 30, 22);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[btntitle setTitle:@"Nearby Bars" forState:UIControlStateNormal];
    [btntitle setImage:[UIImage imageNamed:@"toogle_menu_icon.png"] forState:UIControlStateNormal];
    
    [btntitle addTarget:sw.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    
    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    
    
    [self mapDisplayMethod];

   
    
    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreen mainScreen].bounds.size.height - 44 - 80, 44, 44);
    
    addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"plus"] andPressedImage:[UIImage imageNamed:@"cross"] withScrollview:nil];
    
    
    addButton.imageArray = @[@"faq"];
    addButton.labelArray = @[@"Create Event"];
    
    
    
    addButton.hideWhileScrolling = YES;
    addButton.delegate = self;
    
    
    //    _dummyTable.dataSource = self;
    //    _dummyTable.delegate = self;
    
    
    [self.view addSubview:addButton];
    
}





-(void)mapDisplayMethod
{

    
    
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
    
    
    
    
    
    
    NSMutableArray * latitudeArray = [[NSMutableArray alloc]initWithObjects:@"17.424887",@"17.426719",@"17.427256",@"17.425217",@"17.394047", nil];
    
    NSMutableArray * longitudeArray = [[NSMutableArray alloc]initWithObjects:@"78.447891",@"78.447558",@"78.435420",@"78.425806",@"78.421870", nil];
    
    cameraPosition=[GMSCameraPosition cameraWithLatitude:17.4294 longitude:78.491684 zoom:12];
    mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
    mapView.myLocationEnabled = YES;
    mapView.delegate = self;
    //self.view = mapView;
    
//    mapView.frame = CGRectMake(0,self.eventCollection.frame.origin.y+self.eventCollection.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-105);
//    
//    [self.view addSubview:mapView];
    
    mapView.frame = self.view.frame;
    [self.view addSubview:mapView];
    [self.view addSubview:addButton];
    
    
    ////////////////
    // annotation points fit on screen////////////////
    ////////////////
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    
    
    for (int i =0; i<latitudeArray.count; i++)
    {
        
        
        //        [latitudeArray addObject:[[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"latitude"]];
        //        [longitudeArray addObject:[[[responseInfo objectForKey:@"response"]  objectAtIndex:i] objectForKey:@"longitude"]];
        
        ////////////////////////////////////////////////////////
        /////////////// // to display nearBy bars////////////////
        GMSMarker *marker = [[GMSMarker alloc] init];
        CGFloat latitude = [[latitudeArray objectAtIndex:i] doubleValue];
        CGFloat longitude = [[longitudeArray objectAtIndex:i] doubleValue];
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        // marker.snippet = [self.SPIDArray objectAtIndex:i];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = mapView;
        marker.zIndex = (UInt32)i;
        marker.title = @"static title";
        //        marker.title = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_name"];
        //        marker.snippet = [[barsArray objectAtIndex:i ]objectForKey:@"merchant_id"];
        
        // for marker image icon custom resizing i used frame and imageView , imageView displayed in marker.iconView
        CGRect frame = CGRectMake(0, 0, 70, 70);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        
        // marker.icon  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://testingmadesimple.org/buzzed/uploads/bartypes/%@",[[barsArray objectAtIndex:i ]objectForKey:@"image"]]]]];
        // imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://testingmadesimple.org/buzzed/uploads/bartypes/%@",[[barsArray objectAtIndex:i ]objectForKey:@"image"]]]]];
        
        imageView.image = [UIImage imageNamed:@"map_active_icon.png"];
        marker.iconView = imageView;
        marker.iconView.clipsToBounds =YES;
        marker.iconView.layer.cornerRadius = 38;
        bounds = [bounds includingCoordinate:marker.position];
        
        //to set image for icon
        //marker.icon = [UIImage imageNamed:@"beer_mug.png"];
        ////////////////////////    upto here   ////////////////////////
        ////////////////////////////////////////////////////////////////
    }
    
    self.view.backgroundColor = WHITECOLOR;
    
    
    
    
    
    
    
   
}


- (IBAction)addNewEventAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    creatingEventViewController *newEvent = [storyboard instantiateViewControllerWithIdentifier:@"creatingEventViewController"];
    [self.navigationController pushViewController:newEvent animated:YES];

}


// flaoting button method
-(void) didSelectMenuOptionAtIndex:(NSInteger)row
{
    NSLog(@"Floating action tapped index %tu",row);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    creatingEventViewController *newEvent = [storyboard instantiateViewControllerWithIdentifier:@"creatingEventViewController"];
    [self.navigationController pushViewController:newEvent animated:YES];
}



-(void)menuAction
{
    //eventsMenuViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    eventsMenuViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"eventsMenuViewController"];
    [self.navigationController pushViewController:menu animated:YES];
}

-(void)bellAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    filterViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"filterViewController"];
    [self.navigationController pushViewController:menu animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAllPins
{
    self.mapView.delegate=self;
    
    NSArray *name=[[NSArray alloc]initWithObjects:
                   @"VelaCherry",
                   @"Perungudi",
                   @"Tharamani", nil];
    
    NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc] initWithCapacity:name.count];
    
    [arrCoordinateStr addObject:@"17.449896, 78.390540"];
    [arrCoordinateStr addObject:@"17.452199, 78.392514"];
    [arrCoordinateStr addObject:@"17.458641, 78.388488"];
    
    for(int i = 0; i < name.count; i++)
    {
        [self addPinWithTitle:name[i] AndCoordinate:arrCoordinateStr[i]];
    }
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    
    [self.mapView addAnnotation:mapPin];
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    createEventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"createEventCollectionViewCell" forIndexPath:indexPath];
    
   // cell.nameLbl.text = [futuredArray objectAtIndex:indexPath.row];
    
    
    cell.imageViw.layer.borderWidth = 2;
    cell.imageViw.layer.borderColor = REDCOLOR.CGColor;
    cell.imageViw.layer.cornerRadius = 21;
    cell.imageViw.clipsToBounds = YES;
    
    
    return cell;
    
}



- (IBAction)hidePreviousAction:(id)sender {
    
   // self.previousView.hidden = YES;
    
   // [self.navigationController.navigationBar willRemoveSubview:self.previousView];
    [self mapDisplayMethod];
}

- (IBAction)ExistingGrp_Btn:(id)sender
{
   
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@userEvents",BASEURL];
        
        
        requestDict = @{
                        @"user_id":[NSString stringWithFormat:@"%@",[Utilities getUserID]]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }

    

}

- (IBAction)NewGrp_Btn:(id)sender
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@restaurants",BASEURL];
        
        
        requestDict = @{
                        @"user_id":[NSString stringWithFormat:@"%@",[Utilities getUserID]]
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            // [self uploadImagetoServer:urlStr];
            
        });
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];

    }

}



# pragma mark - Webservice Delegates

- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
    
    
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
        // [Utilities displayCustemAlertViewWithOutImage:@"Failed to getting data" :self.view];
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    NSLog(@"responseInfo :%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        
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
        [Utilities removeLoading:self.view];
    });

}



@end
