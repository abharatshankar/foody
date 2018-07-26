//
//  AddressViewController.h
//  myTask
//
//  Created by ashwin challa on 10/16/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"

@interface AddressViewController : UIViewController

@property NSString * strLong , * strLat;
//@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@property NSMutableArray * barsArray;
@property AppDelegate *appDelg;

@property NSEntityDescription *enterTextED;
- (IBAction)saveAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameTxt;
@property (strong, nonatomic) IBOutlet UITextField *emailTxt;
@property (strong, nonatomic) IBOutlet UITextField *numberTxt;

@end
