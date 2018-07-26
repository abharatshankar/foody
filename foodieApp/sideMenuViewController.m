//
//  sideMenuViewController.m
//  foodieApp
//
//  Created by Bharat shankar on 12/11/17.
//  Copyright © 2017 Bharat shankar. All rights reserved.
//

#import "sideMenuViewController.h"
#import "sideMenuTableViewCell.h"
#import "Constants.h"
#import "ServiceInitiater.h"
#import "ServiceManager.h"
#import "Utilities.h"
#import "editProfileViewController.h"
#import "SingleTon.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"

@interface sideMenuViewController ()
{
    NSMutableArray * titlesArray ,  *imagesArray,
                                    *activeImagesArray;
    
    SingleTon * singleTonInstance;
    
    int varNumber;
    
    BOOL    * isAboutUs,
            * isHowItWorks,
            * isFaqs,
            *isPrivacyPolicy,
            *isTermsOfservice,
            *isLogOut,
            *isImageChanged;
    //now
    NSString * emailString;
    
}
@end

@implementation sideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tblProducts.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    titlesArray = [[NSMutableArray alloc]initWithObjects:@"About Us",@"How it works",@"FAQ's",@"Privacy Policy",@"Terms of Service",@"Logout", nil];
    imagesArray = [[NSMutableArray alloc]initWithObjects:@"about.png",@"how_it_work.png",@"faq.png",@"pravicy_policy.png",@"icons8-edit-file-80.png",@"logout.png",nil];
    
    
    
    
    
    
    activeImagesArray = [[NSMutableArray alloc]initWithObjects:@"about_about.png",@"how_it_work_active .png",@"faq_active .png",@"pravicy_policy .png",@"terms_active.png",@"logout_active.png",nil];
    
    NSString * imgStr = [USERDEFAULTS valueForKey:@"profile_image"];
    
    if (imgStr.length) {
        self.profilePic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/profile_images/%@",imgStr]]]];
        //[Utilities roundCornerImageView:self.profilePic];
    }
    else if (![Utilities null_ValidationString:singleTonInstance.imgUrlStr])
    {
        //self.profileImage.image = [NSURL URLWithString:singleTonInstance.imgUrlStr];
        
        NSURL *url = [NSURL URLWithString:singleTonInstance.imgUrlStr];
        [self.profilePic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"name_icon.png"]];
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    NSData *dictionaryData = [USERDEFAULTS objectForKey:@"data"];
    
    dic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
    
    NSLog(@"data from otp page %@",dic);
    
    self.nameLbl.text = [Utilities null_ValidationString:[[dic objectForKey:@"data"] valueForKey:@"name"]];
    
    //now
    emailString = [Utilities null_ValidationString:[[dic objectForKey:@"data"] valueForKey:@"email"]] ;
    
    
    
    
    
    if (!dic.count) {
        
        NSMutableDictionary * gmDict = [[NSMutableDictionary alloc]init];
        
        NSData *GmDictionaryData = [USERDEFAULTS objectForKey:@"gmailLoginData"];
        
        if (![GmDictionaryData isKindOfClass:[NSNull class]]) {
            
            gmDict = [NSKeyedUnarchiver unarchiveObjectWithData:GmDictionaryData];
            
            NSLog(@"may b login through gmail %@",gmDict);
            
           // self.nameLbl.text = [Utilities null_ValidationString:[[dict valueForKey:@"details"] valueForKey:@"name"]];
        }
        
        else
        {
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            
            NSData *fbdictionaryData = [USERDEFAULTS objectForKey:@"fbLoginData"];
            
            if (![fbdictionaryData isKindOfClass:[NSNull class]]) {
                
                dict = [NSKeyedUnarchiver unarchiveObjectWithData:fbdictionaryData];
                
                NSLog(@"may b login through fb %@",dict);
                
                self.nameLbl.text = [Utilities null_ValidationString:[[dict valueForKey:@"details"] valueForKey:@"name"]];
            }
            
        }
        
        
        
        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"profileImageChanged"
                                               object:nil];

    
    // Do any additional setup after loading the view.
}


-(void)handleUpdatedData:(NSNotification *)notification {
    NSLog(@"recieved");
    isImageChanged = YES;
     NSString * imgStr = [USERDEFAULTS valueForKey:@"profile_image"];
    self.profilePic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/profile_images/%@",imgStr]]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString * imgStr = [USERDEFAULTS valueForKey:@"profile_image"];
    
    if (imgStr.length) {
        self.profilePic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/profile_images/%@",imgStr]]]];
        //[Utilities roundCornerImageView:self.profilePic];
    }
    if ([singleTonInstance.dixFromLogin objectForKey:@"name"]) {
        self.nameLbl.text = [singleTonInstance.dixFromLogin objectForKey:@"name"];
    }
    
    NSData * imageData = [USERDEFAULTS valueForKey:@"changedImageData"];
    NSString * confirmationStr = [USERDEFAULTS valueForKey:@"imageConfirmation"];
    
    if (imageData.length && isImageChanged == YES) {
        
        self.profilePic.image = [UIImage imageWithData:imageData];

    }
    [Utilities addShadowtoView:self.revealViewController.frontViewController.view ];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}



-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
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



- (IBAction)editProfileAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    editProfileViewController *profile = [storyboard instantiateViewControllerWithIdentifier:@"editProfileViewController"];
    
//    profile.nameStr = self.nameLbl.text;
//    
//    profile.emailStr = [singleTonInstance.dixFromLogin objectForKey:@"email"];
//    
//    [self.navigationController pushViewController:profile animated:YES];
    
    //[self presentViewController:profile animated:YES completion:nil];
    
    
    SWRevealViewController *revealController = self.revealViewController;
    // We know the frontViewController is a NavigationController
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    
    NSLog(@"VC: %@", frontNavigationController.topViewController);
    UINavigationController *navigationController;
    
    
    NSString *hexStr3 = @"#ca1d31";
    
    UIColor *color1 = [self getUIColorObjectFromHexString:hexStr3 alpha:1];
    
    // Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
    navigationController.navigationBar.barTintColor = color1;
    navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
    
    
    
    
    
    editProfileViewController *frontViewController;
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"editProfileViewController"];
    
    frontViewController.nameStr = self.nameLbl.text;
    
    frontViewController.emailStr = [singleTonInstance.dixFromLogin objectForKey:@"email"];
    
    frontViewController.isfromSideMenu = YES;
    
    
    //now
    frontViewController.emailStr = emailString;

    NSString * imgStr = [USERDEFAULTS valueForKey:@"profile_image"];
    if (imgStr.length)
    {
        frontViewController.imageStrFromSideMenu = imgStr;
        
    }
    
    frontViewController.isSideEdit = YES;
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    navigationController.navigationBar.barTintColor = color1;
    navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
    
    [navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName :GREEN_COLOR_RBGVALUE}];
    navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : GREEN_COLOR_RBGVALUE};
    [self presentViewController:navigationController animated:YES completion:nil];
    //[self.navigationController pushViewController:navigationController animated:YES];
    //[revealController setFrontViewController:navigationController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    editProfileViewController *profile = [storyboard instantiateViewControllerWithIdentifier:@"editProfileViewController"];
    
//    profile.nameStr = self.nameLbl.text;
//    
//    profile.emailStr = emailStr;
    
    static NSString *simpleTableIdentifier = @"sideMenuTableViewCell";
    
    // Custom TableViewCell
    sideMenuTableViewCell *cell = (sideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
//    if (indexPath.row==0) {
//        
//        
//        varNumber  = 0;
//        isAboutUs = YES;
//        
//        cell.imgView.image = [UIImage imageNamed:[activeImagesArray objectAtIndex:0]];
//        
//        cell.imgView.tintColor = [UIColor whiteColor];
//        
//        cell.titleTxt.textColor = [UIColor whiteColor];
//        
//        cell.contentView.backgroundColor = REDCOLOR;
//        
//        
//    }
//    
//    if (indexPath.row==1) {
//        
//        
//        varNumber  = 1;
//        isHowItWorks = YES;
//        
//        cell.imgView.image = [UIImage imageNamed:[activeImagesArray objectAtIndex:0]];
//        
//        cell.imgView.tintColor = [UIColor whiteColor];
//        
//        cell.titleTxt.textColor = [UIColor whiteColor];
//        
//        cell.contentView.backgroundColor = REDCOLOR;
//        
//        
//    }
//
//    
    
    
    
    
    SWRevealViewController *revealController = self.revealViewController;
    
    
    
    if (indexPath.section == 0)
    {
        
        
        
        
        // We know the frontViewController is a NavigationController
//        UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
//        
        NSInteger row = indexPath.row;
//        
//        NSLog(@"VC: %@", frontNavigationController.topViewController);
//        UINavigationController *navigationController;
//        
//        // Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
//        navigationController.navigationBar.barTintColor = YELLOW_COLOR_RBGVALUE;
//        navigationController.navigationBar.tintColor = GREEN_COLOR_RBGVALUE;
        
        if (row == 0)
        {
            varNumber  = 0;
            isAboutUs = YES;
            
            
            
        }
        
        else if (row == 1)
        {
            varNumber = 1;
            isHowItWorks = YES;
        }
        else if (row == 2)
        {
            varNumber = 2;
            isFaqs = YES;
        }
        else if (row == 3)
        {
            varNumber = 3;
            isPrivacyPolicy = YES;
        }
        else if (row == 4)
        {
            varNumber = 4;
            isTermsOfservice = YES;
        }
        else if (row == 5)
        {
            varNumber = 5;
            isLogOut = YES;
        }
       
    
    
    if (indexPath.row==0)
    {
        if (isAboutUs)
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isAboutUs = NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            [_tblProducts reloadData];
        }
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
        
    else if (indexPath.row==1)
    {
        if (isHowItWorks) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isAboutUs = NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            [_tblProducts reloadData];
        }
            
        
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
        
        
    else if (indexPath.row==2)
    {
        if (isFaqs) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isAboutUs = NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            [_tblProducts reloadData];
        }
        
        
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row==3)
    {
        if (isPrivacyPolicy) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isAboutUs = NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            [_tblProducts reloadData];
        }
        
        
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
        
    else if (indexPath.row==4)
    {
        if (isTermsOfservice) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isAboutUs = NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            [_tblProducts reloadData];
        }
        
        
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row==5)
    {
        if (isLogOut) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = REDCOLOR;
            isAboutUs = NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            [_tblProducts reloadData];
        }
        
        
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.textLabel.textColor = [UIColor grayColor];
        }

        

        
    

    
        
    }
    }


    
        

    
    [Utilities displayToastWithMessage:@"Work in Progress"];
   
    



}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"sideMenuTableViewCell";
    
    // Custom TableViewCell
    sideMenuTableViewCell *cell = (sideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        // I believe here I am going wrong
        cell = [[sideMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        NSLog(@"Cell = %@", cell);  // Shows null
    }
    
    cell.imgView.image = [UIImage imageNamed:[imagesArray objectAtIndex:indexPath.row]];
    
    cell.titleTxt.text = [titlesArray objectAtIndex:indexPath.row];
    
   // cell.layer.borderWidth = 0.5;
    
   // cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    
    
    
    if (indexPath.row==0)
    {
        if (varNumber==0)
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = REDCOLOR;
            
            
            isAboutUs =NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            
        }
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = [UIColor grayColor];
        }
        
    }
    
    else if (indexPath.row==1)
    {
        if (varNumber==1) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = REDCOLOR;
            
            isAboutUs =NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            
            
            
            
        }
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row ==2)
    {
        if (varNumber==2) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = REDCOLOR;
            
            isAboutUs =NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            
        }
        
        
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row ==3)
    {
        if (varNumber==3) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = REDCOLOR;
            
            isAboutUs =NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            
        }
        
        
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = [UIColor grayColor];
        }
        
    }
    
    else if (indexPath.row ==4)
    {
        if (varNumber==4) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = REDCOLOR;
            
            isAboutUs =NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            
        }
        
        
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = [UIColor grayColor];
        }
        
    }
    else if (indexPath.row ==5)
    {
        if (varNumber==5) {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = REDCOLOR;
            cell.titleTxt.textColor = [UIColor whiteColor];
            cell.backgroundColor = REDCOLOR;

            isAboutUs =NO;
            isHowItWorks = NO;
            isFaqs = NO;
            isPrivacyPolicy = NO;
            isTermsOfservice = NO;
            isLogOut = NO;
            
        }
        
        
        else
        {
            cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [activeImagesArray objectAtIndex:indexPath.row]]];
            cell.titleTxt.textColor = [UIColor whiteColor];
            cell.backgroundColor = REDCOLOR;
        }
        
    }

    
    return cell;
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
