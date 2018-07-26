//
//  menuViewController.h
//  foodieApp
//
//  Created by Admin on 13/12/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menuViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *futuredCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *trendingNowCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *groupListCollection;

@property (strong, nonatomic) IBOutlet UIButton *floatingFilterBtn;

@property BOOL isfromEventReady;

@end
