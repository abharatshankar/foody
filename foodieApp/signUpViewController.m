//
//  signUpViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/8/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "signUpViewController.h"
#import "SMTKeyboardManager.h"
#import "loginViewController.h"
#import "Constants.h"
#import "OTPViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SingleTon.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "homeTabViewController.h"


#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 11

@interface signUpViewController ()<SMTKeyboardManagerDelegate, GIDSignInUIDelegate, GIDSignInDelegate>
{

    BOOL SHOWPSWD;
    IBOutlet UIImageView *pswdIconImage;
    NSString *imageUrlSocialMedia,*UserNameStr,*emailIdStr,*fbID;
    NSArray *pageImages;
    //IBOutlet UITextField *emailTextField,*PasswordTextField;
    NSMutableArray * imgArray;
    NSString *loginType;
    AppDelegate *appDelegate;
   // CLLocationManager *locationManager;
   // CLLocation *currentLocation;
    BOOL * isFbLogin;
    NSDictionary *facebookOrgoogleDict;
    SingleTon *singleTonInstance;
    CLLocationCoordinate2D coordinate;


}
@end

@implementation signUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utilities addShadowtoButton:self.signUpBtn];
    self.fbBtn.layer.borderWidth = 0.5;
    self.gmailBtn.layer.borderWidth = 0.5;

    
    self.mobileNumberTextField.delegate = self;
    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
    //this is to get curent location lat and long
    coordinate = [self getLocation];
    double  curLat;
    double  curLong;
    curLat = coordinate.latitude;
    curLong = coordinate.longitude;
    ////////////////
    
    
    // Do any additional setup after loading the view.
}



-(CLLocationCoordinate2D) getLocation{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    // [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signInPage:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    loginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:login];
    rootNavigationController.navigationBarHidden = YES;
    [APPDELEGATE window].rootViewController   = rootNavigationController;
}
- (IBAction)signUpAction:(id)sender {
    
    if (self.nameTextField.text.length<1) {
        [Utilities displayCustemAlertView:@"Please enter name" :self.view];
    }
    else if (self.mobileNumberTextField.text.length<1)
    {
    [Utilities displayCustemAlertView:@"Please enter Mobile Number" :self.view];
    }
    else if (self.PasswordTextfield.text.length<1)
    {
        [Utilities displayCustemAlertView:@"Please enter Password" :self.view];
    }
    else
    {
        
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        OTPViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"OTPViewController"];
//        UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:login];
//        rootNavigationController.navigationBarHidden = YES;
//        [APPDELEGATE window].rootViewController   = rootNavigationController;
    [self signUpServiceCall];
    }
    
    
    
    
}


- (IBAction)fbSigiupAction:(id)sender {
    
    
    @try {
        isFbLogin = YES;
        //if ([Utilities isInternetConnectionExists]) {
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        //        });
        
        //            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        /*********  logout the current session ************/
        FBSDKLoginManager *login1 = [[FBSDKLoginManager alloc] init];
        [login1 logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
        /*********  logout the current session ************/
        
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorNative;
        
        
        if (![UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://"]])
        {
            login.loginBehavior = FBSDKLoginBehaviorWeb;
        }
        
        
        [login
         logInWithReadPermissions: @[@"public_profile",@"email"]
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 //             //@"Process error");
                 dispatch_async(dispatch_get_main_queue(), ^{
                  //   [ activityIndicatorView stopAnimating];
                     
                     // [Utilities removeLoading:self.view];
                 });
             } else if (result.isCancelled) {
                 //             //@"Cancelled");
                 dispatch_async(dispatch_get_main_queue(), ^{
                  //   [ activityIndicatorView stopAnimating];
                     
                     //[Utilities removeLoading:self.view];
                 });
             } else {
                 //             //@"Logged in");
                 if ([FBSDKAccessToken currentAccessToken]) {
                     [USERDEFAULTS setBool:YES forKey:@"SocialCheck"];
                     [USERDEFAULTS setBool:YES forKey:@"FacebookCheck"];
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name, last_name, picture.type(large), email, name, id, gender"}]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id resultDict, NSError *error) {
                          if (!error) {
                              NSDictionary *userDict = (NSDictionary *)resultDict;
                              NSLog(@"fb user data %@",userDict);
                              [USERDEFAULTS setObject:[userDict valueForKey:@"first_name"] forKey:@"firstName"];
                              [USERDEFAULTS setObject:[userDict valueForKey:@"email"] forKey:@"emailId"];
                            //  [Utilities saveFBid:[userDict valueForKey:@"id"]];
                              
                              NSDictionary *pictureData = (NSDictionary *)[[userDict valueForKey:@"picture"] valueForKey:@"data"];
                              
                              imageUrlSocialMedia= [NSString stringWithFormat:@"%@",[pictureData valueForKey:@"url"]];
                            //  [Utilities saveUserProfilePic:imageUrlSocialMedia];
                           //   singleTonInstance.imageUrlStringFromFb = imageUrlSocialMedia;// this is to save image url to singleton class
                              
                              [USERDEFAULTS setBool:YES forKey:@"SocialCheck"];
                              NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                              
                              
                              [Utilities SaveUserID:[userDict objectForKey:@"user_id"]];
                              UserNameStr = [userDict objectForKey:@"name"];
                              emailIdStr = [userDict objectForKey:@"email"];
                              fbID = [userDict objectForKey:@"id"];
                              
                              NSLog(@"fbaccesstoken is %@",fbAccessToken);
                              //                              dispatch_async(dispatch_get_main_queue(), ^{
                              //                                  [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
                              //                              });
                              //                              NSDictionary *requestDict;
                              //                              NSString *urlStr = [NSString stringWithFormat:@"%@checksociallogins",BASEURL];
                              //                              requestDict = @{
                              //                                              @"socialid":[userDict valueForKey:@"id"],
                              //                                              @"type":@"facebook"
                              //                                              };
                              //
                              //                              [USERDEFAULTS setObject:[userDict valueForKey:@"id"] forKey:@"facebookid"];
                              //
                              //
                              //                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                              //                                  ServiceManager *service = [ServiceManager sharedInstance];
                              //                                  service.delegate = self;
                              //
                              //                                  [service  handleRequestWithDelegates:urlStr info:requestDict];
                              //
                              //                              });
                              if ([Utilities isInternetConnectionExists]) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      //color with hex values
                                      NSString *hexStr3 = @"#6dbdba";
                                      
//                                      UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:.9];
//                                      
//                                      activityIndicatorView  = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallPulse tintColor:color1];
//                                      
//                                      
//                                      activityIndicatorView.frame = self.view.frame ;
//                                      [self.view addSubview:activityIndicatorView];
//                                      [activityIndicatorView startAnimating];
                                      //[Utilities showLoading:self.view :BlueFontColorHex and:@"#ffffff"];
                                  });
                                  
                                  [USERDEFAULTS setBool:YES forKey:@"SocialCheck"];
                                  [USERDEFAULTS setBool:YES forKey:@"FacebookCheck"];
                                  
                                  NSDictionary *requestDict;
                                  NSString *urlStr = [NSString stringWithFormat:@"%@checksociallogins",BASEURL];
                                  requestDict = @{@"socialid":[Utilities null_ValidationString:[userDict valueForKey:@"id"]],
                                                  @"type":@"facebook"
                                                  };
                                  
                                  facebookOrgoogleDict = requestDict;
                                  [self checkSocialLoginServiceCall:urlStr and:requestDict];
                                  
                              }
                              else{
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"internet_connection_error"] :self.view];
                                      
                                  });
                              }
                              
                              
                          }
                      }];
                 }
             }
         }];
        
        
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally
    {
        
    }
    
    
    
    
    
}

















-(void)gmailSignupService
{
    
    
    
    
    
    NSDictionary *requestDict;
    NSString *urlStr = [NSString stringWithFormat:@"%@signup",BASEURL];
    
    requestDict = @{@"name":[Utilities null_ValidationString:UserNameStr],
                    @"mobilenumber":@"",
                    @"device_token":[Utilities getDeviceToken],
                    @"password":@"",
                    @"device_type":@"ios",
                    @"email":[Utilities null_ValidationString:emailIdStr],
                    @"type":@"google",
                    @"facebookid":@"",
                    @"twitterid":@"",
                    @"googleid":[Utilities null_ValidationString:fbID],
                    @"latitude":[NSString stringWithFormat:@"%f",coordinate.latitude],
                    @"longitude":[NSString stringWithFormat:@"%f",coordinate.longitude]
                    };
    
    
    
    if ([Utilities isInternetConnectionExists]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            [service  handleRegistration :urlStr info:requestDict andMethod:@"POST"];
            
        });
    }
    else{
        [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"internet_connection_error"] :self.view];
        
    }
    
}

















-(void)checkSocialLoginServiceCall :(NSString *)urlStr and :(NSDictionary *)requestDict{
    @try {
        dispatch_queue_t imageQueue = dispatch_queue_create("Service Queue",NULL);
        responseSuccessCompletionBlock callback = ^(BOOL wasSuccessful, NSDictionary *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
               // [ activityIndicatorView stopAnimating];
                
                 [Utilities removeLoading:self.view];
                if([result valueForKey:@"error"]){
                    
                    [Utilities displayCustemAlertViewWithOutImage: [Utilities getErrorMessageForStatus:[[result valueForKey:@"error"] integerValue]] :self.navigationController.view];
                    
                    return ;
                }
                if (wasSuccessful) {
                    NSUInteger status = [[result valueForKey:@"status"] integerValue];
                    if (status == 2 || status == 1 ) {
                        if ([[Utilities null_ValidationString:[result objectForKey:@"isnewuser"]] isEqualToString:@"yes"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                
                                
                                [self fbSignupService];
//                                SocialMediaMissingFields *loginVC = (SocialMediaMissingFields *)[Utilities viewControllerWithIdentifier:@"SocialMedia" andStoryboardType:YES];
//                                loginVC.fbOrGoogle = [NSString stringWithFormat:@"%@",[requestDict objectForKey:@"type"]];
//                                loginVC.classType = @"signup";
//                                loginVC.socialPicUrl = singleTonInstance.imageUrlStringFromFb;
//                                [self.navigationController pushViewController:loginVC animated:YES];
                            });
                            
                        }
                        else{
                            // Take user to dashboard screen
                            
                            NSLog(@"===succes login===");
                            if ([result objectForKey:@"details"] != nil) {
                                
                                
//                                singleTonInstance.dicDataFromLoginForFbLogin = result;
                                NSDictionary *details = (NSDictionary *)[result objectForKey:@"details"];
                                NSString * imgFB = [Utilities null_ValidationString:[details objectForKey:@"profile_image"]];
                                if (imgFB.length)
                                {
                                    [USERDEFAULTS setObject:imgFB forKey:@"profile_image"];
                                }
                                [Utilities SaveUserID:[details objectForKey:@"user_id"]];
                                
                                
                                
//                                [Utilities saveUsername:[details objectForKey:@"name"] and:@"" andEmailId:[Utilities null_ValidationString:[details objectForKey:@"email"] ] andGender:@"" andUserId:[details objectForKey:@"user_id"]];
//                                [Utilities savePhoneno:[details objectForKey:@"mobilenumber"]];
//                                [Utilities saveProfilePicName:[Utilities null_ValidationString:[details valueForKey:@"profilepic"]]];
                                
                                
                                
                                
                                if ([[details objectForKey:@"type"] isEqualToString:@"facebook"]){
                                    [USERDEFAULTS setObject:[details objectForKey:@"facebookid"] forKey:@"SocialMediaID"];
                                    
                                }
                                
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                homeTabViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
                                
                                UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:login];
                                rootNavigationController.navigationBarHidden = YES;
                                [APPDELEGATE window].rootViewController   = rootNavigationController;
                                
                               // [Utilities saveUserLoginStatus];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                  //  [APPDELEGATE loginChecking];
                                });
                            }
                        }
                    }
                    else{
                        [Utilities displayCustemAlertViewWithOutImage: [Utilities null_ValidationString:[result valueForKey:@"result"]] :self.navigationController.view];
                    }
                }
                else {
                    [Utilities displayCustemAlertViewWithOutImage: [Utilities getErrorMessageForStatus:[[result valueForKey:@"message"] integerValue]] :self.navigationController.view];
                }
                
            });
        };
        
        dispatch_async(imageQueue, ^{
            [[ServiceInitiater sharedInstance] requestQuoteForSymbol :urlStr :requestDict :@"POST"
                                                         withCallback:callback];
        });
        
    }
    @catch (NSException *exception) {
        //NSLog(@"%@", exception.reason);
    }
    @finally {
        
    }
    
}








-(void)fbSignupService
{
    
    
    
    
    
    NSDictionary *requestDict;
    NSString *urlStr = [NSString stringWithFormat:@"%@signup",BASEURL];
    
    requestDict = @{@"name":[Utilities null_ValidationString:UserNameStr],
                    @"mobilenumber":@"",
                    @"device_token":[Utilities getDeviceToken],
                    @"password":@"",
                    @"device_type":@"ios",
                    @"email":[Utilities null_ValidationString:emailIdStr],
                    @"type":@"facebook",
                    @"facebookid":[Utilities null_ValidationString:fbID],
                    @"twitterid":@"",
                    @"googleid":@"",
                    @"latitude":[NSString stringWithFormat:@"%f",coordinate.latitude],
                    @"longitude":[NSString stringWithFormat:@"%f",coordinate.longitude]
                    };
    
    [Utilities savePhoneno:[Utilities null_ValidationString:self.mobileNumberTextField.text]];
    
    if ([Utilities isInternetConnectionExists]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            [service  handleRegistration :urlStr info:requestDict andMethod:@"POST"];
            
        });
    }
    else{
        [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"internet_connection_error"] :self.view];
        
    }
    
}








- (IBAction)passwordShow:(id)sender
{
    if(SHOWPSWD)
    {
        self.pswdIconImage .image = [UIImage imageNamed:@"view.png"];
        
        SHOWPSWD = NO;
    }
    else
    {
        self.pswdIconImage .image = [UIImage imageNamed:@"hideview.png"];
        
        SHOWPSWD = YES;
        
    }
    BOOL wasFirstResponder;
    if ((wasFirstResponder = [self.PasswordTextfield isFirstResponder])) {
        [self.PasswordTextfield resignFirstResponder];
    }
    // In this example, there is a "show password" toggle
    [self.PasswordTextfield setSecureTextEntry:![self.PasswordTextfield isSecureTextEntry]];
    if (wasFirstResponder) {
        [self.PasswordTextfield becomeFirstResponder];
    }

}


- (void)signUpServiceCall
{
    
    if (self.nameTextField.text.length == 0)
    {
       // [Utilities displayCustemAlertViewWithOutImage: [[Utilities gettingPlistUsingDictonary] valueForKey:@"signup_name_error_msg"] :self.view];
        [Utilities displayCustemAlertView:@"Please enter name" :self.view];
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter all valid data" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertControllerStyleAlert handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alert addAction:okAction];
//        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if (self.nameTextField.text.length <3)
    {
        //[Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"signup_short_name_error_msg"]  :self.view];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter all valid data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertControllerStyleAlert handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else if (self.mobileNumberTextField.text.length < 10 || self.mobileNumberTextField.text.length == 0 || self.mobileNumberTextField.text.length > 10)
    {
        [Utilities displayCustemAlertView:@"Please enter valid Mobile Number" :self.view];
        //[Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"signup_number_error_msg"] :self.view];
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter valid data" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertControllerStyleAlert handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alert addAction:okAction];
//        [self presentViewController:alert animated:YES completion:nil];
        
    }
    //    else if (emailTextField.text.length == 0) {
    //        [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"signup_email_error_msg"] :self.view];
    //    }
    //    else if (![Utilities emailCredibility:emailTextField.text]) {
    //        [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"signup_invalid_email_error_msg"] :self.view];
    //    }
    else if (self.PasswordTextfield.text.length == 0)
    {
        [Utilities displayCustemAlertView:@"Please enter Password" :self.view];
        
        //[Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"signup_nopassword_error_msg"] :self.view];

        
    }
    
    else if (self.PasswordTextfield.text.length < 6 ){
        
        // [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"signup_invalid_password_error_msg"] :self.view];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter all valid data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertControllerStyleAlert handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if (self.PasswordTextfield.text.length > 12 ){
        
        //[Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"signup_invalid_password_error_msg"] :self.view];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter all valid data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertControllerStyleAlert handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
    else
    {
        
        
        
        
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@signup",BASEURL];
        
        requestDict = @{
                        
                        @"name":[Utilities null_ValidationString:self.nameTextField.text],
                        @"mobilenumber":[Utilities null_ValidationString:self.mobileNumberTextField.text],
                        @"device_token":[Utilities getDeviceToken],
                        @"password":[Utilities null_ValidationString:self.PasswordTextfield.text],
                        @"device_type":@"ios",
                        @"email":@"test@gmail.com",
                        @"type":@"direct",
                        @"facebookid":@"",
                        @"twitterid":@"",
                        @"googleid":@"",
                        @"latitude":[NSString stringWithFormat:@"%f",coordinate.latitude],
                        @"longitude":[NSString stringWithFormat:@"%f",coordinate.longitude]
                        
                        };
        
        [Utilities savePhoneno:[Utilities null_ValidationString:self.mobileNumberTextField.text]];
        
        if ([Utilities isInternetConnectionExists]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //                    activityIndicatorView  = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor redColor]];
                //
                //
                //                    activityIndicatorView.frame = self.view.frame ;
                //                    [self.view addSubview:activityIndicatorView];
                //                    [activityIndicatorView startAnimating];
                
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ServiceManager *service = [ServiceManager sharedInstance];
                service.delegate = self;
                [service  handleRegistration :urlStr info:requestDict andMethod:@"POST"];
                
            });
        }
        else{
            [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"internet_connection_error"] :self.view];
            
        }
        
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
        //[ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
        // [Utilities displayCustemAlertViewWithOutImage:@"Failed to getting data" :self.view];
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    
    NSLog(@"responseInfo :%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            
            // to save user_id to use in further classes service calls
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                if (fbID.length)
                {
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    
//                    homeTabViewController * home = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
//                    
//                    [home setSelectedIndex:0];
//                    //[self.navigationController pushViewController:home animated:YES];
//                    
//                    [self presentViewController:home animated:YES completion:nil];
                    
                    if ([[responseInfo valueForKey:@"isnewuser"] isEqualToString:@"yes"])
                    {
                        [Utilities SaveUserID:[responseInfo valueForKey:@"user_id"]];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        homeTabViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
                        
                        [Utilities SaveUserID:[responseInfo valueForKey:@"user_id"]];
                        
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseInfo];
                        
                        [USERDEFAULTS setObject:data forKey:@"gmailLoginData"];
                        
                        UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:login];
                        rootNavigationController.navigationBarHidden = YES;
                        [APPDELEGATE window].rootViewController   = rootNavigationController;
                        
                        
                    }
                    else if([[responseInfo valueForKey:@"isnewuser"] isEqualToString:@"no"])
                    {
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        homeTabViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
                        
                        [Utilities SaveUserID:[responseInfo valueForKey:@"user_id"]];

                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseInfo];
                        
                        [USERDEFAULTS setObject:data forKey:@"gmailLoginData"];
                        
                        UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:login];
                        rootNavigationController.navigationBarHidden = YES;
                        [APPDELEGATE window].rootViewController   = rootNavigationController;
                    }
                    
                    
                }
                
                else
                {
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    OTPViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"OTPViewController"];
                    login.mobileNumberString = self.mobileNumberTextField.text;
                    UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:login];
                    rootNavigationController.navigationBarHidden = YES;
                    
                   NSMutableArray * myMutableArray = [[NSMutableArray alloc]init];
                    
                    myMutableArray = [responseInfo valueForKey:@"eventlist"];
                    
                    NSData* myuserData = [NSKeyedArchiver archivedDataWithRootObject:myMutableArray];
                    
                    [USERDEFAULTS setObject:myuserData forKey:@"invitedUserEventArray"];
                    
                    if ([[responseInfo valueForKey:@"invite_status"] intValue] == 1) {
                        [USERDEFAULTS setBool:YES forKey:@"invite_status"];
                    }
                    else
                    {
                        
                        [USERDEFAULTS setBool:NO forKey:@"invite_status"];
                    }
                    
                    
                    
                    
                    
                    [APPDELEGATE window].rootViewController   = rootNavigationController;
                    
                }
                
                
                
                
                
//                [Utilities saveUserId:[responseInfo objectForKey:@"userid"]];
//                OTPViewController * otpview = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPViewController"];
//                otpview.otpString = [responseInfo objectForKey:@"otp"];
//                //[self presentViewController:otpview animated:YES completion:nil];
//                [self.navigationController pushViewController:otpview animated:YES];
                
            });
            
            
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                // [Utilities displayCustemAlertViewWithOutImage:str :self.view];
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertControllerStyleAlert handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //[ activityIndicatorView stopAnimating];
            [Utilities removeLoading:self.view];
        });
        
    }
    
    @catch (NSException *exception) {
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[ activityIndicatorView stopAnimating];
            [Utilities removeLoading:self.view];
            [self.view endEditing:YES];
        });
        
    }
    
}



- (IBAction)btnGoogleLoginClicked:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];
}
#pragma  – mark Google SignIn Delegate Methods

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    // Perform any operations on signed in user here.
    
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    if (idToken == nil) {
        idToken = @" ";
    }
    
    if (user.profile.hasImage)
    {
        NSURL *url = [user.profile imageURLWithDimension:100];
        NSLog(@"profile image url : %@",url);
    }
    
    
    NSDictionary *parameters = @{@"googleIdToken":idToken};
    NSLog(@"googleIdToken ==> GGGggggggg >> %@",parameters);
    UserNameStr = user.profile.name;
    emailIdStr = user.profile.email;
    fbID = user.userID;
    [[GIDSignIn sharedInstance] signOut];
    
    [self gmailSignupService];
}



#pragma mark - TextFiled delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //    [backGroundScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self animateTextField:textField up:YES withOffset:textField.frame.origin.y / 2];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    [backGroundScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
    
    if (textField == self.PasswordTextfield) {
        self.PasswordTextfield.clearsOnBeginEditing = NO;
    }
    
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)animateTextField:(UITextField*)textField up:(BOOL)up withOffset:(CGFloat)offset
{
    const int movementDistance = -offset;
    const float movementDuration = 0.4f;
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //return true;
    if (textField == self.mobileNumberTextField) {
        NSUInteger newLength = [self.mobileNumberTextField.text length] + [string length] - range.length;
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        
        NSString *filtered =[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        while (newLength < CHARACTER_LIMIT) {
            return [string isEqualToString:filtered];
        }
        
        /* Limits the no of characters to be enter in text field */
        
        return (newLength >CHARACTER_LIMIT ) ? YES : NO;
        return true;
        
    }
    if (textField == self.PasswordTextfield)
    {
        return true;
    }
    return false;
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
