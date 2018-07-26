//
//  profileViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/11/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "profileViewController.h"
#import "SWRevealViewController.h"
#import "ServiceInitiater.h"
#import "ServiceManager.h"
#import "Utilities.h"
#import "Constants.h"
#import "editProfileViewController.h"
#import "loginViewController.h"
#import "setReviewViewController.h"
#import "SingleTon.h"
#import "UIImageView+WebCache.h"
#import "UIButton+Glossy.h"



@interface profileViewController ()
{
    NSString * emailStr,
             * phoneStr;
    SingleTon *  singleTonInstance;
}
@end

@implementation profileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    SWRevealViewController*sw=[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    _menu.target=sw.revealViewController;
    _menu.action=@selector(revealToggle:);
    [self.menu setImage:[UIImage imageNamed:@"toogle_menu_icon.png"]];
   
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    
    self.editProfileBut.layer.cornerRadius = 3;
    self.logOutBut.layer.cornerRadius = 3;
    self.callUsBut.layer.borderWidth = 0.5;
    self.rateUsBut.layer.borderWidth = 0.5;
    self.callUsBut.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.rateUsBut.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
   
    
    
    //self.title = @"My Profile";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSString *hexStr3 = @"#ca1d31";
    
    UIColor *color1 = [Utilities getUIColorObjectFromHexString:hexStr3 alpha:1];
    
    [self.logOutBut setBackgroundToGlossyRectOfColor:[UIColor colorWithRed:.65 green:.05 blue:.05 alpha:1] withBorder:NO forState:UIControlStateNormal];

    
    // for navigation bar tint color
    self.navigationController.navigationBar.barTintColor = color1;
    
    
    
    [Utilities roundCornerImageView:self.profileImage];
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    

    
    
    //--right buttons--//
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(0, 0, 30, 22);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[btntitle setTitle:@"Nearby Bars" forState:UIControlStateNormal];
    [btntitle setImage:[UIImage imageNamed:@"toogle_menu_icon.png"] forState:UIControlStateNormal];
    
    [btntitle addTarget:sw.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    NSLayoutConstraint * widthConstraint22 = [btntitle.widthAnchor constraintEqualToConstant:28];
    NSLayoutConstraint * HeightConstraint22 =[btntitle.heightAnchor constraintEqualToConstant:28];
    [widthConstraint22 setActive:YES];
    [HeightConstraint22 setActive:YES];
    
    
    
    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    
    
    //--right buttons--//
    UIButton *btntitle1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle1.frame = CGRectMake(0, 0, 100, 22);
    [btntitle1 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem31 = [[UIBarButtonItem alloc] initWithCustomView:btntitle1];
    [arrLeftBarItems addObject:barButtonItem31];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitle:@"Profile" forState:UIControlStateNormal];
    //[btntitle setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    
   // [btntitle addTarget:self action:@selector(goBackAct) forControlEvents:UIControlEventTouchUpInside];
    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    self.callView.hidden = YES;
    
    
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    
    [self userProfileServiceCall];
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




- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.revealViewController revealToggleAnimated:YES];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    // this is to close side menu if already opened when navigation to another tab bar
    if (self.revealViewController.frontViewPosition == FrontViewPositionRight) {
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide];
    }
    
    if (singleTonInstance.profilePicData)
    {
        self.profileImage.image = [UIImage imageWithData:singleTonInstance.profilePicData];
        
        [Utilities roundCornerImageView:self.profileImage];
        self.profileImage.layer.borderWidth = 1;
        self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    else if (![singleTonInstance.imgUrlStr isKindOfClass:[NSNull class]])
    {
        //self.profileImage.image = [NSURL URLWithString:singleTonInstance.imgUrlStr];
        
        NSURL *url = [NSURL URLWithString:singleTonInstance.imgUrlStr];
        [self.profileImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"name_icon.png"]];
    }

    [self userProfileServiceCall];
    
}

- (IBAction)rateUsAction:(id)sender
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    setReviewViewController *review = [storyboard instantiateViewControllerWithIdentifier:@"setReviewViewController"];
//    [self.navigationController pushViewController:review animated:YES];
    [Utilities displayToastWithMessage:@"Work in Progress"];
    
}


- (IBAction)editProfileBtn:(id)sender {
    
     dispatch_async(dispatch_get_main_queue(), ^{
         
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    editProfileViewController *profile = [storyboard instantiateViewControllerWithIdentifier:@"editProfileViewController"];
    
    profile.nameStr = self.nameLbl.text;
    
    profile.emailStr = [Utilities null_ValidationString:emailStr];
    
    [self.navigationController pushViewController:profile animated:YES];
         
     });
}

- (IBAction)logoutBtn:(id)sender
{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""message:@"Are You Sure, do you Want to logout?"preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   
                                   
                                   
                               }];
    
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    NSDictionary * dict = [USERDEFAULTS dictionaryRepresentation];
                                    for (id key in dict) {
                                        [USERDEFAULTS removeObjectForKey:key];
                                    }
                                
                                    singleTonInstance.barsCountStr = nil;
                                    singleTonInstance.loungeCountStr = nil;
                                    singleTonInstance.clubCountStr = nil;
                                    singleTonInstance.restaurantsStr = nil;
                                    singleTonInstance.toDetectLocationStr = nil;
                                    singleTonInstance.userRatingStr = nil;
                                    singleTonInstance.offersArray = nil;
                                    singleTonInstance.latitudeArray = nil;
                                    singleTonInstance.longitudeArray = nil;
                                    singleTonInstance.dixFromAnimation2Profile  = nil;
                                    singleTonInstance.barsArray = nil;
                                    singleTonInstance.barsArrayReady = nil;
                                    singleTonInstance.loungeArray = nil;
                                    singleTonInstance.ClubsArray = nil;
                                    singleTonInstance.restaurantsArray = nil;
                                    singleTonInstance.profilePicData = nil;
                                    singleTonInstance.profilePicName = nil;
                                    singleTonInstance.profilePicImageUrlString = nil;
                                    singleTonInstance.dixFromLogin = nil;
                                    singleTonInstance.mapItemList = nil;
                                    singleTonInstance.startDateStr = nil;
                                    singleTonInstance.endDateStr = nil;
                                    singleTonInstance.showTimeStr = nil;
                                    singleTonInstance.endTimeStr = nil;
                                    singleTonInstance.descriptionStr = nil;
                                    singleTonInstance.eventNameSt = nil;
                                    singleTonInstance.areaName = nil;
                                    singleTonInstance.eventImgData = nil;
                                    singleTonInstance.editEventImgData = nil;
                                    singleTonInstance.invitesSendArray =  nil;
                                    singleTonInstance.requireArrayToSend = nil;
                                    singleTonInstance.invitesSendArr = nil;
                                    singleTonInstance.contactsSendArray = nil;
                                    singleTonInstance.startDateToServer = nil;
                                    singleTonInstance.endDateToServer = nil;
                                    singleTonInstance.startTimeToServer = nil;
                                    singleTonInstance.endTimeToServer = nil;
                                    singleTonInstance.addressToServer = nil;
                                    singleTonInstance.eventUploadedImageName = nil;
                                    singleTonInstance.editEventUploadedImageName = nil;
                                    singleTonInstance.editedEventStartDate= nil;
                                   
                                    
                                    loginViewController *login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
                                    
                                    login.navigationController.navigationBar.hidden = YES;
                                    
                                    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:login];
                                    [APPDELEGATE window].rootViewController = navController;
                                    
                                }];
    
    [alertController addAction:yesButton];
    
    [alertController addAction:noButton];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
   // [Utilities displayToastWithMessage:@"Work in Progress"];
    
}
- (IBAction)callusBtn:(id)sender
{
    self.callView.hidden = NO;
}

- (IBAction)cancelViewBtn:(id)sender
{
    self.callView.hidden= YES;
}
- (IBAction)callBtn:(id)sender
{
    NSURL *phoneNumber = [NSURL URLWithString:@"telprompt://8885631854"];
    if ([[UIApplication sharedApplication] canOpenURL:phoneNumber]){
        [[UIApplication sharedApplication] openURL:phoneNumber];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed!" message:@"Device not supporting to call" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
}










-(void)userProfileServiceCall
{
    
    
    [self.view endEditing:YES];
    
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
    
            
            
            NSDictionary *requestDict;
            NSString *urlStr = [NSString stringWithFormat:@"%@userProfile",BASEURL];
            
        
                requestDict = @{
                                @"user_id":[Utilities getUserID]
                                };
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ServiceManager *service = [ServiceManager sharedInstance];
                    service.delegate = self;
                    
                    [service  handleRequestWithDelegates:urlStr info:requestDict];
                    
                });
            
            
        
        
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
                
                self.nameLbl.text = [Utilities null_ValidationString:[[responseInfo objectForKey:@"user_info"] objectForKey:@"name"]];
                
                emailStr = [Utilities null_ValidationString:[[responseInfo objectForKey:@"user_info"] objectForKey:@"email"]] ;
                
               // phoneStr =  [Utilities null_ValidationString:[[responseInfo objectForKey:@"user_info"] objectForKey:@"mobilenumber"]];
                
                self.placeLbl.text = [Utilities null_ValidationString:[[responseInfo objectForKey:@"user_info"] objectForKey:@"city"]];
                
                
                NSString * imageStr = [Utilities null_ValidationString:[[responseInfo objectForKey:@"user_info"] objectForKey:@"profile_image"]];
                if (imageStr.length) {
                    NSString * urlStr = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/profile_images/%@",[Utilities null_ValidationString:[[responseInfo objectForKey:@"user_info"] objectForKey:@"profile_image"]]];
                    
                    self.profileImage.layer.cornerRadius = 35;
                    self.profileImage.layer.masksToBounds = NO;
                    self.profileImage.clipsToBounds = YES;
                    
                    self.profileImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
                    
                    singleTonInstance.profilePicImageUrlString = urlStr;
                    
                    [Utilities roundCornerImageView:self.profileImage];
                    
                }
                
               
                
                
                
                
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

















@end
