//
//  demoScreensViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/8/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "demoScreensViewController.h"
#import "loginViewController.h"
#import "Constants.h"


@interface demoScreensViewController ()
{
    BOOL * isLastPAge;
}
@end

@implementation demoScreensViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextAction:(id)sender
{
   self.pageController.currentPage +=1;
    if (self.pageController.currentPage ==2) {
        [self.nextBtn setTitle:@"Get Started" forState:UIControlStateNormal];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        loginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:loginVC];
        rootNavigationController.navigationBarHidden = YES;
        [APPDELEGATE window].rootViewController   = rootNavigationController;

    }
    else
    {
     [self.nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    }
}
- (IBAction)changePageController:(id)sender {
    
}

- (IBAction)skipAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    loginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    rootNavigationController.navigationBarHidden = YES;
    [APPDELEGATE window].rootViewController   = rootNavigationController;
}


- (void)swipe:(UISwipeGestureRecognizer *)swipeRecogniser
{
    if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionLeft)
    {
        self.pageController.currentPage +=1;
        if (self.pageController.currentPage ==2) {
            [self.nextBtn setTitle:@"Get Started" forState:UIControlStateNormal];
        }
        else
        {
            [self.nextBtn setTitle:@"Next" forState:UIControlStateNormal];
        }
        

    }
    else if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionRight)
    {
        
        self.pageController.currentPage -=1;
        self.pageController.tintColor = [UIColor redColor];
        if (self.pageController.currentPage ==2) {
            [self.nextBtn setTitle:@"Get Started" forState:UIControlStateNormal];
        }
        else
        {
            [self.nextBtn setTitle:@"Next" forState:UIControlStateNormal];
        }
    }
//    _dssview.image = [UIImage imageNamed:
//                      [NSString stringWithFormat:@"%d.jpg",self.pageController.currentPage]];
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
