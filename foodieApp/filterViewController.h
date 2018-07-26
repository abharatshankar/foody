//
//  filterViewController.h
//  sam
//
//  Created by ashwin challa on 12/26/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface filterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *locationsTbl;
@property (strong, nonatomic) IBOutlet UIButton *dropDownList;
@property UISearchController * SearchController;

@property (strong, nonatomic) IBOutlet UIImageView *downArrowImg;

@property BOOL * isFromHomeMenu;

@property (strong, nonatomic) IBOutlet UIButton *locationsBtn;
@property (strong, nonatomic) IBOutlet UIButton *cusinesBtn;
@property (strong, nonatomic) IBOutlet UIButton *categoryBtn;

@property BOOL isEventFilter;


@property (strong, nonatomic) IBOutlet UIButton *filterBtn;

@property (strong, nonatomic) IBOutlet UIButton *sortByBtn;


@property (strong, nonatomic) IBOutlet UITableView *sortByTbl;

@property (strong, nonatomic) IBOutlet UIView *sortByView;
@property (strong, nonatomic) IBOutlet UIImageView *loc_img;

@property (strong, nonatomic) IBOutlet UIImageView *cuisines_img;
@property (strong, nonatomic) IBOutlet UIImageView *cat_img;
@property (strong, nonatomic) IBOutlet UIImageView *sort_img;
@property (strong, nonatomic) IBOutlet UILabel *grayBackground;

@end
