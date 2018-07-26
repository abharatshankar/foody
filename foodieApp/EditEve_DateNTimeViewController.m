//
//  EditEve_DateNTimeViewController.m
//  foodieApp
//
//  Created by Bharat on 13/03/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "EditEve_DateNTimeViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "SingleTon.h"



@interface EditEve_DateNTimeViewController ()
{
    SingleTon *  singleTonInstance;
    UIToolbar * toolbar;
    NSString *time24,*seDatee;
    NSDateFormatter * endFormater;
}

@end

@implementation EditEve_DateNTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.datePicker=[[UIDatePicker alloc]init];
    
    [self.strtTimeTxt setEnabled:NO];
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(doneButton)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
    
    
    
    
    
    
    
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
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 70, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    phoneBarItem.action = @selector(phoneAction);
    [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [phoneButton setTitle:@"Done" forState:UIControlStateNormal];
    //[phoneButton setImage:[UIImage imageNamed:@"invite_icon.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    //--right buttons--//
//    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
//    btntitle.frame = CGRectMake(30, 0, 120, 30);
//    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    btntitle.showsTouchWhenHighlighted=YES;
//    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
//    [arrLeftBarItems addObject:barButtonItem3];
//    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [btntitle setTitle:@"Date & Time" forState:UIControlStateNormal];
//    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // [btnh addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    
    self.title = @"Date & Time";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    
    
    //////////////////////////////////////////////////////
    //////////////////dotted border///////////////////////
    
    CAShapeLayer *yourViewBorder = [CAShapeLayer layer];
    yourViewBorder.strokeColor = [UIColor blackColor].CGColor;
    yourViewBorder.fillColor = nil;
    yourViewBorder.lineDashPattern = @[@2, @2];
    yourViewBorder.frame = self.startDteTxt.bounds;
    yourViewBorder.path = [UIBezierPath bezierPathWithRect:self.startDteTxt.bounds].CGPath;
    [self.startDteTxt.layer addSublayer:yourViewBorder];
    
    
    CAShapeLayer *yourViewBorder1 = [CAShapeLayer layer];
    yourViewBorder1.strokeColor = [UIColor blackColor].CGColor;
    yourViewBorder1.fillColor = nil;
    yourViewBorder1.lineDashPattern = @[@2, @2];
    yourViewBorder1.frame = self.strtTimeTxt.bounds;
    yourViewBorder1.path = [UIBezierPath bezierPathWithRect:self.strtTimeTxt.bounds].CGPath;
    [self.strtTimeTxt.layer addSublayer:yourViewBorder1];
    
    CAShapeLayer *yourViewBorder2 = [CAShapeLayer layer];
    yourViewBorder2.strokeColor = [UIColor blackColor].CGColor;
    yourViewBorder2.fillColor = nil;
    yourViewBorder2.lineDashPattern = @[@2, @2];
    yourViewBorder2.frame = self.EndDateTxt.bounds;
    yourViewBorder2.path = [UIBezierPath bezierPathWithRect:self.EndDateTxt.bounds].CGPath;
    [self.EndDateTxt.layer addSublayer:yourViewBorder2];
    
    
    
    
    CAShapeLayer *yourViewBorder3 = [CAShapeLayer layer];
    yourViewBorder3.strokeColor = [UIColor blackColor].CGColor;
    yourViewBorder3.fillColor = nil;
    yourViewBorder3.lineDashPattern = @[@2, @2];
    yourViewBorder3.frame = self.endTimeTxt.bounds;
    yourViewBorder3.path = [UIBezierPath bezierPathWithRect:self.endTimeTxt.bounds].CGPath;
    [self.endTimeTxt.layer addSublayer:yourViewBorder3];
    
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    
    
    
    self.startDteTxt.textAlignment = NSTextAlignmentCenter;
    self.datePicker=[[UIDatePicker alloc]init];
    self.datePicker.datePickerMode=UIDatePickerModeDate;
    [self.startDteTxt setInputView:self.datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.startDteTxt setInputAccessoryView:toolBar];
    
    //datePicker.maximumDate=[NSDate date];
    [self.datePicker setMinimumDate: [NSDate date]];
    
    
    
    
    if (self.strtTimeTxt.text.length) {
        [self.strtTimeTxt setEnabled:NO];
    }
    else{
        
        [self.strtTimeTxt setEnabled:YES];
    }
    
    
    
    
    //placing date picker at start time  text
    
    self.datePicker1=[[UIDatePicker alloc]init];
    self.datePicker1.datePickerMode= UIDatePickerModeTime;
    
    [self.strtTimeTxt setInputView:self.datePicker1];
    UIToolbar *toolBar1=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar1 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn1=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedTime)];
    
    UIBarButtonItem *space1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar1 setItems:[NSArray arrayWithObjects:space1,doneBtn1, nil]];
    [self.strtTimeTxt setInputAccessoryView:toolBar1];
    
    
    
    //placing date picker at end date time text
    
    
    self.datePicker2 = [[UIDatePicker alloc]init];
    self.datePicker2.datePickerMode = UIDatePickerModeDate;
    
    [self.EndDateTxt setInputView:self.datePicker2];
    
    UIToolbar *toolBar2=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar2 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn2=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showEndDate)];
    UIBarButtonItem *space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar2 setItems:[NSArray arrayWithObjects:space2,doneBtn2, nil]];
    [self.EndDateTxt setInputAccessoryView:toolBar2];
    
    
    
    [self.datePicker2 setMinimumDate: [NSDate date]];
    
    //singleTonInstance.startDateStr
    
    //placing date picker at end time text
    
    self.datePicker3=[[UIDatePicker alloc]init];
    self.datePicker3.datePickerMode= UIDatePickerModeTime;
    
    [self.endTimeTxt setInputView:self.datePicker3];
    UIToolbar *toolBar3=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar3 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn3=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showEndTime)];
    
    UIBarButtonItem *space3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar3 setItems:[NSArray arrayWithObjects:space3,doneBtn3, nil]];
    [self.endTimeTxt setInputAccessoryView:toolBar3];
    
    
    
    
    
    self.strtDateLbl.hidden = YES;
    self.startMnthLbl.hidden = YES;
    
    self.endDateLbl.hidden = YES;
    self.endMnthLbl.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneAction
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)Back_Click
{
    singleTonInstance.editedEventStartDateToServer = nil;
    singleTonInstance.editedEventEndDateToServer= nil;
    singleTonInstance.editedEventStartDate = nil;
    singleTonInstance.editedEventEndDate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showSelectedDate
{
    
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    seDatee = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker.date]];
    NSLog(@"setting date is %@",seDatee);
    singleTonInstance.editedEventStartDateToServer = seDatee;// to send to server
    [formater setDateFormat:@"EEE MMM dd yyyy"];
    //yyyy-MM-dd
    
    self.startDteTxt.text = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker.date]];
    
    
    
    
    
    singleTonInstance.editedEventStartDate = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker.date]];
    
    self.startMnthLbl.hidden = NO;
    
    self.strtDateLbl.hidden = NO;
    
    ////////////////////////
    // bring month name from date (yyyy/MM/dd ) And day number
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *date = [dateFormat dateFromString:singleTonInstance.editedEventStartDate];
    [dateFormat setDateFormat:@"MMMM"];
    NSString* temp = [dateFormat stringFromDate:date];
    NSLog(@"month is %@",temp);
    self.startMnthLbl.text = temp;
    
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *date1 = [dateFormat1 dateFromString:singleTonInstance.editedEventStartDate];
    [dateFormat1 setDateFormat:@"dd"];
    NSString* temp1 = [dateFormat1 stringFromDate:date1];
    NSLog(@"Day is %@",temp1);
    self.strtDateLbl.text = temp1;
    
    self.startDteTxt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.startDteTxt.layer.borderWidth = 0.5;
    
    //////////////////////////////
    
    toolbar.hidden = YES;
    
    [self.startDteTxt resignFirstResponder];
    
    
    if (self.strtTimeTxt.text.length) {
        [_strtTimeTxt setEnabled:NO];
    }
    else{
        
        [_strtTimeTxt setEnabled:YES];
    }
    
    
    
    
    // this line is to set date after days of datepickerOne selected date
    self.datePicker2.minimumDate = [self.datePicker.date dateByAddingTimeInterval:24*60*60];
    
}

-(void)showEndDate
{
    
    endFormater = [[NSDateFormatter alloc]init];
    [endFormater setDateFormat:@"EEE MMM dd yyyy"];
    
    
    
    
    
    self.EndDateTxt.text = [NSString stringWithFormat:@"%@",[endFormater stringFromDate:self.datePicker2.date]];
    
    self.EndDateTxt.textAlignment = NSTextAlignmentCenter;
    
    singleTonInstance.editedEventEndDate = [NSString stringWithFormat:@"%@",[endFormater stringFromDate:self.datePicker2.date]];
    
    self.endMnthLbl.hidden = NO;
    
    self.endDateLbl.hidden = NO;
    
    ////////////////////////
    // bring month name from date (yyyy/MM/dd ) And day number
    NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
    [endDateFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *date = [endDateFormat dateFromString:singleTonInstance.editedEventEndDate];
    [endDateFormat setDateFormat:@"MMMM"];
    NSString* endTemp = [endDateFormat stringFromDate:date];
    NSLog(@"month is %@",endTemp);
    self.endMnthLbl.text = endTemp;
    
    
    NSDateFormatter *endDateFormat1 = [[NSDateFormatter alloc] init];
    [endDateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *endDate1 = [endDateFormat1 dateFromString:singleTonInstance.editedEventEndDate];
    [endDateFormat1 setDateFormat:@"dd"];
    NSString* endTemp1 = [endDateFormat1 stringFromDate:endDate1];
    
    self.endDateLbl.text = endTemp1;
    
    self.EndDateTxt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.EndDateTxt.layer.borderWidth = 0.5;
    
    
    toolbar.hidden = YES;
    
    
    [endFormater setDateFormat:@"yyyy-MM-dd"];
    NSString * setEDate = [NSString stringWithFormat:@"%@",[endFormater stringFromDate:self.datePicker2.date]];
    NSLog(@"setting date is %@",setEDate);
    singleTonInstance.editedEventEndDateToServer = setEDate;// to send to server
    
    [self.EndDateTxt resignFirstResponder];
    
    
}



-(void)ShowSelectedTime
{
    self.startOptional.hidden = YES;
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"hh:mm a"];
    
    
    self.strtTimeTxt.text = [NSString stringWithFormat:@"%@",[formater stringFromDate:_datePicker1.date]];
    
    self.strtTimeTxt.textAlignment = NSTextAlignmentCenter;
    
    singleTonInstance.editedEventStartTime = [NSString stringWithFormat:@"%@",[formater stringFromDate:self.datePicker1.date]];
    
    [formater setDateFormat:@"HH:mm"];
    
    time24 = [NSString stringWithFormat:@"%@",[formater stringFromDate:_datePicker1.date]];
    
    NSLog(@"timeeeeee %@",time24);
    
    singleTonInstance.editedEventStartTimeToServer = time24;//march 8th
    
    [self.strtTimeTxt resignFirstResponder];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"hh:mm a"];
    NSDate *date2 = [dateFormat2 dateFromString:singleTonInstance.editedEventStartTime];
    [dateFormat2 setDateFormat:@"hh:mm a"];
    NSString* temp2 = [dateFormat2 stringFromDate:date2];
    
    self.startTmeLbl.text = temp2;
    self.startTmeLbl.hidden = NO;
}

-(void)showEndTime
{
    self.endOptional.hidden = YES;
    NSDateFormatter * endTimeformater = [[NSDateFormatter alloc]init];
    [endTimeformater setDateFormat:@"hh:mm a"];
    
    
    self.endTimeTxt.text = [NSString stringWithFormat:@"%@",[endTimeformater stringFromDate:self.datePicker3.date]];
    
    self.endTimeTxt.textAlignment = NSTextAlignmentCenter;
    
    singleTonInstance.editedEventEndTime = [NSString stringWithFormat:@"%@",[endTimeformater stringFromDate:self.datePicker3.date]];
    
    [endTimeformater setDateFormat:@"HH:mm"];
    
    time24 = [NSString stringWithFormat:@"%@",[endTimeformater stringFromDate:self.datePicker3.date]];
    
    NSLog(@"timeeeeee %@",time24);
    
    singleTonInstance.editedEventEndTimeToServer = time24; //march 8th
    
    [self.endTimeTxt resignFirstResponder];
    
    
    NSDateFormatter *endDateFormat2 = [[NSDateFormatter alloc] init];
    [endDateFormat2 setDateFormat:@"hh:mm a"];
    NSDate *date3 = [endDateFormat2 dateFromString:singleTonInstance.editedEventEndTime];
    [endDateFormat2 setDateFormat:@"hh:mm a"];
    NSString* temp3 = [endDateFormat2 stringFromDate:date3];
    
    self.endTimeLbl.text = temp3;
    self.endTimeLbl.hidden = NO;
    
}

-(void)doneButton
{
   
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)startTime:(id)sender
{
    self.strtTimeTxt.text = nil;
    self.startDteTxt.text = nil;
    self.startTmeLbl.hidden=YES;
    self.startMnthLbl.hidden = YES;
    self.strtDateLbl.hidden = YES;
   // singleTonInstance.startDateStr = nil;
}

- (IBAction)endTime:(id)sender
{
    self.endTimeTxt.text = nil;
    self.EndDateTxt.text = nil;
   // self.endDayLbl.hidden=YES;
    self.endTimeLbl.hidden = YES;
    self.endMnthLbl.hidden = YES;
//    singleTonInstance.endDateStr = nil;
//    singleTonInstance.endTimeStr=nil;
}
@end
