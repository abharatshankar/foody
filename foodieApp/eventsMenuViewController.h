//
//  eventsMenuViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/13/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventsMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *eventMenuCollectionView;


@end
