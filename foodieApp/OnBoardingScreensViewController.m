//
//  OnBoardingScreensViewController.m
//  Zaggle
//
//  Created by Prasad on 11/05/16.
//  Copyright © 2016 . All rights reserved.
//

#import "OnBoardingScreensViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface OnBoardingScreensViewController ()
{
    BOOL pageControlBeingUsed;
    NSArray *menuArray;
    CGRect titleLabelFrame;
}

@property (weak, nonatomic) IBOutlet UIScrollView *slidingScrollView;
@property (weak, nonatomic) IBOutlet UILabel *slidingTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *exploreButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation OnBoardingScreensViewController
@synthesize slidingScrollView,slidingTitleLabel;
@synthesize skipButton,exploreButton,signupButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [USERDEFAULTS setBool:NO forKey:@"ExploreClicked"];
    [USERDEFAULTS removeObjectForKey:@"ExploreClicked"];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Read plist from bundle and get Root Dictionary out of it
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Zaggle" ofType:@"plist"]];
    
    // Your dictionary contains an array of dictionary
    // Now pull an Array out of it.
    menuArray = [NSArray arrayWithArray:[dictRoot objectForKey:@"DemosList"]];
    [self setUpScrollImages:menuArray];
    
    titleLabelFrame = slidingTitleLabel.frame;
}

-(void)setUpScrollImages:(NSArray *)array
{
    pageControlBeingUsed = NO;
    
    CGRect scrollFrame = slidingScrollView.frame;
    
    scrollFrame.size.height = SCREEN_HEIGHT;
    
    scrollFrame.size.width = SCREEN_WIDTH;
    
    slidingScrollView.frame = scrollFrame;
    
    for (int i = 0; i < array.count; i++)
    {
        CGRect frame;
        frame.origin.x = SCREEN_WIDTH * i;
        frame.origin.y = 0;
        frame.size = SCREEN_SIZE;
        
        UIImageView *imageView       =   [[UIImageView alloc]initWithFrame:frame];
        imageView.contentMode        =    UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image              =   [UIImage imageNamed:[[array objectAtIndex:i] objectForKey:@"imageName"]];
        [slidingScrollView addSubview:imageView];
    }
    
    slidingScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * array.count, SCREEN_HEIGHT);
   // pageControl.currentPage    = 0;
   // pageControl.numberOfPages  = array.count;
    
    slidingTitleLabel.text = [[menuArray objectAtIndex:0] objectForKey:@"title"];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
        CGFloat pageWidth           =    slidingScrollView.frame.size.width;
        int page                    =    floor((slidingScrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
       // pageControl.currentPage = page;
        
        if (page == 4) {
            exploreButton.hidden = NO;
            signupButton.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                exploreButton.alpha = 1.0f;
                signupButton.alpha = 1.0f;
                skipButton.alpha = 0.0f;
            }completion:^(BOOL finished){
                skipButton.hidden = YES;
            }];
            CGRect labelFrame = slidingTitleLabel.frame;
            labelFrame.origin.y = SCREEN_HEIGHT/2;
            slidingTitleLabel.frame = labelFrame;
        }
        else{
            if (exploreButton.hidden == NO) {
                [UIView animateWithDuration:0.3 animations:^{
                    exploreButton.alpha = 0.0f;
                    signupButton.alpha = 0.0f;
                    skipButton.alpha = 1.0f;
                }completion:^(BOOL finished){
                    skipButton.hidden = NO;
                    exploreButton.hidden = YES;
                    signupButton.hidden = YES;
                }];
                
                slidingTitleLabel.frame = titleLabelFrame;
            }
        }
        NSLog(@"menuArray =%lu%d",(unsigned long)menuArray.count,page);
        
        if(page < menuArray.count){
        slidingTitleLabel.text = [[menuArray objectAtIndex:page] objectForKey:@"title"];
        }
    }
    
}

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}

- (IBAction)showPageScrolls:(UIPageControl *)sender
{
    CGRect frame;
    frame.origin.x = slidingScrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size     = slidingScrollView.frame.size;
    [slidingScrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
    
}
 */

- (IBAction)skipButtonClicked:(id)sender {
    
//    [UIView animateWithDuration:0.3 animations:^{
//        skipButton.alpha = 0.0f;
//        exploreButton.alpha = 1.0f;
//        signupButton.alpha = 1.0f;
//    } completion:^(BOOL finished){
//        skipButton.hidden = YES;
//        exploreButton.hidden = NO;
//        signupButton.hidden = NO;
//    }];
    
    
    CGRect frame;
    frame.origin.x = slidingScrollView.frame.size.width * ([menuArray count] - 1);
    frame.origin.y = 0;
    frame.size     = slidingScrollView.frame.size;
    [slidingScrollView scrollRectToVisible:frame animated:YES];

}
- (IBAction)exploreButtonClicked:(id)sender {
     // [USERDEFAULTS setBool:YES forKey:@"SlideSeen"];
    //[USERDEFAULTS setBool:YES forKey:@"UserSignedIn"];

    [USERDEFAULTS setBool:YES forKey:@"ExploreClicked"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   // DashBoardViewController *dashboardVC = [storyboard instantiateViewControllerWithIdentifier:@"DashBoardVC"];
   // UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:dashboardVC];
   // [APPDELEGATE window].rootViewController   = rootNavigationController;

}

- (IBAction)signupButtonClicked:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SignupViewController *signupVC = [storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
//    UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:signupVC];
//    rootNavigationController.navigationBarHidden = YES;
//    [APPDELEGATE window].rootViewController   = rootNavigationController;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
