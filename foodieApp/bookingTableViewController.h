//
//  bookingTableViewController.h
//  foodieApp
//
//  Created by Bharat shankar on 23/05/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bookingTableViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UITextField *timeText;
@property (weak, nonatomic) IBOutlet UITextField *requestText;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIView *justView;

@property (weak, nonatomic) IBOutlet UIView *justView2;

@property UIDatePicker * datePicker;
@property UIDatePicker * datePicker1;

@property (weak, nonatomic) IBOutlet UIButton *minusButton;

@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIView *JustView3;
@property (strong, nonatomic) IBOutlet UIView *JustView4;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UILabel *peopleLabel;


@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;


@property (strong, nonatomic) IBOutlet UITextField *selectBookingDate;
@property (strong, nonatomic) IBOutlet UITextField *bookingTime;


@property NSString * partisipantCount;
@property NSString * eventDate;



@end
