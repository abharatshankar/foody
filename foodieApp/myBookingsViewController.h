//
//  myBookingsViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/11/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myBookingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menu;
@property (strong, nonatomic) IBOutlet UITableView *BookingsTableView;

- (IBAction)CurrentBookingsBtn_Clicked:(id)sender;
- (IBAction)PreviousBookingsBtn_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *yourEventsHighlightLbl;

@property (strong, nonatomic) IBOutlet UILabel *pastEventsHighlightLbl;
@property (strong, nonatomic) IBOutlet UIButton *clearAllBtn;
@property (strong, nonatomic) IBOutlet UIButton *myEventsBtn;
@property (strong, nonatomic) IBOutlet UIButton *pastEventsBtn;

@end
