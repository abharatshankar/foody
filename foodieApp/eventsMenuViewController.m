//
//  eventsMenuViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/13/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "eventsMenuViewController.h"
#import "eventsMenuTableViewCell.h"
#import "eventsMenuCollectionViewCell.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"

@interface eventsMenuViewController ()

@end

@implementation eventsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    eventsMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"eventsMenuCollectionViewCell" forIndexPath:indexPath];
    
    
    
    
   // cell.nameLbl.text = [futuredArray objectAtIndex:indexPath.row];
    
    cell.layer.cornerRadius = 35;
    cell.clipsToBounds = YES;
    
    cell.profilePic.layer.borderWidth=1;
    cell.profilePic.layer.borderColor = REDCOLOR.CGColor;
    cell.profilePic.layer.cornerRadius = 39;
    cell.profilePic.clipsToBounds = YES;
    cell.profilePic.layer.masksToBounds = YES;
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"eventsMenuTableViewCell";
    
    // Custom TableViewCell
    eventsMenuTableViewCell *cell = (eventsMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[eventsMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
       
    }
    
    
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
