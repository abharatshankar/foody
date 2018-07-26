//
//  DirectionsViewController.h
//  buzzedApp
//
//  Created by ashwin challa on 9/8/17.
//  Copyright © 2017 adroitent.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface DirectionsViewController : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate, GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property NSString * latitudeString;
@property NSString * longitudeString;
@end
