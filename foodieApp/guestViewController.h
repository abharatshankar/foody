//
//  guestViewController.h
//  foodieApp
//
//  Created by ashwin challa on 1/31/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LcnManager.h"
#import "CustomAnnotation.h"
#import "guestViewController.h"

@interface guestViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *sourceCoordinate;
    CLLocation *destinationCoordinate;
}

@property (strong, nonatomic) IBOutlet MKMapView *MapView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *pinnedLbl;


@property (strong, nonatomic) IBOutlet UIScrollView *guestScrollView;

@property (strong, nonatomic) IBOutlet UILabel *goingCount;
@property (strong, nonatomic) IBOutlet UILabel *interestedCount;
@property (strong, nonatomic) IBOutlet UILabel *totalCount;

@end
