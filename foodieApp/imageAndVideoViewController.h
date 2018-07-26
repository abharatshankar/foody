//
//  imageAndVideoViewController.h
//  foodieApp
//
//  Created by Bharat shankar on 04/07/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MWPhotoBrowser.h"

@interface imageAndVideoViewController : UIViewController<MWPhotoBrowserDelegate>
{
    NSMutableArray *_selections;

}
@property NSMutableArray * photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;

- (void)loadAssets;

@end
