//
//  filterResultViewController.h
//  foodieApp
//
//  Created by ashwin challa on 4/9/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface filterResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property NSMutableDictionary * resultDict;

@property BOOL isfromEventMenu;

@end
