//
//  setDateAndTimeController.m
//  foodieApp
//
//  Created by ashwin challa on 2/1/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "setDateAndTimeController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "SingleTon.h"
#import "creatingEventViewController.h"


@interface setDateAndTimeController ()
{
    SingleTon *  singleTonInstance;
    UIToolbar * toolbar;
    NSString *time24,*seDatee;
    NSDateFormatter * endFormater;
    

}
@end

@implementation setDateAndTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePicker=[[UIDatePicker alloc]init];
    
    [self.startTimeText setEnabled:NO];
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(doneButton)];
    [doneButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                          forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
    
    
    
    
    
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    //////////////////////////////////////////////////////
    //////////////////dotted border///////////////////////
    
    CAShapeLayer *yourViewBorder = [CAShapeLayer layer];
    yourViewBorder.strokeColor = [UIColor blackColor].CGColor;
    yourViewBorder.fillColor = nil;
    yourViewBorder.lineDashPattern = @[@2, @2];
    yourViewBorder.frame = self.startDateText.bounds;
    yourViewBorder.path = [UIBezierPath bezierPathWithRect:self.startDateText.bounds].CGPath;
   // [self.startDateText.layer addSublayer:yourViewBorder];
    
    
    CAShapeLayer *yourViewBorder1 = [CAShapeLayer layer];
    yourViewBorder1.strokeColor = [UIColor blackColor].CGColor;
    yourViewBorder1.fillColor = nil;
    yourViewBorder1.lineDashPattern = @[@2, @2];
    yourViewBorder1.frame = self.startTimeText.bounds;
    yourViewBorder1.path = [UIBezierPath bezierPathWithRect:self.startTimeText.bounds].CGPath;
   // [self.startTimeText.layer addSublayer:yourViewBorder1];
   
    CAShapeLayer *yourViewBorder2 = [CAShapeLayer layer];
    yourViewBorder2.strokeColor = [UIColor blackColor].CGColor;
    yourViewBorder2.fillColor = nil;
    yourViewBorder2.lineDashPattern = @[@2, @2];
    yourViewBorder2.frame = self.endDateText.bounds;
    yourViewBorder2.path = [UIBezierPath bezierPathWithRect:self.endDateText.bounds].CGPath;
   // [self.endDateText.layer addSublayer:yourViewBorder2];
    
    

    
    CAShapeLayer *yourViewBorder3 = [CAShapeLayer layer];
    yourViewBorder3.strokeColor = [UIColor blackColor].CGColor;
    yourViewBorder3.fillColor = nil;
    yourViewBorder3.lineDashPattern = @[@2, @2];
    yourViewBorder3.frame = self.endTimeText.bounds;
    yourViewBorder3.path = [UIBezierPath bezierPathWithRect:self.endTimeText.bounds].CGPath;
  //  [self.endTimeText.layer addSublayer:yourViewBorder3];
    
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    
    
    
    self.startDateText.textAlignment = NSTextAlignmentLeft;
    self.datePicker=[[UIDatePicker alloc]init];
    self.datePicker.datePickerMode=UIDatePickerModeDate;
    [self.startDateText setInputView:self.datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.startDateText setInputAccessoryView:toolBar];
    
    //datePicker.maximumDate=[NSDate date];
    [self.datePicker setMinimumDate: [NSDate date]];
    

//    self.startDateDateLbl.hidden = YES;
//    self.startdateMonthLbl.hidden = YES;
    
    if (self.startTimeText.text.length) {
        [self.startTimeText setEnabled:NO];
    }
    else{
        
        [self.startTimeText setEnabled:YES];
    }
    
    
    
    
    //placing date picker at start time  text
    
    self.datePicker1=[[UIDatePicker alloc]init];
    self.datePicker1.datePickerMode= UIDatePickerModeTime;
    
    [self.startTimeText setInputView:self.datePicker1];
    UIToolbar *toolBar1=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar1 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn1=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedTime)];
    
    UIBarButtonItem *space1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar1 setItems:[NSArray arrayWithObjects:space1,doneBtn1, nil]];
    [self.startTimeText setInputAccessoryView:toolBar1];
    
    
    
    //placing date picker at end date time text
    
    
    self.datePicker2 = [[UIDatePicker alloc]init];
    self.datePicker2.datePickerMode = UIDatePickerModeDate;
    
    [self.endDateText setInputView:self.datePicker2];
    
    UIToolbar *toolBar2=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar2 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn2=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showEndDate)];
    UIBarButtonItem *space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar2 setItems:[NSArray arrayWithObjects:space2,doneBtn2, nil]];
    [self.endDateText setInputAccessoryView:toolBar2];
    
    
    
    [self.datePicker2 setMinimumDate: [NSDate date]];
    
    //singleTonInstance.startDateStr
    
    //placing date picker at end time text
    
    self.datePicker3=[[UIDatePicker alloc]init];
    self.datePicker3.datePickerMode= UIDatePickerModeTime;
    
    [self.endTimeText setInputView:self.datePicker3];
    UIToolbar *toolBar3=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar3 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn3=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showEndTime)];
    
    UIBarButtonItem *space3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar3 setItems:[NSArray arrayWithObjects:space3,doneBtn3, nil]];
    [self.endTimeText setInputAccessoryView:toolBar3];
    
    
    
    
    
    self.startDateDateLbl.hidden = YES;
    self.startdateMonthLbl.hidden = YES;
    
    self.endDateDateLabel.hidden = YES;
    self.endDateMonthLabel.hidden = YES;
}



-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)showSelectedDate
{
    
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    seDatee = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker.date]];
    NSLog(@"setting date is %@",seDatee);
    singleTonInstance.startDateToServer = seDatee;// to send to server
    [formater setDateFormat:@"EEE MMM dd yyyy"];
   //yyyy-MM-dd
    
    self.startDateText.text = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker.date]];
    
    
    
   
    
    singleTonInstance.startDateStr = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker.date]];
    
    self.startdateMonthLbl.hidden = NO;
    
    self.startDateDateLbl.hidden = NO;
    
    ////////////////////////
    // bring month name from date (yyyy/MM/dd ) And day number
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *date = [dateFormat dateFromString:singleTonInstance.startDateStr];
    [dateFormat setDateFormat:@"MMMM"];
    NSString* temp = [dateFormat stringFromDate:date];
    NSLog(@"month is %@",temp);
    self.startdateMonthLbl.text = temp;
    
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *date1 = [dateFormat1 dateFromString:singleTonInstance.startDateStr];
    [dateFormat1 setDateFormat:@"dd"];
    NSString* temp1 = [dateFormat1 stringFromDate:date1];
    NSLog(@"Day is %@",temp1);
    self.startDateDateLbl.text = temp1;
    
   // self.startDateText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.startDateText.layer.borderWidth = 0.5;
    
    //////////////////////////////
    
    toolbar.hidden = YES;
    
    [self.startDateText resignFirstResponder];
    
    
    if (self.startTimeText.text.length) {
        [_startTimeText setEnabled:NO];
    }
    else{
        
        [_startTimeText setEnabled:YES];
    }
    

    
    
    // this line is to set date after days of datepickerOne selected date
    self.datePicker2.minimumDate = [self.datePicker.date dateByAddingTimeInterval:24*60*60];
    
}
-(void)showEndDate
{
    
     endFormater = [[NSDateFormatter alloc]init];
    [endFormater setDateFormat:@"EEE MMM dd yyyy"];
    
   
   
    
    
    self.endDateText.text = [NSString stringWithFormat:@"%@",[endFormater stringFromDate:self.datePicker2.date]];
    
    self.endDateText.textAlignment = NSTextAlignmentLeft;
    
    singleTonInstance.endDateStr = [NSString stringWithFormat:@"%@",[endFormater stringFromDate:self.datePicker2.date]];
    
    self.endDateMonthLabel.hidden = NO;
    
    self.endDateDateLabel.hidden = NO;
    
    ////////////////////////
    // bring month name from date (yyyy/MM/dd ) And day number
    NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
    [endDateFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *date = [endDateFormat dateFromString:singleTonInstance.endDateStr];
    [endDateFormat setDateFormat:@"MMMM"];
    NSString* endTemp = [endDateFormat stringFromDate:date];
    NSLog(@"month is %@",endTemp);
    self.endDateMonthLabel.text = endTemp;
    
    
    NSDateFormatter *endDateFormat1 = [[NSDateFormatter alloc] init];
    [endDateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *endDate1 = [endDateFormat1 dateFromString:singleTonInstance.endDateStr];
    [endDateFormat1 setDateFormat:@"dd"];
    NSString* endTemp1 = [endDateFormat1 stringFromDate:endDate1];
    
    self.endDateDateLabel.text = endTemp1;
    
    //self.endDateText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.endDateText.layer.borderWidth = 0.5;
    
    
    toolbar.hidden = YES;
    
    
    [endFormater setDateFormat:@"yyyy-MM-dd"];
   NSString * setEDate = [NSString stringWithFormat:@"%@",[endFormater stringFromDate:self.datePicker2.date]];
    NSLog(@"setting date is %@",setEDate);
    singleTonInstance.endDateToServer = setEDate;// to send to server
    
    [self.endDateText resignFirstResponder];
    
    
}



-(void)ShowSelectedTime
{
    self.startOptional.hidden = YES;
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"hh:mm a"];
    
    
    self.startTimeText.text = [NSString stringWithFormat:@"%@",[formater stringFromDate:_datePicker1.date]];
    
    self.startTimeText.textAlignment = NSTextAlignmentLeft;
    
    singleTonInstance.showTimeStr = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker1.date]];
    
    [formater setDateFormat:@"HH:mm"];
    
    time24 = [NSString stringWithFormat:@"%@",[formater stringFromDate:_datePicker1.date]];
    
    NSLog(@"timeeeeee %@",time24);
    
    singleTonInstance.startTimeToServer = time24;//march 8th
    
    [self.startTimeText resignFirstResponder];
    
    
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"hh:mm a"];
    NSDate *date2 = [dateFormat2 dateFromString:singleTonInstance.showTimeStr];
    [dateFormat2 setDateFormat:@"hh:mm a"];
    NSString* temp2 = [dateFormat2 stringFromDate:date2];
    
    self.startTimeLabel.text = temp2;
    self.startTimeLabel.hidden = NO;
}

-(void)showEndTime
{
    self.endOptional.hidden = YES;
    NSDateFormatter * endTimeformater = [[NSDateFormatter alloc]init];
    [endTimeformater setDateFormat:@"hh:mm a"];
    
    
    self.endTimeText.text = [NSString stringWithFormat:@"%@",[endTimeformater stringFromDate:self.datePicker3.date]];
    
    self.endTimeText.textAlignment = NSTextAlignmentLeft;
    
    singleTonInstance.endTimeStr = [NSString stringWithFormat:@"%@",[endTimeformater stringFromDate:self.datePicker3.date]];
    
    [endTimeformater setDateFormat:@"HH:mm"];
    
    time24 = [NSString stringWithFormat:@"%@",[endTimeformater stringFromDate:self.datePicker3.date]];
    
    NSLog(@"timeeeeee %@",time24);
    
    singleTonInstance.endTimeToServer = time24; //march 8th
    
    [self.endTimeText resignFirstResponder];
    
    
    NSDateFormatter *endDateFormat2 = [[NSDateFormatter alloc] init];
    [endDateFormat2 setDateFormat:@"hh:mm a"];
    NSDate *date3 = [endDateFormat2 dateFromString:singleTonInstance.endTimeStr];
    [endDateFormat2 setDateFormat:@"hh:mm a"];
    NSString* temp3 = [endDateFormat2 stringFromDate:date3];
    
    self.endTimeLabel.text = temp3;
    self.endTimeLabel.hidden = NO;
    
}

-(void)doneButton
{
//    creatingEventViewController * eventView =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"creatingEventViewController"];
//    
//    [self.navigationController pushViewController:eventView animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)startTimeClear:(id)sender {
    
    self.startTimeText.text = nil;
    self.startDateText.text = nil;
    self.startTimeLabel.hidden=YES;
    self.startdateMonthLbl.hidden = YES;
    self.startDateDateLbl.hidden = YES;
    singleTonInstance.startDateStr = nil;

}
- (IBAction)endTimeClear:(id)sender {
    
    self.endTimeText.text = nil;
    self.endDateText.text = nil;
    self.endDayLbl.hidden=YES;
    self.endTimeLabel.hidden = YES;
    self.endMonthLbl.hidden = YES;
    singleTonInstance.endDateStr = nil;
    singleTonInstance.endTimeStr=nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
