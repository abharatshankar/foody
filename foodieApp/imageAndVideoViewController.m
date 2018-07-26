//
//  imageAndVideoViewController.m
//  foodieApp
//
//  Created by Bharat shankar on 04/07/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "imageAndVideoViewController.h"
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"
#import "foodieApp-Swift.h"


@interface imageAndVideoViewController ()
{
    SegmentedProgressBar * myClass;
    
    UIImageView * iv;
    
    NSMutableArray * images ;
    
    NSCoder * coder;
    
    int pageIndex;
    
    NSMutableArray * items , *item;
    
    AVPlayer * player;
    
    
}
@end

@implementation imageAndVideoViewController



- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.title = @"Stories";
        
        // Clear cache for testing
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
        
        [self loadAssets];
        
    }
    return self;
}



- (IBAction)butAction:(id)sender {
//    
//    NSMutableArray *photos = [[NSMutableArray alloc] init];
//    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
//    MWPhoto *photo, *thumb;
//    BOOL displayActionButton = YES;
//    BOOL displaySelectionButtons = NO;
//    BOOL displayNavArrows = NO;
//    BOOL enableGrid = YES;
//    BOOL startOnGrid = NO;
//    BOOL autoPlayOnAppear = NO;
//    
//    //photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo5" ofType:@"jpg"]]];
//    photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://www.google.co.in/search?q=google+images&rlz=1C5CHFA_enIN789IN789&source=lnms&tbm=isch&sa=X&ved=0ahUKEwiP07SsmIfcAhWMtY8KHVoHBE0Q_AUICigB&biw=1207&bih=694#imgrc=N4gcsTLxCXMRuM:"]];
//    photo.caption = @"Fireworks";
//    [photos addObject:photo];
//    //photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"photo2.jpg"]];
//    photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://www.google.co.in/search?q=google+images&rlz=1C5CHFA_enIN789IN789&source=lnms&tbm=isch&sa=X&ved=0ahUKEwiP07SsmIfcAhWMtY8KHVoHBE0Q_AUICigB&biw=1207&bih=694#imgrc=C2yEz1SjLyz1LM:"]];
//    photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
//    [photos addObject:photo];
//    photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"photo3.jpg"]];//[MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo3" ofType:@"jpg"]]];
//    photo.caption = @"York Floods";
//    [photos addObject:photo];
//    photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"video_thumb.jpg"]];//[MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video_thumb" ofType:@"jpg"]]];
//    //  photo.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
//    //  photo.caption = @"Big Buck Bunny";
//    //  [photos addObject:photo];
//    photo =  [MWPhoto photoWithImage:[UIImage imageNamed:@"video_thumb.jpg"]];//[MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo4" ofType:@"jpg"]]];
//    photo.caption = @"Campervan";
//    [photos addObject:photo];
//    // Options
//    enableGrid = NO;
//    
//    self.photos = photos;
//    self.thumbs = thumbs;
//    
//    // Create browser
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = displayActionButton;
//    browser.displayNavArrows = displayNavArrows;
//    browser.displaySelectionButtons = displaySelectionButtons;
//    browser.alwaysShowControls = displaySelectionButtons;
//    browser.zoomPhotosToFill = YES;
//    browser.enableGrid = enableGrid;
//    browser.startOnGrid = startOnGrid;
//    browser.enableSwipeToDismiss = NO;
//    browser.autoPlayOnAppear = autoPlayOnAppear;
//    [browser setCurrentPhotoIndex:0];
//    
//    // Test reloading of data after delay
//    double delayInSeconds = 3;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//        //        // Test removing an object
//        //        [_photos removeLastObject];
//        //        [browser reloadData];
//        //
//        //        // Test all new
//        //        [_photos removeAllObjects];
//        //        [_photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo3" ofType:@"jpg"]]];
//        //        [browser reloadData];
//        //
//        //        // Test changing photo index
//        //        [browser setCurrentPhotoIndex:9];
//        
//        //        // Test updating selections
//        //        _selections = [NSMutableArray new];
//        //        for (int i = 0; i < [self numberOfPhotosInPhotoBrowser:browser]; i++) {
//        //            [_selections addObject:[NSNumber numberWithBool:YES]];
//        //        }
//        //        [browser reloadData];
//        
//    });
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
//    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:nc animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [NSMutableArray array];
    
    
    images = [[NSMutableArray alloc]init];
    
    iv.frame = self.view.bounds;
    iv.contentMode = PHImageContentModeAspectFill;
    [self.view addSubview:iv];
    
    [images addObject:@"1-900-Love-Prison-l.jpg"];
    [images addObject:@"banner.jpg"];
    [images addObject:@"Thumb-up-smiley.png"];
    myClass =[[SegmentedProgressBar alloc]initWithCoder:coder];
    myClass = [[SegmentedProgressBar alloc] initWithNumberOfSegments:3 duration:5];
    
    
    myClass.topColor = [UIColor redColor];
    myClass.bottomColor = [UIColor grayColor];
    myClass.padding = 2;
    
    //[myClass initWithCoder:self];
    //[myClass initWithNumberOfSegments:3 duration:5];
    // myClass =  [[SegmentedProgressBar alloc]initWithNumberOfSegments:3 duration:5];
    
    myClass.frame = CGRectMake(12, 12, self.view.frame.size.width-24, 5);
    myClass.delegate = self;
    
    [self.view addSubview:myClass];
    
    [myClass startAnimation];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)];
    
    [self.view addGestureRecognizer:tap];
    self.photos = [NSMutableArray array];
    
    
    
    
    //    [self updateImage:0];
    //
    //
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    //    self.navigationController.navigationBar.translucent = NO;
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return YES;
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Load Assets

- (void)loadAssets {
    if (NSClassFromString(@"PHAsset")) {
        
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self performLoadAssets];
        }
        
    } else {
        
        // Assets library
        [self performLoadAssets];
        
    }
}

- (void)performLoadAssets {
    
    // Initialise
    _assets = [NSMutableArray new];
    
    // Load
    if (NSClassFromString(@"PHAsset")) {
        
        // Photos library iOS >= 8
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
            [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_assets addObject:obj];
            }];
            
        });
        
    } else {
        
        // Assets Library iOS < 8
        _ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Run in the background as it takes a while to get all assets from the library
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
            NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
            
            // Process assets
            void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto] || [assetType isEqualToString:ALAssetTypeVideo]) {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url = result.defaultRepresentation.url;
                        [_ALAssetsLibrary assetForURL:url
                                          resultBlock:^(ALAsset *asset) {
                                              if (asset) {
                                                  @synchronized(_assets) {
                                                      [_assets addObject:asset];
                                                      if (_assets.count == 1) {
                                                          // Added first asset so reload data
                                                          
                                                      }
                                                  }
                                              }
                                          }
                                         failureBlock:^(NSError *error){
                                             NSLog(@"operation was not successfull!");
                                         }];
                        
                    }
                }
            };
            
            // Process groups
            void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                    [assetGroups addObject:group];
                }
            };
            
            // Process!
            [_ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                            usingBlock:assetGroupEnumerator
                                          failureBlock:^(NSError *error) {
                                              NSLog(@"There is an error");
                                          }];
            
        });
        
    }
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)playVideoOrLoadImage:(NSInteger *)index
{
    
}
//
//- (void)segmentedProgressBarChangedIndexWithIndex:(NSInteger)index {
//    <#code#>
//}
//
//- (void)segmentedProgressBarFinished {
//    <#code#>
//}

//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

@end
