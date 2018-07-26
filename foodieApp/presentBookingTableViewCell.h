//
//  presentBookingTableViewCell.h
//  foodieApp
//
//  Created by ashwin challa on 4/10/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface presentBookingTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *eventImg;
@property (strong, nonatomic) IBOutlet UILabel *eventName;
@property (strong, nonatomic) IBOutlet UILabel *numberOfEventPeople;
@property (strong, nonatomic) IBOutlet UILabel *startMonth;
@property (strong, nonatomic) IBOutlet UILabel *startDay;
@property (strong, nonatomic) IBOutlet UILabel *startTime;
@property (strong, nonatomic) IBOutlet UILabel *endMonth;
@property (strong, nonatomic) IBOutlet UILabel *endDay;
@property (strong, nonatomic) IBOutlet UILabel *endTime;



@property (strong, nonatomic) IBOutlet UILabel *eventStatus;

@end
