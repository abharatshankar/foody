//
//  DirectionsViewController.m
//  buzzedApp
//
//  Created by ashwin challa on 9/8/17.
//  Copyright © 2017 adroitent.com. All rights reserved.
//

#import "DirectionsViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "homeTabViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"

@interface DirectionsViewController ()
{
    NSMutableData *_responseData;
    NSMutableArray *tableArr;
    NSMutableArray *polyArr;
    GMSMutablePath *path1;
}
@end

@implementation DirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(0, 5, 30, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    phoneButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    // phoneBarItem.action = @selector(nextAction);
    [arrLeftBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[phoneButton setTitle:singleTonInstance.eventNameSt forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"icons8-left-24.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    [self Hello];
    // Do any additional setup after loading the view.
}


-(void)backAction
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeTabViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
    
    
    [invite setSelectedIndex:2];
    
    [self presentViewController:invite animated:YES completion:nil];
    
    
    
    
}
-(void)Hello
{
    float latitudeFloat,longitudeFloat;
    latitudeFloat =  [self.latitudeString floatValue];
    longitudeFloat = [self.longitudeString floatValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:latitudeFloat longitude:longitudeFloat zoom:12];
        _mapView =[GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
        
        GMSMarker *marker=[[GMSMarker alloc]init];
        marker.position=CLLocationCoordinate2DMake(latitudeFloat, longitudeFloat);
        marker.icon=[UIImage imageNamed:@"aaa.png"] ;
        marker.groundAnchor=CGPointMake(0.5,0.5);
        marker.map=_mapView;
        
        GMSMarker *marker1=[[GMSMarker alloc]init];
        marker1.position=CLLocationCoordinate2DMake(18.315364, 83.895578);
        marker1.icon=[UIImage imageNamed:@"aaa.png"] ;
        marker1.groundAnchor=CGPointMake(0.5,0.5);
        marker1.map=_mapView;
        
        
        
        GMSMutablePath *path = [GMSMutablePath path];
        [path addCoordinate:CLLocationCoordinate2DMake(37.36, -122.0)];
        [path addCoordinate:CLLocationCoordinate2DMake(37.45, -122.0)];
        
        
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeColor = [UIColor redColor];
        polyline.strokeWidth = 10.f;
        polyline.geodesic = YES;
        
        polyline.map = _mapView;
        self.view=_mapView;
        
        
        ////// for finding road path //////
        
        NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%f,%f", marker.position.latitude, marker.position.longitude, marker1.position.latitude, marker1.position.longitude];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
        
//        UIApplication *application = [UIApplication sharedApplication];
//        NSURL *URL = [NSURL URLWithString:googleMapUrlString];
//        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
//            if (success) {
//                NSLog(@"Opened url");
//            }
//        }];
        
//        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps:"]]) {
//            NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?ll=%@,%@",destinationLatitude,destinationLongitude];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//        } else {
//            NSString *string = [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%@,%@",destinationLatitude,destinationLongitude];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
//        }
        ///////////upto here///////////////
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
