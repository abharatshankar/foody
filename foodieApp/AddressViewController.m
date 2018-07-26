//
//  AddressViewController.m
//  myTask
//
//  Created by ashwin challa on 10/16/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "AddressViewController.h"
//#import <GoogleMaps/GoogleMaps.h>
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "SingleTon.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "AddAddressManually.h"

@interface AddressViewController ()</*GMSMapViewDelegate,*/CLLocationManagerDelegate,ServiceHandlerDelegate>
{
//GMSCameraPosition *cameraPosition;
    NSMutableArray * latitudeArray,*longitudeArray,*itemsAlreadyInDataBaseArray,*storedData;
    SingleTon * singleTonInstance;
    NSManagedObject * obj;
}
@end
//@import GoogleMaps;
@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_mapView.delegate=self;
    
    
    NSLog(@"lat== %@ and long == %@",_strLat,_strLong);
    
    
    storedData = [[NSMutableArray alloc]init];
    _appDelg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _enterTextED = [NSEntityDescription entityForName:@"Data" inManagedObjectContext:_appDelg.persistentContainer.viewContext];
    itemsAlreadyInDataBaseArray =  [[NSMutableArray alloc]init];
    latitudeArray = [[NSMutableArray alloc]init];
    longitudeArray = [[NSMutableArray alloc]init];
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    [singleTonInstance.latitudeArray addObject:_strLat];
    [singleTonInstance.longitudeArray addObject:_strLong];
    
//    cameraPosition=[GMSCameraPosition cameraWithLatitude:17.4294 longitude:78.491684 zoom:12];
//    cameraPosition=[GMSCameraPosition cameraWithLatitude:[_strLat floatValue] longitude:[_strLong floatValue] zoom:12];
//
//    _mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
//    _mapView.myLocationEnabled = YES;
//    _mapView.delegate = self;
//    [self.view addSubview:_mapView];
//    
//    _mapView.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
    /// for bars

    
    NSFetchRequest * fetchReq = [NSFetchRequest fetchRequestWithEntityName:@"Data"];
    NSError * fetchErrorObj;
    storedData = [_appDelg.persistentContainer.viewContext executeFetchRequest:fetchReq error:&fetchErrorObj];
    NSLog(@"array count is %lu",storedData.count);
    
    
    
    for (int i=0; i<storedData.count; i++)
    {
        obj = [storedData objectAtIndex:i];
         [longitudeArray addObject:[obj valueForKey:@"longitude"]];
        [latitudeArray addObject:[obj valueForKey:@"latitude"] ];
    }
    
    NSLog(@"\n long %@ \n lat %@",longitudeArray,latitudeArray);
    ///////////////////////////////////-------------------///////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    // this is to display content if already stored in data base
    
    
//    NSManagedObjectContext *context ;
//    
//    NSFetchRequest *fetchRequest  =  [[NSFetchRequest alloc]init];
//    NSEntityDescription *entity   =  [NSEntityDescription entityForName:@"Data" inManagedObjectContext:context];
//    
//    [fetchRequest setEntity:entity];
//    
//    NSError *error=nil;
//   
//    
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//
//    
//    if (fetchedObjects.count)
//    {
//       
//        
//        for(int i=0 ;i<fetchedObjects.count;i++)
//        {
//            obj = [fetchedObjects objectAtIndex:i];
//            
//            [itemsAlreadyInDataBaseArray addObject:obj];
//            
//            NSManagedObject * object;
//            
//            object =[itemsAlreadyInDataBaseArray objectAtIndex:0];
//            
//            NSLog(@"-----========-------%@",[object valueForKey:@"longitude"]);
//            
//            [longitudeArray addObject:[object valueForKey:@"longitude"]];
//            [latitudeArray addObject:[object valueForKey:@"latitude"] ];
//            
//        }
//        
//    }
//    else
//    {
//    
//        [latitudeArray addObject:_strLat ];
//        [longitudeArray addObject:_strLong];
//    }
//    
    
    //    //------------// upto here//-----------------//
    //
    //    ///////////////////////////////////-------------------///////////////////////////////////////////////////
    
//    cameraPosition=[GMSCameraPosition cameraWithLatitude:17.4294 longitude:78.491684 zoom:12];
//    _mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
//    _mapView.myLocationEnabled = YES;
//    _mapView.delegate = self;

    
    for (int i =0; i<latitudeArray.count; i++)
    {
        
        
        ////////////////////////////////////////////////////////
//        /////////////// // to display nearBy bars////////////////
//        GMSMarker * marker = [[GMSMarker alloc] init];
//        CGFloat latitude = [[latitudeArray objectAtIndex:i] doubleValue];
//        CGFloat longitude = [[longitudeArray objectAtIndex:i] doubleValue];
//        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
//        // marker.snippet = [self.SPIDArray objectAtIndex:i];
//        marker.appearAnimation = kGMSMarkerAnimationPop;
//        marker.map = _mapView;
//       
        
        //marker.icon = [UIImage imageNamed:@"point.png"];
        
        //to set image for icon
        //marker.icon = [UIImage imageNamed:@"beer_mug.png"];
        ////////////////////////    upto here   ////////////////////////
        ////////////////////////////////////////////////////////////////
    }
    ////////
    
   
    [self getLocation];
    
    // Do any additional setup after loading the view.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    //    GMSMarker *pointMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)];
    //    pointMarker.icon = [UIImage imageNamed:@"aroundme.png"];
    //    pointMarker.map = mapView;
}


- (NSManagedObjectContext *)managedObjectContext
{
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(id)sender {
    if (_nameTxt.text.length)
    {
        _appDelg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        _enterTextED = [NSEntityDescription entityForName:@"Data" inManagedObjectContext:_appDelg.persistentContainer.viewContext];
        
        NSManagedObject *managedObject = [[NSManagedObject alloc]initWithEntity:_enterTextED insertIntoManagedObjectContext:_appDelg.persistentContainer.viewContext];
        [managedObject setValue:_nameTxt.text forKey:@"name"];
        [managedObject setValue:_numberTxt.text forKey:@"number"];
        [managedObject setValue:_emailTxt.text forKey:@"email"];
        [managedObject setValue:_strLong forKey:@"longitude"];
        [managedObject setValue:_strLat forKey:@"latitude"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddAddressManually *barsList = [storyboard instantiateViewControllerWithIdentifier:@"AddAddressManually"];
        
        [self.navigationController pushViewController:barsList animated:YES];
        

    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"enter values"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        
                                    }];
        
        
        //Add your buttons to alert controller
        
        [alert addAction:yesButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
   
    
    
    
    NSError *errorObj;
    
    [_appDelg.persistentContainer.viewContext save:&errorObj];
    
    
    
}
@end
