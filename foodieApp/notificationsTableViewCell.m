//
//  notificationsTableViewCell.m
//  buzzedApp
//
//  Created by  on 7/20/17.
//  Copyright © 2017 adroitent.com. All rights reserved.
//

#import "notificationsTableViewCell.h"

@implementation notificationsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.acceptBtn.layer.cornerRadius =5;
     self.rejectBtn.layer.cornerRadius =5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
