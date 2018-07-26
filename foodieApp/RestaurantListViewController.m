//
//  RestaurantListViewController.m
//  foodieApp
//
//  Created by ashwin challa on 7/19/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "RestaurantListViewController.h"
#import "Constants.h"
#import "SingleTon.h"
#import "RestaurantListTableViewCell.h"
#import "Utilities.h"
#import "UIImageView+WebCache.h"
#import "filterViewController.h"
#import "detailRestaurantViewController.h"


@interface RestaurantListViewController ()
{
    SingleTon * singleTonInstance;

}

@end

@implementation RestaurantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _restaurantList.delegate = self;
    _restaurantList.dataSource = self;
    
    
    singleTonInstance = [SingleTon singleTonMethod];

    
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
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
    [btntitle2 setTitle:@"Restaurants" forState:UIControlStateNormal];
    [btntitle2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 28, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    phoneButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    phoneBarItem.action = @selector(phoneAction);
    [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneButton setImage:[UIImage imageNamed:@"icons8-filter-filled-80.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(filterAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    NSLayoutConstraint * widthConstraint1 = [phoneButton.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint1 =[phoneButton.heightAnchor constraintEqualToConstant:30];
    [widthConstraint1 setActive:YES];
    [HeightConstraint1 setActive:YES];
    
    
    
    
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;

}

-(void)filterAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    filterViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"filterViewController"];
    menu.isEventFilter = YES;
        [self.navigationController pushViewController:menu animated:YES];
        
    
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


////Table view method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return singleTonInstance.barsArrayReady.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
    // This is just Programatic method you can also do that by xib !
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    detailRestaurantViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    detailRestaurantViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"detailRestaurantViewController"];
    menu.dict = [singleTonInstance.barsArrayReady objectAtIndex:indexPath.row ];
    [self.navigationController pushViewController:menu animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    
    static NSString *CellIdentifier = @"RestaurantCell";
    
    
    RestaurantListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if ([singleTonInstance.barsArrayReady count] > 0 )
    {
        
        cell.restaurantName.text =  [[singleTonInstance.barsArrayReady objectAtIndex:indexPath.row ]objectForKey:@"merchant_name"];
        
        cell.stateLabel.text =  [[singleTonInstance.barsArrayReady objectAtIndex:indexPath.row ]objectForKey:@"address"];
        
        
        NSString * distanceStr = [Utilities null_ValidationString:[[singleTonInstance.barsArrayReady objectAtIndex:indexPath.row ]objectForKey:@"distance"]];
        
        cell.kmsLbl.text = [NSString stringWithFormat:@"%@km",distanceStr];

        
        [Utilities addShadowtoView:cell.bgView];
        
        NSString * imgName =  [[singleTonInstance.barsArrayReady objectAtIndex:indexPath.row ]objectForKey:@"merchant_banner"];
        
        NSString * ImageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/merchant_banners/%@",imgName];
        
        NSLog(@"images uploaded string %@",ImageString);
        
        NSURL *url = [NSURL URLWithString:ImageString];
        [ cell.restaurantImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];


        
    }
    
    return cell;
}

@end
