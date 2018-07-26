//
//  EditEve_DateNTimeViewController.h
//  foodieApp
//
//  Created by Prasad on 13/03/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditEve_DateNTimeViewController : UIViewController
- (IBAction)startTime:(id)sender;
- (IBAction)endTime:(id)sender;


@property UIDatePicker * datePicker;
@property UIDatePicker * datePicker1;
@property UIDatePicker * datePicker2;
@property UIDatePicker * datePicker3;




@property (strong, nonatomic) IBOutlet UITextField *startDteTxt;
@property (strong, nonatomic) IBOutlet UITextField *EndDateTxt;
@property (strong, nonatomic) IBOutlet UITextField *strtTimeTxt;
@property (strong, nonatomic) IBOutlet UITextField *endTimeTxt;
@property (strong, nonatomic) IBOutlet UILabel *startOptional;
@property (strong, nonatomic) IBOutlet UILabel *endOptional;
@property (strong, nonatomic) IBOutlet UILabel *startMnthLbl;
@property (strong, nonatomic) IBOutlet UILabel *endMnthLbl;
@property (strong, nonatomic) IBOutlet UILabel *strtDateLbl;

@property (strong, nonatomic) IBOutlet UILabel *endDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *startTmeLbl;

@property (strong, nonatomic) IBOutlet UILabel *endTimeLbl;

@end
