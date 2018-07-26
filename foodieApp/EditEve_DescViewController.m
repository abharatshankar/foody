//
//  EditEve_DescViewController.m
//  foodieApp
//
//  Created by Prasad on 13/03/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "EditEve_DescViewController.h"
#import "SingleTon.h"
#import "Constants.h"
#import "Utilities.h"

@interface EditEve_DescViewController ()
{
     SingleTon *  singleTonInstance;
}

@end

@implementation EditEve_DescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    self.txtView.delegate = self;
    
    
    
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
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 50, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    phoneButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    phoneBarItem.action = @selector(phoneAction);
    [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [phoneButton setTitle:@"Done" forState:UIControlStateNormal];
   // [phoneButton setImage:[UIImage imageNamed:@"invite_icon.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////

}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneAction
{
    
    singleTonInstance.editedEventDescription = self.txtView.text;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    self.descriptnLbl.hidden = YES;
    
    
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.text.length)
    {
        self.descriptnLbl.hidden = YES;
        
    }
    else
        self.descriptnLbl.hidden = NO;
    
}



@end
