//
//  detectAddressViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/18/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detectAddressViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *detectLocationBtn;

@property (weak, nonatomic) IBOutlet UITableView *locationsTable;


@end
