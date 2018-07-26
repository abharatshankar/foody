//
//  smallPopupViewController.h
//  foodieApp
//
//  Created by Bharat shankar on 05/05/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface smallPopupViewController : UIViewController

@property NSMutableArray * array;
@property NSString * str;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
