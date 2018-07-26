//
//  menuViewController.m
//  foodieApp
//
//  Created by Admin on 13/12/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "menuViewController.h"
#import "menuCollectionViewCell.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "Constants.h"
#import "Utilities.h"
#import "SingleTon.h"
#import "SWRevealViewController.h"
#import "addInvitationViewController.h"
#import "detailRestaurantViewController.h"
#import "homeTabViewController.h"
#import "notificationViewController.h"
#import "GroupCollectionViewCell.h"
#import "menuGroupCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "filterViewController.h"
#import "NSVBarController.h"

@interface menuViewController ()
{
    NSMutableArray * futuredArray;
    SingleTon * singleTonInstance;
    NSMutableArray * groupCollectionArray;
     NSDictionary * requestDict;
    NSMutableArray * trendingArray;
   
    NSMutableArray * trendingImages, *featuredimages,*requireArrayToSend;
    NSString * imageString , *strImg;
}
@end

@implementation menuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    singleTonInstance=[SingleTon singleTonMethod];
    futuredArray = [[NSMutableArray alloc]init];
    trendingArray = [[NSMutableArray alloc]init];
    trendingImages = [[NSMutableArray alloc]init];
    featuredimages = [[NSMutableArray alloc]init];
    singleTonInstance.requireArrayToSend = [[NSMutableArray alloc]init];
    
    
    
    // these are to singleton variables here initialising for filtersPage
    
     singleTonInstance.locationOptions = [[NSMutableArray alloc]init];
     singleTonInstance.cusinesOptions = [[NSMutableArray alloc]init];
     singleTonInstance.categoriesOptions = [[NSMutableArray alloc]init];
    ////////////////////////////////////////////////////////////////
    
    
    
    
    
   
    [Utilities addShadowtoButton:self.floatingFilterBtn];
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 28, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint = [phoneButton.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[phoneButton.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
    //phoneButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    phoneBarItem.action = @selector(phoneAction);
    [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneButton setImage:[UIImage imageNamed:@"invite_icon.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(addInvitationAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(275, 5, 28, 25);
    [menuButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint1 = [menuButton.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint1 =[menuButton.heightAnchor constraintEqualToConstant:30];
    [widthConstraint1 setActive:YES];
    [HeightConstraint1 setActive:YES];
    
    //menuButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem *  meuBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [arrRightBarItems addObject:meuBarItem];
    menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuButton setImage:[UIImage imageNamed:@"notificationWhite.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(bellAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    UIButton *menuButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton1.frame = CGRectMake(275, 5, 28, 25);
    [menuButton1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint2 = [menuButton1.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint2 =[menuButton1.heightAnchor constraintEqualToConstant:30];
    [widthConstraint2 setActive:YES];
    [HeightConstraint2 setActive:YES];
    
    
    
    UIBarButtonItem *  meuBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:menuButton1];
    meuBarItem1.action = @selector(menuAction);
    [arrRightBarItems addObject:meuBarItem1];
    menuButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuButton1 setImage:[UIImage imageNamed:@"list_view_active.png"] forState:UIControlStateNormal];
    
    //[menuButton1 addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton1 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    
    
    UIButton *menuButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton2.frame = CGRectMake(275, 5, 28, 25);
    [menuButton2 setTitleColor:WHITECOLOR forState:UIControlStateNormal];

    NSLayoutConstraint * widthConstraint3 = [menuButton2.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint3 =[menuButton2.heightAnchor constraintEqualToConstant:30];
    [widthConstraint3 setActive:YES];
    [HeightConstraint3 setActive:YES];
    
    
    UIBarButtonItem *  meuBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:menuButton2];
    meuBarItem2.action = @selector(menuAction);
    [arrRightBarItems addObject:meuBarItem2];
    menuButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuButton2 setImage:[UIImage imageNamed:@"location_map_icon.png"] forState:UIControlStateNormal];
    [menuButton2 addTarget:self action:@selector(showMapAction) forControlEvents:UIControlEventTouchUpInside];
    [menuButton2 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    //--right buttons--//
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(0, 0, 30, 22);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    //btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    //[arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[btntitle setTitle:@"Nearby Bars" forState:UIControlStateNormal];
    [btntitle setImage:[UIImage imageNamed:@"toogle_menu_icon.png"] forState:UIControlStateNormal];
    
    
    
    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnLib1 setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    //btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];
    //[btnLib1 setTitle:@"<<" forState:UIControlStateNormal];
    [btnLib1 addTarget:self action:@selector(Back_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnLib1 setImage:[UIImage imageNamed:@"icons8-left-24.png"] forState:UIControlStateNormal ];
    
    UIButton *btntitle2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle2.frame = CGRectMake(30, 0, 120, 30);
    [btntitle2 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    //btntitle2.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem31 = [[UIBarButtonItem alloc] initWithCustomView:btntitle2];
    [arrLeftBarItems addObject:barButtonItem31];
    btntitle2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle2 setTitle:@"Home" forState:UIControlStateNormal];
    [btntitle2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    
     [self servicecall];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{

}


-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addInvitationAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    addInvitationViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"addInvitationViewController"];
    [self.navigationController pushViewController:invite animated:YES];
}

-(void)bellAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    notificationViewController *notifications = [storyboard instantiateViewControllerWithIdentifier:@"notificationViewController"];
    [self.navigationController pushViewController:notifications animated:YES];
}

-(void)showMapAction
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NSVBarController *invite = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
        
        NSArray *array = [self.navigationController viewControllers];
        
        [invite setSelectedIndex:0];
        
        [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
        
    });
    
}
- (IBAction)filterAction:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    filterViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"filterViewController"];
        menu.isFromHomeMenu = YES;
    [self.navigationController pushViewController:menu animated:YES];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collection view delegates


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int value;
    if (collectionView == _futuredCollection)
    {
        value = [futuredArray count];
    }
    
     else if (collectionView == _trendingNowCollection)
     {
         value = [trendingArray count];
     }
    return  value;
  
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == _futuredCollection)
    {
        menuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuCollectionViewCell" forIndexPath:indexPath];
        
        if ([futuredArray count] > 0)
        {
            
            featuredimages = [[futuredArray objectAtIndex:indexPath.row ] objectForKey:@"merchant_banner"];
            
            imageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/merchant_banners/%@",featuredimages];
            
            NSLog(@"===image url  == %@",imageString);
            
            NSURL *url = [NSURL URLWithString:imageString];
            [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
            
            
            
            cell.nameLbl.text = [[futuredArray objectAtIndex:indexPath.row]objectForKey:@"merchant_name"];
        }
        
        return  cell;

    }
    
    
   else
    {
         menuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuCollectionViewCell" forIndexPath:indexPath];
        
//        if ([trendingArray count] > 0)
//        {
        
            trendingImages = [[trendingArray objectAtIndex:indexPath.row ] objectForKey:@"merchant_banner"];
            
            strImg = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/merchant_banners/%@",trendingImages];
            
            NSLog(@"===image url  == %@",strImg);
            
            NSURL *url = [NSURL URLWithString:strImg];
            [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            cell.nameLbl.text = [[trendingArray objectAtIndex:indexPath.row]objectForKey:@"merchant_name"];
     //   }
        
        return  cell;
    }
    
    
         
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.groupListCollection)
    {
        
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        detailRestaurantViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"detailRestaurantViewController"];
        
        if (collectionView == self.futuredCollection) {
            singleTonInstance.requireArrayToSend = [futuredArray objectAtIndex:indexPath.row];
            
            NSLog(@"required array to display data is %@",singleTonInstance.requireArrayToSend);
        }
        else
        {
        singleTonInstance.requireArrayToSend = [trendingArray objectAtIndex:indexPath.row];
        }
        
        [self.navigationController pushViewController:menu animated:YES];
    }
    
}




#pragma mark service call delegates

-(void)servicecall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        NSString *mylati;
        NSString *mylongi ;
        
        if (self.isfromEventReady == YES) {
            
            mylati = [[NSNumber numberWithFloat:singleTonInstance.latiNumTomenu] stringValue];
            
            mylongi = [[NSNumber numberWithFloat:singleTonInstance.longiNumTomenu] stringValue];
            
            
        }
        else
        {
            
            mylati = [[NSNumber numberWithFloat:singleTonInstance.latiNum] stringValue];
            
            mylongi = [[NSNumber numberWithFloat:singleTonInstance.longiNum] stringValue];
            
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"%@merchants",BASEURL];
        requestDict = @{
                        
                        @"user_id":[Utilities getUserID],
                        @"latitude":mylati,
                        @"longitude":mylongi
                        
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
    
    
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
      
        [Utilities removeLoading:self.view];
        
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    NSLog(@"responseInfo :%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
          
                
        futuredArray = [[responseInfo objectForKey:@"response"]objectForKey:@"featured"];
        trendingArray = [[responseInfo valueForKey:@"response"]objectForKey:@"trending"];
            
            [self.futuredCollection reloadData];
            [self.trendingNowCollection reloadData];
            
            
        });
        
    }
   
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            //[Utilities displayToastWithMessage:@"No Events Found"];
        });
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
    });
    
    
}




@end
