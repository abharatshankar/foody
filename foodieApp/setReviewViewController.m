//
//  setReviewViewController.m
//  buzzedApp
//
//  Created by ashwin challa on 8/17/17.
//  Copyright © 2017 adroitent.com. All rights reserved.
//

#import "setReviewViewController.h"
#import "StarRatingView.h"
#import "Utilities.h"
#import "ServiceInitiater.h"
#import "ServiceManager.h"
#import "Constants.h"
#import "SingleTon.h"
#import "AFHTTPRequestOperationManager.h"
#import "CustomAlertView.h"

#define kLabelAllowance 50.0f
#define kStarViewHeight 30.0f
#define kStarViewWidth 160.0f
#define kLeftPadding 5.0f




@interface setReviewViewController ()
{
    UILabel * placeholderlbl;
     SingleTon *singleTonInstance;
    NSMutableDictionary * imageDataDict;

}

@end

@implementation setReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     singleTonInstance=[SingleTon singleTonMethod];
    [self.commentTextView setDelegate:self];
    
     imageDataDict = [[NSMutableDictionary alloc] init];
    
    placeholderlbl = [[UILabel alloc]init];
    placeholderlbl.frame = CGRectMake(0, 5,self.commentTextView.frame.size.width , 40);
    placeholderlbl.text = @"Give your comments here...";
    // to set color from hex value
    NSString *hexStr3 = @"#979A9A";
    
    UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:.9];
    
    placeholderlbl.textColor = color1;
    
    [placeholderlbl setFont:[UIFont systemFontOfSize:16]];
    
    [self.commentTextView addSubview:placeholderlbl];
    
    //#EBEDEF
    
    StarRatingView* starview = [[StarRatingView alloc]initWithFrame:CGRectMake(16, 110, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:0 withLabel:YES animated:NO];
    [self.view addSubview:starview];
    
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer: tapRec];
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    //for right bar buttons
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(275, 5, 28, 25);
    [menuButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    menuButton.showsTouchWhenHighlighted=YES;
    
    
    //for right bar buttons
//    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    editButton.frame = CGRectMake(self.view.frame.size.width-100, 5, 100, 25);
//    [editButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
//    editButton.showsTouchWhenHighlighted=YES;
//    
//    UIBarButtonItem * editBarItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
//    //editBarItem.action = @selector(menuAction);
//    [arrRightBarItems addObject:editBarItem];
//    editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [editButton setTitle:@"Photo" forState:UIControlStateNormal];
//    //[editButton setImage:[UIImage imageNamed:@"logout_icon.png"] forState:UIControlStateNormal];
//    [editButton addTarget:self action:@selector(photoMethod) forControlEvents:UIControlEventTouchUpInside];
//    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    // Do any additional setup after loading the view.
}



-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)photoMethod
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



-(void)updateCoverPic

{
    
    @try {
        
        NSString *hexStr3 = @"#6dbdba";
        
        UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:.9];
        
       
        [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        
        NSMutableDictionary * requestDict = [[NSMutableDictionary alloc]init];
        
        requestDict = @{
                        
                        @"user_id":[Utilities getUserID], /*totalBubblesArray*/
                        };
        [imageDataDict setValue:[self returnCompressedImageData:self.reviewImg.image] forKey:@"profile_image"];
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
                
                [Utilities removeLoading:self.view];
                NSLog(@"image upload successfully");
                
                NSDictionary *response = (NSDictionary *)responseObject;
                NSUInteger status = [[response valueForKey:@"status"] integerValue];
                NSString *resultMessage = [response valueForKey:@"result"];
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
    
   
        self.reviewImg.image = chosenImage;
        [self updateCoverPic];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//////////////////// DISMISS AFTER PICKING IMAGE ////////////////

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}





-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // NSLog(@"REPlace %@ %d",text,range.location);
    if(range.location==0 && ![text isEqualToString:@""])
    {
        placeholderlbl.hidden = YES;
    }
    else if(range.location==0)
    {
        placeholderlbl.hidden = NO;
    }
    
    return YES;
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





-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)publishReviewAction:(id)sender {
   
    //[USERDEFAULTS setObject:self.label.text forKey:@"userRatingStr"];
    //if (_commentTextView.text.length>0 && singleTonInstance.userRatingStr.length >0)
    NSString * userStrRate = [USERDEFAULTS valueForKey:@"userRatingStr"];
    if (_commentTextView.text.length>0 && userStrRate.length >0)
    {
        if ([Utilities isInternetConnectionExists])
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                NSString *hexStr3 = @"#6dbdba";
//                
//                UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:.9];
//                
//                activityIndicatorView  = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallPulse tintColor:color1];
//                
//                
//                activityIndicatorView.frame = self.view.frame ;
//                [self.view addSubview:activityIndicatorView];
//                [activityIndicatorView startAnimating];
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            NSDictionary *requestDict;
            NSString *urlStr = [NSString stringWithFormat:@"%@addReview",BASEURL];
            
            //NSLog(@"---%@----",singleTonInstance.userRatingStr);
            
            NSLog(@"---%@----",userStrRate);
            
            NSString * changeRating ;
            if ([userStrRate isEqualToString:@"80%"])
            {
                changeRating = @"4";
            }
            else if ([userStrRate isEqualToString:@"60%"])
            {
            changeRating = @"3";
            }
            else if ([userStrRate isEqualToString:@"40%"])
            {
                changeRating = @"2";
            }
            else if ([userStrRate isEqualToString:@"20%"])
            {
                changeRating = @"1";
            }
            else
            {
                 changeRating = @"5";
            }
            requestDict = @{
                            @"user_id":[Utilities getUserID],   //test with @"1234567890"
                            
                            @"merchant_id":@"27"/*self.merchantIdStr*/,
                            @"review":_commentTextView.text,
                            @"rating":changeRating
                            };
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ServiceManager *service = [ServiceManager sharedInstance];
                service.delegate = self;
                
                [service  handleRequestWithDelegates:urlStr info:requestDict];
                
            });
            
            
            //                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //                            tabBarViewController *tabs = [storyboard instantiateViewControllerWithIdentifier:@"tabBarViewController"];
            //                            [self.navigationController pushViewController:tabs animated:YES];
        }
        else
        {
            [Utilities displayCustemAlertViewWithOutImage:[[Utilities gettingPlistUsingDictonary] valueForKey:@"internet_connection_error"] :self.navigationController.view];
            [Utilities displayCustemAlertViewWithOutImage:@"Please Enter at least 8 characters password" :self.view];
            
            
        }
    }
    else
    {
    [Utilities displayCustemAlertViewWithOutImage:@"please Give your valuable Ratings and Comments" :self.view];
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
       // [ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
        [Utilities displayCustemAlertViewWithOutImage:@"Failed to getting data" :self.view];
        
    });
}

-(void)handleResponse :(NSDictionary *)responseInfo
{
    NSLog(@"responseInfo :::%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[self.preferenceTbl reloadData];
                    
//                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                    animationViewController * tabs = [storyboard instantiateViewControllerWithIdentifier:@"animationViewController"];
//                                    [self.navigationController pushViewController:tabs animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                    
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
    
    @catch (NSException *exception) {
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
           // [ activityIndicatorView stopAnimating];
            [Utilities removeLoading:self.view];
        });
        [self.view endEditing:YES];
    }
    
}


@end
