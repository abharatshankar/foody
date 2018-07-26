//
//  ViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/8/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "ViewController.h"
#import "YSLContainerViewController.h"
#import "myBookingsViewController.h"
#import "bookingsViewController.h"
#import "pastBookingViewController.h"
#import "SWRevealViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"



@interface ViewController ()<YSLContainerViewControllerDelegate>
{
    UIBarButtonItem *menuButton;
    UIBarButtonItem *bellButton;
    
    BOOL * sidebarMenuOpen;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    
    
    
    self.revealViewController.delegate = self;
    
    SWRevealViewController*sw=[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    
    self.menu.target=sw.revealViewController;
    
    [sw panGestureRecognizer];
    [sw tapGestureRecognizer];
    
    sidebarMenuOpen = NO;
    
    self.menu.action=@selector(revealToggle:);
    
    [self.menu setImage:[UIImage imageNamed:@"toogle_menu_icon.png"]];
    
    
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    [self.view addGestureRecognizer:sw.tapGestureRecognizer];
    
    
    pastBookingViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pastBookingViewController"];
    SVC.title = @"Past Events";
    
    
    bookingsViewController *GTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"bookingsViewController"];
    GTVC.title = @"UpComing Events";
    
    
    
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[GTVC,SVC]
                                                                                        topBarHeight:statusHeight + navigationHeight
                                                                                parentViewController:self];
    
    containerVC.menuItemFont = [UIFont fontWithName:@"Calibri" size:18];
    containerVC.menuItemTitleColor = [UIColor darkGrayColor];
    containerVC.menuItemSelectedTitleColor = [UIColor redColor];
    containerVC.menuIndicatorColor = [UIColor redColor];
    containerVC.menuBackGroudColor = [UIColor whiteColor];
    containerVC.delegate=self;
    
    [self.view addSubview:containerVC.view];
    

    // this is for navigation bar background color
    self.navigationController.navigationBar.barTintColor = REDCOLOR;
    
    
    
    
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    
    
    
    //--right buttons--//
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(0, 0, 30, 22);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[btntitle setTitle:@"Nearby Bars" forState:UIControlStateNormal];
    [btntitle setImage:[UIImage imageNamed:@"toogle_menu_icon.png"] forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint = [btntitle.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[btntitle.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
    [btntitle addTarget:sw.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    
    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    
    
    //--right buttons--//
    UIButton *btntitle1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle1.frame = CGRectMake(0, 0, 100, 22);
    [btntitle1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem31 = [[UIBarButtonItem alloc] initWithCustomView:btntitle1];
    [arrLeftBarItems addObject:barButtonItem31];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitle:@"Profile" forState:UIControlStateNormal];
    //[btntitle setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    
    // [btntitle addTarget:self action:@selector(goBackAct) forControlEvents:UIControlEventTouchUpInside];
    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
   // self.callView.hidden = YES;
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    // this is to close side menu if already opened when navigation to another tab bar
    if (self.revealViewController.frontViewPosition == FrontViewPositionRight) {
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide];
    }
    
    bookingsViewController *GTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"bookingsViewController"];
    GTVC.title = @"UpComing Events";
    [self containerViewItemIndex:0 currentController:GTVC];
}


#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    
    
    
    [controller viewWillAppear:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
