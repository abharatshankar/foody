//
//  detailRestaurantViewController.m
//  foodieApp
//
//  Created by Admin on 14/12/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "detailRestaurantViewController.h"
#import "photosCollectionViewCell.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "DirectionsViewController.h"
#import "LcnManager.h"
#import "ISMessages.h"
#import "SingleTon.h"
#import "UIImageView+WebCache.h"
#import "bookingTableViewController.h"
#import "amenitiesTableViewCell.h"
#import "cusineTableViewCell.h"






@interface detailRestaurantViewController ()
{
    
    NSMutableArray * photosArray;
    NSMutableArray * amenitiesArray;
    
    NSMutableArray * cusineArray;

    NSMutableArray * reviewsArray;
    NSString * merchantIdStr ;
    SingleTon * singleTonInstance;

}
@end

@implementation detailRestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    photosArray = [[NSMutableArray alloc]init];
    amenitiesArray = [[NSMutableArray alloc]init];
    
    cusineArray = [[NSMutableArray alloc]init];
    
    reviewsArray  = [[NSMutableArray alloc]init];
    
    self.cusineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.amenitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if (singleTonInstance.requireArrayToSend.count)
    {
        
        self.dict = singleTonInstance.requireArrayToSend;
        
    }
    
    [Utilities addShadowtoButton:self.bookTblBtn];
    
    NSLog(@"---%@",self.dict);
    
    self.mainScroll.contentSize = CGSizeMake(0, self.view.frame.size.height-247+self.mainView.frame.size.height);
    
    merchantIdStr = [self.dict valueForKey:@"merchant_id"];
    
   self.titleName.text = [Utilities null_ValidationString:[self.dict objectForKey:@"merchant_name"]] ;
    
    self.timingsLbl.text = [NSString stringWithFormat:@"%@ - %@",[self.dict objectForKey:@"open_time"],[self.dict objectForKey:@"close_time"]];
    
    self.addressLbl.text = [Utilities null_ValidationString:[self.dict objectForKey: @"address"]];
    
    self.phoneNum.text =  [Utilities null_ValidationString:[ self.dict objectForKey:@"contact_number"]] ;
    
    self.costLbl.text = [Utilities null_ValidationString:[self.dict objectForKey:@"cost_for_one"]];
    
    self.amenitiesLbl.text = [Utilities null_ValidationString:[self.dict objectForKey:@"facilities"]];
    
    self.emailLbl.text = [Utilities null_ValidationString:[self.dict objectForKey:@"email"]];
    
    self.areaName.text = [Utilities null_ValidationString:[self.dict objectForKey:@"state"]];
    
    
    
    
    if (self.dict.count) {
        NSString * urlStr = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/merchant_banners/%@",[self.dict objectForKey:@"merchant_banner"]];
        
        //self.bannerImgViw.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        
        
        NSLog(@"===image url  == %@",urlStr);
        
        NSURL *url = [NSURL URLWithString:urlStr];
        [self.bannerImgViw sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
    }
    else
    {
        self.bannerImgViw.image = [UIImage imageNamed:@"logo.png"];
    }
    
    
    if (IS_IPHONE_5 || IS_IPHONE_5S || IS_IPHONE_5C)
    {
       
    }
    
    else if (IS_STANDARD_IPHONE_6 || IS_STANDARD_IPHONE_6S || IS_STANDARD_IPHONE_7 )
    {
        
    }
    
    
    else if( IS_STANDARD_IPHONE_6S_PLUS || IS_STANDARD_IPHONE_7_PLUS )
    {
       
    }
    
    else
    {
       
    }
   
    if ([[self.dict objectForKey:@"merchant_photos"] isKindOfClass:[NSNull class]]) {
        photosArray = nil;
    }
    else
    photosArray = [self.dict objectForKey:@"merchant_photos"];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 28, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    phoneButton.showsTouchWhenHighlighted=YES;
    
    NSLayoutConstraint * widthConstraint22 = [phoneButton.widthAnchor constraintEqualToConstant:28];
    NSLayoutConstraint * HeightConstraint22 =[phoneButton.heightAnchor constraintEqualToConstant:28];
    [widthConstraint22 setActive:YES];
    [HeightConstraint22 setActive:YES];
    
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    phoneBarItem.action = @selector(phoneAction);
    [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneButton setImage:[UIImage imageNamed:@"icons8-split-80.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(mapAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(275, 5, 28, 25);
    [menuButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    menuButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem *  meuBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    //meuBarItem.action = @selector(menuAction);
    [arrRightBarItems addObject:meuBarItem];
    menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuButton setImage:[UIImage imageNamed:@"icons8-phone-26.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    

    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnLib1 setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];
    //[btnLib1 setTitle:@"<<" forState:UIControlStateNormal];
    [btnLib1 addTarget:self action:@selector(Back_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnLib1 setImage:[UIImage imageNamed:@"icons8-left-24.png"] forState:UIControlStateNormal ];
    

   
//    
//    //--right buttons--//
//    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
//    btntitle.frame = CGRectMake(0, 0, 30, 22);
//    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    btntitle.showsTouchWhenHighlighted=YES;
//    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
//    [arrLeftBarItems addObject:barButtonItem3];
//    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    //[btntitle setTitle:@"Nearby Bars" forState:UIControlStateNormal];
//    [btntitle setImage:[UIImage imageNamed:@"toogle_menu_icon.png"] forState:UIControlStateNormal];
//    
//    [btntitle addTarget:sw.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addGestureRecognizer:sw.panGestureRecognizer];
//    
//    
//    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
//    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    // this is to hide call view by default and show when cliks on Add to prefered button
    self.callView.hidden = YES;
    
    
    [self merchantDetailViewServiceCall];
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
self.tabBarController.tabBar.hidden = NO;
}


-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mapAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DirectionsViewController * direction = [storyboard instantiateViewControllerWithIdentifier:@"DirectionsViewController"];
    direction.latitudeString = [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude];
    direction.longitudeString  = [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.longitude];
    [self.navigationController pushViewController:direction animated:YES];
}

-(void)directionAction
{

    
}

-(void)phoneAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+917842863818"] options:nil completionHandler:^(BOOL success) {
        
    } ];
}

- (IBAction)addToPreferedAction:(id)sender {
    
    
     [self AddToPrefereServiceCall];
}

-(void)AddToPrefereServiceCall
{
    //    CLLocationCoordinate2D coordinate = [self getLocation];
    //    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@addPreferedMerchant",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"merchant_id":merchantIdStr
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.photosCollection)
    {
        if (photosArray.count>0) {
            return photosArray.count;
        }
        else
        {
            return 0;
        }
        
    }
    else
    {
        return reviewsArray.count;
    }
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        photosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photosCollectionViewCell" forIndexPath:indexPath];
        
        NSString * imageString1 = [NSString stringWithFormat:@"http://testingmadesimple.org/buzzed/uploads/merchant_photos/%@",[photosArray objectAtIndex:indexPath.row]] ;
        
      //  cell.imageViw.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString1]]];
        
        
        
        
        
        
        
        
        //self.bannerImgViw.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        
        
        NSLog(@"===image url  == %@",imageString1);
        
        NSURL *url = [NSURL URLWithString:imageString1];
        [  cell.imageViw sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
        
        
        
        return cell;
    }

    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.amenitiesTableView){
        return 1;
    }
    else
    {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.amenitiesTableView){
    return amenitiesArray.count;
    }
    else
    {
        return cusineArray.count;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.amenitiesTableView){
        return 20;
    }
    else
    {
        return 20;
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView == self.amenitiesTableView)
    {
        static NSString *simpleTableIdentifier = @"amenitiesCell";
        
        amenitiesTableViewCell *amenitiesCell = (amenitiesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        amenitiesCell.amenitiesLbl.text = [[amenitiesArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        
        
        
        
        return amenitiesCell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"cusineCell";
        
        cusineTableViewCell *cusineCell = (cusineTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cusineCell.cusineLbl.text = [[cusineArray objectAtIndex:indexPath.row] valueForKey:@"cuisine_name"];
        
    
        return cusineCell;
        
    }
    
    
}





- (IBAction)callBtn:(id)sender
{
    self.callView.hidden = YES;
}

- (IBAction)bookTableAction:(id)sender {
     self.callView.hidden = NO;
    self.addPreferedView.hidden = YES;
    self.bookTableView.hidden = NO;
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        bookingTableViewController *bookTbl = [storyboard instantiateViewControllerWithIdentifier:@"bookingTableViewController"];
        [self.navigationController pushViewController:bookTbl animated:YES];
        
        
    });
    
    
}

- (IBAction)cancelViewBtn:(id)sender
{
    self.callView.hidden= YES;
}


-(void)merchantDetailViewServiceCall
{
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@merchantDetailView",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"merchant_id":merchantIdStr
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}


- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self handleResponse:info];
        
        
    });
    
    
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
        //[ activityIndicatorView stopAnimating];
        
    });
}

-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    NSLog(@"responseInfo merchantDetailViewServiceCall :%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                self.callView.hidden= NO;
                self.addPreferedView.layer.cornerRadius = 10;
                self.bookTableView.hidden = YES;
                
                amenitiesArray = [[responseInfo objectForKey:@"response"] objectForKey:@"facilities"];
                
                [self.amenitiesTableView  reloadData];
                
                cusineArray = [[responseInfo objectForKey:@"response"] objectForKey:@"cuisines"];
                
                [self.cusineTableView reloadData];
                
            });
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                //                            barsList_vc *barsList = [storyboard instantiateViewControllerWithIdentifier:@"barsList_vc"];
                //                            [self.navigationController pushViewController:barsList animated:YES];
                
                
            });
            
            
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
//                
//                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction * ok  = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                   // [self.navigationController popViewControllerAnimated:YES];
//                   
//                }];
//                [alert addAction:ok];
//                [self presentViewController:alert animated:YES completion:^{
//                    
//                }];
                
                
                [ISMessages showCardAlertWithTitle:nil
                                           message:@"Alerady added to prefered list"
                                          duration:3.f
                                       hideOnSwipe:YES
                                         hideOnTap:YES
                                         alertType:ISAlertTypeWarning
                                     alertPosition:ISAlertPositionBottom
                                           didHide:^(BOOL finished) {
                                               NSLog(@"Alert did hide.");
                                               
                                               [Utilities removeLoading:self.view];
                                               //[ activityIndicatorView stopAnimating];
                                               
                                           }];
                
                
                
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
            //[ activityIndicatorView stopAnimating];
        });
        
    }
    
    @catch (NSException *exception) {
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[ activityIndicatorView stopAnimating];
            [Utilities removeLoading:self.view];
        });
        [self.view endEditing:YES];
    }
    
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
