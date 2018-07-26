//
//  newCreateEventController.h
//  foodieApp
//
//  Created by ashwin challa on 2/7/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newCreateEventController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *contactsListTbl;

@property UISearchController *searchController;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menu;
@property NSString * eventIdStr;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendsBtn;

@end
