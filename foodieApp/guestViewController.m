//
//  guestViewController.m
//  foodieApp
//
//  Created by ashwin challa on 1/31/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "guestViewController.h"
#import <MapKit/MapKit.h>


@interface guestViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) MKPlacemark *destination;
@property (strong,nonatomic) MKPlacemark *source;

@end

@implementation guestViewController
@synthesize  MapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.guestScrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+300);
    
    MapView.scrollEnabled = NO;
    
    NSMutableArray *arrBtns = [[NSMutableArray alloc]init];
    
    
    UIButton *btnplus = [[UIButton alloc]initWithFrame:CGRectMake(36, 22, 28, 25)];
    [btnplus setImage:[UIImage imageNamed:@"search_icon.png"] forState:UIControlStateNormal ];
    UIBarButtonItem * itemplus = [[UIBarButtonItem alloc] initWithCustomView:btnplus];
    [btnplus addTarget:self action:@selector(plusMethodClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnsettings = [[UIButton alloc]initWithFrame:CGRectMake(116, 22, 28, 25)];
    [btnsettings setImage:[UIImage imageNamed:@"search_icon.png"] forState:UIControlStateNormal ];
    UIBarButtonItem * itemsettings = [[UIBarButtonItem alloc] initWithCustomView:btnsettings];
    [btnsettings addTarget:self action:@selector(searchMethodClicked) forControlEvents:UIControlEventTouchUpInside];
    [arrBtns addObject:itemsettings];
    [arrBtns addObject:itemplus];
    
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    
    
    _descriptionLbl.numberOfLines = 0;
    _descriptionLbl.text = @"Enter large amount of text here jhdgd djbcj cjhcghbcb xjbdgc sgfdgd dhgdufh cghijgn ihgiuhi ihubhoihg vihjio joigvh vihoghihbg vubhufhiuhv";
    [_descriptionLbl sizeToFit];
    
    
    self.pinnedLbl.frame = CGRectMake(self.pinnedLbl.frame.origin.x, self.descriptionLbl.frame.origin.y+self.descriptionLbl.frame.size.height, self.pinnedLbl.frame.size.width, self.pinnedLbl.frame.size.height);
    
    [self getDirections];
}

-(void)getDirections {
    
    NSString *strTOlat = @"17.4294";
    
    
    NSString *strTOlog = @"78.4508";
    //  NSLog(@"seltctedRestLong %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"seltctedRestLong"]]);
    
    
    
    
    double latdouble = [strTOlat doubleValue];
    NSLog(@"latdouble: %f", latdouble);
    double londouble = [strTOlog doubleValue];
    NSLog(@"londouble: %f", londouble);
    
    
    NSString * Strlat =@"17.4294";
    // NSLog(@"to_lat %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_lat"]]);
    
    NSString * Strlong =@"78.4508";
    //  NSLog(@"to_long %@",[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"to_long"]]);
    
    
    double Latdouble = [Strlat doubleValue];
    NSLog(@"latdouble: %f", Latdouble);
    double Longdouble = [Strlong doubleValue];
    NSLog(@"londouble: %f", Longdouble);
    
    
    CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(latdouble, londouble);
    
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;
    region.center = sourceCoords;
    
    span.latitudeDelta = 0.015;
    span.longitudeDelta = 0.015;
    region.span=span;
    [MapView setRegion:region animated:TRUE];
    
    MKPlacemark *placemark  = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = sourceCoords;
    //annotation.title = @"San Francisco";
    [self.MapView addAnnotation:annotation];
    //[self.myMapView addAnnotation:placemark];
    
    _destination = placemark;
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:_destination];
    
    CLLocationCoordinate2D destCoords = CLLocationCoordinate2DMake(Latdouble, Longdouble);
    MKPlacemark *placemark1  = [[MKPlacemark alloc] initWithCoordinate:destCoords addressDictionary:nil];
    
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc] init];
    annotation1.coordinate = destCoords;
    //  annotation1.title = @"San Francisco University";
    [self.MapView addAnnotation:annotation1];
    
    //[self.myMapView addAnnotation:placemark1];
    
    _source = placemark1;
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:_source];
    
}


#pragma mark - MKMapViewDelegate methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:253.0/255.0 alpha:1.0];
    renderer.lineWidth = 10.0;
    return  renderer;
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
