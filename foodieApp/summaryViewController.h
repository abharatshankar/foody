//
//  summaryViewController.h
//  foodieApp
//
//  Created by ashwin challa on 3/15/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface summaryViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *locationLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *partisipantsLbl;
@property (strong, nonatomic) IBOutlet UIButton *callUsBtn;
@property (strong, nonatomic) IBOutlet UIButton *rateUsBtn;

@property (strong, nonatomic) IBOutlet UIView *subView;

@property NSMutableDictionary * presentDict;

@property NSMutableDictionary * summaryDict;

@property NSString * eventDate;

@end
