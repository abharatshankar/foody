//
//  SearchLocationsViewController.m
//  RushNow
//
//  Created by  on 10/11/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "AddAddressManually.h"
#import "Constants.h"
#import "LcnManager.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "AddressViewController.h"
//#import "Utilities.h"
//#import "ServiceManager.h"
//#import "User_AddressViewController.h"
//#import "User_AddNewAddressViewController.h"

@interface AddAddressManually ()<ServiceHandlerDelegate/*,GMSMapViewDelegate*/>
{
    NSString * strLatitude,*strLongitude,*locationAddressStr,*locationIdStr;
    NSDictionary *manuvalDataDictionary;
    NSMutableArray *locationsFilterResults;
    NSArray *subplacesArr;
    UIView *lcnBGView;
  IBOutlet  UILabel *locationLbl;
    
}

@property (weak, nonatomic) IBOutlet UILabel *dropLocLbl;

@end

@implementation AddAddressManually
@synthesize couriourOrOrderStr,addrssforManualDrop;
@synthesize currentLocationStr,classTypeStr,dropLocLbl,saveaddress;


- (void)viewDidLoad {
    [super viewDidLoad];
    

//    self.title = @"Address";
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor whiteColor],
//       NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Semibold" size:18]}];

    [USERDEFAULTS setValue:@"Yes" forKey:@"ShowUserlocation"];
    
    [self.view endEditing:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) { // For iOS7
        UIColor *searchBarColor = [UIColor blueColor];
        [[UISearchBar appearance] setBackgroundColor:searchBarColor];
    }
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:MENUBGCOLOR];
    
        // Do any additional setup after loading the view from its nib.
    //    if(IS_IPHONE_4)
    //    {
    //        customMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 60, [[Constants sharedManager] screenRect].size.width, [[Constants sharedManager] screenRect].size.height-[[Constants sharedManager] screenRect].size.height/2-25)];
    //
    //    }
    //    else
    //    {
    customMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200)];
    // }
    [customMapView setZoomEnabled:YES];
    [customMapView setScrollEnabled:YES];
    customMapView.delegate = self;
    
    [self.view addSubview:customMapView];
    point = [[MKPointAnnotation alloc] init];
    
    
    shouldBeginEditing = YES;
    
    locationsFilterResults = [[NSMutableArray alloc] init];
   
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = WHITECOLOR;
    
//    self.navigationController.navigationBar.backgroundColor = headbgColor;
//    self.navigationController.navigationBar.tintColor = WHITECOLOR;

    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    [self updateMainBarItems];
    
    searchbar.placeholder = @"Search Address";
    //[self LoadLocationandMap];
    // [self.navigationController setNavigationBarHidden:YES animated:NO];
    // Fix annotation
    
    //    [manualBtn setImage:[UIImage imageNamed:@"home-512"] forState:UIControlStateNormal];
    //    [self.mapView addSubview:manualBtn]
    
    // Fix annotation
    _fixAnnotation = [[CustomAnnotation alloc] initWithTitle:@"" subTitle:@"" detailURL:nil location:customMapView.userLocation.coordinate];
    // [customMapView addAnnotation:self.fixAnnotation];
    
    // Annotation image.
    CGFloat width = 20;
    CGFloat height = 20;
    CGFloat margiX = customMapView.center.x - (width / 2);
    CGFloat margiY = customMapView.center.y - (height / 2) -22;
    

    
    // 32 is half size for navigationbar and status bar height to set exact location for image.

    _annotationImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, width, height)];

//    _annotationImage = [[UIImageView alloc] initWithFrame:CGRectMake(margiX, margiY-65, width, height)];
    [self.annotationImage setImage:[UIImage imageNamed:@"mapannotation.png"]];
    self.annotationImage.contentMode = UIViewContentModeScaleAspectFill;
    self.annotationImage.clipsToBounds = YES;


    
    [self performSelector:@selector(showUserLocation) withObject:nil afterDelay:0.01];;
    
    
    lcnBGView = [[UIView alloc] init];
    [self.view addSubview:lcnBGView];
    [lcnBGView setFrame:CGRectMake(0, SCREEN_HEIGHT-95, SCREEN_WIDTH, 50)];
    lcnBGView.backgroundColor = REDCOLOR;
    
    locationLbl = [[UILabel alloc] init];
    [locationLbl setFrame:CGRectMake(5, 0,SCREEN_WIDTH-10, 50)];
    locationLbl.font=[UIFont fontWithName:@"MyriadPro-Regular" size:13.0];
    [locationLbl setBackgroundColor:CLEARCOLOR];
    locationLbl.textColor = WHITECOLOR;
    locationLbl.textAlignment =  NSTextAlignmentCenter;
    locationLbl.text = @" ";
    locationLbl.numberOfLines = 0;
    [lcnBGView addSubview:locationLbl];
    [self.view bringSubviewToFront:lcnBGView];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    // self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    [[popbgView layer] setCornerRadius:8.0f];
    [[popbgView layer] setMasksToBounds:YES];
    popbgView.layer.borderColor = GrayColor.CGColor;
    popbgView.layer.borderWidth = 0.5;
    
    
    
    
    [[searchView layer] setCornerRadius:8.0f];
    [[searchView layer] setMasksToBounds:YES];
    searchView.layer.borderColor = GrayColor.CGColor;
    searchView.layer.borderWidth = 0.5;
    
    
    lblAdress.text = currentLocationStr;
    [self.view bringSubviewToFront:dropLocLbl];
    [self.view bringSubviewToFront:dropBtn];
    [self.view bringSubviewToFront:popbgView];
    [self.view bringSubviewToFront:searchbar];
    [self.view bringSubviewToFront:searchBtn];
    [self.view bringSubviewToFront:searchView];
    
    

}

-(void)updateMainBarItems
{
//    SWRevealViewController *revealController = [self revealViewController];
//    [revealController tapGestureRecognizer];
//    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *fixedSpace;
    UIBarButtonItem *fixedSpace2;
    
    fixedSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [fixedSpace setWidth:-5];
    fixedSpace2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [fixedSpace2 setWidth:-5];
    [arrRightBarItems addObject:fixedSpace];
    [arrLeftBarItems addObject:fixedSpace2];
    
    
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS){
        btnLib1.frame = CGRectMake(0, 0, 33, 33);
        
    }
    else
    {
        btnLib1.frame = CGRectMake(0, 0, 26, 26);
    }
    
   // [btnLib1 setImage:[UIImage imageNamed:REVELICON] forState:UIControlStateNormal];

    
    [btnLib1 setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    [btnLib1 addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];


    UIButton *btnLib = [UIButton buttonWithType:UIButtonTypeCustom];
  
    [btnLib setTitle:@"Save" forState:UIControlStateNormal];
     btnLib.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];

    [btnLib setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btnLib.frame = CGRectMake(0, 0, 50, 23);
    btnLib.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *  barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnLib];
    
    [btnLib addTarget:self action:@selector(saveMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [arrRightBarItems addObject:barButtonItem1];
    
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;

    
//    self.navigationController.navigationBar.backgroundColor = headbgColor;
    self.navigationController.navigationBar.tintColor = WHITECOLOR;
    
}
-(void)backButtonClicked:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)LoadLocationandMap{
    
    currentLocation = [[CLLocationManager alloc]init];
    currentLocation.desiredAccuracy = kCLLocationAccuracyBest;
    currentLocation.delegate = self;
    [currentLocation startUpdatingLocation];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [currentLocation requestAlwaysAuthorization]; // Add This Line for iOS8
    }
    
    lblAdress = [[UILabel alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50 , SCREEN_WIDTH, 50)];
    lblAdress.backgroundColor = BGNavigationCOLOR;
    lblAdress.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    lblAdress.textAlignment = NSTextAlignmentCenter;
    lblAdress.textColor = [UIColor whiteColor];
    lblAdress.numberOfLines = 2;
    lblAdress.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:lblAdress];
    
    
}


-(void)saveMethodClicked:(id)sender
{
    
    NSString *locationAddressStrValue = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"locationAddressStr"]];
    
    if(locationAddressStrValue.length>0){
        
        manuvalDataDictionary = @{@"manualAddess":locationAddressStrValue,@"manuvalLocationLat":[USERDEFAULTS valueForKey:@"LAT"] ,@"manuvalLocationLong":[USERDEFAULTS valueForKey:@"LONG"],@"manuvalLocationPlaceId":[USERDEFAULTS valueForKey:@"locationid"]};
        
            [USERDEFAULTS setObject:locationAddressStrValue forKey:@"saveAddress"];
        
        [USERDEFAULTS setObject:manuvalDataDictionary forKey:@"saveAddresslatlong"];

        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddressViewController *prcObj = [storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
        
                    [self.navigationController pushViewController:prcObj animated:YES];
        
    }
    
}



-(void)backBtnClicked:(UIButton*)sender
{
    //locationTableView.hidden = YES;
    [searchbar resignFirstResponder];
    
    if([classTypeStr isEqualToString:@"checkOutOrder"]||[classTypeStr isEqualToString:@"CouriercheckOut"]){
        
        [USERDEFAULTS removeObjectForKey:@"EditCheckOutDeliveryAddress"];
    }
    
    [USERDEFAULTS setBool:YES forKey:@"NodataSaved"];
    
    
    self.navigationController.navigationBarHidden =NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
}

#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [customMapView removeAnnotation:point];
    }
    
    else{
        NSString *rawString = searchText;
        rawString = [rawString stringByReplacingOccurrencesOfString:@" " withString:@""];
        //
        //    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
        // NSLog(@"rawString =%@",rawString);
        
        if ([rawString length] != 0) {
            shouldBeginEditing = NO;
            [self updateSearchString:rawString];
        }
        
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    // self.searchDisplayController.searchResultsTableView.frame = CGRectMake(0, 50, 400, 500);
    [UIView commitAnimations];
    return YES;
    
}


- (void)updateSearchString:(NSString*)aSearchString
{
    
//    [NOTIFICATIONCENTER addObserver:self selector:@selector(didreceiveLocaionAddress:) name:GOOGLEMANUALLOCATIONS_NOTIFY object:nil];
//    
    [self ServiceCallSearchString:aSearchString];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchbar resignFirstResponder];
    searchbar.text = @"";
    searchBar.placeholder = @"Search Address";
    
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
    @try {
         if([(NSArray*)[responseInfo objectForKey:@"results"] count ]>0){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 [locationsFilterResults removeAllObjects];
                [self didreceiveLocationAddress:responseInfo];
                
            });
               dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
        });
         }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",@"Error"];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });

        }
    }
    
    @catch (NSException *exception) {
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
        });
        [self.view endEditing:YES];
    }
    
}




#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}


//---------------------------------------------------------------

#pragma mark
#pragma mark MKMapView delegate methods

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    //    for (UIView *view in views) {
    //        [self addBounceAnnimationToView:view];
    //    }
}

//---------------------------------------------------------------

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *customAnnotation = (CustomAnnotation *) annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        
        if (annotationView == nil)
            annotationView = customAnnotation.annotationView;
        else
        {
            annotationView.annotation = annotation;
            
        }
        //        [self addBounceAnnimationToView:annotationView];
        
        return annotationView;
    } else
        return nil;
    
    
}

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    //NSLog(@"Region will changed...");
    [customMapView removeAnnotation:self.fixAnnotation];
    [customMapView addSubview:self.annotationImage];
}
-(void)ServiceCallSearchString: (NSString *)searchString
{
    
    
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            

            [service  getLocationswithStrig:searchString];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
}

-(void)ServiceCall: (NSString *)latitude : (NSString *) langtitude
{
   // gettingCurrentLocatoion
    
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
       
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            
            [service  gettingCurrentLocatoion:latitude :langtitude];
            
        });
        
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
    }
    
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    
    if([[USERDEFAULTS valueForKey:@"ShowUserlocation"] isEqualToString:@"Yes"])
    {
        [USERDEFAULTS removeObjectForKey:@"ShowUserlocation"];
        
        [self.annotationImage removeFromSuperview];
        CLLocationCoordinate2D centre = [mapView centerCoordinate];
        self.fixAnnotation.coordinate = centre;
        [customMapView addAnnotation:self.fixAnnotation];
       
        [self ServiceCall: [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude] :[NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude]];

        strLatitude   =  [NSString stringWithFormat:@"%f",centre.latitude];
        strLongitude  =  [NSString stringWithFormat:@"%f",centre.longitude];
    }
    else
    {
        [self.annotationImage removeFromSuperview];
        CLLocationCoordinate2D centre = [mapView centerCoordinate];
        self.fixAnnotation.coordinate = centre;
        [customMapView addAnnotation:self.fixAnnotation];
       
        [self ServiceCall: [NSString stringWithFormat:@"%f",centre.latitude] :[NSString stringWithFormat:@"%f", centre.longitude]];
        
        strLatitude = [NSString stringWithFormat:@"%f",centre.latitude];
        strLongitude = [NSString stringWithFormat:@"%f",centre.longitude];
    }
}

- (void) didreceiveLocationAddress:(NSDictionary *) notification
{
    
    if([(NSArray*)[notification objectForKey:@"results"] count ]>0){
        NSString *locationStr = [[[notification objectForKey:@"results"]valueForKey:@"formatted_address"] objectAtIndex:0];
        
        NSString *locationid = [[[notification objectForKey:@"results"]valueForKey:@"place_id"] objectAtIndex:0];
        
        NSString *latitudeVAlue = [NSString stringWithFormat:@"%f",[[[[[[notification objectForKey:@"results"]valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] objectAtIndex:0] floatValue]];
        
        NSString *longitudeValue = [NSString stringWithFormat:@"%f",[[[[[[notification objectForKey:@"results"]valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] objectAtIndex:0] floatValue]];
        
        
        
        NSString *nameStr = [locationStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray* dataArray = [nameStr componentsSeparatedByString: @","];
        
        BOOL isLocationFound = NO;
        NSString *locationnameStr;
        for(int i =0 ; i<dataArray.count;i++)
        {
            locationnameStr = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:i]];
            NSLog(@"locationnameStr =%@",locationnameStr);
//            if([locationnameStr isEqualToString:@"Hyderabad"] || [locationnameStr isEqualToString:@"Secunderabad"])
//            {
                isLocationFound = YES;
                locationStr=[[[notification valueForKey:@"results"]valueForKey:@"formatted_address"] objectAtIndex:0];
                locationLbl.text = [locationStr uppercaseString];
                [USERDEFAULTS setValue:locationStr forKey:@"locationAddressStr"];
                [USERDEFAULTS setValue:latitudeVAlue forKey:@"LAT"];
                [USERDEFAULTS setValue:longitudeValue forKey:@"LONG"];
                [USERDEFAULTS setValue:locationid forKey:@"locationid"];
//                return;
//            }
 
            
//            else
//            {
//                locationStr=[NSString stringWithFormat:@"We currently don't serve in this Area"];
//                locationLbl.text = [locationStr uppercaseString];
//                [USERDEFAULTS setValue:locationStr forKey:@"locationAddressStr"];
//            }
            
        }
    }
    
}

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // [self showUserLocation];
}

//---------------------------------------------------------------




//---------------------------------------------------------------

#pragma mark
#pragma mark Custom methods

//---------------------------------------------------------------

- (void) showUserLocation
{
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.02;
    span.longitudeDelta = 0.02;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[LcnManager sharedManager] locationManager] location].coordinate, 1500, 1500);
    [customMapView setRegion:[customMapView regionThatFits:region] animated:YES];
}


//- (void) showUserLocation
//{
//    
//    [USERDEFAULTS setValue:@"Yes" forKey:@"ShowUserlocation"];
//    
//    [UIView animateWithDuration:2.0
//                          delay:YES
//                        options:UIViewAnimationOptionAllowAnimatedContent
//                     animations:^{
//                         
//                         CLLocationCoordinate2D location;
//                         location.latitude = [[LcnManager sharedManager]locationManager].location.coordinate.latitude;
//                         location.longitude = [[LcnManager sharedManager]locationManager].location.coordinate.longitude;
//                         
//                         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 600, 600);
//                         [customMapView setRegion:[customMapView regionThatFits:region] animated:NO];
//                         [customMapView removeAnnotation:point];
//                         
//                         [point setCoordinate:location];
//                         
//                         //[customMapView addAnnotation:point];
//                         //[self performSelector:@selector(Animatedtolocation) withObject:nil afterDelay:5.0f];
//                     }
//                     completion:nil];
//    
//}

//---------------------------------------------------------------


//---------------------------------------------------------------

//---------------------------------------------------------------
- (void)getCurrentLocationInfo:(CLLocationCoordinate2D)locCorrdinate
{
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:locCorrdinate.latitude longitude:locCorrdinate.longitude];
    
    NSMutableString* finalStr = [[NSMutableString alloc] init];
    
    // Instantiate _geoCoder if it has not been already
    if (geocoder == nil)
    {
        geocoder = [[CLGeocoder alloc] init];
    }
    
    //Only one geocoding instance per action
    //so stop any previous geocoding actions before starting this one
    if([geocoder isGeocoding])
    {
        [geocoder cancelGeocode];
    }
    [geocoder reverseGeocodeLocation: newLocation
                   completionHandler: ^(NSArray* placemarks, NSError* error)
     {
         
         if([placemarks count] > 0)
         {
             CLPlacemark *foundPlacemark = [placemarks objectAtIndex:0];
             int i;
             
             for(i =0 ;i<[[foundPlacemark.addressDictionary objectForKey:@"FormattedAddressLines"]count];i++)
             {
                 [finalStr appendString:[[foundPlacemark.addressDictionary objectForKey:@"FormattedAddressLines"]objectAtIndex:i]];
                 [finalStr appendString:@","];
                 
             }
             NSString *locationstr = [NSString stringWithFormat:@"  %@",finalStr];
             
             id strAddress =[foundPlacemark.addressDictionary objectForKey:@"FormattedAddressLines"];
             
             [finalStr appendString:[NSString stringWithFormat:@"%@", locationstr]];
             
             
             if ([strAddress isKindOfClass:[NSArray class]])
             {
                 NSMutableString *str = [[NSMutableString alloc]init];
                 id lastEl = [strAddress lastObject];
                 for (NSString* strarry in strAddress) {
                     [str appendString:[NSString stringWithFormat:@" %@",strarry]];
                     if ( strarry == lastEl ){
                         [str appendString:[NSString stringWithFormat:@"."]];
                     }else{
                         [str appendString:[NSString stringWithFormat:@","]];
                     }
                 }
                 lblAdress.text = str;
             }
         }
         else if (error.code == kCLErrorGeocodeCanceled)
         {
             //NSLog(@"Geocoding cancelled");
         }
         else if (error.code == kCLErrorGeocodeFoundNoResult)
         {
             //NSLog(@"No geocode result found");
         }
         else if (error.code == kCLErrorGeocodeFoundPartialResult)
         {
             // NSLog(@"Partial geocode result");
         }
         else
         {
             // NSLog(@"%@", [NSString stringWithFormat:@"Unknown error: %@",
             //error.description]);
         }
     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)dropBtnClicked:(id)sender
{ //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    DeliveryAddresses *delvry;
//    
//    
//    delvry = [[DeliveryAddresses alloc] initWithNibName:@"DeliveryAddresses" bundle:nil];
//    if([classTypeStr isEqualToString:@"Home"]){
//        delvry.classTypeStr=@"Home";
//    }
//    else
//        if([classTypeStr isEqualToString:@"SingleMultiple"])
//            
//        {
//            delvry.classTypeStr=@"SingleMultiple";
//            
//        }
//        else
//            if([classTypeStr isEqualToString:@"CourierSingleMultiple"])
//                
//            {
//                delvry.classTypeStr=@"CourierSingleMultiple";
//                
//            }
//    
//            else if([classTypeStr isEqualToString:@"CouriercheckOut"])
//            {
//                delvry.classTypeStr = @"CouriercheckOut";
//                
//            }
//            else
//                if([classTypeStr isEqualToString:@"checkOutOrder"])
//                    
//                {
//                    delvry.classTypeStr=@"checkOutOrder";
//                    
//                }
//    
//    
//    
//    [self.navigationController pushViewController:delvry animated:YES];
    
}


- (IBAction)nextAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressViewController *barsList = [storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
    
    barsList.strLat = strLatitude;
    barsList.strLong = strLongitude;
    
    [self.navigationController pushViewController:barsList animated:YES];

    
    
   
   
}
@end
