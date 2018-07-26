//
//  RestaurantListViewController.h
//  foodieApp
//
//  Created by ashwin challa on 7/19/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *restaurantList;

@property BOOL isEventListFilter;

@end
