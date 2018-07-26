//
//  summaryViewController.m
//  foodieApp
//
//  Created by ashwin challa on 3/15/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "summaryViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "Constants.h"
#import "myBookingsViewController.h"
#import "homeTabViewController.h"
#import "NSVBarController.h"
#import "bookingTableViewController.h"
#import "SingleTon.h"

@interface summaryViewController ()
{

    SingleTon * singleTonInstance;
}
@end

@implementation summaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    singleTonInstance=[SingleTon singleTonMethod];

    
    
    self.nameLbl.text = [Utilities null_ValidationString:[singleTonInstance.summaryDict valueForKey:@"merchant_name"]];
    [self.nameLbl sizeToFit];
    
    
    self.locationLbl.text = [Utilities null_ValidationString: [singleTonInstance.summaryDict valueForKey:@"address"]];
    [self.locationLbl sizeThatFits:CGSizeMake(self.locationLbl.frame.size.width, self.locationLbl.frame.size.height)];
    self.locationLbl.adjustsFontSizeToFitWidth = YES;
    
    NSString * partisipantsCount = [NSString stringWithFormat:@"%d",[[self.presentDict valueForKey:@"member_count"] intValue]];
    self.partisipantsLbl.text = [Utilities null_ValidationString:partisipantsCount];
    
    self.dateLbl.text = [Utilities null_ValidationString:self.eventDate];
    
//    self.callUsBtn.layer.borderWidth = 0.5;
//    self.callUsBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.rateUsBtn.layer.borderWidth = 0.5;
//    self.rateUsBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Do any additional setup after loading the view.
    
    
    
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
    
    
    UIButton *btnsearch = [[UIButton alloc]initWithFrame:CGRectMake(116, 22, 28, 25)];
    [btnsearch setImage:[UIImage imageNamed:@"icons8-left-24.png"] forState:UIControlStateNormal ];
    UIBarButtonItem * itemsearch = [[UIBarButtonItem alloc] initWithCustomView:btnsearch];
    [btnsearch addTarget:self action:@selector(BellMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:itemsearch, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    
    //for right bar buttons
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(275, 5, 28, 25);
    [menuButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    menuButton.showsTouchWhenHighlighted=YES;
    
    
    //--right buttons--//
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(30, 0, 120, 30);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitle:@"Summary" forState:UIControlStateNormal];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // [btnh addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    [self.locationLbl sizeToFit];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)bookTableButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    bookingTableViewController *bookTbl = [storyboard instantiateViewControllerWithIdentifier:@"bookingTableViewController"];
    bookTbl.partisipantCount = [Utilities null_ValidationString:[NSString stringWithFormat:@"%d",[[self.presentDict valueForKey:@"member_count"] intValue]]];
    bookTbl.eventDate = self.eventDate;
    [self.navigationController pushViewController:bookTbl animated:YES];
}



-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
self.tabBarController.tabBar.hidden = NO;
}

- (IBAction)visitAgainAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NSVBarController *invite = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
        
        NSArray *array = [self.navigationController viewControllers];
        
        [invite setSelectedIndex:2];
        
        // [self presentViewController:invite animated:YES completion:nil];
        
        self.tabBarController.tabBar.hidden = NO;
        
        [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
        
//        homeTabViewController * home = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
//        
//        
//        [home setSelectedIndex:0];
//        
//        [self presentViewController:home animated:YES completion:nil];
        
        // [self.navigationController popToViewController:home animated:YES];
        
        //                profileViewController * tabs = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
        //                [self.navigationController pushViewController:tabs animated:YES];
    });
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
