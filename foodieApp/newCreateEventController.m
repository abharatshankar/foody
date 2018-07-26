//
//  newCreateEventController.m
//  foodieApp
//
//  Created by ashwin challa on 2/7/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "newCreateEventController.h"
#import "addInvitationTableViewCell.h"
#import "SWRevealViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "Constants.h"
#import "ISMessages.h"
#import "SingleTon.h"
#import "creatingEventViewController.h"

@interface newCreateEventController ()<UISearchResultsUpdating,UISearchBarDelegate>
{
    NSMutableArray  * invitesArray,
                    * invitesSendArray,
                    * contactsArray,
                    * contactsSendArray,
                    * totalContactsArr,
                    * contactIdArray;
    
    
    NSMutableDictionary * invitesDict;
    NSString *jsonContacts;

    SingleTon *  singleTonInstance;//march 8th
    NSString *jsonString;
    NSMutableArray *contactList,*filteredArray,*pathStoreArray,* pathStoreArray2;
    BOOL * isIvitesSend;
    BOOL * isAddEventMembers;

}
@end

@implementation newCreateEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contactsListTbl.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    singleTonInstance=[SingleTon singleTonMethod];//march 8th
    singleTonInstance.invitesSendArray = [[NSMutableArray alloc]init];//march 8th
    singleTonInstance.contactsSendArray = [[NSMutableArray alloc]init];
    pathStoreArray = [[NSMutableArray alloc]init];
    pathStoreArray2 = [[NSMutableArray alloc]init];
    totalContactsArr = [[NSMutableArray alloc]init];
    
    //Search Controller & Search Bar
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    self.contactsListTbl.tableHeaderView=self.searchController.searchBar;
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.delegate=self;
    
    contactsSendArray = [[NSMutableArray alloc]init];
    contactsArray = [[NSMutableArray alloc]init];
    invitesArray = [[NSMutableArray alloc]init];
    invitesSendArray = [[NSMutableArray alloc]init];
    filteredArray = [[NSMutableArray alloc]init];
    contactIdArray = [[NSMutableArray alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    SWRevealViewController*sw=[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    _menu.target=sw.revealViewController;
    _menu.action=@selector(revealToggle:);
    [self.menu setImage:[UIImage imageNamed:@"toogle_menu_icon.png"]];
    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    
    // this is for background color of navigation bar
    self.navigationController.navigationBar.barTintColor = REDCOLOR;
    
    // this is for navigation bar title color
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    //////////////////////////////////////////////////////////////////////////
    ////////////////  this is to set title in navigation bar  ////////////////
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    //for right bar buttons
    
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(0, 0, 30, 22);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[btntitle setTitle:@"Nearby Bars" forState:UIControlStateNormal];
    [btntitle setImage:[UIImage imageNamed:@"icons8-left-24.png"] forState:UIControlStateNormal];
    
    NSLayoutConstraint * widthConstraint = [btntitle.widthAnchor constraintEqualToConstant:30];
    NSLayoutConstraint * HeightConstraint =[btntitle.heightAnchor constraintEqualToConstant:30];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
      [btntitle addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [btntitle addTarget:sw.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addGestureRecognizer:sw.panGestureRecognizer];
    
    
    btntitle.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(275, 5, 50, 15);
    [phoneButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    phoneButton.showsTouchWhenHighlighted=YES;
    
    
    UIBarButtonItem * phoneBarItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
   // [arrRightBarItems addObject:phoneBarItem];
    phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [phoneButton setTitle:@"Next" forState:UIControlStateNormal];
    //[phoneButton setImage:[UIImage imageNamed:@"invite_icon.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(275, 5, 50, 15);
    [skipButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    skipButton.showsTouchWhenHighlighted=YES;
    
    UIBarButtonItem * skipBarItem = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
   // [arrRightBarItems addObject:skipBarItem];
    skipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    //[phoneButton setImage:[UIImage imageNamed:@"invite_icon.png"] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btntitle4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle4.frame = CGRectMake(30, 0, 120, 30);
    [btntitle4 setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle4.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem34 = [[UIBarButtonItem alloc] initWithCustomView:btntitle4];
    [arrLeftBarItems addObject:barButtonItem34];
    btntitle4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle4 setTitle:@"Create Event" forState:UIControlStateNormal];
    [btntitle4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    self.contactsListTbl.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    
    //    UIView * sampView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 49)];
    //    sampView.backgroundColor = [UIColor blueColor];
    //    [arrLeftBarItems addObject:sampView];
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    
    
    
//    self.title = @"Create Event";
//    // to change title color
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self toAccessContacts];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toAccessContacts
{
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //        dispatch_release(semaphore);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
        
        NSData* data = [ NSJSONSerialization dataWithJSONObject:contactList options:NSJSONWritingPrettyPrinted error:nil ];
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self userPhonebookserviceCall];
    }
    else
    {
        // if user click on deny access to contacts this alert will called
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Contacts Access"
                                                        message:@"To re-enable, please go to Settings and turn on Allow Contacts for this app."
                                                       delegate:self
                                              cancelButtonTitle:@"Settings"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{

    
    
    self.tabBarController.tabBar.hidden = NO;
    self.searchController.searchBar.hidden = NO;
    
    [self toAccessContacts];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.searchController.searchBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Search Implementation
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
{
   
        NSPredicate * predicate=[NSPredicate predicateWithFormat:@"SELF contains[c]%@",self.searchController.searchBar.text];
        
        NSMutableArray * NamesSearchArray = [[NSMutableArray alloc]init];
        
        NSMutableArray * filteredNames = [[NSMutableArray alloc]init];
    
    NSMutableArray * allMixNames = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<invitesArray.count; i++) {
            [NamesSearchArray addObject:[[invitesArray objectAtIndex:i] objectForKey:@"name"]];
            [allMixNames addObject:[invitesArray objectAtIndex:i]];
        }
    
    for (int i = 0; i<contactsArray.count; i++) {
        [NamesSearchArray addObject:[[contactsArray objectAtIndex:i] objectForKey:@"name"]];
        [allMixNames addObject:[contactsArray objectAtIndex:i]];
    }
        
        filteredNames = [NamesSearchArray filteredArrayUsingPredicate:predicate];
    
    filteredArray = [[NSMutableArray alloc]init];
    
    NSLog(@" -- - - %d",NamesSearchArray.count);
    
        for (int i=0; i<filteredNames.count; i++) {
         
            for (int k=0; k<allMixNames.count; k++) {
                if ([[[allMixNames objectAtIndex:k] objectForKey:@"name"] isEqualToString:[filteredNames objectAtIndex:i]])
                {
                    [filteredArray addObject:[allMixNames objectAtIndex:k]];
                    
                }
            }
        }
    
        [self.contactsListTbl reloadData];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                       // called when text ends editing
{

}

- (void)searchTableList
{
    NSString *searchString = self.searchController.searchBar.text;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    [self.searchController.searchBar setShowsCancelButton:NO];
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    searchBar = self.searchController.searchBar;
    
    [searchBar setShowsCancelButton:NO];
    
    //Remove all objects first.
    ////[filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        //isSearching = YES;
        [searchBar setShowsCancelButton:NO];
        [self searchTableList];
    }
    else {
        //isSearching = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [filteredArray removeAllObjects];
            [searchBar setShowsCancelButton:YES];
            
            [self.contactsListTbl reloadData];
        });
        
        
    }
[self.contactsListTbl reloadData];

}



-(void)nextAction
{
//creatingEventViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    creatingEventViewController *invite = [storyboard instantiateViewControllerWithIdentifier:@"creatingEventViewController"];
    [self.navigationController pushViewController:invite animated:YES];

}

- (IBAction)inviteFriendsAct:(id)sender {
    
    
     dispatch_async(dispatch_get_main_queue(), ^{
    isAddEventMembers = YES;
    
    if (contactIdArray.count>0) {
        
//        for (int i = 0; i<contactIdArray.count; i++) {
//
//            if (invitesArray.count) {
//                for (int j =0; j<invitesArray.count; i++) {
//                    if ([[contactIdArray objectAtIndex:i] intValue] == [[invitesArray objectAtIndex:j] objectForKey:@"contact_id"]) {
//                        [invitesSendArray addObject:[invitesArray objectAtIndex:j] ];
//                    }
//                }
//            }
//
//            if (contactsArray.count) {
//                for (int k =0; k<contactsArray.count; i++) {
//                    if ([[[contactsArray objectAtIndex:k] objectForKey:@"contact_id"] intValue] == [[contactIdArray objectAtIndex:i] intValue]) {
//                        [contactsSendArray addObject:[contactsArray objectAtIndex:k] ];
//                    }
//                }
//            }
//        }
        
    }
    
   
    
    if (invitesSendArray.count>0 || contactsSendArray.count>0) {
        [self addMembersToService];
    }
    else
    {
        [Utilities displayToastWithMessage:@"Select atleast one contact."];
    }
    
     });
}


#pragma mark - if user deny redirect to settings

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////if user denine to access contacts/////////////////////////////////////
/////////////////////////on tap of settings alert this will redirect to settings in device///////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if (&UIApplicationOpenSettingsURLString != NULL) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
        else {
            // Present some dialog telling the user to open the settings app.
        }
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////--------------end of code---------------//////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////



#pragma mark - contact access methods


// Get the contacts.
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        NSMutableDictionary *mobiledict=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName, companyName;
        companyName = ABRecordCopyValue(ref, kABPersonOrganizationProperty);
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        
        NSString * fna = [NSString stringWithFormat:@"%@",firstName];
        
        NSString * lna = [NSString stringWithFormat:@"%@",lastName];
        
        
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@",[Utilities null_ValidationString:fna] ,[Utilities null_ValidationString:lna]] forKey:@"name"];
        
        [dOfPerson setObject:[NSString stringWithFormat:@"%@", companyName] forKey:@"company"];
        
        // [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //contact id
        ABRecordID recordID = ABRecordGetRecordID(ref);
        NSString *strid=[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(int)recordID]];
        
        [dOfPerson setObject:strid forKey:@"contact_id"];
        
        
        // For getting the user image.
        UIImage *contactImage;
        if(ABPersonHasImageData(ref)){
            contactImage = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(ref)];
            
            
        }
        
        
        //        //For Phone number
        //        NSString* mobileLabel;
        //
        //        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
        //            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
        //            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
        //            {
        //                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
        //            }
        //            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
        //            {
        //                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
        //                break ;
        //            }
        //
        //        }
        
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            
            
            
            
            
            if([mobileLabel isEqualToString:(NSString *)kABHomeLabel])
            {
                [mobiledict setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"home"];
            }
            if([mobileLabel isEqualToString:(NSString *)kABWorkLabel])
            {
                [mobiledict setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"work"];
            }
            
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                NSLog(@"mobile no conditions: %@",(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i));
                NSString *firstName=[NSString stringWithFormat:@"%@",(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i)];
                if (firstName == nil || firstName == ((id)[NSNull null]) || firstName.length == 0)
                {
                    
                }
                else
                {
                    NSString  *strno = [firstName stringByReplacingOccurrencesOfString:@"+91"
                                                                            withString:@""];
                    
                    [mobiledict setObject:strno forKey:@"mobile"];
                    
                }
            }
            /********************/
            /*    else if ([maillabel isEqualToString:(NSString*)kABPersonEmailProperty])
             {
             [mobiledict setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
             break ;
             }
             
             
             }
             if (mobiledict == nil || mobiledict == ((id)[NSNull null]) || mobiledict.count == 0)
             {
             
             }
             else
             [dOfPerson setObject:mobiledict forKey:@"email"];
             [contactList addObject:dOfPerson];
             
             */
            
            /************/
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [mobiledict setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"phone"];
                break ;
            }
            
            
        }
        if (mobiledict == nil || mobiledict == ((id)[NSNull null]) || mobiledict.count == 0)
        {
            
        }
        else
        {
            if ([mobiledict objectForKey:@"mobile"]) {
                [dOfPerson setObject:[mobiledict objectForKey:@"mobile"] forKey:@"mobilenumber"];
            }
            else if ([mobiledict objectForKey:@"home"])
            {
                [dOfPerson setObject:[mobiledict objectForKey:@"home"] forKey:@"mobilenumber"];
                
            }
            else if ([mobiledict objectForKey:@"work"])
            {
                [dOfPerson setObject:[mobiledict objectForKey:@"work"] forKey:@"mobilenumber"];
                
            }
            
            
        }
        
        
        if([dOfPerson valueForKey:@"mobilenumber"] != nil) {
            // The key existed...
            [contactList addObject:dOfPerson];
        }
        else {
            // No joy...
            
        }
        
        
        
        
    }
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.isActive)
    {
        return filteredArray.count;
    }
    else
    {
        if (section == 0) {
            return invitesArray.count;
        }
        else
            return contactsArray.count;
    }
    
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section    // fixed font style. use custom view (UILabel) if you want something different
{

    if (section == 0) {
        if (filteredArray.count) {
            return @"search result";
        }
        else
        return @"Invited List";
    }
    else
        return @"Contacts List";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (filteredArray.count) {
        return 1;
    }
    else
    return 2;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    addInvitationTableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        
        if (self.searchController.isActive)
        {
            if ([filteredArray containsObject:[filteredArray objectAtIndex:path.row]])
            {
                
                [singleTonInstance.invitesSendArray removeObject:[filteredArray objectAtIndex:path.row]];
                
              //  [filteredArray removeObject:[filteredArray objectAtIndex:path.row]] ;
                
                
                if ([contactIdArray containsObject:[[filteredArray objectAtIndex:path.row] objectForKey:@"contact_id"]]) {
                   [contactIdArray removeObject:[[filteredArray objectAtIndex:path.row] objectForKey:@"contact_id"] ];
                    [invitesSendArray removeObject:[filteredArray objectAtIndex:path.row]  ];
                }
                
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else
        {
            
            
            if (path.section == 0) {
                
                if ([invitesSendArray containsObject:[invitesArray objectAtIndex:path.row]])
                {
                    
                    //  [invitesSendArray removeObject:[invitesArray objectAtIndex:path.row]] ;
                    
                    //march 8th
                    [singleTonInstance.invitesSendArray removeObject:[invitesArray objectAtIndex:path.row]];
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    // if ([pathStoreArray containsObject:[NSString stringWithFormat:@"%d", path.row ]]) {
                    [pathStoreArray removeObject:path];
                    [contactIdArray removeObject:[[invitesArray objectAtIndex:path.row] objectForKey:@"contact_id"] ];
                    // }
                    //singleTonInstance.invitesSendArray is to send selected contacts to service
                }
            }
            else if (path.section == 1)
            {
                
                if ([contactsSendArray containsObject:[contactsArray objectAtIndex:path.row]])
                {
                    
                    //  [invitesSendArray removeObject:[invitesArray objectAtIndex:path.row]] ;
                    
                    //march 8th
                    [singleTonInstance.contactsSendArray removeObject:[contactsArray objectAtIndex:path.row]];
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    // if ([pathStoreArray containsObject:[NSString stringWithFormat:@"%d", path.row ]]) {
                    [pathStoreArray2 removeObject:path];
                    [contactIdArray removeObject:[[contactsArray objectAtIndex:path.row] objectForKey:@"contact_id"] ];
                    // }
                    //singleTonInstance.invitesSendArray is to send selected contacts to service
                }
            }
                
            
        }
        
        
        
        
    }
    else {
        
        if (self.searchController.isActive) {
            
            
        [filteredArray addObject:[filteredArray objectAtIndex:path.row]] ;
            [singleTonInstance.invitesSendArray addObject:[filteredArray objectAtIndex:path.row]];
            
            
            
            
            [contactIdArray addObject:[[filteredArray objectAtIndex:path.row] objectForKey:@"contact_id"] ];
            [invitesSendArray addObject:[filteredArray objectAtIndex:path.row]  ];
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            
            if (path.section == 0) {
                
                [invitesSendArray addObject:[invitesArray objectAtIndex:path.row]] ;
                
                //march 8th
                [singleTonInstance.invitesSendArray addObject:[invitesArray objectAtIndex:path.row]];
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                [pathStoreArray addObject:path];
                [contactIdArray addObject:[[invitesArray objectAtIndex:path.row] objectForKey:@"contact_id"] ];
            }
            else
            {
                [contactsSendArray addObject:[contactsArray objectAtIndex:path.row]] ;
                
                [singleTonInstance.contactsSendArray addObject:[contactsArray objectAtIndex:path.row]];
                
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                [pathStoreArray2 addObject:path];
                [contactIdArray addObject:[[contactsArray objectAtIndex:path.row] objectForKey:@"contact_id"] ];
            
            }
            
        }
        
        
        
    }
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"addInvitationTableViewCell";
    
    addInvitationTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[addInvitationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    
    
    cell.profileImg.hidden = YES;
    
    
    
    if (self.searchController.isActive)
    {
        
        [Utilities null_ValidationString:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        //[Utilities null_ValidationString:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"lname"]];
        
        cell.nameLbl.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
        cell.phoneNumberLbl.text =[NSString stringWithFormat:@"Home - %@",[Utilities null_ValidationString:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"]]] ;
        
        cell.workPhoneNumLbl.text =[NSString stringWithFormat:@"Work - %@",[Utilities null_ValidationString:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"]]] ;
        cell.mobilePhoneLbl.text  =[NSString stringWithFormat:@"Mobile - %@",[Utilities null_ValidationString:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"]]] ;
        
//        if ([self contactPicture:[[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]] == nil)
//        {
//            //                user_male2-512.png
//            [cell.profileImg setImage:[UIImage imageNamed:@"name_icon.png"]];
//        }
//        else
//        {
//            [cell.profileImg setImage:[self contactPicture:[[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]]];
//
//        }
        
        if ([contactIdArray containsObject:[[filteredArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] ]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        
        
        
    }
    else
    {
        
        if (indexPath.section == 0) {
            
            
            
            
            
            
            [Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
            // [Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"lname"]];
            
            cell.nameLbl.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
            
            cell.phoneNumberLbl.text =[NSString stringWithFormat:@"Home - %@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] ]] ;
            
            cell.workPhoneNumLbl.text =[NSString stringWithFormat:@"Work - %@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] ]] ;
            cell.mobilePhoneLbl.text  =[NSString stringWithFormat:@"Mobile - %@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] ]] ;
            
            if ([self contactPicture:[[[invitesArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]] == nil)
            {
                //                user_male2-512.png
                [cell.profileImg setImage:[UIImage imageNamed:@"name_icon.png"]];
            }
            else
            {
                [cell.profileImg setImage:[self contactPicture:[[[invitesArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]]];
                
            }
            
            
            
            
            //this is to maintain checkmarks if user alerady selected
            
            if ( [pathStoreArray containsObject:indexPath]) {
                NSLog(@"- - - -%d",indexPath.row);
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            
            if ([contactIdArray containsObject:[[invitesArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] ]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            
            
        }
        else if (indexPath.section == 1)
        {
        
            
            
            
            
            
            
            [Utilities null_ValidationString:[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
            // [Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"lname"]];
            
            cell.nameLbl.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
            
//            cell.phoneNumberLbl.text =[NSString stringWithFormat:@"Home - %@",[Utilities null_ValidationString:[[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"home"]]] ;
//
//            cell.workPhoneNumLbl.text =[NSString stringWithFormat:@"Work - %@",[Utilities null_ValidationString:[[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"work"]]] ;
            cell.mobilePhoneLbl.text  =[NSString stringWithFormat:@"Mobile - %@",[Utilities null_ValidationString:[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] ]] ;
            
            if ([self contactPicture:[[[contactsArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]] == nil)
            {
                //                user_male2-512.png
                [cell.profileImg setImage:[UIImage imageNamed:@"name_icon.png"]];
            }
            else
            {
                [cell.profileImg setImage:[self contactPicture:[[[contactsArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]]];
                
            }
            
            
            
            
            //this is to maintain checkmarks if user alerady selected
            
            if ( [pathStoreArray2 containsObject:indexPath]) {
                NSLog(@"- - - -%d",indexPath.row);
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            
            
            if ([contactIdArray containsObject:[[contactsArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    cell.profileImg.clipsToBounds =YES;
    cell.profileImg.layer.cornerRadius = 23;
    [Utilities roundCornerImageView:cell.profileImg];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}



#pragma mark - contacts animation methods
//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}


//Helper function to get a random float
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (UIColor*)colorFromIndex:(int)index{
    UIColor *color;
    
    //Purple
    if(index % 3 == 0){
        color = [UIColor colorWithRed:0.93 green:0.01 blue:0.55 alpha:1.0];
        //Blue
    }else if(index % 3 == 1){
        color = [UIColor colorWithRed:0.00 green:0.68 blue:0.94 alpha:1.0];
        //Blk
    }else if(index % 3 == 2){
        color = [UIColor blackColor];
    }
    else if(index % 3 == 3){
        color = [UIColor colorWithRed:0.00 green:1.0 blue:0.00 alpha:1.0];
    }
    
    
    return color;
    
}















#pragma mark - service calls methods







-(void)addMembersToService
{
    
    [totalContactsArr removeAllObjects];
    
    if ([Utilities isInternetConnectionExists])
    {
        
        for (int i = 0; i<invitesSendArray.count; i++) {
            [totalContactsArr addObject:[invitesSendArray objectAtIndex:i]];
        }
        
        for (int i=0; i<contactsSendArray.count; i++) {
            [totalContactsArr addObject:[contactsSendArray objectAtIndex:i]];
        }
        
        
        
        NSData* data = [ NSJSONSerialization dataWithJSONObject:totalContactsArr options:NSJSONWritingPrettyPrinted error:nil ];
        jsonContacts = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSString *newString = [[jsonContacts componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        NSInteger * eventIdNum = [self.eventIdStr intValue];
        
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@addEventMember",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"event_members":newString,
                        @"event_id":[NSString stringWithFormat:@"%d",eventIdNum]
                        
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






-(void)userPhonebookserviceCall
{
    //    CLLocationCoordinate2D coordinate = [self getLocation];
    //    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //
    
    if ([Utilities isInternetConnectionExists])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
        });
        
        NSString *newString = [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        NSDictionary *requestDict;
        NSString *urlStr = [NSString stringWithFormat:@"%@userPhonebook",BASEURL];
        requestDict = @{
                        @"user_id":[Utilities getUserID],
                        @"user_phonebook":newString
                        
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

// Return picture from contact
- (UIImage *) contactPicture:(NSInteger)contactId {
    // Get contact from Address Book
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordID recordId = (ABRecordID)contactId;
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordId);
    
    // Check for contact picture
    if (person != nil && ABPersonHasImageData(person)) {
        if ( &ABPersonCopyImageDataWithFormat != nil ) {
            // iOS >= 4.1
            return [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
        } else {
            // iOS < 4.1
            return [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(person)];
        }
    } else {
        return nil;
    }
}


- (void)responseDic:(NSDictionary *)info
{
    [self handleResponse:info];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self handleResponse:info];
        
        
    });
    
    
}
- (void)failResponse:(NSError*)error
{
    ////@"Error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities removeLoading:self.view];
        //[ activityIndicatorView stopAnimating];
        
    });
}

-(void)handleResponse :(NSDictionary *)responseInfo
{
    
    NSLog(@"responseInfo addinvitation:%@",responseInfo);
    @try {
        if([[responseInfo valueForKey:@"status"] intValue] == 1)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isIvitesSend)
                {
                    NSLog(@"invites sent %@",responseInfo);
                    
                    [Utilities displayToastWithMessage:@"Invitation sent successfully"];
                    [self.navigationController popViewControllerAnimated:YES];
                    //                    [ISMessages showCardAlertWithTitle:nil
                    //                                               message:@"Invitation sent successfully"
                    //                                              duration:3.f
                    //                                           hideOnSwipe:YES
                    //                                             hideOnTap:YES
                    //                                             alertType:ISAlertTypeSuccess
                    //                                         alertPosition:ISAlertPositionBottom
                    //                                               didHide:^(BOOL finished) {
                    //                                                   NSLog(@"Alert did hide.");
                    //                                                   [self.navigationController popViewControllerAnimated:YES];
                    //                                               }];
                }
                else if (isAddEventMembers == YES)
                {
                    
                    [Utilities displayToastWithMessage:@"Invitation Sent Successfully"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    isAddEventMembers = NO;
                }
                else
                {
                    invitesArray = [responseInfo valueForKey:@"invite_list"];
                    
                    contactsArray = [responseInfo valueForKey:@"contact_list"];
                    
                    [self.contactsListTbl reloadData];
                    
                }
                
                
                
            });
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utilities removeLoading:self.view];
                
            });
            
            
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
