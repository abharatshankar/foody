//
//  filterResultViewController.m
//  foodieApp
//
//  Created by ashwin challa on 4/9/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "filterResultViewController.h"
#import "filterResultCell.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "UIImageView+WebCache.h"
#import "menuViewController.h"
#import "detailRestaurantViewController.h"

@interface filterResultViewController ()
{
    NSMutableArray * cellsArray;
}
@end

@implementation filterResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellsArray = [[NSMutableArray alloc]init];
    
    NSLog(@"result dict is =======>> %@",self.resultDict);
    
    cellsArray = [self.resultDict objectForKey:@"response"];
    
    
    
    
    [self buttonsOnNav];
    
    
    // Do any additional setup after loading the view.
}

-(void)buttonsOnNav
{
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    
    
    
    UIButton *btnLib1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnLib1 setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
    btnLib1.frame = CGRectMake(0, 0, 22, 22);
    btnLib1.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib1];
    [arrLeftBarItems addObject:barButtonItem2];
    //[btnLib1 setTitle:@"<<" forState:UIControlStateNormal];
    [btnLib1 addTarget:self action:@selector(Back_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnLib1 setImage:[UIImage imageNamed:@"icons8-left-24.png"] forState:UIControlStateNormal ];
    
    
    UIButton *btnsearch = [[UIButton alloc]initWithFrame:CGRectMake(116, 22, 28, 25)];
    [btnsearch setImage:[UIImage imageNamed:@"icons8-left-24.png"] forState:UIControlStateNormal ];
    UIBarButtonItem * itemsearch = [[UIBarButtonItem alloc] initWithCustomView:btnsearch];
    [btnsearch addTarget:self action:@selector(BellMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:itemsearch, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    
    //for right bar buttons
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(275, 5, 28, 25);
    [menuButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    menuButton.showsTouchWhenHighlighted=YES;
    
    
    //--right buttons--//
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(30, 0, 120, 30);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitle:@"Filter Result" forState:UIControlStateNormal];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // [btnh addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Back_Click
{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        menuViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
    
    if (self.isfromEventMenu == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[menuViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                
                break;
            }
        }
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return cellsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"filterResultCell";
    filterResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[filterResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.restaurantName.text = [Utilities null_ValidationString:[[cellsArray objectAtIndex:indexPath.row] objectForKey:@"merchant_name"]] ;
    cell.restaurantName.textColor = [UIColor whiteColor];
    
    //imageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/merchant_banners/%@",featuredimages];
    
    //NSLog(@"===image url  == %@",imageString);
    
    //NSURL *url = [NSURL URLWithString:imageString];
    //[cell.imgView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"banner.jpg"]];

    
    
    NSString * imgStr = [[cellsArray objectAtIndex:indexPath.row] objectForKey:@"merchant_banner"];
    
     NSString * imageString = [NSString stringWithFormat:@"http://testingmadesimple.org/foody/uploads/merchant_banners/%@",imgStr];
//
    NSLog(@"===image url  == %@",imageString);

    NSURL *url = [NSURL URLWithString:imageString];
    [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    detailRestaurantViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"detailRestaurantViewController"];
    
    search.dict =  [[self.resultDict objectForKey:@"response"] objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:search animated:YES];

    
}




@end
