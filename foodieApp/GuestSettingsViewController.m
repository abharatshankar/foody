//
//  GuestSettingsViewController.m
//  foodieApp
//
//  Created by PossibillionTech on 2/1/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "GuestSettingsViewController.h"
#import "guestViewController.h"
#import "homeTabViewController.h"
#import "EventReadyPageController.h"
#import "SingleTon.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"

@interface GuestSettingsViewController ()
{

    SingleTon *  singleTonInstance;
    
    NSString * inviteString , *votesString, *preferencesString;

}
@end

@implementation GuestSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    singleTonInstance=[SingleTon singleTonMethod];

    if (singleTonInstance.eventImgData.length)
    {
        self.eventImage.image = [UIImage imageWithData:singleTonInstance.eventImgData] ;

    }
    
    
    
    
//    self.InviteFrndsLbl.layer.borderWidth = 0.5;
//    self.InviteFrndsLbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    
//    self.createVotesLbl.layer.borderWidth = 0.5;
//    self.createVotesLbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    
//    self.addPreferencesLbl.layer.borderWidth = 0.5;
//    self.addPreferencesLbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [Utilities addShadowtoView:self.inviteFndsViw];
    [Utilities addShadowtoView:self.createVotesViw];
    [Utilities addShadowtoView:self.addPreferencesViw];
    
    
    ////////////////////////
    // bring month name from date (yyyy/MM/dd ) And day number
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *date = [dateFormat dateFromString:singleTonInstance.startDateStr];
    [dateFormat setDateFormat:@"MMMM"];
    NSString* temp = [dateFormat stringFromDate:date];
    NSLog(@"month is %@",temp);
    self.startMonthLbl.text = temp;
    if (!singleTonInstance.startDateStr.length) {
        self.startMonthLbl.text = @"No date";
    }
    
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *date1 = [dateFormat1 dateFromString:singleTonInstance.startDateStr];
    [dateFormat1 setDateFormat:@"dd"];
    NSString* temp1 = [dateFormat1 stringFromDate:date1];
    NSLog(@"Day is %@",temp1);
    self.startDayLbl.text = temp1;
    
    self.startTimeLbl.text = [Utilities null_ValidationString:singleTonInstance.showTimeStr];
    
    
    //////////////////////////////
    

    
    
    
    
    
    
    
    
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
    
    
    //--right buttons--//
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(30, 0, 120, 30);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitle:@"Set Details" forState:UIControlStateNormal];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // [btnh addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////
    // bring month name from date (yyyy/MM/dd ) And day number
    NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
    [endDateFormat setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *endDate = [endDateFormat dateFromString:singleTonInstance.endDateStr];
    [endDateFormat setDateFormat:@"MMMM"];
    NSString* endTemp = [endDateFormat stringFromDate:endDate];
    NSLog(@"month is %@",endTemp);
    self.endMonthLbl.text = [Utilities null_ValidationString:endTemp];
    if (!singleTonInstance.endDateStr.length)
    {
        self.endMonthLbl.text = @"No Date";
    }
    
    
    NSDateFormatter *endDateFormat1 = [[NSDateFormatter alloc] init];
    [endDateFormat1 setDateFormat:@"EEE MMM dd yyyy"];
    NSDate *endDate1 = [endDateFormat1 dateFromString:singleTonInstance.endDateStr];
    [endDateFormat1 setDateFormat:@"dd"];
    NSString* endTemp1 = [endDateFormat1 stringFromDate:endDate1];
    
    self.endDateLbl.text = [Utilities null_ValidationString:endTemp1];
    
    self.endTimeLbl.text = [Utilities null_ValidationString:singleTonInstance.endTimeStr];
    

    
    //////////////////////////////

    
    
    
    
    
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Create"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(createButton)];
    
    [createButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

    
    self.navigationItem.rightBarButtonItem = createButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)createButton
{

    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self createEventServiceCall];
        
    });
    
}

- (IBAction)inviteFrndsSwitch:(id)sender {
    if (self.inviteSwitch.isOn)
    {
        inviteString = @"1";
    }
    else
    {
    inviteString = @"0";
    }
    
}
- (IBAction)votesSwitch:(id)sender {
    if (self.voteSwitch.isOn)
    {
        votesString = @"1";
    }
    else
    {
        votesString = @"0";
    }
}
- (IBAction)preferencesSwitch:(id)sender {
    
    if (self.preferenceSwitch.isOn)
    {
        preferencesString = @"1";
    }
    else
    {
        preferencesString = @"0";
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








# pragma mark - Webservice Delegates

-(void)createEventServiceCall
{
    [self.view endEditing:YES];
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *hexStr3 = @"#6dbdba";
            UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:.9];
            
            //            activityIndicatorView  = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallPulse tintColor:color1];
            //
            //
            //            activityIndicatorView.frame = self.view.frame ;
            //            [self.view addSubview:activityIndicatorView];
            //            [activityIndicatorView startAnimating];
            //[Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        NSError * error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:singleTonInstance.invitesSendArray options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (singleTonInstance.invitesSendArray.count<1) {
            jsonString = nil;
        }
        
        if (!inviteString.length) {
            inviteString = @"0";
        }
        
        if (!votesString.length) {
            votesString = @"0";
        }
        
        if (!preferencesString.length) {
            preferencesString = @"0";
        }
        
        NSDictionary * requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@createEvent",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"event_name":[Utilities null_ValidationString:singleTonInstance.eventNameSt],
                        @"event_members":[Utilities null_ValidationString:jsonString],
                        @"start_date":[Utilities null_ValidationString:singleTonInstance.startDateToServer],
                        @"start_time":[Utilities null_ValidationString:singleTonInstance.startTimeToServer],
                        @"end_date":[Utilities null_ValidationString:singleTonInstance.endDateToServer],
                        @"end_time":[Utilities null_ValidationString:singleTonInstance.endTimeToServer],
                        @"description":[Utilities null_ValidationString:singleTonInstance.descriptionStr],
                        @"location":[Utilities null_ValidationString:singleTonInstance.addressToServer],
                        @"image":[Utilities null_ValidationString:singleTonInstance.eventUploadedImageName],
                        @"invite_friends":[Utilities null_ValidationString:inviteString],
                        @"votes":[Utilities null_ValidationString:votesString],
                        @"preferences":[Utilities null_ValidationString:preferencesString]
                        
                        
                        };
        
        NSMutableDictionary * dictToSend = [[NSMutableDictionary alloc]init];

        
        [dictToSend setObject:[Utilities getUserID] forKey:@"user_id"];
        
        [dictToSend setObject:[Utilities null_ValidationString:singleTonInstance.eventNameSt] forKey:@"event_name"];
        
        [dictToSend setObject:[Utilities null_ValidationString:inviteString] forKey:@"invite_friends"];
        
        [dictToSend setObject:[Utilities null_ValidationString:votesString] forKey:@"votes"];
        
        [dictToSend setObject:[Utilities null_ValidationString:preferencesString] forKey:@"preferences"];
        
        [dictToSend setObject:[Utilities null_ValidationString:singleTonInstance.eventUploadedImageName] forKey:@"image"];
        
        if (jsonString.length) {
            [dictToSend setObject:jsonString forKey:@"event_members"];
        }
        if (singleTonInstance.startDateToServer.length) {
            
            [dictToSend setObject:singleTonInstance.startDateToServer forKey:@"start_date"];
        }
        if (singleTonInstance.startTimeToServer.length) {
            
            [dictToSend setObject:singleTonInstance.startTimeToServer forKey:@"start_time"];
        }
        if (singleTonInstance.endDateToServer.length) {
            
            [dictToSend setObject:singleTonInstance.endDateToServer forKey:@"end_date"];
        }
        if (singleTonInstance.endTimeToServer.length) {
            
            [dictToSend setObject:singleTonInstance.endTimeToServer forKey:@"end_time"];
        }
        if (singleTonInstance.descriptionStr.length) {
            
            [dictToSend setObject:singleTonInstance.descriptionStr forKey:@"description"];
        }
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:dictToSend];
            
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
    
    NSLog(@"responseInfo createEvent:%@",responseInfo);
    
    if([[responseInfo valueForKey:@"status"] intValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            EventReadyPageController * guestView =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EventReadyPageController"];
            
            guestView.eventIdStr = [responseInfo valueForKey:@"event_id"];
            
            [self.navigationController pushViewController:guestView animated:YES];
            
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
