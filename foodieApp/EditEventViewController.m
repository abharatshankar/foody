//
//  EditEventViewController.m
//  foodieApp
//
//  Created by Prasad on 12/03/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "EditEventViewController.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "EditEve_DateNTimeViewController.h"
#import "EditEve_DescViewController.h"
#import "MyTableViewController.h"
#import "SingleTon.h"
#import "PlaceAnnotation.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSVBarController.h"

@interface EditEventViewController ()
{
    NSString * PreviewStr, * paymentSwitchStr, * voteswitchStr, * inviteswitchStr,* imageName;
    SingleTon *  singleTonInstance;
    NSMutableDictionary *requestDict,* imageDataDict;
    BOOL * isDateAvailable;
}

@end

@implementation EditEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ScrollView.delegate = self;
    
    
   singleTonInstance=[SingleTon singleTonMethod];
    
    imageDataDict = [[NSMutableDictionary alloc] init];
    
    NSLog(@"for event data to edit is %@",self.editEventDict);
    
    if (self.editEventDict.count>0) {
        
        isDateAvailable = YES;
    }
    
    self.closebtn1.hidden = YES;
    self.closebtn2.hidden = YES;
    self.closebtn3.hidden = YES;
    self.closebtn4.hidden = YES;
    
    self.datentimeView.hidden = YES;
    self.mapview.hidden = YES;
    self.descrpview.hidden = YES;
    
    self.eventNameTxtField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.eventNameTxtField.layer.borderWidth = 0.5;
    
    
    // by default these start and end dates are hidden
    self.startDateDay.hidden = NO;
    self.startDateMonth.hidden = NO;
    
    self.endDateDay.hidden = NO;
    self.endDateMonth.hidden = NO;
    
    
    
        NSLog(@"image url is %@",self.imgUrl);
    //    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:@""];
    self.imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrl]]];
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnLib1 setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
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
//    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    menuButton.frame = CGRectMake(275, 5, 28, 25);
//    [menuButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    menuButton.showsTouchWhenHighlighted=YES;
//    
//    
//    //--right buttons--//
//    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
//    btntitle.frame = CGRectMake(30, 0, 120, 30);
//    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    btntitle.showsTouchWhenHighlighted=YES;
//    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
//    [arrLeftBarItems addObject:barButtonItem3];
//    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [btntitle setTitle:@"Notifications" forState:UIControlStateNormal];
//    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // [btnh addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 70, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    phoneBarItem.action = @selector(phoneAction);
    [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [phoneButton setTitle:@"Confirm" forState:UIControlStateNormal];
    //[phoneButton setImage:[UIImage imageNamed:@"invite_icon.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    self.title = @"Edit Event";
    
    self.eventNameViw.frame = CGRectMake(self.eventNameViw.frame.origin.x, self.imgView.frame.size.height+self.imgView.frame.origin.y+10, self.eventNameViw.frame.size.width, self.eventNameViw.frame.size.height);
    
    self.eventNameTxtField.frame = CGRectMake(self.eventNameTxtField.frame.origin.x, self.eventNameViw.frame.origin.y+self.eventNameViw.frame.size.height, self.eventNameTxtField.frame.size.width, self.eventNameTxtField.frame.size.height);
    
    self.dateNtime.frame = CGRectMake(self.dateNtime.frame.origin.x, self.eventNameTxtField.frame.origin.y+self.eventNameTxtField.frame.size.height+10, self.dateNtime.frame.size.width, self.dateNtime.frame.size.height);
    
    self.AddLocatn.frame = CGRectMake(self.AddLocatn.frame.origin.x, self.dateNtime.frame.origin.y+self.dateNtime.frame.size.height+10, self.AddLocatn.frame.size.width, self.AddLocatn.frame.size.height);
    
    self.AddEventDes.frame = CGRectMake(self.AddEventDes.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height+10 , self.AddEventDes.frame.size.width, self.AddEventDes.frame.size.height);
    
    self.eventOptionsView.frame = CGRectMake(self.eventOptionsView.frame.origin.x, self.AddEventDes.frame.origin.y+self.AddEventDes.frame.size.height+10, self.eventOptionsView.frame.size.width, self.eventOptionsView.frame.size.height);
    
//    self.inviteFrndsViw.frame = CGRectMake(self.inviteFrndsViw.frame.origin.x, self.eventoptnslbl.frame.origin.y+self.eventoptnslbl.frame.size.height+10, self.inviteFrndsViw.frame.size.width, self.inviteFrndsViw.frame.size.height);
//
//    self.createVotes.frame = CGRectMake(self.createVotes.frame.origin.x, self.inviteFrndsViw.frame.origin.y+self.inviteFrndsViw.frame.size.height, self.inviteFrndsViw.frame.size.width, self.inviteFrndsViw.frame.size.height);
//
    
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in  _ScrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.ScrollView.contentSize = CGSizeMake(0,contentRect.size.height) ;
    
    self.eventNameViw.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.eventNameViw.layer.borderWidth = 0.5;
    
    self.dateNtime.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.dateNtime.layer.borderWidth = 0.5;
    
    self.AddLocatn.layer.borderColor  =[UIColor lightGrayColor].CGColor;
    
    self.AddLocatn.layer.borderWidth = 0.5;
    
    self.AddEventDes.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    self.AddEventDes.layer.borderWidth = 0.5;
    
    self.eventoptnslbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.eventoptnslbl.layer.borderWidth = 0.5;
    
    self.eventNameTxtField.text = [Utilities null_ValidationString:singleTonInstance.eventNameSt];
    
    
    
    
    
    
    
    if (singleTonInstance.startDateStr)
    {
        ////////////////////////
        // bring month name from date (yyyy/MM/dd ) And day number
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *date = [dateFormat dateFromString:singleTonInstance.startDateStr];
        [dateFormat setDateFormat:@"MMMM"];
        NSString* temp = [dateFormat stringFromDate:date];
        NSLog(@"month is %@",temp);
        self.startDateMonth.text = temp;
        
        
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
        NSDate *date1 = [dateFormat1 dateFromString:singleTonInstance.startDateStr];
        [dateFormat1 setDateFormat:@"dd"];
        NSString* temp1 = [dateFormat1 stringFromDate:date1];
        NSLog(@"Day is %@",temp1);
        self.startDateDay.text = temp1;
        
        
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        [dateFormat2 setDateFormat:@"hh:mm a"];
        NSDate *date2 = [dateFormat2 dateFromString:singleTonInstance.showTimeStr];
        [dateFormat2 setDateFormat:@"hh:mm a"];
        NSString* temp2 = [dateFormat2 stringFromDate:date2];
        
        self.startDateTime.text = temp2;
        
        
        //////////////////////////////
        
        
        self.startDateDay.hidden = NO;
        self.startDateMonth.hidden = NO;
        self.startDateTime.hidden = NO;
        
        self.datentimeView.hidden = NO;
        
        
        self.datentimeView.frame = CGRectMake(self.datentimeView.frame.origin.x, self.dateNtime.frame.origin.y+self.dateNtime.frame.size.height, self.datentimeView.frame.size.width, self.datentimeView.frame.size.height);
        
        self.closebtn2.frame = CGRectMake(self.closebtn2.frame.origin.x, self.datentimeView.frame.origin.y+2, self.closebtn2.frame.size.width, self.closebtn2.frame.size.height);
        
        self.AddLocatn.frame = CGRectMake(self.AddLocatn.frame.origin.x, self.datentimeView.frame.origin.y+self.datentimeView.frame.size.height+10, self.AddLocatn.frame.size.width, self.AddLocatn.frame.size.height);
        
        self.AddEventDes.frame = CGRectMake(self.AddEventDes.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height+10 , self.AddEventDes.frame.size.width, self.AddEventDes.frame.size.height);
        
        self.eventOptionsView.frame = CGRectMake(self.eventOptionsView.frame.origin.x, self.AddEventDes.frame.origin.y+self.AddEventDes.frame.size.height+10, self.eventOptionsView.frame.size.width, self.eventOptionsView.frame.size.height);
        
    }
    
    
    
    
    
    
    
    
    
    
    //self.AddLocatn.frame = CGRectMake(self.view.frame.origin.x,self.dateNtime.frame.origin.y+5,self.view.frame.size.height, self.view.frame.size.width);
   
}


-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    
    self.startDateMonth.adjustsFontSizeToFitWidth = YES;
    
    self.endDateMonth.adjustsFontSizeToFitWidth = YES;
    
    if (singleTonInstance.isDateAvailable == YES || isDateAvailable == YES) {
        
        if (singleTonInstance.editedEventStartDate.length || singleTonInstance.editedEventEndDate.length)
        {
            
            NSLog(@"edited dates are %@",singleTonInstance.editedEventStartDate);
            
            self.datentimeView.hidden = NO;
            
            self.closebtn2.hidden = NO;
            
            
            
            if (singleTonInstance.editedEventStartDate.length) {
                self.startDateDay.hidden = NO;
                self.startDateMonth.hidden = NO;
            }
            else
            {
                self.startDateDay.hidden = YES;
                self.startDateMonth.hidden =YES;
            }
            
            
            if (singleTonInstance.editedEventEndDate.length) {
                self.endDateMonth.hidden = NO;
                self.endDateDay.hidden = NO;
            }
            else
            {
                self.endDateDay.hidden = YES;
                self.endDateMonth.hidden = YES;
            }
            
            
            
            self.datentimeView.frame = CGRectMake(self.datentimeView.frame.origin.x, self.dateNtime.frame.origin.y+self.dateNtime.frame.size.height, self.datentimeView.frame.size.width, self.datentimeView.frame.size.height);
            
            self.closebtn2.frame = CGRectMake(self.closebtn2.frame.origin.x, self.datentimeView.frame.origin.y+2, self.closebtn2.frame.size.width, self.closebtn2.frame.size.height);
            
            self.AddLocatn.frame = CGRectMake(self.AddLocatn.frame.origin.x, self.datentimeView.frame.origin.y+self.datentimeView.frame.size.height+10, self.AddLocatn.frame.size.width, self.AddLocatn.frame.size.height);
            
            self.AddEventDes.frame = CGRectMake(self.AddEventDes.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height+10 , self.AddEventDes.frame.size.width, self.AddEventDes.frame.size.height);
            
            self.eventOptionsView.frame = CGRectMake(self.eventOptionsView.frame.origin.x, self.AddEventDes.frame.origin.y+self.AddEventDes.frame.size.height+10, self.eventOptionsView.frame.size.width, self.eventOptionsView.frame.size.height);
            
            //        self.inviteFrndsViw.frame = CGRectMake(self.inviteFrndsViw.frame.origin.x, self.eventoptnslbl.frame.origin.y+self.eventoptnslbl.frame.size.height, self.inviteFrndsViw.frame.size.width, self.inviteFrndsViw.frame.size.height);
            //
            //        self.createVotes.frame = CGRectMake(self.createVotes.frame.origin.x, self.inviteFrndsViw.frame.origin.y+self.inviteFrndsViw.frame.size.height, self.inviteFrndsViw.frame.size.width, self.inviteFrndsViw.frame.size.height);
            
            NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
            [dateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
            NSDate *date1 = [dateFormat1 dateFromString:singleTonInstance.editedEventStartDate];
            [dateFormat1 setDateFormat:@"dd"];
            NSString* temp1 = [dateFormat1 stringFromDate:date1];
            NSLog(@"Day is %@",temp1);
            self.startDateDay.text = temp1;
            
            self.startDateDay.layer.borderColor = [UIColor lightGrayColor].CGColor;
            self.startDateDay.layer.borderWidth = 0.5;
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEE MMM dd yyyy"];
            NSDate *date = [dateFormat dateFromString:singleTonInstance.editedEventStartDate];
            [dateFormat setDateFormat:@"MMMM"];
            NSString* temp = [dateFormat stringFromDate:date];
            NSLog(@"month is %@",temp);
            self.startDateMonth.text = temp;
            self.startDateDay.hidden = NO;
            self.startDateMonth.hidden = NO;
            
            self.startDateTime.text = [Utilities null_ValidationString:singleTonInstance.editedEventStartTime] ;
            
            
            if (singleTonInstance.editedEventEndDate.length)
            {
                ////////////////////////
                // bring month name from date (yyyy/MM/dd ) And day number
                NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
                [endDateFormat setDateFormat:@"EEE MMM dd yyyy"];
                NSDate *date = [endDateFormat dateFromString:singleTonInstance.editedEventEndDate];
                [endDateFormat setDateFormat:@"MMMM"];
                NSString* endTemp = [endDateFormat stringFromDate:date];
                NSLog(@"month is %@",endTemp);
                
                self.endDateMonth.text = endTemp;
                
                
                NSDateFormatter *endDateFormat1 = [[NSDateFormatter alloc] init];
                [endDateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
                NSDate *endDate1 = [endDateFormat1 dateFromString:singleTonInstance.editedEventEndDate];
                [endDateFormat1 setDateFormat:@"dd"];
                NSString* endTemp1 = [endDateFormat1 stringFromDate:endDate1];
                
                self.endDateDay.text = endTemp1;
                
                self.endDateDay.layer.borderColor = [UIColor lightGrayColor].CGColor;
                self.endDateDay.layer.borderWidth = 0.5;
                self.endDateDay.hidden = NO;
                self.endDateMonth.hidden = NO;
                self.endDateTime.text = [Utilities null_ValidationString:singleTonInstance.editedEventEndTime];
            }
            
            
            
        }
        else
        {
            self.datentimeView.hidden = YES;
            
            self.AddLocatn.frame= CGRectMake(self.AddLocatn.frame.origin.x, self.dateNtime.frame.origin.y+self.dateNtime.frame.size.height+4, self.AddLocatn.frame.size.width,  self.AddLocatn.frame.size.height);
            
            
            
        }
        
    }
    
    
    if (singleTonInstance.mapItemListForEditPage) {
        
        NSLog(@"map selected location is %@",singleTonInstance.mapItemListForEditPage);
        
        self.locaationNameLbl.text = [Utilities null_ValidationString:singleTonInstance.areaNameForEditEvent];
        
        NSLog(@"map selected location is %@",self.locaationNameLbl.text);
        
        self.mapview.hidden = NO;
        
        self.closebtn3.hidden = YES;
        
        self.mapview.frame = CGRectMake(self.mapview.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height, self.mapview.frame.size.width, self.mapview.frame.size.height);
        
        self.AddEventDes.frame = CGRectMake(self.AddEventDes.frame.origin.x, self.mapview.frame.origin.y+self.mapview.frame.size.height+10, self.AddEventDes.frame.size.width, self.AddEventDes.frame.size.height);
        
        self.eventOptionsView.frame = CGRectMake(self.eventOptionsView.frame.origin.x, self.AddEventDes.frame.origin.y+self.AddEventDes.frame.size.height+10, self.eventOptionsView.frame.size.width, self.eventOptionsView.frame.size.height);
        
//        self.inviteFrndsViw.frame = CGRectMake(self.inviteFrndsViw.frame.origin.x, self.eventoptnslbl.frame.origin.y+self.eventoptnslbl.frame.size.height, self.inviteFrndsViw.frame.size.width, self.inviteFrndsViw.frame.size.height);
//
//        self.createVotes.frame = CGRectMake(self.createVotes.frame.origin.x, self.inviteFrndsViw.frame.origin.y+self.inviteFrndsViw.frame.size.height, self.inviteFrndsViw.frame.size.width, self.inviteFrndsViw.frame.size.height);
        
        
        
    }
    else
    {
        self.mapview.hidden = YES;
        self.AddEventDes.frame = CGRectMake(self.AddEventDes.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height+4, self.AddEventDes.frame.size.width, self.AddEventDes.frame.size.height);
        self.eventOptionsView.frame = CGRectMake(self.eventOptionsView.frame.origin.x, self.AddEventDes.frame.origin.y+self.AddEventDes.frame.size.height+10, self.eventOptionsView.frame.size.width, self.eventOptionsView.frame.size.height);
        //self.inviteFrndsViw.frame = CGRectMake(self.inviteFrndsViw.frame.origin.x, self.eventoptnslbl.frame.origin.y+self.eventoptnslbl.frame.size.height+2, self.inviteFrndsViw.frame.size.width, self.inviteFrndsViw.frame.size.height);
    }
    
    if (singleTonInstance.editedEventDescription.length)
    {
        self.descrpview.hidden = NO;
        
        self.descriptionLbl.text=[Utilities null_ValidationString:singleTonInstance.editedEventDescription];
        [self.descriptionLbl sizeToFit];
        
        self.descriptionLbl.frame = CGRectMake(self.descriptionLbl.frame.origin.x, self.descriptionLbl.frame.origin.y, self.descriptionLbl.frame.size.width, self.descriptionLbl.frame.size.height+4);
        
        self.descrpview.frame = CGRectMake(self.descrpview.frame.origin.x, self.AddEventDes.frame.origin.y+self.AddEventDes.frame.size.height, self.descrpview.frame.size.width, self.descriptionLbl.frame.size.height+6);
        [self.descriptionLbl sizeToFit];
        self.eventOptionsView.frame = CGRectMake(self.eventoptnslbl.frame.origin.x, self.descrpview.frame.origin.y+self.descrpview.frame.size.height+4, self.eventOptionsView.frame.size.width, self.eventOptionsView.frame.size.height);
        
       // self.inviteFrndsViw.frame = CGRectMake(self.inviteFrndsViw.frame.origin.x, self.eventoptnslbl.frame.origin.y+self.eventoptnslbl.frame.size.height+2, self.inviteFrndsViw.frame.size.width, self.inviteFrndsViw.frame.size.height);
        
        CGRect contentRect = CGRectZero;
        for (UIView *view in  _ScrollView.subviews) {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        
         self.ScrollView.contentSize = CGSizeMake(0,contentRect.size.height+self.descriptionLbl.frame.size.height) ;
        
        
    }
    else
    {
        self.descrpview.hidden = YES;
        
        if (singleTonInstance.mapItemListForEditPage) {
            self.mapview.hidden = NO;
            self.AddEventDes.frame = CGRectMake(self.AddEventDes.frame.origin.x, self.mapview.frame.origin.y+self.mapview.frame.size.height+4, self.AddEventDes.frame.size.width, self.AddEventDes.frame.size.height);
           
            self.eventOptionsView.frame = CGRectMake(self.eventOptionsView.frame.origin.x, self.AddEventDes.frame.origin.y+self.AddEventDes.frame.size.height+10, self.eventOptionsView.frame.size.width, self.eventOptionsView.frame.size.height);
            
        }
        else{
            
            self.mapview.hidden = YES;
            
            self.AddEventDes.frame = CGRectMake(self.AddEventDes.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height+4, self.AddEventDes.frame.size.width, self.AddEventDes.frame.size.height);
            
            self.eventOptionsView.frame = CGRectMake(self.eventOptionsView.frame.origin.x, self.AddEventDes.frame.origin.y+self.AddEventDes.frame.size.height+20, self.eventOptionsView.frame.size.width, self.eventOptionsView.frame.size.height);
            
        }
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)confirmAction
{
    [self AcceptOrRejectServiceCall];
}

-(void)Back_Click
{
    

    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)PreviewswitchBtn:(id)sender
{
    if (self.previewSwitch.isOn)
    {
        PreviewStr = @"1";
    }
    else
    {
        PreviewStr = @"0";
    }

}

- (IBAction)paymentSwitchBtn:(id)sender
{
    if (self.paymentSwitch.isOn)
    {
        paymentSwitchStr = @"1";
    }
    else
    {
        paymentSwitchStr = @"0";
    }

}

- (IBAction)voteSwitchBtn:(id)sender
{
    if (self.voteSwitch.isOn)
    {
        voteswitchStr = @"1";
    }
    else
    {
        voteswitchStr = @"0";
    }

}



- (IBAction)inviteSwitchBtn:(id)sender
{
    if (self.inviteSwitch.isOn)
    {
        inviteswitchStr = @"1";
    }
    else
    {
        inviteswitchStr = @"0";
    }

    
}

- (IBAction)DatenTimeBtn:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditEve_DateNTimeViewController *event = [storyboard instantiateViewControllerWithIdentifier:@"EditEve_DateNTimeViewController"];
    [self.navigationController pushViewController:event animated:YES];
    });

}

- (IBAction)LocatnBtn:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyTableViewController *event = [storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController"];
    event.fromEditEventPage = @"editPage";
    [self.navigationController pushViewController:event animated:YES];
    });

}

- (IBAction)EventDesBtn:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditEve_DescViewController *event = [storyboard instantiateViewControllerWithIdentifier:@"EditEve_DescViewController"];
    [self.navigationController pushViewController:event animated:YES];
    });

}

- (IBAction)clearDatesBtn:(id)sender {
    singleTonInstance.editedEventEndDate = nil;
    singleTonInstance.editedEventStartDate = nil;
    singleTonInstance.editedEventEndDateToServer = nil;
    singleTonInstance.editedEventEndTimeToServer = nil;
    singleTonInstance.editedEventStartTimeToServer = nil;
    singleTonInstance.editedEventStartDateToServer = nil;
    self.datentimeView.hidden = YES;
    self.AddLocatn.frame = CGRectMake(self.AddLocatn.frame.origin.x, self.dateNtime.frame.origin.y+self.dateNtime.frame.size.height+4, self.AddLocatn.frame.size.width, self.AddLocatn.frame.size.height);
    
    if (singleTonInstance.addressToServer.length)
    {
        self.mapview.hidden = YES;
        
        self.mapview.frame = CGRectMake(self.mapview.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height, self.mapview.frame.size.width, self.mapview.frame.size.height);
        
        self.AddEventDes.frame = CGRectMake(self.AddEventDes.frame.origin.x, self.mapview.frame.origin.y+self.mapview.frame.size.height+4, self.AddEventDes.frame.size.width, self.AddEventDes.frame.size.height);
    }
    
    if (singleTonInstance.mapItemListForEditPage) {
        
        self.mapview.hidden = NO;
        
        self.mapview.frame = CGRectMake(self.mapview.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height, self.mapview.frame.size.width, self.mapview.frame.size.height);
    
        
    }
    else
    {
        
        self.mapview.hidden = YES;
        
        self.mapview.frame = CGRectMake(self.mapview.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height, self.mapview.frame.size.width, self.mapview.frame.size.height);
        
        self.AddEventDes.frame = CGRectMake(self.AddEventDes.frame.origin.x, self.AddLocatn.frame.origin.y+self.AddLocatn.frame.size.height+4, self.AddEventDes.frame.size.width, self.AddEventDes.frame.size.height);
    }
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



-(NSData *)returnCompressedImageData :(UIImage *)image
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    // int maxFileSize = 320*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while (compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}


- (IBAction)changeImage:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // take photo button tapped.
        
        [self takePhoto];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose photo from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // choose photo button tapped.
        [self choosePhoto];
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
}





/////////////// TAKING PHOTO FROM CAMERA ////////////////////

-(void)takePhoto{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        
    }
    else
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
    
}

////////////////// CHOOSE PHOTO FROM GALLERY//////////////

-(void)choosePhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
/////////// FUNCTION FOR PICK IMAGE /////////////////

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    //  singleTonInstance.profilePicData = UIImagePNGRepresentation(chosenImage);
    
    
    
    self.imgView.image = chosenImage;
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.9);
    
    singleTonInstance.editEventImgData = imageData;
    
    
    //    UIGraphicsBeginImageContextWithOptions(self.profileImageView.bounds.size, NO, 1.0);
    //    // Add a clip before drawing anything, in the shape of an rounded rect
    //    [[UIBezierPath bezierPathWithRoundedRect:self.profileImageView.bounds
    //                                cornerRadius:50.0] addClip];
    //    // Draw your image
    //    [chosenImage drawInRect:self.profileImageView.bounds];
    //
    //    // Get the image, here setting the UIImageView image
    //    self.profileImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //    self.profileImageView.backgroundColor = [UIColor darkGrayColor];
    //
    //    // Lets forget about that we were drawing
    //    UIGraphicsEndImageContext();
    
    
    
    [self updateCoverPic];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



# pragma mark - Webservice Delegates










-(void)updateCoverPic

{
    
    @try {
        
        NSString *hexStr3 = @"#ca1d31";
        
        UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:1];
        
        //        activityIndicatorView  = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallPulse tintColor:color1];
        //
        //
        //        activityIndicatorView.frame = self.view.frame ;
        //        [self.view addSubview:activityIndicatorView];
        //        [activityIndicatorView startAnimating];
        [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        
        requestDict = @{
                        
                        @"user_id":[Utilities getUserID], /*totalBubblesArray*/
                        };
        [imageDataDict setValue:[self returnCompressedImageData:self.imgView.image] forKey:@"image"];
        [imageDataDict setValue:[Utilities getUserID] forKey:@"user_id"];
        NSString  *urlStr = [NSString stringWithFormat:@"%@eventImage",BASEURL];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *fileName1 = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // BASIC AUTH (if you need):
            manager.securityPolicy.allowInvalidCertificates = YES;
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"foo" password:@"bar"];
            
            [manager POST:urlStr parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if ([imageDataDict valueForKey:@"image"]!= nil) {
                    [formData appendPartWithFileData:[imageDataDict valueForKey:@"image"] name:@"image" fileName:fileName1 mimeType:@"image/jpeg"];
                }
                //                if ([imageDataDict valueForKey:@"cover_photo"]!= nil) {
                //                    [formData appendPartWithFileData:[imageDataDict valueForKey:@"cover_photo"] name:@"cover_photo" fileName:fileName1 mimeType:@"image/jpeg"];
                //                }
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //[ activityIndicatorView stopAnimating];
                [Utilities removeLoading:self.view];
                
                
                NSDictionary *response = (NSDictionary *)responseObject;
                NSUInteger status = [[response valueForKey:@"status"] integerValue];
                NSString *resultMessage = [response valueForKey:@"result"];
                
                singleTonInstance.editEventUploadedImageName = [response valueForKey:@"image"];
                
                imageName = [response valueForKey:@"image"];
                //                if(status == 30 )
                //                {
                //                    [APPDELEGATE showAlertBlockOrAuthenticationCheck:resultMessage];
                //                }
                //
                //                else if(status == 32)
                //                {
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                //                        [APPDELEGATE showAlertBlockOrAuthenticationCheck:resultMessage];
                //
                //                    });
                //                    return;
                //                }
                
                if ([[response valueForKey:@"status"] integerValue] == 1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[ activityIndicatorView stopAnimating];
                        [Utilities removeLoading:self.navigationController.view];
                        NSString *billIdStrVAl = [response valueForKey:@"billuploadid"];
                        //@"sucessssssss.....");
                        
                        [Utilities displayToastWithMessage:@"Image added successfully"];
                        
                        
                        
                        
                    });
                    
                    
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[ activityIndicatorView stopAnimating];
                        [Utilities removeLoading:self.navigationController.view];
                    });
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[ activityIndicatorView stopAnimating];
                        [Utilities removeLoading:self.view];
                        
                        NSLog(@"alert from here");
                        //                        CustomAlertView *alert = [[CustomAlertView alloc]initWithAlertType:ImageWithSingleButtonType andMessage:[response valueForKey:@"result"] andImageName:AlertVpanicImage andCancelTitle:nil andOtherTitle:@"OK" andDisplayOn:self.view];
                        //                        alert.delegate =self;
                        //                        [self.view addSubview:alert];
                        [Utilities displayCustemAlertView:[response valueForKey:@"result"] :self.view];
                        //[self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 //@"Failure.....");
                 //@"Failure %@, %@", error, operation.responseString);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[ activityIndicatorView stopAnimating];
                     [Utilities removeLoading:self.navigationController.view];
                     
                 });
                 
                 
             }];
            
        });
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
    }
    
}






-(void)AcceptOrRejectServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *hexStr3 = @"#6dbdba";
            //UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:.9];
            
            //            activityIndicatorView  = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallPulse tintColor:color1];
            //
            //
            //            activityIndicatorView.frame = self.view.frame ;
            //            [self.view addSubview:activityIndicatorView];
            //            [activityIndicatorView startAnimating];
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        
        NSDictionary * requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@updateEvent",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"event_name":[Utilities null_ValidationString:singleTonInstance.eventNameSt],
                        @"event_id":[Utilities null_ValidationString:singleTonInstance.eventIdStr],
                        @"start_date":[Utilities null_ValidationString:singleTonInstance.editedEventStartDateToServer],
                        @"end_date":[Utilities null_ValidationString:singleTonInstance.editedEventEndDateToServer],
                        @"end_time":@"",
                        @"start_time":@"",
                        @"location":[Utilities null_ValidationString:singleTonInstance.addressToServerForEditPage],
                        @"description":[Utilities null_ValidationString:singleTonInstance.editedEventDescription],
                        @"image":[Utilities null_ValidationString:imageName]
                        
                        
                        
                        };
        
        
        
        
        
        NSMutableDictionary * dictToSend = [[NSMutableDictionary alloc]init];
        
        
        [dictToSend setObject:[Utilities getUserID] forKey:@"user_id"];
        
        [dictToSend setObject:[Utilities null_ValidationString:singleTonInstance.eventNameSt] forKey:@"event_name"];
        
        //[dictToSend setObject:[Utilities null_ValidationString:inviteString] forKey:@"invite_friends"];
        
        //[dictToSend setObject:[Utilities null_ValidationString:votesString] forKey:@"votes"];
        
        //[dictToSend setObject:[Utilities null_ValidationString:preferencesString] forKey:@"preferences"];
        
        
//        if (jsonString.length) {
//            [dictToSend setObject:jsonString forKey:@"event_members"];
//        }
        if (singleTonInstance.startDateToServer.length) {
            
            [dictToSend setObject:singleTonInstance.editedEventStartDateToServer forKey:@"start_date"];
        }
        if (singleTonInstance.startTimeToServer.length) {
            
            [dictToSend setObject:singleTonInstance.startTimeToServer forKey:@"start_time"];
        }
        if (singleTonInstance.endDateToServer.length) {
            
            [dictToSend setObject:singleTonInstance.editedEventEndDateToServer forKey:@"end_date"];
        }
        if (singleTonInstance.endTimeToServer.length) {
            
            [dictToSend setObject:singleTonInstance.endTimeToServer forKey:@"end_time"];
        }
        if (singleTonInstance.descriptionStr.length) {
            
            [dictToSend setObject:singleTonInstance.editedEventDescription forKey:@"description"];
        }
        
        
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
    
    NSLog(@"responseInfo updateEvent:%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NSVBarController *invite = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
            
            NSArray *array = [self.navigationController viewControllers];
            
            [invite setSelectedIndex:2];
            
            // [self presentViewController:invite animated:YES completion:nil];
            
            
            
            [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];

        });
        
    }
    
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            [Utilities displayToastWithMessage:@"Please Enter Details"];
        });
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // [ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
    });
    
    
}

















@end
