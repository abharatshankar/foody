//
//  editProfileViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/13/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "editProfileViewController.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "Utilities.h"
#import "Constants.h"
#import "SingleTon.h"
#import "changePasswordViewController.h"
#import "ISMessages.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CustomAlertView.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"
#import "homeTabViewController.h"
#import "NSVBarController.h"



@interface editProfileViewController ()
{
 NSMutableDictionary *imageDataDict;
    SingleTon *  singleTonInstance;
    NSDictionary *requestDict;
    BOOL * isPicSelected;

    NSData * changedImageData;

}
@end

@implementation editProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageDataDict = [[NSMutableDictionary alloc] init];
    
    singleTonInstance=[SingleTon singleTonMethod];

    self.nameTxtField.text = self.nameStr;
    self.mobileTxtField.text = @"Temporarily not available"/*self.mobileStr*/;
    self.emailTxtField.text = self.emailStr;
    
//    self.title = @"Edit Profile";
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
   
    
    if (self.imageStrFromSideMenu.length)
    {
        self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/profile_images/%@",self.imageStrFromSideMenu]]]];
        
    }
    else if (singleTonInstance.profilePicData.length)
    {
        self.profileImageView.image = [UIImage imageWithData:[NSData dataWithData:singleTonInstance.profilePicData]];
        

    }
    else if (singleTonInstance.profilePicImageUrlString.length)
    {
        NSLog( @"-- imag %@",singleTonInstance.profilePicImageUrlString);
         self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:singleTonInstance.profilePicImageUrlString]]];
        
        
        NSLog(@"pic already uploaded");
    }
    
    [Utilities roundCornerImageView:self.profileImageView];
    
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
    
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(30, 0, 120, 30);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    self.nameTxtField.delegate = self;
    
    self.emailTxtField.delegate = self;
    
    self.mobileTxtField.delegate = self;
    
    // Do any additional setup after loading the view.
}


-(void)Back_Click
{
    if (self.isSideEdit==YES) {
    
        self.isSideEdit = NO;
        
        /*NSVBarController * home = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
        
        
        NSArray *array = [self.navigationController viewControllers];
        
        [home setSelectedIndex:2];
        
        // [self presentViewController:invite animated:YES completion:nil];
        
        
        
        [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
        
        */
        [self dismissViewControllerAnimated:YES completion:nil];
       
     
    }
    else
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)saveBtnAction:(id)sender {
    
    if (isPicSelected) {
        [self updateCoverPic];
        
    }
    
    
    [self updateProfileServicecall];
}




- (IBAction)editProfile:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    changePasswordViewController *changePass = [storyboard instantiateViewControllerWithIdentifier:@"changePasswordViewController"];
    [self.navigationController pushViewController:changePass animated:YES];

}



- (IBAction)EditButton_Clicked:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Add Photo!" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
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
   
    isPicSelected =YES;
    
    
    
 //  singleTonInstance.profilePicData = UIImagePNGRepresentation(chosenImage);
    
    
    
        self.profileImageView.image = chosenImage;
    
    [Utilities roundCornerImageView:self.profileImageView];
    
    changedImageData = UIImagePNGRepresentation(self.profileImageView.image);
    
    [USERDEFAULTS setObject:changedImageData forKey:@"changedImageData"];
    
    
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
    
    
    
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//////////////////// DISMISS AFTER PICKING IMAGE ////////////////

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)updateProfileServicecall
{
    [self.view endEditing:YES];
    
    
    if ([Utilities isInternetConnectionExists])
    {
        
       
        
        
        BOOL * isemailValid = [self validateEmail:self.emailTxtField.text];
        
      
        
        if (isemailValid) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            
            NSDictionary *requestDict;
            NSString *urlStr = [NSString stringWithFormat:@"%@updateProfile",BASEURL];
            
            if ([Utilities validateMobileOREmail:self.emailTxtField.text error:nil])
            {
                requestDict = @{
                                @"email":self.emailTxtField.text,                                   @"name":self.nameTxtField.text,
                                @"user_id":[Utilities getUserID]
                                };
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ServiceManager *service = [ServiceManager sharedInstance];
                    service.delegate = self;
                    
                    [service  handleRequestWithDelegates:urlStr info:requestDict];
                    
                });
            }

        }
        else
        {
            [ISMessages showCardAlertWithTitle:nil
                                                            message:@"Invalid Email"
                                                           duration:3.f
                                                        hideOnSwipe:YES
                                                          hideOnTap:YES
                                                          alertType:ISAlertTypeError
                                                      alertPosition:ISAlertPositionTop
                                                            didHide:^(BOOL finished) {
                                                                NSLog(@"Alert did hide.");
                                                                
                                                            }];
            
            //[Utilities displayToastWithMessage:@"Invalid Email"];
        }
            
            
        
        
        
    }
    else
    {
        // [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"internet_connection_error"] :self.navigationController.view];
        [Utilities displayCustemAlertViewWithOutImage:@"Please check your connection" :self.view];
        
        
    }
    
    
    

}



-(BOOL)validatePhone:(NSString *)enteredPhoneNumber
{
    NSString *phoneRegex = @"[789][0-9]{9}";
    // OR below for advanced type
    //NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:enteredPhoneNumber];
}


- (BOOL)validateEmail:(NSString *)inputText {
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:inputText]) {
        aRange = [inputText rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [inputText length])];
        int indexOfDot = aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [inputText substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    return FALSE;
}


-(void)updateCoverPic

{
    
    @try {
        
               [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        
        requestDict = @{
                        
                        @"user_id":[Utilities getUserID] /*totalBubblesArray*/
                        };
        [imageDataDict setValue:[self returnCompressedImageData:self.profileImageView.image] forKey:@"profile_image"];
        
        [imageDataDict setValue:[Utilities getUserID] forKey:@"user_id"];
        NSString  *urlStr = [NSString stringWithFormat:@"%@uploadProfileImage",BASEURL];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *fileName1 = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // BASIC AUTH (if you need):
            manager.securityPolicy.allowInvalidCertificates = YES;
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"foo" password:@"bar"];
            
            [manager POST:urlStr parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if ([imageDataDict valueForKey:@"profile_image"]!= nil) {
                    [formData appendPartWithFileData:[imageDataDict valueForKey:@"profile_image"] name:@"profile_image" fileName:fileName1 mimeType:@"image/jpeg"];
                }
                //                if ([imageDataDict valueForKey:@"cover_photo"]!= nil) {
                //                    [formData appendPartWithFileData:[imageDataDict valueForKey:@"cover_photo"] name:@"cover_photo" fileName:fileName1 mimeType:@"image/jpeg"];
                //                }
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //[ activityIndicatorView stopAnimating];
                [Utilities removeLoading:self.view];
               // [self.nameTextField becomeFirstResponder];
                
                NSDictionary *response = (NSDictionary *)responseObject;
                NSUInteger status = [[response valueForKey:@"status"] integerValue];
                NSString *resultMessage = [response valueForKey:@"result"];
                
                self.profileImageView.layer.cornerRadius = 35;
                self.profileImageView.layer.masksToBounds = NO;
                self.profileImageView.clipsToBounds = YES;
                
                
                [Utilities roundCornerImageView:self.profileImageView];
               
                
                
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
                        
                        if ([[USERDEFAULTS valueForKey:@"reUploadClicked"] isEqualToString:@"Yes"])
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecondMain" bundle:nil];
                                //                                BillHistoryViewController  *bilhst = [storyboard instantiateViewControllerWithIdentifier:@"BillHst"];
                                //                                bilhst.classTypeStr = @"BillUpload";
                                //                                [USERDEFAULTS removeObjectForKey:@"reUploadClicked"];
                                //                                [self.navigationController pushViewController:bilhst animated:YES];
                            });
                        }
                        
                        
                        else
                        {
                            //                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecondMain" bundle:nil];
                            //                            BillUploadCouponsViewController *dashboardVC = [storyboard instantiateViewControllerWithIdentifier:@"BillUpload"];
                            //                            dashboardVC.biilIdStr = billIdStrVAl;
                            //
                            //                            dashboardVC.marchentID = merchentIdStr;
                            //                            [self.navigationController pushViewController:dashboardVC animated:YES];
                        }
                        
                        
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
                        CustomAlertView *alert = [[CustomAlertView alloc]initWithAlertType:ImageWithSingleButtonType andMessage:[response valueForKey:@"result"] andImageName:AlertVpanicImage andCancelTitle:nil andOtherTitle:@"OK" andDisplayOn:self.view];
                        alert.delegate =self;
                        [self.view addSubview:alert];
                        //                        [Utilities displayCustemAlertView:[response valueForKey:@"result"] :self.view];
                        //[self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 //@"Failure.....");
                 //@"Failure %@, %@", error, operation.responseString);
                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [ activityIndicatorView stopAnimating];
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   // if (textField == self.inputText) {
        [textField resignFirstResponder];
//        return NO;
//    }
    return YES;
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
    NSLog(@"responseInfo editProfilePage:%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSData * imgDataToProfile = UIImagePNGRepresentation(self.profileImageView.image);
                
//                NSString * imgStrChange = [Utilities null_ValidationString:[[responseInfo valueForKey:@"user_info"] valueForKey:@"profile_image"]] ;
//                
//                if (imgStrChange.length) {
//                    
//                   // singleTonInstance.profilePicData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/profile_images/%@",[[responseInfo valueForKey:@"user_info"] valueForKey:@"profile_image"]]]];
//                    
//                    [USERDEFAULTS setObject:imgStrChange forKey:@"imgStrChange"];
//                    
//                    singleTonInstance.profilePicName = imgStrChange;
//                }
                
               
                
                if (imgDataToProfile.length)
                {
                    singleTonInstance.profilePicData = imgDataToProfile;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileImageChanged"
                                                                        object:self];
                }
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
                if (self.isfromSideMenu)
                {
                    homeTabViewController * home = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
                    
                    
                    [home setSelectedIndex:0];
                    
                    self.isfromSideMenu = NO;
                    
                    
                    //now
                    [Utilities displayToastWithMessage:@"Saved Successfully"];
                    //now
                    [self presentViewController:home animated:YES completion:nil];
                    //now
                    [Utilities displayToastWithMessage:@"Saved Successfully"];
                }
                
                [Utilities displayToastWithMessage:@"Saved Successfully"];
                
            });
            
            
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                [Utilities displayCustemAlertViewWithOutImage:str :self.view];
                
                NSLog(@"status other than 1");
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           // [ activityIndicatorView stopAnimating];
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







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
