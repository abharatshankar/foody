//
//  notificationViewController.h
//  buzzedApp
//
//  Created by  on 7/20/17.
//  Copyright © 2017 adroitent.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableProducts;

@property NSMutableArray * notificationsArray;

@end
