//
//  myBookingsViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/11/17.
//  Copyright © 2017 Bhargav. All rights reserved.


#import "myBookingsViewController.h"
#import "SWRevealViewController.h"
#import "homeTabViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceInitiater.h"
#import "ServiceManager.h"
#import "MyBookingsCell.h"
#import "UIImageView+WebCache.h"
#import "EventReadyPageController.h"

@interface myBookingsViewController ()<UITableViewDataSource,UITableViewDelegate,SWRevealViewControllerDelegate>
{
    NSMutableArray * BookingsArr,*presentEventsArr,*pastEventsArray,*grabingArray;
    BOOL *isPresentEvents , *isPastEvents,*sidebarMenuOpen;
    NSString * typStr;
}

@end

@implementation myBookingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pastEventsHighlightLbl.hidden = YES;
    
    self.revealViewController.delegate = self;
    
    SWRevealViewController*sw=[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    
    _menu.target=sw.revealViewController;
    
    [sw panGestureRecognizer];
    [sw tapGestureRecognizer];
    
    sidebarMenuOpen = NO;
    
    _menu.action=@selector(revealToggle:);
    
    [self.menu setImage:[UIImage imageNamed:@"toogle_menu_icon.png"]];
    
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    [self.view addGestureRecognizer:sw.tapGestureRecognizer];
    
    _BookingsTableView.delegate =self;
    
    _BookingsTableView.dataSource = self;
    
    BookingsArr = [[NSMutableArray alloc]init];
    
    presentEventsArr = [[NSMutableArray alloc]init];
    
    pastEventsArray = [[NSMutableArray alloc]init];
    
    grabingArray = [[NSMutableArray alloc]init];
    
    isPresentEvents = YES;
    
    typStr = @"present";
    
    self.clearAllBtn.hidden = YES;
    
    [self.myEventsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //[self userPastServiceCall];
    
   // self.title = @"My Events";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//    [[self.tabBarController.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"around_me.png"]];
//    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:2];// item index is the tab index which starts from 0
//    
//    item.selectedImage = [[UIImage imageNamed:@"booking_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
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
        //btntitle.showsTouchWhenHighlighted=YES;
        UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
        [arrLeftBarItems addObject:barButtonItem3];
        btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //[btntitle setTitle:@"Nearby Bars" forState:UIControlStateNormal];
        [btntitle setImage:[UIImage imageNamed:@"toogle_menu_icon.png"] forState:UIControlStateNormal];
    
        [btntitle addTarget:sw.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    
        btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    UIButton *btntitle1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle1.frame = CGRectMake(30, 0, 120, 30);
    [btntitle1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    //btntitle1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem33 = [[UIBarButtonItem alloc] initWithCustomView:btntitle1];
    [arrLeftBarItems addObject:barButtonItem33];
    btntitle1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle1 setTitle:@"My Events" forState:UIControlStateNormal];
    btntitle1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    self.BookingsTableView.frame = CGRectMake(self.BookingsTableView.frame.origin.x, self.yourEventsHighlightLbl.frame.origin.y+self.yourEventsHighlightLbl.frame.size.height, self.BookingsTableView.frame.size.width, self.BookingsTableView.frame.size.height);
    
    
//    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
//    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [self.view addGestureRecognizer:gestureRecognizer];
//    
//    UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandler:)];
//    [leftGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    
//    [self.view addGestureRecognizer:leftGestureRecognizer];
    
    [self currentBookings];
    
    
    
    
}




-(void)viewWillAppear:(BOOL)animated
{
    // this is to close side menu if already opened when navigation to another tab bar
    
    if (self.revealViewController.frontViewPosition == FrontViewPositionRight) {
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide];
    }
    
    self.tabBarController.tabBar.hidden = NO;
    
    //[self PreviousBookingsBtn_Clicked:self];
    
}






//-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
//    
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        NSLog(@"right Swipe received.");
//        [self CurrentBookingsBtn_Clicked:self];
//        
//    }];
//}
//
//-(void)leftSwipeHandler:(UISwipeGestureRecognizer *)recognizer
//{
//    [UIView animateWithDuration:0.1 animations:^{
//        NSLog(@"right Swipe received.");
//        [self PreviousBookingsBtn_Clicked:self];
//        
//    }];
//    
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






//
//
//- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
//{
//    if(position == FrontViewPositionLeft) {
//        //self.view.userInteractionEnabled = YES;
//        sidebarMenuOpen = NO;
//    } else {
//        //self.view.userInteractionEnabled = NO;
//        sidebarMenuOpen = YES;
//    }
//}
//
//- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
//{
//    if(position == FrontViewPositionLeft) {
//        //self.view.userInteractionEnabled = YES;
//        sidebarMenuOpen = NO;
//    } else {
//        //self.view.userInteractionEnabled = NO;
//        sidebarMenuOpen = YES;
//    }
//}








//- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
//{
//    if(position == FrontViewPositionLeft)
//    {
//        self.view.userInteractionEnabled = NO;
//        self.navigationController.navigationBar.userInteractionEnabled = NO;
//    }else{
//        self.view.userInteractionEnabled = YES;
//        self.navigationController.navigationBar.userInteractionEnabled = YES;
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   // return BookingsArr.count;
    
    if (isPresentEvents == YES)
    {
        grabingArray = presentEventsArr;
        return presentEventsArr.count;
    }
    else
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    
    
    
    static NSString *CellIdentifier = @"MyBookingsCell";
    
    MyBookingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyBookingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    if (isPresentEvents == YES)
    {
        
        cell.eventNameLbl.text = [Utilities null_ValidationString:[[presentEventsArr objectAtIndex:indexPath.row] objectForKey:@"event_name"]];
        
        int numB = [[[presentEventsArr objectAtIndex:indexPath.row] objectForKey:@"member_count"] intValue];
        
        NSString * countNum = [NSString stringWithFormat:@"%d",numB];
        
        cell.numberOfMembersLbl.text = [Utilities null_ValidationString:countNum];
        
        if([[[presentEventsArr objectAtIndex:indexPath.row] objectForKey:@"event_status"] intValue] == 1)
        {
            

            cell.eventStatusLbl.text =  @"Going";
        }
        else if ([[[presentEventsArr objectAtIndex:indexPath.row] objectForKey:@"event_status"] intValue] == 2)
        {
        cell.eventStatusLbl.text =  @"Interested";
        }
        else
        {
        cell.eventStatusLbl.text =  @"Can't Go";
        }
        
        [cell.eventStatusLbl sizeToFit];
          //  cell.eventStatusLbl.text = [Utilities null_ValidationString:[[presentEventsArr objectAtIndex:indexPath.row] objectForKey:@"event_status"]];
        
        
        NSString * startDat =  [[presentEventsArr objectAtIndex:indexPath.row ] objectForKey:@"start_date"];
        
        NSString * startTim = [[presentEventsArr objectAtIndex:indexPath.row ] objectForKey:@"start_time"];
        
        NSString * endDat = [[presentEventsArr objectAtIndex:indexPath.row ] objectForKey:@"end_date"];
        
        NSString * endTim = [[presentEventsArr objectAtIndex:indexPath.row ] objectForKey:@"end_time"];
        
        
        ////////////////////////
        // bring month name from date (yyyy/MM/dd ) And day number
        
        if (startDat.length)
        {
            
            NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"MMMM"];
            [dateFormatter2 setDateFormat:@"dd"];
            
            
            
            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
            [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [dateFormatter3 dateFromString:startDat];
            
            cell.startMonthLbl.text = [dateFormatter1 stringFromDate:dateFromString];
            cell.startDayLbl.text = [dateFormatter2 stringFromDate:dateFromString];
            
            NSLog(@"date is %@",cell.startMonthLbl.text);
            
            cell.startMonthLbl.hidden = NO;
            cell.startDayLbl.hidden = NO;
        }
        else
        {
        
            cell.startMonthLbl.hidden = YES;
            cell.startDayLbl.hidden = YES;
            
            
        }
        
        
        if (endDat.length)
        {
            
            NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"MMMM"];
            [dateFormatter2 setDateFormat:@"dd"];
            
            
            
            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
            [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [dateFormatter3 dateFromString:endDat];
            
            cell.endMonthLbl.text = [dateFormatter1 stringFromDate:dateFromString];
            cell.endDayLbl.text = [dateFormatter2 stringFromDate:dateFromString];
            
            
            
            cell.endMonthLbl.hidden = NO;
            cell.endDayLbl.hidden = NO;
        }
        else
        {
            
            cell.endMonthLbl.hidden = YES;
            cell.endDayLbl.hidden = YES;
            
            
        }
        
        
        
        if (![startTim isKindOfClass:[NSNull class]]) {
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            dateFormatter.dateFormat = @"HH:mm:ss";
            
            NSDate *date = [dateFormatter dateFromString:startTim];
            
            dateFormatter.dateFormat = @"hh:mm a";
            
            NSString *pmamDateString = [dateFormatter stringFromDate:date];
            
            cell.startTimeLbl.text  = pmamDateString;
            
            cell.startTimeLbl.textColor = [UIColor whiteColor];
            
            cell.startTimeLbl.hidden = NO;

            
        }
        else
        {
            cell.startTimeLbl.hidden = YES;
            
        }
        
        
        if (![endTim isKindOfClass:[NSNull class]]) {
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            dateFormatter.dateFormat = @"HH:mm:ss";
            
            NSDate *date = [dateFormatter dateFromString:endTim];
            
            dateFormatter.dateFormat = @"hh:mm a";
            
            NSString *pmamDateString = [dateFormatter stringFromDate:date];
            
            cell.endTimeLbl.text  = pmamDateString;
            
            cell.endTimeLbl.textColor = [UIColor whiteColor];
            
            cell.endTimeLbl.hidden = NO;

            
        }
        else
        {
            cell.endTimeLbl.hidden = YES;
            
        }
        
        
        
        //////////////////////////////
        
        
        
        
        
        
        
        
        NSString * featuredimages = [[presentEventsArr objectAtIndex:indexPath.row ] objectForKey:@"image"];
        
        NSString *  imageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/events/%@",featuredimages];
        
        NSLog(@"===image url  == %@",imageString);
        
        NSURL *url = [NSURL URLWithString:imageString];
        [cell.eventImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
        
        
        [Utilities setBorderView:cell.lineview :3 :LIGHTGRYCOLOR];
        
        
        return cell;
    }
    
    if (isPastEvents == YES) {
        
        
        
        cell.eventNameLbl.text = [Utilities null_ValidationString:[[pastEventsArray objectAtIndex:indexPath.row] objectForKey:@"event_name"]];
        
        int numB = [[pastEventsArray objectAtIndex:indexPath.row] objectForKey:@"member_count"];
        
        NSString * countNum = [NSString stringWithFormat:@"%d",numB];
        
        cell.numberOfMembersLbl.text = [Utilities null_ValidationString:countNum];
        
        
        NSString * featuredimages = [[pastEventsArray objectAtIndex:indexPath.row ] objectForKey:@"image"];
        
        NSString *  imageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/events/%@",featuredimages];
        
        NSLog(@"===image url  == %@",imageString);
        
        NSURL *url = [NSURL URLWithString:imageString];
        [cell.eventImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
        
        
        [Utilities setBorderView:cell.lineview :3 :LIGHTGRYCOLOR];
        
         
        return cell;
        
    }
    
    [Utilities addShadowtoImage:cell.eventImgView];
    
    return cell;
    


}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    NSLog(@"------->>> %d", presentEventsArr.count);
    if (presentEventsArr.count)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        EventReadyPageController *notifications = [storyboard instantiateViewControllerWithIdentifier:@"EventReadyPageController"];
        
        notifications.isFromMyEventsPage = @"present";
        
        NSString * str  = [[presentEventsArr objectAtIndex:indexPath.row] objectForKey:@"start_time"];
        
        NSString * endStr = [[presentEventsArr objectAtIndex:indexPath.row] objectForKey:@"end_time"];
        
        NSString * startTim = [self convetTimeTo12hours:endStr];
        
        NSString * endTim = [self convetTimeTo12hours:str];
        
        notifications.startTimeFromBookings = startTim;
        
        notifications.endTimeFromBookings = endTim;
        
        
        notifications.presentEventsDict = [presentEventsArr objectAtIndex:indexPath.row];
        
        int eventIdNum = [[[presentEventsArr objectAtIndex:indexPath.row] objectForKey:@"event_id"] intValue];
        
        NSString * eventIDNumStr = [NSString stringWithFormat:@"%d",eventIdNum];
        
        notifications.eventIdStr = [Utilities null_ValidationString:eventIDNumStr];
        
        [self.navigationController pushViewController:notifications animated:YES];
    }
    });
    
}


- (IBAction)CurrentBookingsBtn_Clicked:(id)sender
{
    [self currentBookings];
    
}

- (void)currentBookings{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        isPresentEvents = YES;
        typStr = @"present";
        self.clearAllBtn.hidden = YES;
        self.yourEventsHighlightLbl.hidden = NO;
        self.pastEventsHighlightLbl.hidden = YES;
        [self.myEventsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.pastEventsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.BookingsTableView.frame = CGRectMake(self.BookingsTableView.frame.origin.x, self.yourEventsHighlightLbl.frame.origin.y+self.yourEventsHighlightLbl.frame.size.height, self.BookingsTableView.frame.size.width, self.BookingsTableView.frame.size.height);
        [self userPastServiceCall];
        
        
    });
}

- (IBAction)PreviousBookingsBtn_Clicked:(id)sender
{
     dispatch_async(dispatch_get_main_queue(), ^{
    isPastEvents = YES;
    typStr = @"past";
    self.clearAllBtn.hidden = NO;
    self.yourEventsHighlightLbl.hidden = YES;
    self.pastEventsHighlightLbl.hidden = NO;
    [self.myEventsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.pastEventsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
         self.BookingsTableView.frame = CGRectMake(self.BookingsTableView.frame.origin.x, self.clearAllBtn.frame.origin.y+self.clearAllBtn.frame.size.height, self.BookingsTableView.frame.size.width, self.BookingsTableView.frame.size.height);
    [self userPastServiceCall];
         });
}

- (IBAction)clearAllAction:(id)sender {
    [Utilities displayToastWithMessage:@"Work In Progress"];
}




//////////////////////////////////////////////////////////////////////////////////////
                // convert time(10:25:01) to am/pm format
//////////////////////////////////////////////////////////////////////////////////////
-(id)convetTimeTo12hours:(NSString *)timeToConvertStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"HH:mm:ss";
    
    NSDate *date = [dateFormatter dateFromString:timeToConvertStr];
    
    dateFormatter.dateFormat = @"hh:mm a";
    
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    
    return pmamDateString;
}

//////////////////////////////////////////////////////////////////////////////////////



# pragma mark - Webservice Delegates








-(void)userPastServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
        
        
        NSDictionary * requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@userEvents",BASEURL];
        
        
        
        
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"type":typStr/*[Utilities null_ValidationString:typStr]*/
                        
                        
                        
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
    
    NSLog(@"responseInfo user present Events:%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        
                
                presentEventsArr = [responseInfo valueForKey:@"events"];
                if (presentEventsArr.count)
                {
                    self.BookingsTableView.hidden = NO;
                }
                else
                {
                    self.BookingsTableView.hidden = YES;
                }
                
                [self.BookingsTableView reloadData];
                
                

            
            
           
        });
        
    }
    
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
            if([[responseInfo valueForKey:@"status"] intValue] == 2)
            {
                self.BookingsTableView.hidden = YES;
            }
            [Utilities displayCustemAlertViewWithOutImage:str :self.view];
        });
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // [ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
    });
    
    
}











@end
