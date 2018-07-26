//
//  OTPViewController.h
//  Zaggle
//
//  Created by  on 5/11/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPViewController : UIViewController
{
    IBOutlet UIButton *confirmOtpBtn,*resendOtpBtn,*enetrNewNumBtn;
    IBOutlet UITextField *otpTfld;
    IBOutlet UILabel *mobileNumberLbl;
}
@property (nonatomic ,retain) NSString *mobileNumberString,*classTypeStr;

-(IBAction)resendOtpBtnClicked:(id)sender;
-(IBAction)confirmOtpBtnClicked:(id)sender;
-(IBAction)enterNumberBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *otp1;
@property (strong, nonatomic) IBOutlet UITextField *otp2;
@property (strong, nonatomic) IBOutlet UITextField *otp3;
@property (strong, nonatomic) IBOutlet UITextField *otp4;

@end
