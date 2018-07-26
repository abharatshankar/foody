//
//  bookingsViewController.m
//  foodieApp
//
//  Created by ashwin challa on 4/10/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "bookingsViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceInitiater.h"
#import "ServiceManager.h"
#import "presentBookingTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "EventReadyPageController.h"
#import "UIViewController+ENPopUp.h"

#import "smallPopupViewController.h"
@interface bookingsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * BookingsArr,*presentEventsArray,*grabingArray;
    BOOL  *sidebarMenuOpen ;
    
}
@end

@implementation bookingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    BookingsArr = [[NSMutableArray alloc]init];
    
    presentEventsArray = [[NSMutableArray alloc]init];
    
    grabingArray = [[NSMutableArray alloc]init];
    
   
    
    
    
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    
    
    
    [self userPresentServiceCall];
    
    
    
    NSData * myData = [USERDEFAULTS valueForKey:@"invitedUserEventArray"];
    
    BOOL  isBool  = [USERDEFAULTS objectForKey:@"invite_status"];
    
    
    NSMutableArray* myMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    
    if (myMutableArray.count && isBool == YES)
    {
        smallPopupViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopUp"];
        vc.view.frame = CGRectMake(0, 0, 270.0f, 240.0f);
        
        [self presentPopUpViewController:vc];
        
    }
    
    
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{

    [self userPresentServiceCall];
    
   // [self.tblView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"cells count %d",presentEventsArray.count);
        return presentEventsArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    
    
    
    static NSString *CellIdentifier = @"presentBookingTableViewCell";
    
    presentBookingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[presentBookingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    
        
        cell.eventName.text = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"event_name"]];
    
    NSLog(@"name of cell  = = = %@",cell.eventName.text);
        
        int numB = [[[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"member_count"] intValue];
        
        NSString * countNum = [NSString stringWithFormat:@"%d",numB];
        
        cell.numberOfEventPeople.text = [Utilities null_ValidationString:countNum];
        
        if([[[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"event_status"] intValue] == 1)
        {
            
            
            cell.eventStatus.text =  @"Going";
        }
        else if ([[[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"event_status"] intValue] == 2)
        {
            cell.eventStatus.text =  @"Interested";
        }
        else
        {
            cell.eventStatus.text =  @"Can't Go";
        }
        
        [cell.eventStatus sizeToFit];
        //  cell.eventStatusLbl.text = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"event_status"]];
        
        
        NSString * startDat =  [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row ] objectForKey:@"start_date"]];
        
        NSString * startTim = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row ] objectForKey:@"start_time"]];
        
        NSString * endDat = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row ] objectForKey:@"end_date"]];
        
        NSString * endTim = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row ] objectForKey:@"end_time"]];
        
        
        ////////////////////////
        // bring month name from date (yyyy/MM/dd ) And day number
        
        if (startDat.length>0)
        {
            
            NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"MMMM"];
            [dateFormatter2 setDateFormat:@"dd"];
            
            
            
            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
            [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [dateFormatter3 dateFromString:startDat];
            
            cell.startMonth.text = [dateFormatter1 stringFromDate:dateFromString];
            cell.startDay.text = [dateFormatter2 stringFromDate:dateFromString];
            
            NSLog(@"date is %@",cell.startMonth.text);
            
            cell.startMonth.hidden = NO;
            cell.startDay.hidden = NO;
        }
        else
        {
            
            cell.startMonth.hidden = YES;
            cell.startDay.hidden = YES;
            
            
        }
        
        
        if (endDat.length>0)
        {
            
            NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"MMMM"];
            [dateFormatter2 setDateFormat:@"dd"];
            
            
            
            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
            [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [dateFormatter3 dateFromString:endDat];
            
            cell.endMonth.text = [dateFormatter1 stringFromDate:dateFromString];
            cell.endDay.text = [dateFormatter2 stringFromDate:dateFromString];
            
            
            
            cell.endMonth.hidden = NO;
            cell.endDay.hidden = NO;
        }
        else
        {
            
            cell.endMonth.hidden = YES;
            cell.endDay.hidden = YES;
            
            
        }
        
        
        
        if (![startTim isKindOfClass:[NSNull class]]) {
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            dateFormatter.dateFormat = @"HH:mm:ss";
            
            NSDate *date = [dateFormatter dateFromString:startTim];
            
            dateFormatter.dateFormat = @"hh:mm a";
            
            NSString *pmamDateString = [dateFormatter stringFromDate:date];
            
            cell.startTime.text  = pmamDateString;
            
            cell.startTime.textColor = [UIColor whiteColor];
            
            cell.startTime.hidden = NO;
            
            
        }
        else
        {
            cell.startTime.hidden = YES;
            
        }
        
        
        if (![endTim isKindOfClass:[NSNull class]]) {
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            dateFormatter.dateFormat = @"HH:mm:ss";
            
            NSDate *date = [dateFormatter dateFromString:endTim];
            
            dateFormatter.dateFormat = @"hh:mm a";
            
            NSString *pmamDateString = [dateFormatter stringFromDate:date];
            
            cell.endTime.text  = pmamDateString;
            
            cell.endTime.textColor = [UIColor whiteColor];
            
            cell.endTime.hidden = NO;
            
            
        }
        else
        {
            cell.endTime.hidden = YES;
            
        }
        
        
        
        //////////////////////////////
        
        
        
        
        
        
        
        
        NSString * featuredimages = [[presentEventsArray objectAtIndex:indexPath.row ] objectForKey:@"image"];
        
        NSString *  imageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/events/%@",featuredimages];
        
        NSLog(@"===image url  == %@",imageString);
        
        NSURL *url = [NSURL URLWithString:imageString];
        [cell.eventImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
        
        
       // [Utilities setBorderView:cell.lineview :3 :LIGHTGRYCOLOR];
    
    
        
        return cell;
    
    
    
    
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"------->>> %d", presentEventsArray.count);
        if (presentEventsArray.count)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            EventReadyPageController *notifications = [storyboard instantiateViewControllerWithIdentifier:@"EventReadyPageController"];
            
            notifications.isFromMyEventsPage = @"present";
            
            NSLog(@"\n\n\n\n\n current selected event info : %@\n\n\n\n\n",[presentEventsArray objectAtIndex:indexPath.row]);
            
            NSString * str  = [[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"start_time"];
            
            NSString * endStr = [[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"end_time"];
            
            NSString * startTim = [self convetTimeTo12hours:endStr];
            
            NSString * endTim = [self convetTimeTo12hours:str];
            
            notifications.startTimeFromBookings = startTim;
            
            notifications.endTimeFromBookings = endTim;
            
            
            notifications.presentEventsDict = [presentEventsArray objectAtIndex:indexPath.row];
            
            int eventIdNum = [[[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"event_id"] intValue];
            
            NSString * eventIDNumStr = [NSString stringWithFormat:@"%d",eventIdNum];
            
            notifications.eventIdStr = [Utilities null_ValidationString:eventIDNumStr];
            
            [self.navigationController pushViewController:notifications animated:YES];
        }
    });
    
}





//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}



//Helper function to get a random float
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (UIColor*)colorFromIndex:(int)index{
    UIColor *color;
    
    //Purple
    if(index % 3 == 0){
        color = [UIColor colorWithRed:0.93 green:0.01 blue:0.55 alpha:1.0];
        //Blue
    }else if(index % 3 == 1){
        color = [UIColor colorWithRed:0.00 green:0.68 blue:0.94 alpha:1.0];
        //Blk
    }else if(index % 3 == 2){
        color = [UIColor blackColor];
    }
    else if(index % 3 == 3){
        color = [UIColor colorWithRed:0.00 green:1.0 blue:0.00 alpha:1.0];
    }
    
    
    return color;
    
}






//////////////////////////////////////////////////////////////////////////////////////
// convert time(10:25:01) to am/pm format
//////////////////////////////////////////////////////////////////////////////////////
-(id)convetTimeTo12hours:(NSString *)timeToConvertStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"HH:mm:ss";
    
    NSDate *date = [dateFormatter dateFromString:[Utilities null_ValidationString:timeToConvertStr]];
    
    dateFormatter.dateFormat = @"hh:mm a";
    
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    
    return pmamDateString;
}

//////////////////////////////////////////////////////////////////////////////////////



# pragma mark - Webservice Delegates








-(void)userPresentServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
        
        
        NSDictionary * requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@userEvents",BASEURL];
        
        
        
        
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"type":@"present"
                        
                        
                        
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
    
    NSLog(@"responseInfo present event:%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            self.tblView.hidden = NO;
                
                presentEventsArray = [responseInfo valueForKey:@"events"];

                [self.tblView reloadData];
            
        });
        
    }
    else if ( [[responseInfo valueForKey:@"status"] intValue] == 2)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tblView.hidden = YES;
            //[presentEventsArray removeAllObjects];
            //[self.tblView reloadData];
        });
    }
    //presentEventsArray
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
            if([[responseInfo valueForKey:@"status"] intValue] == 2)
            {
               // self.tblView.hidden = YES;
            
            }
            [Utilities displayToastWithMessage:str ];
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
