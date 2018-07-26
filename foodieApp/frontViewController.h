//
//  frontViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/11/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"
#import "VCFloatingActionButton.h"


@interface frontViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,floatMenuDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menu;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (weak, nonatomic) IBOutlet UIView *cusWindow;
@property (weak, nonatomic) IBOutlet UIView *mapShowView;

@property NSInteger row;
@property (weak, nonatomic) IBOutlet UILabel *locationAddressLbl;

@property (weak, nonatomic) IBOutlet UIView *callView;
- (IBAction)cancelViewBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callBtn:(id)sender;
@property (strong, nonatomic) IBOutlet HWViewPager *GroupCollectionView;

@property (weak, nonatomic) IBOutlet UIView *mapshowView;

@property (weak, nonatomic) IBOutlet UIButton *searchHere;

@property BOOL  isMarkerActive;


@end
