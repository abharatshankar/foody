//
//  voteTableViewCell.h
//  foodieApp
//
//  Created by Bharat shankar on 28/05/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface voteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *voteCellView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *option1;
@property (weak, nonatomic) IBOutlet UILabel *option2;
@property (weak, nonatomic) IBOutlet UILabel *option3;
@property (weak, nonatomic) IBOutlet UILabel *option4;
@property (weak, nonatomic) IBOutlet UIButton *cellVoteBtn;

@property (weak, nonatomic) IBOutlet UILabel *option1Count;
@property (weak, nonatomic) IBOutlet UILabel *option2Count;
@property (weak, nonatomic) IBOutlet UILabel *option3Count;
@property (weak, nonatomic) IBOutlet UILabel *option4Count;
@property (weak, nonatomic) IBOutlet UILabel *totalVotesCount;


@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
