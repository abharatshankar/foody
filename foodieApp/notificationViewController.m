//
//  notificationViewController.m
//  buzzedApp
//
//  Created by  on 7/20/17.
//  Copyright © 2017 adroitent.com. All rights reserved.
//

#import "notificationViewController.h"
#import "notificationsTableViewCell.h"
#import "Constants.h"
#import "profileViewController.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"


//#import "DGActivityIndicatorView.h"


@interface notificationViewController ()
{
    NSString * AcceptOrRejectString;
    int indexNum;
   // DGActivityIndicatorView *activityIndicatorView ;

    NSMutableArray * tempArray;
}
@end

@implementation notificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableProducts.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    
    
    //////////////////
    
    
    
     tempArray = [[NSMutableArray alloc]initWithObjects:@"Bharat",@"Shankar",@"Ayyapa sir",@"Possibillion",@"BroadCast",@"Punjagutta", nil];
    
    
    self.tableProducts.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
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
    [btntitle setTitle:@"Notifications" forState:UIControlStateNormal];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [btnh addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
}


-(void)Back_Click
{

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    profileViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
//    [self.navigationController pushViewController:search animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)BellMethodClicked:(id)sender
{
    NSLog(@"tapped");
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return _notificationsArray.count;
   // return tempArray.count;
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"notificationsTableViewCell";
    
    notificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[notificationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];

    }

//    cell.layer.cornerRadius = 1;
//    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    cell.layer.borderWidth = 0.5;
    
   // [cell.acceptBtn addTarget:self action:@selector(AcceptAction) forControlEvents:UIControlEventTouchUpInside];
   // [cell.rejectBtn addTarget:self action:@selector(RejectAction) forControlEvents:UIControlEventTouchUpInside];
    
    indexNum = indexPath.row;
    indexNum = indexPath.row;
    
    cell.nameLbl.text = [tempArray objectAtIndex:indexPath.row];
//    cell.nameLbl.text = [[self.notificationsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
//    NSString * imageStr = [NSString stringWithFormat:@"http://testingmadesimple.org/buzzed/uploads/profile_images/%@", [[_notificationsArray objectAtIndex:indexPath.row] objectForKey:@"profile_image"]];
   // NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
    cell.userImageView.layer.cornerRadius = 20;
    cell.userImageView.clipsToBounds = YES;
    //cell.userImageView.image = [UIImage imageWithData:imgData];
    cell.userImageView.image = [UIImage imageNamed:@"name_icon.png"];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    
    return cell;
}


-(void)AcceptAction
{
    AcceptOrRejectString = [[_notificationsArray objectAtIndex:indexNum] objectForKey:@"id"];
    
    
    [self AcceptOrRejectServiceCall];
    
}
-(void)RejectAction
{
    AcceptOrRejectString = [[_notificationsArray objectAtIndex:indexNum] objectForKey:@"id"];
    [self AcceptOrRejectServiceCall];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}





//////////////////////////////////////////////////
/// helper method to show message for few seconds
- (void)showMessage:(NSString*)message atPoint:(CGPoint)point {
    const CGFloat fontSize = 18;  // Or whatever.
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];  // Or whatever.
    label.text = message;
    label.layer.cornerRadius = 10;
    label.textColor = [UIColor redColor];  // Or whatever.
    [label sizeToFit];
    
    label.center = point;
    
    [self.view addSubview:label];
    
    [UIView animateWithDuration:0.6 delay:3 options:0 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        label.hidden = YES;
        [label removeFromSuperview];
    }];
}





//helper method for color hex values
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

//helper method for color hex values
- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}





# pragma mark - Webservice Delegates

-(void)AcceptOrRejectServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *hexStr3 = @"#6dbdba";
            UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:.9];
            
//            activityIndicatorView  = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallPulse tintColor:color1];
//            
//            
//            activityIndicatorView.frame = self.view.frame ;
//            [self.view addSubview:activityIndicatorView];
//            [activityIndicatorView startAnimating];
            //[Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSDictionary * requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@acceptCheerRequest",BASEURL];
        requestDict = @{
                        @"id":AcceptOrRejectString,
                        @"type":@"1"
                        
                        
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
       // [ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
        
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    NSLog(@"responseInfo filtersServiceCall:%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGPoint point;
            point.x = 200;
            point.y = 600;
            
            [self showMessage:[responseInfo objectForKey:@"result"] atPoint:point];
            
            if ([_notificationsArray containsObject:[_notificationsArray objectAtIndex:indexNum]])
            {
                [_notificationsArray removeObjectAtIndex:indexNum];
                
            }
            
            [_tableProducts reloadData];
        });
        
    }
    
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"message"]];
            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
        });
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // [ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
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
