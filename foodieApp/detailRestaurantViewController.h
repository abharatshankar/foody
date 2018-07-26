//
//  detailRestaurantViewController.h
//  foodieApp
//
//  Created by Admin on 14/12/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailRestaurantViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property NSMutableDictionary * dict;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *areaName;
@property (weak, nonatomic) IBOutlet UILabel *timingsLbl;
@property (weak, nonatomic) IBOutlet UILabel *costLbl;


@property (weak, nonatomic) IBOutlet UILabel *amenitiesLbl;

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImgViw;

@property (strong, nonatomic) IBOutlet UIButton *bookTblBtn;


@property (strong, nonatomic) IBOutlet UIView *bookTableView;

@property (strong, nonatomic) IBOutlet UIView *addPreferedView;

@property (weak, nonatomic) IBOutlet UIView *callView;
- (IBAction)callusBtn:(id)sender;
- (IBAction)cancelViewBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callBtn:(id)sender;

- (IBAction)bookTableAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *amenitiesTableView;

@property (strong, nonatomic) IBOutlet UILabel *cusine;

@property (weak, nonatomic) IBOutlet UICollectionView *photosCollection;

@property (weak, nonatomic) IBOutlet UICollectionView *cusineNameCollection;
@property (strong, nonatomic) IBOutlet UITableView *cusineTableView;

@end
