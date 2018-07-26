//
//  votePopupViewController.h
//  foodieApp
//
//  Created by Bharat shankar on 22/05/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface votePopupViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *voteLab1;
@property (weak, nonatomic) IBOutlet UILabel *voteLab2;
@property (weak, nonatomic) IBOutlet UILabel *voteLab3;
@property (weak, nonatomic) IBOutlet UILabel *voteLab4;

@property (weak, nonatomic) IBOutlet UIButton *voteButton;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;


@end
