//
//  bookingTableViewController.m
//  foodieApp
//
//  Created by Bharat shankar on 23/05/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "bookingTableViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "SingleTon.h"


@interface bookingTableViewController ()
{
    SingleTon *  singleTonInstance;
    UIToolbar * toolbar;
    NSString *time24,*seDatee;
    NSDateFormatter * endFormater;
    
    int number;
    int numOfPartisipants;

}
@end

@implementation bookingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Utilities addShadowtoView:self.justView];
    [Utilities addShadowtoView:self.justView2];
    
    self.datePicker=[[UIDatePicker alloc]init];
    
    [self.timeText setEnabled:NO];
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    self.doneBtn.layer.cornerRadius = 10;
    number = 0;
    
    self.plusButton.layer.borderColor = REDCOLOR.CGColor;
    self.minusButton.layer.borderColor = REDCOLOR.CGColor;
    self.plusButton.layer.borderWidth = 0.5;
    self.minusButton.layer.borderWidth = 0.5;
    
    
    
    self.dateText.textAlignment = NSTextAlignmentLeft;
    self.datePicker=[[UIDatePicker alloc]init];
    self.datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateText setInputView:self.datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dateText setInputAccessoryView:toolBar];
    
    //datePicker.maximumDate=[NSDate date];
    [self.datePicker setMinimumDate: [NSDate date]];
    
    
    //    self.startDateDateLbl.hidden = YES;
    //    self.startdateMonthLbl.hidden = YES;
    
    if (self.timeText.text.length) {
        [self.timeText setEnabled:NO];
    }
    else{
        
        [self.timeText setEnabled:YES];
    }
    
    
    
    
    //placing date picker at start time  text
    
    self.datePicker1=[[UIDatePicker alloc]init];
    self.datePicker1.datePickerMode= UIDatePickerModeTime;
    
    [self.timeText setInputView:self.datePicker1];
    UIToolbar *toolBar1=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar1 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn1=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedTime)];
    
    UIBarButtonItem *space1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar1 setItems:[NSArray arrayWithObjects:space1,doneBtn1, nil]];
    [self.timeText setInputAccessoryView:toolBar1];
    
    
    self.JustView3.hidden = YES;
    
    self.bookingTime.text = [Utilities null_ValidationString:[singleTonInstance.summaryDict objectForKey:@"open_time"]];
    
    self.countLabel.text = [Utilities null_ValidationString:self.partisipantCount];
    
    numOfPartisipants = [[Utilities null_ValidationString:self.partisipantCount] intValue];
    
    seDatee = [Utilities null_ValidationString:self.eventDate];
    
    self.dateText.text = [Utilities null_ValidationString:seDatee];
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;

}



-(void)showSelectedDate
{
    
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    seDatee = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker.date]];
    NSLog(@"setting date is %@",seDatee);
    //singleTonInstance.startDateToServer = seDatee;// to send to server
    [formater setDateFormat:@"EEE MMM dd yyyy"];
    //yyyy-MM-dd
    
    self.dateText.text = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker.date]];
    
    
    
    
    
    //singleTonInstance.startDateStr = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker.date]];
    
//
//
//    ////////////////////////
//    // bring month name from date (yyyy/MM/dd ) And day number
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"EEE MMM dd yyyy"];
//    NSDate *date = [dateFormat dateFromString:singleTonInstance.startDateStr];
//    [dateFormat setDateFormat:@"MMMM"];
//    NSString* temp = [dateFormat stringFromDate:date];
//    NSLog(@"month is %@",temp);
//    self.startdateMonthLbl.text = temp;
//
//
//    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
//    [dateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
//    NSDate *date1 = [dateFormat1 dateFromString:singleTonInstance.startDateStr];
//    [dateFormat1 setDateFormat:@"dd"];
//    NSString* temp1 = [dateFormat1 stringFromDate:date1];
//    NSLog(@"Day is %@",temp1);
//    self.startDateDateLbl.text = temp1;
//
//    self.startDateText.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.startDateText.layer.borderWidth = 0.5;
    
    //////////////////////////////
    
    toolbar.hidden = YES;
    
    [self.dateText resignFirstResponder];
    
    
    if (self.timeText.text.length) {
        [self.timeText setEnabled:NO];
    }
    else{
        
        [self.timeText setEnabled:YES];
    }
    
    
    
    
   
    
}






-(void)ShowSelectedTime
{
    //self.startOptional.hidden = YES;
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"hh:mm a"];
    
    
    self.timeText.text = [NSString stringWithFormat:@"%@",[formater stringFromDate:_datePicker1.date]];
    
    self.timeText.textAlignment = NSTextAlignmentLeft;
    
//    singleTonInstance.showTimeStr = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker1.date]];
//
//    [formater setDateFormat:@"HH:mm"];
//
//    time24 = [NSString stringWithFormat:@"%@",[formater stringFromDate:_datePicker1.date]];
//
//    NSLog(@"timeeeeee %@",time24);
//
//    singleTonInstance.startTimeToServer = time24;//march 8th
    
    [self.timeText resignFirstResponder];
    
    
//
//    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
//    [dateFormat2 setDateFormat:@"hh:mm a"];
//    NSDate *date2 = [dateFormat2 dateFromString:singleTonInstance.showTimeStr];
//    [dateFormat2 setDateFormat:@"hh:mm a"];
//    NSString* temp2 = [dateFormat2 stringFromDate:date2];
    
    
}


- (IBAction)minusAction:(id)sender {
    
    if (number == 0) {
        
    }
    else
    {
        number = number-1;
        self.countLabel.text = [NSString stringWithFormat:@"%d",number];
    }
    
}

- (IBAction)plusAction:(id)sender {
    number = number+1;
    self.countLabel.text = [NSString stringWithFormat:@"%d",number];
}


- (IBAction)confirmAction:(id)sender {
    
    
    [self.view endEditing:YES];
    
    if ([self.selectBookingDate.text length] > 0)
    {
        if ([self.bookingTime.text length] > 0)
        {
            if (numOfPartisipants > 0)
            {
                if ([Utilities isInternetConnectionExists])
                {
                    
                    
                    //loading UI Starting on mainThread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                    });
                    
                    NSDictionary *requestDict;
                    
                    //Request URL
                    NSString *urlStr = [NSString stringWithFormat:@"%@booktable",BASEURL];
                    requestDict = @{
                                    @"user_id":[Utilities getUserID],
                                    @"date":seDatee,
                                    @"time":[Utilities null_ValidationString:self.bookingTime.text],
                                    @"number_of_people":[Utilities null_ValidationString:self.partisipantCount],
                                    @"request":[Utilities null_ValidationString:self.requestText.text],
                                    };
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        ServiceManager *service = [ServiceManager sharedInstance];
                        service.delegate = self;
                        
                        
                        
                        [service  handleRequestWithDelegates:urlStr info:requestDict];
                        
                    });
                    
                }
                else
                {
                    [Utilities displayCustemAlertViewWithOutImage:@"Please Check Your Internet connection" :self.view];
                }
            }
            else
            {
                [Utilities displayCustemAlertViewWithOutImage:@"please select persons" :self.view];
            }
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:@"please select booking time" :self.view];
        }
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"please select booking date" :self.view];
    }
}


# pragma mark - Webservice Delegates

- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
}
- (void)failResponse:(NSError*)error
{
    
    dispatch_async(dispatch_get_main_queue(),
^{
    [Utilities removeLoading:self.view];
});
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    NSLog(@"responseInfo :%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
            
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.JustView3.hidden = NO;
                
                self.dateLbl.text = seDatee;
                self.timeLbl.text = self.timeText.text;
                self.peopleLabel.text = [NSString stringWithFormat:@"%d People",numOfPartisipants];
                
                //                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"response"]];
                //                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
                
                
                
                
            });
            
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
        });
        
    }
    
    @catch (NSException *exception) {
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities removeLoading:self.view];
        });
        [self.view endEditing:YES];
    }
    
}


- (IBAction)doneAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeView:(id)sender
{
    self.JustView3.hidden = YES;
}

@end
