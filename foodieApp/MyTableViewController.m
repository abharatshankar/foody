/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Primary view controller used to display search results.
 */

#import "MyTableViewController.h"
#import "MapViewController.h"
#import "SingleTon.h"
#import <MapKit/MapKit.h>
#import "creatingEventViewController.h"
#import "frontViewController.h"

#pragma mark -

static NSString *kCellIdentifier = @"cellIdentifier";

@interface MyTableViewController ()
{

    SingleTon *  singleTonInstance;
}
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;

@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *viewAllButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userCoordinate;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end


#pragma mark -

@implementation MyTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.searchBar.barTintColor = [UIColor whiteColor];
    
    [self.searchBar becomeFirstResponder];
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnLib1 setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];
    //[btnLib1 setTitle:@"<<" forState:UIControlStateNormal];
    [btnLib1 addTarget:self action:@selector(Back_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnLib1 setImage:[UIImage imageNamed:@"icons8-left-24.png"] forState:UIControlStateNormal ];
    
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"Search Location";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *mapViewController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        // Get the single item.
        NSIndexPath *selectedItemPath = [self.tableView indexPathForSelectedRow];
        MKMapItem *mapItem = self.places[selectedItemPath.row];
        
        // Pass the new bounding region to the map destination view controller.
        MKCoordinateRegion region = self.boundingRegion;
        // And center it on the single placemark.
        region.center = mapItem.placemark.coordinate;
        mapViewController.boundingRegion = region;
        
        // Pass the individual place to our map destination view controller.
        mapViewController.mapItemList = [NSArray arrayWithObject:mapItem];
         
    } else if ([segue.identifier isEqualToString:@"showAll"]) {
                
         // Pass the new bounding region to the map destination view controller.
         mapViewController.boundingRegion = self.boundingRegion;
         
         // Pass the list of places found to our map destination view controller.
         mapViewController.mapItemList = self.places;
     }
}


#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    MKMapItem *mapItem = [self.places objectAtIndex:indexPath.row];
    
    cell.textLabel.text = mapItem.name;
    
    
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKMapItem *mapItem = self.places[indexPath.row];
    
    // Pass the new bounding region to the map destination view controller.
    MKCoordinateRegion region = self.boundingRegion;
    // And center it on the single placemark.
    region.center = mapItem.placemark.coordinate;
    
    if (self.fromEditEventPage.length)
    {
        singleTonInstance.areaNameForEditEvent = mapItem.name;
        
    }
    else if (self.iseventPage == YES)
    {
        singleTonInstance.mapItemForEventPage = self.places[indexPath.row];
    }
    else if (self.isFromCreatingEvent == YES)
    {
        
    }
    else
    {
        singleTonInstance.areaName = mapItem.name;

        singleTonInstance.mapItem =  self.places[indexPath.row];
    }
    
    //creatingEventViewController. .boundingRegion = region;
    
    
    //march 8th
    
   NSLog(@"address is %@",[mapItem.placemark.addressDictionary objectForKey:@"FormattedAddressLines"]) ;
    NSArray * addressLinesArray = [[NSArray alloc]init];
    addressLinesArray = [mapItem.placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
    
    NSString *addressString = [addressLinesArray componentsJoinedByString:@"\n"];
    
    NSLog(@"Address: %@", addressString);
    
    if (self.fromEditEventPage.length)
    {
        singleTonInstance.addressToServerForEditPage = addressString;
    }
    else if (self.iseventPage == YES)
    {
        singleTonInstance.areaNameForEventPage = [mapItem.placemark.addressDictionary objectForKey:@"Name"];
        singleTonInstance.isForEventPage = YES;
    }
    else if (self.isFromCreatingEvent == YES)
    {
        
        singleTonInstance.areaNameForCreateEvent =  [mapItem.placemark.addressDictionary objectForKey:@"Name"];
        singleTonInstance.addressToServer = addressString;
    }
    else
    {
        singleTonInstance.addressToServer = addressString;
        
        
        singleTonInstance.isLocationChanged = YES;
    }
    
    
    
    // Pass the individual place to our map destination view controller.
    if (self.fromEditEventPage.length)
    {
        singleTonInstance.mapItemListForEditPage = [NSArray arrayWithObject:mapItem];
    }
    else if (self.iseventPage == YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
        self.iseventPage = NO;
    }
    else if (self.isFromCreatingEvent == YES)
    {
        
        
        
        singleTonInstance.mapItemsForcreateEventPage = [NSArray arrayWithObject:mapItem];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        self.isFromCreatingEvent = NO;
        
    }
    else
    {
        singleTonInstance.mapItemList = [NSArray arrayWithObject:mapItem];
        self.fromEditEventPage = nil;
        
        
        NSArray *viewControllers = [[self navigationController] viewControllers];
        for( int i=0;i<[viewControllers count];i++){
            id obj=[viewControllers objectAtIndex:i];
            if([obj isKindOfClass:[frontViewController class]]){
                [[self navigationController] popToViewController:obj animated:YES];
                return;
            }
        }
    }
    
    
    
    
    //
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    // If the text changed, reset the tableview if it wasn't empty.
    if (self.places.count != 0) {
        
        // Set the list of places to be empty.
        self.places = @[];
        // Reload the tableview.
        [self.tableView reloadData];
        // Disable the "view all" button.
        self.viewAllButton.enabled = NO;
    }
    [self startSearch:searchText];
}

- (void)startSearch:(NSString *)searchString {
    
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    // Confine the map search area to the user's current location.
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.userCoordinate.latitude;
    newRegion.center.longitude = self.userCoordinate.longitude;
    
    // Setup the area spanned by the map region:
    // We use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level).
    //      The numbers used here correspond to a roughly 8 mi
    //      diameter area.
    //
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error) {
        if (error != nil) {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            self.places = [response mapItems];
            
            // Used for later when setting the map's region in "prepareForSegue".
            self.boundingRegion = response.boundingRegion;
            
            self.viewAllButton.enabled = self.places != nil ? YES : NO;
            
            [self.tableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil) {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    // Check if location services are available
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"%s: location services are not available.", __PRETTY_FUNCTION__);
        
        // Display alert to the user.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services"
                                                                       message:@"Location services are not enabled on this device. Please enable location services in settings."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}]; // Do nothing action to dismiss the alert.
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    // Request "when in use" location service authorization.
    // If authorization has been denied previously, we can display an alert if the user has denied location services previously.
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"%s: location services authorization was previously denied by the user.", __PRETTY_FUNCTION__);
        
        // Display alert to the user.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services"
                                                                       message:@"Location services were previously denied by the user. Please enable location services for this app in settings."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}]; // Do nothing action to dismiss the alert.
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    // Start updating locations.
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    // When a location is delivered to the location manager delegate, the search will actually take place. See the -locationManager:didUpdateLocations: method.
}


#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // Remember for later the user's current location.
    CLLocation *userLocation = locations.lastObject;
    self.userCoordinate = userLocation.coordinate;
    
	[manager stopUpdatingLocation]; // We only want one update.
    
    manager.delegate = nil;         // We might be called again here, even though we
                                    // called "stopUpdatingLocation", so remove us as the delegate to be sure.
    
    // We have a location now, so start the search.
    [self startSearch:self.searchBar.text];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // report any errors returned back from Location Services
}

@end

