//
//  setDateAndTimeController.h
//  foodieApp
//
//  Created by ashwin challa on 2/1/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setDateAndTimeController : UIViewController


@property UIDatePicker * datePicker;
@property UIDatePicker * datePicker1;
@property UIDatePicker * datePicker2;
@property UIDatePicker * datePicker3;

@property (strong, nonatomic) IBOutlet UITextField *startDateText;
@property (strong, nonatomic) IBOutlet UITextField *startTimeText;
@property (strong, nonatomic) IBOutlet UITextField *endDateText;
@property (strong, nonatomic) IBOutlet UITextField *endTimeText;


@property (strong, nonatomic) IBOutlet UILabel *startdateMonthLbl;
@property (strong, nonatomic) IBOutlet UILabel *startDateDateLbl;

@property (strong, nonatomic) IBOutlet UILabel *endMonthLbl;
@property (strong, nonatomic) IBOutlet UILabel *endDayLbl;


@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *endDateMonthLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *startOptional;
@property (strong, nonatomic) IBOutlet UILabel *endOptional;


@end
