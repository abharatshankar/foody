//
//  CreateEventViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/11/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <GoogleMaps/GoogleMaps.h>

#import "VCFloatingActionButton.h"

@interface CreateEventViewController : UIViewController<MKMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,floatMenuDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menu;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UICollectionView *eventCollection;
@property (strong, nonatomic) IBOutlet UIView *previousView;
@property (strong, nonatomic) IBOutlet UIButton *hidePreviousView;
- (IBAction)hidePreviousAction:(id)sender;

- (IBAction)ExistingGrp_Btn:(id)sender;
- (IBAction)NewGrp_Btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *innerView;


@end
