//
//  pastBookingViewController.m
//  foodieApp
//
//  Created by ashwin challa on 4/10/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "pastBookingViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceInitiater.h"
#import "ServiceManager.h"
#import "presentBookingTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "EventReadyPageController.h"

@interface pastBookingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * BookingsArr,*presentEventsArray,*grabingArray;
    BOOL  *sidebarMenuOpen ;
    NSString * typStr;
}

@end

@implementation pastBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    BookingsArr = [[NSMutableArray alloc]init];
    
    presentEventsArray = [[NSMutableArray alloc]init];
    
    grabingArray = [[NSMutableArray alloc]init];
    
    
    
    typStr = @"past";
    
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    
    
    
    [self userPresentServiceCall];
    
    
    
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    typStr = @"past";
    [self userPresentServiceCall];
    
    [self.tblView reloadData];
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
    
    
    
    static NSString *CellIdentifier = @"pastBookingTableViewCell";
    
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
    
    
    NSString * startDat = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row ] objectForKey:@"start_date"]] ;
    
    NSString * startTim = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row ] objectForKey:@"start_time"]];
    
    NSString * endDat = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row ] objectForKey:@"end_date"]];
    
    NSString * endTim = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row ] objectForKey:@"end_time"]];
    
    
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
    
    
    if (endDat.length)
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
            
            notifications.isFromMyEventsPage = @"past";
            
            NSString * str  = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"start_time"]];
            
            NSString * endStr = [Utilities null_ValidationString:[[presentEventsArray objectAtIndex:indexPath.row] objectForKey:@"end_time"]];
            
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
                        @"type":@"past"
                        
                        
                        
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
    
    NSLog(@"responseInfo userEvents:%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            
            presentEventsArray = [responseInfo valueForKey:@"events"];
            
            [self.tblView reloadData];
            
            
            
            
            
            
        });
        
    }
    
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
            if([[responseInfo valueForKey:@"status"] intValue] == 2)
            {
                //self.tblView.hidden = YES;
            }
            //[Utilities displayCustemAlertViewWithOutImage:str :self.view];
            [Utilities displayToastWithMessage:[Utilities null_ValidationString:str] ];
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
