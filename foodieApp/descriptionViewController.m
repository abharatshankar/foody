//
//  descriptionViewController.m
//  foodieApp
//
//  Created by ashwin challa on 2/16/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "descriptionViewController.h"
#import "SingleTon.h"
#import "Constants.h"
#import "Utilities.h"

@interface descriptionViewController ()
{
    SingleTon *  singleTonInstance;

    
}
@end

@implementation descriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    singleTonInstance=[SingleTon singleTonMethod];

    self.textViw.delegate = self;
    
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 45, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    phoneButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    phoneBarItem.action = @selector(phoneAction);
    [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneButton setTitle:@"Done" forState:UIControlStateNormal];
    //[phoneButton setImage:[UIImage imageNamed:@"invite_icon.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    

    
    // Do any additional setup after loading the view.
}


-(void)doneAction
{

    singleTonInstance.descriptionStr = self.textViw.text;
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
        self.descriptionLabel.hidden = YES;
    
    
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.text.length)
    {
        self.descriptionLabel.hidden = YES;

    }
    else
        self.descriptionLabel.hidden = NO;

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
