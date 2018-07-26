//
//  voteCollectionCell.h
//  foodieApp
//
//  Created by Bharat shankar on 24/05/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface voteCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@property (weak, nonatomic) IBOutlet UILabel *optionLbl1;
@property (weak, nonatomic) IBOutlet UILabel *optionLbl2;
@property (weak, nonatomic) IBOutlet UILabel *optionLbl3;
@property (weak, nonatomic) IBOutlet UILabel *optionLbl4;


@property (weak, nonatomic) IBOutlet UIButton *optionButton1;
@property (weak, nonatomic) IBOutlet UIButton *optionButton2;
@property (weak, nonatomic) IBOutlet UIButton *optionButton3;
@property (weak, nonatomic) IBOutlet UIButton *optionButton4;

@property (weak, nonatomic) IBOutlet UIButton *voteButon;

@property (weak, nonatomic) IBOutlet UILabel *voteNumCountLbl;

@end
