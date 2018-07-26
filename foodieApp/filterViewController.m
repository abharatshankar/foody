//
//  filterViewController.m
//  sam
//
//  Created by Bharat shankar on 12/26/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "filterViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "ServiceInitiater.h"
#import "ServiceManager.h"
#import "SingleTon.h"
#import "filterResultViewController.h"

@interface filterViewController ()
{
    NSMutableArray * locationNamesArr,
                   * locationIDArr,
                   * searchLocationNamesArr,
                   * searchLocationIDArr,
                   *citiesArr,
                   *citiesIDArr,
                   *sortByArray,
                   *cusinesArray,
                   *cusinesIDArray,
                   *categoryArray,
                   *categoryIDArray,
                   *categoryIDArrayToServer,
                   *localitiesToServerArray;
    UITableView * cityTbl,
                * cusinesTbl,
                *categoryTbl;
    SingleTon * singleTonInstance;
    BOOL * isCityAvilable , * isForLocalities , *isLocalitiesSearch , *isApplyFilters;
    
    NSString * sortTypeStr,
             *sortValueStr,
             *cityIdStr,
             *cityIdStrFromSelection,
             *cityNameStr,
             *citySearchStr;
    
    NSInteger * pathNum;
}
@end

@implementation filterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    singleTonInstance=[SingleTon singleTonMethod];
    

    //Search Controller & Search Bar
    self.SearchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    self.locationsTbl.tableHeaderView=self.SearchController.searchBar;
    self.SearchController.searchResultsUpdater=self;
    self.SearchController.searchBar.delegate=self;
    
    self.sortByBtn.backgroundColor = [UIColor whiteColor];
    self.filterBtn.backgroundColor = [UIColor darkGrayColor];
    [self.sortByBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.cusinesBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cusinesBtn.layer.borderWidth = 0.5;
    
    self.sortByTbl.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    [btntitle setTitle:@"Filter & Sort" forState:UIControlStateNormal];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // [btnh addTarget:self action:@selector(searchMethodClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //for right bar buttons
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 28, 25);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    phoneButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
    phoneBarItem.action = @selector(phoneAction);
    [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(Back_Click) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    NSLayoutConstraint * widthConstraint1 = [phoneButton.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint1 =[phoneButton.heightAnchor constraintEqualToConstant:30];
    [widthConstraint1 setActive:YES];
    [HeightConstraint1 setActive:YES];
    
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    citiesIDArr = [[NSMutableArray alloc]init];
    citiesArr = [[NSMutableArray alloc]init];
    cusinesArray = [[NSMutableArray alloc]init];
    cusinesIDArray = [[NSMutableArray alloc]init];
    categoryArray = [[NSMutableArray alloc]init];
    categoryIDArray = [[NSMutableArray alloc]init];
    categoryIDArrayToServer = [[NSMutableArray alloc]init];
    localitiesToServerArray = [[NSMutableArray alloc]init];
//    locationNamesArr = [[NSMutableArray alloc]init];
//    locationIDArr = [[NSMutableArray alloc]init];
    
    [self citiesGetServiceCall];
    
    [self getcuisinesServiceCall];
    
    [self getcategoriesServiceCall];
    
    isForLocalities = YES;
    
    cityIdStr = @"1";// by default city name is selected as hyderabad
    
    [self localitiesServiceCall];
    
    
    
    sortByArray = [[NSMutableArray alloc]initWithObjects:@"Near Me",@"Popularity",@"Ratings",@"Distance",@"Price - Low-High", @"Price - High-Low",nil];
    
    
   //  locationNamesArr = [[NSMutableArray alloc]initWithObjects:@"Gachibowli",@"Shamshabad",@"Kukatpally",@"Mallapur",@"Hi Tech City",@"KondaPur",@"Habsiguda",@"Jubilee Hills",@"Secunderabad",@"Vikarabad",@"Gachibowli",@"Erragadda", nil];
    
    
    
    cityTbl = [[UITableView alloc]initWithFrame:CGRectMake(self.dropDownList.frame.origin.x, self.dropDownList.frame.origin.y+self.dropDownList.frame.size.height+1, self.dropDownList.frame.size.width-5, citiesArr.count*40) style:UITableViewStylePlain];
    
    cityTbl.delegate = self;
    cityTbl.dataSource =self;
    
    cityTbl.hidden = YES;
    [self.view addSubview:cityTbl];
    [Utilities addShadowtoView:cityTbl];
    isCityAvilable = NO;
    
    
    
    cusinesTbl = [[UITableView alloc]initWithFrame:CGRectMake(self.dropDownList.frame.origin.x, self.dropDownList.frame.origin.y+self.dropDownList.frame.size.height+1, self.dropDownList.frame.size.width, cusinesArray.count*42) style:UITableViewStylePlain];
    cusinesTbl.delegate = self;
    cusinesTbl.dataSource =self;
    cusinesTbl.hidden = YES;
   
    
    
    categoryTbl = [[UITableView alloc]initWithFrame:CGRectMake(self.dropDownList.frame.origin.x, self.dropDownList.frame.origin.y+self.dropDownList.frame.size.height+1, self.dropDownList.frame.size.width, categoryArray.count*45) style:UITableViewStylePlain];
    categoryTbl.delegate = self;
    categoryTbl.dataSource =self;
    categoryTbl.hidden = YES;
    
    
    
   // [self.sortByBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.filterBtn.backgroundColor = [UIColor colorWithRed:4.0f/255.0f green:99.0f/255.0f blue:6.0f/255.0f alpha:1.0f];
    self.sortByBtn.backgroundColor = [UIColor blackColor];
    
    
     self.locationsBtn.backgroundColor = REDCOLOR;
    
    
    self.categoryBtn.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0f];

    self.cusinesBtn.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0f];

    
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    self.SearchController.searchBar.hidden = NO;
  self.tabBarController.tabBar.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.SearchController.searchBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)Back_Click
{
    [self.SearchController.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.SearchController setActive:NO];
    
    
     if (tableView ==  self.locationsTbl) {
         UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
         
         if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
             cell.accessoryType = UITableViewCellAccessoryNone;
             
             NSString * pathNo = [NSString stringWithFormat:@"%d",[[locationIDArr objectAtIndex:indexPath.row] intValue]];
             NSLog(@"De-selected path is %@",pathNo);
             [localitiesToServerArray removeObject:pathNo];
             [singleTonInstance.locationOptions removeObject:pathNo];
         } else {
             
             
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
             NSString * pathNo = [NSString stringWithFormat:@"%d",[[locationIDArr objectAtIndex:indexPath.row] intValue]];
             NSLog(@"selected path is %@",pathNo);
             [localitiesToServerArray addObject:pathNo];
             [singleTonInstance.locationOptions addObject:pathNo];
         }
         
         self.SearchController.searchBar.text = nil;
         [self.SearchController.searchBar resignFirstResponder];
     }
    else if(tableView == cityTbl)
    {
        
        
        [self.dropDownList setTitle:[citiesArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
         cityIdStrFromSelection = cityIdStr;
        
        cityIdStr = [citiesIDArr objectAtIndex:indexPath.row];
        
        isCityAvilable = NO;
        //cityNameStr = [citiesArr objectAtIndex:indexPath.row] ;
        
        isForLocalities = YES;
        
        [self localitiesServiceCall];
        
        cityTbl.hidden = YES;
    }
    else if (tableView == self.sortByTbl)
    {
        cityTbl.hidden = YES;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
        
        NSString * pathNo = [NSString stringWithFormat:@"%d",indexPath.row];
        singleTonInstance.sortByOptions  = pathNo;
        
        sortTypeStr = [sortByArray objectAtIndex:indexPath.row];
        
        sortValueStr = nil;
        
        if (indexPath.row == 4) {
            sortTypeStr = @"price";
            sortValueStr = @"asc";
        }
        else if (indexPath.row == 5)
        {
         sortTypeStr = @"price";
            sortValueStr = @"desc";
        }
        
        
//        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        } else {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
    }
    else if (tableView == cusinesTbl)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if (tableView == categoryTbl)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [categoryIDArrayToServer removeObject:[categoryIDArray objectAtIndex:indexPath.row]];
        } else {
            
            [categoryIDArrayToServer addObject:[categoryIDArray objectAtIndex:indexPath.row]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
    }
    
}



-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    if (tableView == self.sortByTbl)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        
        //        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        //            cell.accessoryType = UITableViewCellAccessoryNone;
        //        } else {
        //            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.locationsTbl) {
        if (self.SearchController.active==YES) {
            isLocalitiesSearch = YES;
            return searchLocationNamesArr.count;
        }
        else
        return locationNamesArr.count;
    }
    
    else if(tableView == cityTbl)
    {
    return citiesArr.count;
    }
    else if (tableView == self.sortByTbl)
    {
    return sortByArray.count;
    }
    else if (tableView == cusinesTbl)
    {
        return cusinesArray.count;
    }//categoryArray
    else if (tableView == categoryTbl)
    {
        return categoryArray.count;
    }
    else
        return 0;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.locationsTbl) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (self.SearchController.isActive==YES) {
            
            cell.textLabel.text = [searchLocationNamesArr objectAtIndex:indexPath.row];
        }
        else
        {
        cell.textLabel.text = [locationNamesArr objectAtIndex:indexPath.row];
        }
        
        if ([cityIdStr isEqualToString:cityIdStrFromSelection]) {
           
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.backgroundColor = [UIColor clearColor];
        
        self.locationsTbl.backgroundColor =[UIColor clearColor];
        
        return cell;

    }
    else if(tableView == cityTbl)
    {

        
        static NSString *cellIdentifier = @"HistoryCell";
        
        // Similar to UITableViewCell, but
        UITableViewCell *cell = (UITableViewCell *)[cityTbl dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        // Just want to test, so I hardcode the data
        cell.textLabel.text = [citiesArr objectAtIndex:indexPath.row];
        
        return cell;
        
    }
    else if(tableView == self.sortByTbl)
    {
        
        
        static NSString *cellId = @"SortByCell";
        
        // Similar to UITableViewCell, but
        UITableViewCell *cell = (UITableViewCell *)[self.sortByTbl dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        // Just want to test, so I hardcode the data
        cell.textLabel.text = [sortByArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:@"icons8-home-page-80.png"];

        cell.imageView.hidden = YES;
        
//        if (singleTonInstance.sortByOptions.length)
//        {
//            NSString * strNo;
//            strNo = [NSString stringWithFormat:@"%d",indexPath.row];
//            if ([strNo isEqualToString:singleTonInstance.sortByOptions ] ) {
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            }
//        }
        
        
        return cell;
        
    }
    else if(tableView == cusinesTbl)
    {
        
        
        static NSString *celId = @"cusinesTbl";
        
        // Similar to UITableViewCell, but
        UITableViewCell *cell = (UITableViewCell *)[cusinesTbl dequeueReusableCellWithIdentifier:celId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celId];
        }
        // Just want to test, so I hardcode the data
        cell.textLabel.text = [cusinesArray objectAtIndex:indexPath.row];
        
       
        
        return cell;
        
    }
    
    else if(tableView == categoryTbl)
    {
        
        
        static NSString *celid = @"categoryTbl";
        
        // Similar to UITableViewCell, but
        UITableViewCell *cell = (UITableViewCell *)[categoryTbl dequeueReusableCellWithIdentifier:celid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celid];
        }
        // Just want to test, so I hardcode the data
        cell.textLabel.text = [categoryArray objectAtIndex:indexPath.row];
        
        
        
        return cell;
        
    }
    
    

    else
    {
        return nil;
    }
}

- (IBAction)dropDownListAction:(id)sender {
    if (isCityAvilable == YES)
    {
        [cityTbl reloadData];
        cityTbl.hidden = YES;
        
        isCityAvilable = NO;
        self.locationsTbl.userInteractionEnabled = NO;
        
    }

    else
    {
        self.locationsTbl.userInteractionEnabled = YES;
        [cityTbl reloadData];
        cityTbl.hidden = NO;
        isCityAvilable = YES;
    }
    
   
}




- (IBAction)locationsAction:(id)sender {
    
    self.SearchController.searchBar.hidden = NO;
    
    self.downArrowImg.hidden = NO;
    
    self.locationsTbl.hidden = NO;
    
    self.dropDownList.hidden = NO;
    
    [self.locationsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.cusinesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.categoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    
     self.locationsBtn.backgroundColor = REDCOLOR;
    self.cusinesBtn.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0f];

    self.categoryBtn.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0f];

    
    self.cuisines_img.image = [UIImage imageNamed:@"cuisines_black.png"];
    self.loc_img.image = [UIImage imageNamed:@"location_icon_white.png"];
    self.cat_img.image = [UIImage imageNamed:@"category_black.png"];
    


    
    //locationNamesArr = [[NSMutableArray alloc]initWithObjects:@"Gachibowli",@"Shamshabad",@"Kukatpally",@"Mallapur",@"Hi Tech City",@"KondaPur",@"Habsiguda",@"Jubilee Hills",@"Secunderabad",@"Vikarabad",@"Gachibowli",@"Erragadda", nil];
    
    cusinesTbl.hidden = YES;
    categoryTbl.hidden = YES;
    self.locationsTbl.hidden = NO;
    
   // [self.locationsTbl reloadData];
    
}

- (IBAction)cusinesAction:(id)sender {
    
    self.SearchController.searchBar.hidden = YES;
    
    self.downArrowImg.hidden = YES;
    
    self.dropDownList.hidden = YES;
    
    self.locationsTbl.hidden = YES;
    
    [self.locationsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.cusinesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.categoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    cusinesTbl.hidden = NO;
    categoryTbl.hidden = YES;
    
    self.cusinesBtn.backgroundColor = REDCOLOR;
    
    self.locationsBtn.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0f];

    self.categoryBtn.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0f];

    
    self.cuisines_img.image = [UIImage imageNamed:@"cuisines_white.png"];
    self.loc_img.image = [UIImage imageNamed:@"location_icon_black.png"];
    self.cat_img.image = [UIImage imageNamed:@"category_black.png"];
  

    
   // cusinesArray  = [[NSMutableArray alloc]initWithObjects:@"Caribbean",@"Chinese",@"French",@"Greek",@"Indian",@"Italian",@"Mangolian",@"Mexcian",@"Turkish",@"Thai",@"Spanish", nil];
     [self.view addSubview:cusinesTbl];
    [cusinesTbl reloadData];
}

- (IBAction)categoryAction:(id)sender {
    
    self.SearchController.searchBar.hidden = YES;
    
    self.downArrowImg.hidden = YES;
    
    self.dropDownList.hidden = YES;
    
    cityTbl.hidden = YES;
    
    [self.locationsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.cusinesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.categoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    cusinesTbl.hidden = YES;
    self.locationsTbl.hidden = YES;
    categoryTbl.hidden = NO;
    
    
    
    self.categoryBtn.backgroundColor = REDCOLOR;
    
    self.locationsBtn.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0f];

    self.cusinesBtn.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0f];

    
    
    self.cuisines_img.image = [UIImage imageNamed:@"cuisines_black.png"];
    self.loc_img.image = [UIImage imageNamed:@"location_icon_black.png"];
    self.cat_img.image = [UIImage imageNamed:@"category_white.png"];
    

    
    //categoryArray  = [[NSMutableArray alloc]initWithObjects:@"Restaurant",@"Cafe",@"Pub",@"Lounge", nil];
     [self.view addSubview:categoryTbl];
    [categoryTbl reloadData];
    
   
}

- (IBAction)filterBtnAction:(id)sender {
    [self locationsAction:self];
    cityTbl.hidden = YES;
    self.grayBackground.hidden = NO;
    self.sortByView.hidden = YES;
    self.sortByBtn.backgroundColor = [UIColor blackColor];
    self.locationsTbl.hidden = NO;
    
    self.filterBtn.backgroundColor = [UIColor colorWithRed:4.0f/255.0f green:99.0f/255.0f blue:6.0f/255.0f alpha:1.0f];
   
}

- (IBAction)sortByAction:(id)sender {
    
    self.SearchController.searchBar.hidden = YES;
    cityTbl.hidden = YES;
    self.grayBackground.hidden = YES;
    cusinesTbl.hidden = YES;
    categoryTbl.hidden  = YES;
    self.sortByView.hidden = NO;
    
    self.sortByBtn.backgroundColor = [UIColor colorWithRed:4.0f/255.0f green:99.0f/255.0f blue:6.0f/255.0f alpha:1.0f];
    self.filterBtn.backgroundColor = [UIColor blackColor];
  //  [self.sortByBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
   // [self.filterBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}


- (IBAction)applyAction:(id)sender {

    isApplyFilters = YES;
    [self filterServiceCall];
}


# pragma mark - search Delegates
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (searchController.searchBar.text.length>0) {
        NSLog(@"search starting");
        
        
        
        citySearchStr = searchController.searchBar.text;
        
        cityNameStr = searchController.searchBar.text;
        
        [self localitiesServiceCall];
        
        [self.locationsTbl reloadData];
        
        cityNameStr = nil;
        
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

    self.dropDownList.hidden = NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.dropDownList.hidden = YES;
    
    self.SearchController.hidesNavigationBarDuringPresentation = NO;
    
    [self.SearchController.searchBar setShowsCancelButton:NO];
    
    self.SearchController.dimsBackgroundDuringPresentation = NO;
    
}

# pragma mark - Webservice Delegates

-(void)citiesGetServiceCall
{
    if ([Utilities isInternetConnectionExists])
    {
//
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
NSError *error;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat: @"http://testingmadesimple.org/foody/api/services/cities"]]] options:kNilOptions error:&error];
    
    NSMutableArray * cities = [[NSMutableArray alloc]init];
    
    cities = [json objectForKey:@"cities"];
    
    for (int i = 0; i<cities.count; i++) {
        [citiesArr addObject:[[cities objectAtIndex:i] objectForKey:@"city_name"]];
        [citiesIDArr addObject:[[cities objectAtIndex:i] objectForKey:@"city_id"]];
        
    }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            // [ activityIndicatorView stopAnimating];
            [Utilities removeLoading:self.view];
            
            
        });
    NSLog(@"cities data %@",json);
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
    
}



-(void)getcuisinesServiceCall
{
    
    if ([Utilities isInternetConnectionExists])
    {
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        NSError *error;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat: @"http://testingmadesimple.org/foody/api/services/getcuisines"]]] options:kNilOptions error:&error];
        
        NSMutableArray * cusines = [[NSMutableArray alloc]init];
        
        cusines = [json objectForKey:@"cuisines"];
        
        for (int i = 0; i<cusines.count; i++) {
            [cusinesArray addObject:[[cusines objectAtIndex:i] objectForKey:@"cuisine_name"]];
            [cusinesIDArray addObject:[[cusines objectAtIndex:i] objectForKey:@"cuisine_id"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // [ activityIndicatorView stopAnimating];
            
            [Utilities removeLoading:self.view];
            
            
        });
        NSLog(@"cities data %@",json);
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
    

}





-(void)getcategoriesServiceCall
{
    
    
    if ([Utilities isInternetConnectionExists])
    {
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        NSError *error;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat: @"http://testingmadesimple.org/foody/api/services/getcategories"]]] options:kNilOptions error:&error];
        
        NSMutableArray * categories = [[NSMutableArray alloc]init];
        
        categories = [json objectForKey:@"categories"];
        
        for (int i = 0; i<categories.count; i++) {
            [categoryArray addObject:[[categories objectAtIndex:i] objectForKey:@"name"]];
            [categoryIDArray addObject:[[categories objectAtIndex:i] objectForKey:@"category_id"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // [ activityIndicatorView stopAnimating];
            [Utilities removeLoading:self.view];
            
            
        });
        NSLog(@"cities data %@",json);
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
    

}





-(void)localitiesServiceCall
{
    
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
       
        
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@localities",BASEURL];
        requestDict = @{
                        @"city_id":  [Utilities null_ValidationString:cityIdStr],
                        @"search_info":[Utilities null_ValidationString:cityNameStr]
                        
                        };
        
        NSLog(@"requestDict is %@",requestDict);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }

}




-(void)filterServiceCall
{
    
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        
        
      //  NSString *stringFromArray = [localitiesToServerArray componentsJoinedByString:@","];
        NSError * error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:localitiesToServerArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *strin = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
       NSString *stringFromArray =   [strin stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
      
       // NSString * categoriesStrToSend = [categoryIDArrayToServer componentsJoinedByString:@","];
        NSData *catJsonData = [NSJSONSerialization dataWithJSONObject:categoryIDArrayToServer options:NSJSONWritingPrettyPrinted error:&error];
        NSString *strin2 = [[NSString alloc] initWithData:catJsonData encoding:NSUTF8StringEncoding];
        NSString *categoriesStrToSend = [strin2
                                     stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString * catToSend =[categoriesStrToSend
                               stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        if (!categoryIDArrayToServer.count) {
            catToSend = nil;
            categoriesStrToSend= nil;
        }
        if (localitiesToServerArray.count<1) {
            stringFromArray = nil;
        }
        NSLog(@"categories to sertver are %@",categoriesStrToSend);
        
        NSString * mylati = [[NSNumber numberWithFloat:singleTonInstance.latiNum] stringValue];
        
        NSString * mylongi = [[NSNumber numberWithFloat:singleTonInstance.longiNum] stringValue];
        
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@merchantfilters",BASEURL];
        
        if (self.isEventFilter == YES) {
            
        }
        
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"latitude":mylati,
                        @"longitude":mylongi,
                        @"sort_type":[Utilities null_ValidationString:sortTypeStr],
                        @"sort_value":[Utilities null_ValidationString:sortValueStr],
                        @"cuisines":@"",
                        @"categories":[Utilities null_ValidationString:categoriesStrToSend],
                        @"localities":[Utilities null_ValidationString:stringFromArray]
                        
                        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ServiceManager *service = [ServiceManager sharedInstance];
            service.delegate = self;
            
            [service  handleRequestWithDelegates:urlStr info:requestDict];
            
        });
        
    }
    else
    {
        [Utilities displayCustemAlertViewWithOutImage:@"Internet connection error" :self.view];
        
    }
}




- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        // [ activityIndicatorView stopAnimating];
        [Utilities removeLoading:self.view];
        [Utilities displayCustemAlertViewWithOutImage:@"Failed to getting data" :self.view];
        
    });
}
-(void)handleResponse :(NSDictionary *)responseInfo
{
    NSLog(@"responseInfo %@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (isApplyFilters == YES) {
                    
                    
                    
                    NSLog(@"/n/n/n/n result of filtres %@ /n/n/n/n",responseInfo);
                    
                    if (self.isFromHomeMenu == YES) {
                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                             filterResultViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"filterResultViewController"];
                                            menu.resultDict = responseInfo;
                        self.isFromHomeMenu = NO;
                                            [self.navigationController pushViewController:menu animated:YES];
                    }
                    else if (self.isEventFilter == YES)
                    {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        filterResultViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"filterResultViewController"];
                        menu.resultDict = responseInfo;
                        self.isEventFilter = NO;
                        menu.isfromEventMenu = YES;
                        [self.navigationController pushViewController:menu animated:YES];
                    }
                    else
                    {
                        
                        singleTonInstance.filterResultArray = [responseInfo valueForKey:@"response"];
                        singleTonInstance.isHomeFilter = YES;
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                    isApplyFilters = NO;
                    
                }
                else
                {
                    
                    if (isForLocalities == YES && isLocalitiesSearch == NO)
                    {
                        
                        
                        locationNamesArr = [[NSMutableArray alloc]init];
                        locationIDArr = [[NSMutableArray alloc]init];
                        
                        
                        NSMutableArray * localities = [[NSMutableArray alloc]init];
                        
                        localities = [responseInfo objectForKey:@"localities"];
                        
                        for (int i = 0; i<localities.count; i++) {
                            
                            [locationNamesArr addObject:[[localities objectAtIndex:i] objectForKey:@"locality_name"]];
                            [locationIDArr  addObject:[[localities objectAtIndex:i] objectForKey:@"locality_id"]];
                        }
                        
                        [self.locationsTbl reloadData];
                        isForLocalities = NO;
                        
                    }
                    if (isForLocalities == NO && isLocalitiesSearch == YES)
                    {
                        
                        
                        searchLocationNamesArr = [[NSMutableArray alloc]init];
                        searchLocationIDArr = [[NSMutableArray alloc]init];
                        
                        
                        NSMutableArray * localities = [[NSMutableArray alloc]init];
                        
                        localities = [responseInfo objectForKey:@"localities"];
                        
                        for (int i = 0; i<localities.count; i++) {
                            
                            [searchLocationNamesArr addObject:[[localities objectAtIndex:i] objectForKey:@"locality_name"]];
                            [searchLocationIDArr  addObject:[[localities objectAtIndex:i] objectForKey:@"locality_id"]];
                        }
                        
                        [self.locationsTbl reloadData];
                        isForLocalities = NO;
                        isLocalitiesSearch = NO;
                    }
                    
                    
                }
               

            });
            
            
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isForLocalities==YES)
                {
                    [locationNamesArr removeAllObjects];
                    [locationIDArr removeAllObjects];
                    [self.locationsTbl reloadData];
                    [Utilities displayToastWithMessage:@"No Data Found"];
                    isForLocalities = NO;
                    
                }
                else
                {
                    NSString *str = [NSString stringWithFormat:@"%@",[responseInfo valueForKey:@"result"]];
                    [Utilities displayCustemAlertViewWithOutImage:str :self.view];
                }
                
                
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //[ activityIndicatorView stopAnimating];
            [Utilities removeLoading:self.view];
        });
        
    }
    
    @catch (NSException *exception) {
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[ activityIndicatorView stopAnimating];
            [Utilities removeLoading:self.view];
        });
        [self.view endEditing:YES];
    }
    
}













@end
