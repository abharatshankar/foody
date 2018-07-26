//
//  smallPopupViewController.m
//  foodieApp
//
//  Created by Bharat shankar on 05/05/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "smallPopupViewController.h"
#import "smallPopupViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "UIImageView+WebCache.h"
#import "homeTabViewController.h"
#import "popupCollectionViewCell.h"

@interface smallPopupViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    
    NSMutableArray * arr;
}
@end

@implementation smallPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
     arr = [[NSMutableArray alloc]init];
    NSData *myData = [USERDEFAULTS valueForKey:@"invitedUserEventArray"];
    arr = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    
    NSLog(@"my comig data is %@",arr);
    
    self.pageControl.numberOfPages = arr.count;
    
    [self.collectionView reloadData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - collectionview delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return arr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    popupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"popupCollectionViewCell" forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        cell.titleLbl.text = [Utilities null_ValidationString:[[arr objectAtIndex:indexPath.row]objectForKey:@"event_name"]];
        
        [cell.titleLbl adjustsFontSizeToFitWidth];
        
        NSString * featuredimages = [[arr objectAtIndex:indexPath.row ] objectForKey:@"image"];
        
        NSString *  imageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/events/%@",featuredimages];
        
        NSLog(@"===image url  == %@",imageString);
        
        NSURL *url = [NSURL URLWithString:imageString];
        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
        
        cell.nameOfPerson.text = [NSString stringWithFormat:@"%@ invited you to ",[Utilities null_ValidationString:[[arr objectAtIndex:indexPath.row ] objectForKey:@"name"]]];
        
        
    });
    return cell;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    dispatch_async(dispatch_get_main_queue(), ^{
        
//
//        homeTabViewController * home = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabViewController"];
//
//
//        [home setSelectedIndex:2];
//
//       // [self presentViewController:home animated:YES completion:nil];
//
//        [self.navigationController presentViewController:home animated:YES completion:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
}

#pragma mark - scrollview delegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSIndexPath *visibleIndexPath;
    
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
        
       
    }
    NSLog(@" - - - %d",visibleIndexPath.row);
    
    self.pageControl.numberOfPages = arr.count;
    self.pageControl.currentPage = visibleIndexPath.row;
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGFloat pageWidth = self.collectionView.frame.size.width;
//
//    self.pageControl.numberOfPages = arr.count;
//    self.pageControl.currentPage = self.collectionView.contentOffset.x / pageWidth;
//
//
//    NSLog(@"current page num is %d",self.pageControl.currentPage);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
