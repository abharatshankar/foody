//
//  detectAddressViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/18/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "detectAddressViewController.h"
#import "SingleTon.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "Utilities.h"
#import "Constants.h"
#import "LcnManager.h"
#import "MyTableViewController.h"

@interface detectAddressViewController ()
{
SingleTon * singleTonInstance;
    NSMutableArray * citesArr;
    NSString * colorCode;
    UIColor * colorFor;
}
@end

@implementation detectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    citesArr = [[NSMutableArray alloc]initWithObjects:@"Al Barsha",@"Coral dubai al barsha hotel",@"Abidos hotel apartment dubailand",@"Al Ain",@"Sharjah", nil];
    
   NSLog(@"location detection %@", [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location]);
    
    colorCode= @"#E8E8E8";
    colorFor = [Utilities getUIColorObjectFromHexString:colorCode alpha:1];
    
    self.detectLocationBtn.backgroundColor = colorFor;
    
    self.detectLocationBtn.font = [UIFont fontWithName:@"Roboto-Bold" size:14];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchHereBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MyTableViewController *notifications = [storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController"];
    
    [self.navigationController pushViewController:notifications animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return citesArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // al barsha lat 25.098851952936041 and long 55.204635858535767
        
        singleTonInstance.mostPopLatiNum = 25.098851952936041;
        singleTonInstance.mostPopLongiNum = 55.204635858535767;
        singleTonInstance.isMostPopularClicked = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (indexPath.row == 1) {
        // coral dubai al barsha hotel
        
        singleTonInstance.mostPopLatiNum = 25.113895928963281;
        singleTonInstance.mostPopLongiNum = 55.200502574443817;
        singleTonInstance.isMostPopularClicked = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (indexPath.row == 2) {
        // coral dubai al barsha hotel
        
        singleTonInstance.mostPopLatiNum = 25.0893106747274;
        singleTonInstance.mostPopLongiNum = 55.379290580749498;
        singleTonInstance.isMostPopularClicked = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    cell.textLabel.text = [citesArr objectAtIndex:indexPath.row];
    
    
    
    cell.contentView.backgroundColor = colorFor;
    
    return cell;
}

- (IBAction)detectLocation:(id)sender {
    [USERDEFAULTS removeObjectForKey:@"city"];
    
    singleTonInstance.toDetectLocationStr = [USERDEFAULTS valueForKey:@"placemark.name"];
    
     [self.navigationController popViewControllerAnimated:YES];
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
