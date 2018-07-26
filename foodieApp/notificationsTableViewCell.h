//
//  notificationsTableViewCell.h
//  buzzedApp
//
//  Created by  on 7/20/17.
//  Copyright © 2017 adroitent.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

@end
