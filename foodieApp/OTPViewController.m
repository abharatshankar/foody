//
//  OTPViewController.m
//  Zaggle
//
//  Created by  on 5/11/16.
//  Copyright © 2016 . All rights reserved.
//

#import "OTPViewController.h"
#import "Utilities.h"
//#import "ItemsScrollViewController.h"
#import "ServiceManager.h"
#import "Constants.h"
#import "LcnManager.h"
//#import "DashBoardViewController.h"
#import "ServiceInitiater.h"
#import "homeTabViewController.h"
#import "SingleTon.h"

@interface OTPViewController ()<ServiceHandlerDelegate>
{
    NSTimer *timer;
    IBOutlet UILabel *progress;
    NSInteger currMinute,currSeconds;
    SingleTon *singleTonInstance;
    
}
@end

@implementation OTPViewController
@synthesize mobileNumberString,classTypeStr;
- (void)viewDidLoad {
    [super viewDidLoad];
    
     singleTonInstance = [SingleTon singleTonMethod];
    
      [USERDEFAULTS removeObjectForKey:@"ResendBtnClicked"];
    [Utilities setBorderBtn:confirmOtpBtn :2.0:WHITECOLOR];
    [Utilities setBorderBtn:resendOtpBtn :2.0:WHITECOLOR];
    mobileNumberLbl.text = mobileNumberString;
    resendOtpBtn.alpha = 0.2;
    resendOtpBtn.userInteractionEnabled = NO;
    // Do any additional setup after loading the view.
    progress.hidden = NO;

    [progress setText:@"You can resend OTP in 60 seconds"];
       currMinute=1;
    currSeconds=0;
    [self start];
    
    self.otp1.delegate = self;
    self.otp2.delegate = self;
    self.otp3.delegate = self;
    self.otp4.delegate = self;
    
    self.otp1.layer.cornerRadius = 3;
    self.otp1.layer.borderWidth = 1;
    self.otp1.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.otp2.layer.cornerRadius = 3;
    self.otp2.layer.borderWidth = 1;
    self.otp2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.otp3.layer.cornerRadius = 3;
    self.otp3.layer.borderWidth = 1;
    self.otp3.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.otp4.layer.cornerRadius = 3;
    self.otp4.layer.borderWidth = 1;
    self.otp4.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)resendOtpBtnClicked:(id)sender
{
    resendOtpBtn.alpha = 0.2;
    resendOtpBtn.userInteractionEnabled = NO;
    currMinute=1;
    currSeconds=0;
    [self start];
    progress.hidden = NO;
  
    
    if ([Utilities isInternetConnectionExists]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        [USERDEFAULTS setValue:@"Yes" forKey:@"ResendBtnClicked"];
        NSString *urlStr = [NSString stringWithFormat:@"%@resendOTP",BASEURL];
        
        
        NSDictionary *requestDict = @{
                                      @"mobilenumber":mobileNumberString
                                      };
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            [service handleRequestWithDelegates:urlStr info:requestDict];
        });
    }
    else{
        [Utilities displayCustemAlertView:@"Please check your internet connection" :self.view];
        
    }
}
-(IBAction)confirmOtpBtnClicked:(id)sender
{

     [self.view endEditing:YES];
    if (self.otp1.text.length==0 || self.otp2.text.length==0 || self.otp3.text.length==0 || self.otp4.text.length==0 ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities displayCustemAlertView:OtpEmptyMsg :self.view];
        });
        
    }
    else
    {

      
        if ([Utilities isInternetConnectionExists]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            NSString *latitude = [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.longitude];
            NSString *urlStr;
            urlStr = [NSString stringWithFormat:@"%@verifyOtp",BASEURL];

            NSString *reffrealcode = [USERDEFAULTS valueForKey:@"RefferalCode"];
            NSDictionary *requestDict;
            if(reffrealcode.length>0)
            {
                requestDict = @{
                                              @"mobilenumber":mobileNumberString,
                                              @"otp_code":@"1111"/*otpTfld.text*/,
                                              @"latitude":latitude,
                                              @"longitude":longitude,
                                              @"device_type":@"ios",
                                              @"device_token":[USERDEFAULTS valueForKey:@"devicetoken"],@"ref_code":reffrealcode};
            }
            else
            {
            requestDict = @{
                                              @"mobilenumber":mobileNumberString,
                                              @"otp":@"1111"/*otpTfld.text,*/
                                              //@"latitude":latitude,
                                             // @"longitude":longitude,
                                             // @"device_type":@"ios",
                                             // @"device_token":[USERDEFAULTS valueForKey:@"devicetoken"]
                                              };
            }
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ServiceManager *service = [ServiceManager sharedInstance];
                service.delegate = self;
                [service handleRequestWithDelegates:urlStr info:requestDict];
            });
            
        }
        else{
            [Utilities displayCustemAlertView:@"Please check your internet connection" :self.view];
            
        }
        
    }
}

- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
}
- (void)failResponse:(NSError*)error
{
    //NSLog(@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
        [Utilities displayCustemAlertView:@"Failed to getting data" :self.view];
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    [USERDEFAULTS setObject:mobileNumberString forKey:@"mobileNumber"];

    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
    });
    NSUInteger status = [[responseInfo valueForKey:@"status"] integerValue];
    NSString *resultMessage = [responseInfo valueForKey:@"result"];
   
    
    if([[USERDEFAULTS valueForKey:@"ResendBtnClicked"]isEqualToString:@"Yes"])
    {
        [USERDEFAULTS removeObjectForKey:@"ResendBtnClicked"];
        if(status ==1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities displayCustemAlertView:@"OTP Sent Again Successfully" :self.view];
            });
            
        }
        else if(status == 2)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities displayCustemAlertView:resultMessage :self.view];
            });
            
        }
        else if(status == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities displayCustemAlertView:resultMessage :self.view];
            });
        }
   
    }
    else
    {
        if(status ==1)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            [USERDEFAULTS setBool:YES forKey:@"UserSignedIn"];
            
           
            
          //  if([classTypeStr isEqualToString:@"loginClass"])
          //  {

                dispatch_async(dispatch_get_main_queue(), ^{
//                    DashBoardViewController *dashboardVC = [storyboard instantiateViewControllerWithIdentifier:@"DashBoardVC"];
//                    UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:dashboardVC];
//                    [APPDELEGATE window].rootViewController   = rootNavigationController;
                    
                    BOOL  isBool  = [USERDEFAULTS objectForKey:@"invite_status"];
                    
                    homeTabViewController * home = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
                    
                    singleTonInstance.dixFromAnimation2Profile = [[NSMutableDictionary alloc]init];
                    
                    singleTonInstance.dixFromAnimation2Profile = responseInfo;
                    // [USERDEFAULTS setObject:responseInfo forKey:@"ResponseFromOtp"];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseInfo];
                    [USERDEFAULTS setObject:data forKey:@"ResponseFromOtp"];
                    
                     [Utilities SaveUserID:[[responseInfo valueForKey:@"data"] valueForKey:@"user_id"]];
                    
                    NSLog(@" saved user id is %@",[Utilities getUserID]);
                    
                    if (isBool == YES)
                    {
                        [home setSelectedIndex:2];
                        //[self.navigationController pushViewController:home animated:YES];
                        [self presentViewController:home animated:YES completion:nil];
                    }
                    else
                    {
                        [home setSelectedIndex:0];
                        //[self.navigationController pushViewController:home animated:YES];
                        [self presentViewController:home animated:YES completion:nil];
                        
                    }
                    
                    
                });
                
           // }
         //   else{
         //       [USERDEFAULTS setValue:[responseInfo valueForKey:@"auth_key"] forKey:@"authkey"];
         //       [USERDEFAULTS setValue:[responseInfo valueForKey:@"user_id"] forKey:@"userId"];
         //       [USERDEFAULTS setBool:YES forKey:@"SlideSeen"];
         //       dispatch_async(dispatch_get_main_queue(), ^{
//                    ItemsScrollViewController *sideBarVC = [storyboard instantiateViewControllerWithIdentifier:@"ScrollingItemsVC"];
//                    [self.navigationController pushViewController:sideBarVC animated:YES];
          //      });
                
         //   }
            
            
        }
    else if(status == 2)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities displayCustemAlertView:resultMessage :self.view];
        });

    }
    else if(status == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities displayCustemAlertView:resultMessage :self.view];
        });

    }
    }
    
}
-(IBAction)enterNumberBtnClicked:(id)sender
{
    [USERDEFAULTS setBool:YES forKey:@"EnterNewnumberClicked"];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            if(currSeconds == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resendOtpBtn.alpha = 1.0;
                    resendOtpBtn.userInteractionEnabled = YES;
                    progress.hidden = YES;
                });
                
 
            }
            progress.text =[NSString stringWithFormat:@"You can resend OTP in %2ld seconds" ,(long)currSeconds];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            resendOtpBtn.alpha = 1.0;
            resendOtpBtn.userInteractionEnabled = YES;
            progress.hidden = YES;
        });
       
       [timer invalidate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == otpTfld) {
        [self showDoneButtonOnNumberPad:textField];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    [backGroundScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
    return YES;
}

-(void)showDoneButtonOnNumberPad :(UITextField *)txtField
{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
    done.tintColor = [UIColor blackColor];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexibleSpace,done, nil]];
    txtField.inputAccessoryView = keyboardDoneButtonView;
    
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"Enter");
//    NSInteger oldLength = [textField.text length];
//    NSInteger newLength = oldLength + [string length] - range.length;
//    if(newLength >= 5){
//        return NO;
//    }
//    return YES;
//}
-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    
    if (textField == self.otp1)
    {
        if (self.otp1.text.length==1)
        {
            return YES;
        }
    }
    if (self.otp2.text.length==1)
    {
        return YES;
    }
    else
        return NO;
    
    if (self.otp3.text.length==1)
    {
        return YES;
    }
    else
        return NO;
    
    if (self.otp4.text.length==1)
    {
        return YES;
    }
    else
        return NO;
    
//    if (_text5.text.length==1)
//    {
//        isWrongOtp = YES;
//        return YES;
//    }
//    
//    if (_text6.text.length==1)
//    {
//        
//        return YES;
//    }
//    
//    else
//        return NO;
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField == otpTfld) {
//        [self showDoneButtonOnNumberPad:textField];
//    }
//    
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
    //    [self.text1 resignFirstResponder];
    //    [self.text2 resignFirstResponder];
    //    [self.text3 resignFirstResponder];
    //    [self.text4 resignFirstResponder];
    //    [self.text5 resignFirstResponder];
    //    [self.text6 resignFirstResponder];
//}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    if (![string isEqualToString:@""] ) {
    //        textField.text = string;
    //        if ([textField isEqual:self.text1]) {
    //            [self.text2 becomeFirstResponder];
    //        }else if ([textField isEqual:self.text2]){
    //            [self.text3 becomeFirstResponder];
    //        }else if ([textField isEqual:self.text3]){
    //            [self.text4 becomeFirstResponder];
    //        }else if ([textField isEqual:self.text4]){
    //            [self.text5 becomeFirstResponder];
    //        }else if ([textField isEqual:self.text5]){
    //            [self.text6 becomeFirstResponder];
    //        }
    //        else{
    //            [textField resignFirstResponder];
    //        }
    //        return NO;
    //    }
    //
    //
    //
    //
    //
    //    return YES;
    
    
    
    if (textField.text.length <= 1 && string.length != 0) {
        
        if (textField == self.otp1) {
            
            textField.text = string;
            
            [self.otp2 becomeFirstResponder];
            
            
        } else if (textField == self.otp2) {
            
            textField.text = string;
            
            [self.otp3 becomeFirstResponder];
            
        } else if (textField == self.otp3) {
            
            textField.text = string;
            
            [self.otp4 becomeFirstResponder];
            
        } else if (textField == self.otp4) {
            
            textField.text = string;
            
            
            [self.otp4 resignFirstResponder];
            
        }
        
    }
//     else if (string.length == 0 ) {
//        
//        
//        if (textField == self.text6) {
//            
//            textField.text = string;
//            
//            [self.text5 becomeFirstResponder];
//            
//            
//        } else if (textField == self.text5) {
//            
//            textField.text = string;
//            
//            [self.text4 becomeFirstResponder];
//            
//        } else if (textField == self.text4) {
//            
//            textField.text = string;
//            
//            [self.text3 becomeFirstResponder];
//            
//        }else if (textField == self.text3) {
//            
//            textField.text = string;
//            
//            [self.text2 becomeFirstResponder];
//            
//        }else if (textField == self.text2) {
//            
//            textField.text = string;
//            
//            [self.text1 becomeFirstResponder];
//            
//        }
//        else if (textField == self.text1) {
//            
//            textField.text = string;
//            
//            [self.text1 resignFirstResponder];
//            
//        }
//        
//    }
    
    
    
    
    return NO;
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (textField.text.length > 0) {
//        textField.text = @"";
//    }
//    return YES;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
