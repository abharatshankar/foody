//
//  loginViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/8/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "loginViewController.h"
#import "ForgotPasswordViewController.h"
#import "SMTKeyboardManager.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "signUpViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "homeTabViewController.h"
#import "SingleTon.h"
#import "frontViewController.h"
#import "UIButton+Glossy.h"
#import "AppDelegate.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 11

@interface loginViewController ()<SMTKeyboardManagerDelegate, GIDSignInUIDelegate, GIDSignInDelegate>
{
    BOOL * isFbLogin;
    NSDictionary *facebookOrgoogleDict;
    SingleTon *singleTonInstance;
    NSString *imageUrlSocialMedia,*UserNameStr,*emailIdStr,*fbID;

    CLLocationCoordinate2D coordinate;
    //CLLocationCoordinate2D
    AppDelegate * appDelegate;
    NSString * deviceToken;
}
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.fbLogin.layer.cornerRadius = 3;
//    self.gmailLogin.layer.cornerRadius = 3;
    
    singleTonInstance=[SingleTon singleTonMethod];

    //this is to get curent location lat and long
    coordinate = [self getLocation];
    double  curLat;
    double  curLong;
    curLat = coordinate.latitude;
    curLong = coordinate.longitude;
    ////////////////
    
    self.fbLogin.layer.borderWidth = 0.5;
    self.gmailLogin.layer.borderWidth = 0.5;
    
    self.emailTextFiled.delegate = self;
    self.PasswordTextField.delegate = self;
    
    
    
    self.emailTextFiled.text = @"8500985009";
    self.PasswordTextField.text = @"123";
    // Do any additional setup after loading the view.
    
    [Utilities addShadowtoButton:self.loginButton];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"updateDeviceToken"
                                               object:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

  NSLog(@"login page device token is %@",  [Utilities getDeviceToken]);
    
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


-(void)handleUpdatedData:(NSNotification *)notification {
    
    NSLog(@"devicetoken is %@",[Utilities getDeviceToken]);
    
    deviceToken = [Utilities getDeviceToken];
    
    
     NSLog(@"login page device token is via noti %@",  [Utilities getDeviceToken]);
    //[self chatHistoryServiceCall];
    
}



- (IBAction)forgotPassBtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgotPasswordViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    rootNavigationController.navigationBarHidden = YES;
    [APPDELEGATE window].rootViewController   = rootNavigationController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signupPage:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    signUpViewController *signup = [storyboard instantiateViewControllerWithIdentifier:@"signUpViewController"];
    UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:signup];
    rootNavigationController.navigationBarHidden = YES;
    [APPDELEGATE window].rootViewController   = rootNavigationController;
}

- (IBAction)fbLoginAct:(id)sender
{
    
   ((AppDelegate *)[[UIApplication sharedApplication]delegate]).socialLoginType = @"Facebook";
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
                              
                              singleTonInstance.imgUrlStr = imageUrlSocialMedia;
                              
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





-(void)checkSocialLoginServiceCall :(NSString *)urlStr and :(NSDictionary *)requestDict{
    @try {
        dispatch_queue_t imageQueue = dispatch_queue_create("Service Queue",NULL);
        responseSuccessCompletionBlock callback = ^(BOOL wasSuccessful, NSDictionary *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // [ activityIndicatorView stopAnimating];
                
                
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
                                
                                
                                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:result];
                                
                                [USERDEFAULTS setObject:data forKey:@"fbLoginData"];
                                
                                //                                singleTonInstance.dicDataFromLoginForFbLogin = result;
                                
                                NSDictionary *details = (NSDictionary *)[result objectForKey:@"details"];
                                
                                [Utilities SaveUserID:[details objectForKey:@"user_id"]];
                                
                                NSLog(@"details from fb login %@",details);
                                
                                
                                NSString * imgFB = [Utilities null_ValidationString:[details objectForKey:@"profile_image"]];
                                if (imgFB.length)
                                {
                                    [USERDEFAULTS setObject:imgFB forKey:@"profile_image"];
                                }
                                [Utilities SaveUserID:[details objectForKey:@"user_id"]];
                                
//                                                                [Utilities saveUsername:[details objectForKey:@"name"] and:@"" andEmailId:[Utilities null_ValidationString:[details objectForKey:@"email"] ] andGender:@"" andUserId:[details objectForKey:@"user_id"]];
//                                                                [Utilities savePhoneno:[details objectForKey:@"mobilenumber"]];
//                                                                [Utilities saveProfilePicName:[Utilities null_ValidationString:[details valueForKey:@"profilepic"]]];
                                
                                
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






















-(IBAction)LoginClicked:(id)sender
{
    
    
    [self.view endEditing:YES];
    
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
       
        
        if (_emailTextFiled.text.length<10 || _emailTextFiled.text.length>10 || _emailTextFiled.text.length == 0) {
            [Utilities displayCustemAlertView:@"please enter mobile number" :self.view];
        }
        else if (self.PasswordTextField.text.length ==0)
        {
        [Utilities displayCustemAlertView:@"please Enter Password" :self.view];
        }
        
        else{
            
            
            NSDictionary *requestDict;
            NSString *urlStr = [NSString stringWithFormat:@"%@login",BASEURL];
            
            if ([Utilities validateMobileOREmail:self.emailTextFiled.text error:nil])
            {
                
                NSLog(@"mobile %@ \n password %@ \n device_token %@",self.emailTextFiled.text,_PasswordTextField.text,[Utilities getDeviceToken]);
                
                requestDict = @{
                                @"mobilenumber":self.emailTextFiled.text ,   //test with @"1234567890"
                                @"password":_PasswordTextField.text,    //test with @"123456"
                                @"device_token":[Utilities getDeviceToken],
                                @"device_type":@"ios"
                                };
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ServiceManager *service = [ServiceManager sharedInstance];
                    service.delegate = self;
                    
                    [service  handleRequestWithDelegates:urlStr info:requestDict];
                    
                });
            }
            
        }
    //9491248714
    }
    else
    {
       // [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"internet_connection_error"] :self.navigationController.view];
        [Utilities displayCustemAlertViewWithOutImage:@"Please check your connection" :self.view];
        
        
    }
    
    
    
    
    
    
    
}
# pragma mark - Webservice Delegates

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
         [Utilities displayCustemAlertViewWithOutImage:@"Failed to getting data" :self.view];
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    NSLog(@"responseInfo :=::%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // save password in userDefaults to use in cahnge Password Service call
                [Utilities saveName:self.emailTextFiled.text];
                [USERDEFAULTS setObject:_PasswordTextField.text forKey:@"UserPassword"];
                
                // saved userId to use in further future classes
                [USERDEFAULTS setObject:[[responseInfo objectForKey:@"data"] objectForKey:@"user_id"] forKey:@"UserID"];
                
                [Utilities SaveUserID:[[responseInfo objectForKey:@"data"] objectForKey:@"user_id"] ];
                
                [Utilities saveMobileno:[[responseInfo objectForKey:@"data"] objectForKey:@"mobilenumber"]];
                
                [Utilities saveName:[[responseInfo objectForKey:@"data"] objectForKey:@"name"]];
                
                NSString * proPic = [Utilities null_ValidationString:[[responseInfo objectForKey:@"data"] objectForKey:@"profile_image"]];
                
                if (proPic.length) {
                    
                    [USERDEFAULTS setObject:[[responseInfo objectForKey:@"data"] objectForKey:@"profile_image"] forKey:@"profile_image"];
                    
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseInfo];
                    
                    [USERDEFAULTS setObject:data forKey:@"data"];
                    
                    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
                    
                    NSData *dictionaryData = [USERDEFAULTS objectForKey:@"data"];
                    
                    dic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
                    
                    NSLog(@"----%@----",dic);
                    
                    
                }
                
                
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                homeTabViewController * home = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
                
               
                
                [home setSelectedIndex:0];
                //[self.navigationController pushViewController:home animated:YES];
                
                [self presentViewController:home animated:YES completion:nil];
                
                //                animationViewController * tabs = [storyboard instantiateViewControllerWithIdentifier:@"animationViewController"];
                //                [self.navigationController pushViewController:tabs animated:YES];
                
            });
            
            
        }
        
        else if ([[responseInfo valueForKey:@"status"] intValue] == 3)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utilities displayCustemAlertViewWithOutImage:@"Number does not exist" :self.view];
                NSLog(@"===status 3===");
                
            });
        }
        else if ([[responseInfo valueForKey:@"status"] intValue] == 2)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utilities displayCustemAlertViewWithOutImage:@"Wrong Password" :self.view];
                NSLog(@"===status 2===");
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:@"check your connection" :self.view];
                NSLog(@"===status other than 1===");
                
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
        });
        [self.view endEditing:YES];
    }
    
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
    
    if (textField == self.PasswordTextField) {
        self.PasswordTextField.clearsOnBeginEditing = NO;
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
    if (textField == self.emailTextFiled) {
        NSUInteger newLength = [self.emailTextFiled.text length] + [string length] - range.length;
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        
        NSString *filtered =[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        while (newLength < CHARACTER_LIMIT) {
            return [string isEqualToString:filtered];
        }
        
        /* Limits the no of characters to be enter in text field */
        
        return (newLength >CHARACTER_LIMIT ) ? YES : NO;
        return true;
        
    }
    if (textField == self.PasswordTextField)
    {
        return true;
    }
    return false;
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
    UserNameStr = user.profile.name;
    emailIdStr = user.profile.email;
    fbID = user.userID;
    NSDictionary *parameters = @{@"googleIdToken":idToken};
    NSLog(@"googleIdToken ==> GGGggggggg >> %@",parameters);
    [[GIDSignIn sharedInstance] signOut];
    [self gmailSignupService];
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
