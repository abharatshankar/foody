//
//  addInvitationViewController.m
//  foodieApp
//
//  Created by ashwin challa on 12/13/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "addInvitationViewController.h"
#import "addInvitationTableViewCell.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SingleTon.h"
#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "Constants.h"
#import "ISMessages.h"
#import "SingleTon.h"
#import <MapKit/MapKit.h>



@interface addInvitationViewController ()<UISearchResultsUpdating,UISearchBarDelegate>
{
    NSMutableArray  * invitesArray,
                    *invitesSendArray,
                    *contactsArray,
                    *contactsSendArray,*pathStoreArray;
    SingleTon *  singleTonInstance;//march 8th
    NSString *jsonString;
     NSMutableArray *contactList,*filteredArray;
    BOOL * isIvitesSend;
}
@end

@implementation addInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    contactsArray = [[NSMutableArray alloc]init];
    contactsSendArray = [[NSMutableArray alloc]init];
    invitesArray = [[NSMutableArray alloc]init];
    invitesSendArray = [[NSMutableArray alloc]init];
    
    pathStoreArray = [[NSMutableArray alloc]init];
    
    singleTonInstance=[SingleTon singleTonMethod];//march 8th
    singleTonInstance.invitesSendArr = [[NSMutableArray alloc]init];
    
    self.addinvitationTbl.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
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
    
    
    
    
    UIButton *btntitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btntitle.frame = CGRectMake(30, 0, 120, 30);
    [btntitle setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    btntitle.showsTouchWhenHighlighted=YES;
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:btntitle];
    [arrLeftBarItems addObject:barButtonItem3];
    btntitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btntitle setTitle:@"Invite Friends" forState:UIControlStateNormal];
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
   
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    //Search Controller & Search Bar
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    self.addinvitationTbl.tableHeaderView=self.searchController.searchBar;
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.delegate=self;

    filteredArray = [[NSMutableArray alloc]init];


    
    //self.title = @"Invite Friends";
    // to change title color 
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
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
   
    
    // Do any additional setup after loading the view.
}





-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:YES];
}



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









-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}








#pragma mark - Search Implementation
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
{
    
    NSPredicate * predicate=[NSPredicate predicateWithFormat:@"SELF contains[c]%@",self.searchController.searchBar.text];
    
    NSMutableArray * NamesSearchArray = [[NSMutableArray alloc]init];
    
    NSMutableArray * filteredNames = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<invitesArray.count; i++) {
        [NamesSearchArray addObject:[[invitesArray objectAtIndex:i] objectForKey:@"name"]];
    }
    
    filteredNames = [NamesSearchArray filteredArrayUsingPredicate:predicate];
    
    filteredArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<filteredNames.count; i++) {
        
        for (int k=0; k<invitesArray.count; k++) {
            if ([[[invitesArray objectAtIndex:k] objectForKey:@"name"] isEqualToString:[filteredNames objectAtIndex:i]])
            {
                [filteredArray addObject:[invitesArray objectAtIndex:k]];
            }
        }
    }
    
    
    [self.addinvitationTbl reloadData];
    
    //FFFFFFFFB5647722E83C4AC897B276E76F5B7691
    
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
            
            [self.addinvitationTbl reloadData];
        });
        
        
    }
    [self.addinvitationTbl reloadData];
    
}













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
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName,lastName] forKey:@"name"];
       // [dOfPerson setObject:[NSString stringWithFormat:@"%@", lastName] forKey:@"lname"];
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
            [dOfPerson setObject:mobiledict forKey:@"mobilenumber"];
        [contactList addObject:dOfPerson];
        
    }
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

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
        {
            return contactsArray.count;
        }
    }
    
    


}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    addInvitationTableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        
        if (self.searchController.isActive)
        {
            if ([filteredArray containsObject:[filteredArray objectAtIndex:path.row]])
            {
                
                [singleTonInstance.invitesSendArr removeObject:[filteredArray objectAtIndex:path.row]];
                
                [filteredArray removeObject:[filteredArray objectAtIndex:path.row]] ;
                
                
                
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else
        {
            
            if (path.section == 0) {
                if ([invitesSendArray containsObject:[invitesArray objectAtIndex:path.row]])
                {
                    
                    [invitesSendArray removeObject:[invitesArray objectAtIndex:path.row]] ;
                    
                    //march 8th
                    [singleTonInstance.invitesSendArr removeObject:[invitesArray objectAtIndex:path.row]];
                    
                     [pathStoreArray removeObject:path];
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    // singleTonInstance.invitesSendArr is to send selected contacts to service
                }
            }
            else if ([contactsSendArray containsObject:[contactsArray objectAtIndex:path.row]])
            {
                [contactsSendArray removeObject:[contactsArray objectAtIndex:path.row]] ;
                
                [pathStoreArray removeObject:path];

                
                //march 8th
                [singleTonInstance.contactsSendArray removeObject:[contactsArray objectAtIndex:path.row]];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            
        }
        
        
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (self.searchController.isActive) {
            [filteredArray addObject:[filteredArray objectAtIndex:path.row]] ;
            [singleTonInstance.invitesSendArr addObject:[filteredArray objectAtIndex:path.row]];
        }
        else
        {
            if (path.section == 0) {
                [invitesSendArray addObject:[invitesArray objectAtIndex:path.row]] ;
                
                [pathStoreArray addObject:path];
                
                //march 8th
                [singleTonInstance.invitesSendArr addObject:[invitesArray objectAtIndex:path.row]];
            }
            else
            {
                [contactsSendArray addObject:[contactsArray objectAtIndex:path.row]] ;
                
                 [pathStoreArray addObject:path];
                
                //march 8th
                [singleTonInstance.contactsSendArray addObject:[contactsArray objectAtIndex:path.row]];
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
    
    
//    cell.nameLbl.text = [NSString stringWithFormat:@"%@ %@",
//                         [Utilities null_ValidationString:[invitesArray objectAtIndex:indexPath.row] objectForKey:@"fname"],
//                        [Utilities null_ValidationString:[invitesArray objectAtIndex:indexPath.row] objectForKey:@"lname"]];
    
    
    
    if (indexPath.section == 0) {
        
        [Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        //[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"lname"]];
        
        cell.nameLbl.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
        //cell.nameLbl.text = [NSString stringWithFormat:@"%@ %@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"fname"]],[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"lname"]]];
        
        cell.phoneNumberLbl.text =[NSString stringWithFormat:@"Home - %@",[Utilities null_ValidationString:[[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"home"]]] ;
        
        cell.workPhoneNumLbl.text =[NSString stringWithFormat:@"Work - %@",[Utilities null_ValidationString:[[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"work"]]] ;
        
        NSString * homeNum = [Utilities null_ValidationString:[[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"home"]] ;
        
        NSString * workNum = [Utilities null_ValidationString:[[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"work"]] ;
        
        NSString * mobiNum = [Utilities null_ValidationString:[[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"mobile"]];
        
        if (homeNum.length>5) {
            //cell.mobilePhoneLbl.text  =[NSString stringWithFormat:@"Mobile - %@",[Utilities null_ValidationString:[[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"mobile"]]] ;
            
            cell.mobilePhoneLbl.text  =homeNum ;
        }
        else if (workNum.length>5)
        {
        cell.mobilePhoneLbl.text  =workNum ;
        }
        else
            cell.mobilePhoneLbl.text = mobiNum;
        
        
        
        if ([self contactPicture:[[[invitesArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]] == nil)
        {
            //                user_male2-512.png
            [cell.profileImg setImage:[UIImage imageNamed:@"name_icon.png"]];
        }
        else
        {
            [cell.profileImg setImage:[self contactPicture:[[[invitesArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]]];
            
        }
        
        
        
        cell.profileImg.clipsToBounds =YES;
        cell.profileImg.layer.cornerRadius = 23;
        [Utilities roundCornerImageView:cell.profileImg];
        
    }
    else
    {
        
        [Utilities null_ValidationString:[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        //[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"lname"]];
        
        cell.nameLbl.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
        //cell.nameLbl.text = [NSString stringWithFormat:@"%@ %@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"fname"]],[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"lname"]]];
        
        cell.phoneNumberLbl.text =[NSString stringWithFormat:@"Home - %@",[Utilities null_ValidationString:[[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"home"]]] ;
        
        cell.workPhoneNumLbl.text =[NSString stringWithFormat:@"Work - %@",[Utilities null_ValidationString:[[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"work"]]] ;
        //cell.mobilePhoneLbl.text  =[NSString stringWithFormat:@"Mobile - %@",[Utilities null_ValidationString:[[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"mobile"]]] ;
        
        NSString * homeNum = [Utilities null_ValidationString:[[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"home"]] ;
        
        NSString * workNum = [Utilities null_ValidationString:[[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"work"]] ;
        
        NSString * mobiNum = [Utilities null_ValidationString:[[[contactsArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"mobile"]];
        
        if (homeNum.length>5) {
            //cell.mobilePhoneLbl.text  =[NSString stringWithFormat:@"Mobile - %@",[Utilities null_ValidationString:[[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] objectForKey:@"mobile"]]] ;
            
            cell.mobilePhoneLbl.text  =homeNum ;
        }
        else if (workNum.length>5)
        {
            cell.mobilePhoneLbl.text  =workNum ;
        }
        else
            cell.mobilePhoneLbl.text = mobiNum;
        
        

        
        if ([self contactPicture:[[[contactsArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]] == nil)
        {
            //                user_male2-512.png
            [cell.profileImg setImage:[UIImage imageNamed:@"name_icon.png"]];
        }
        else
        {
            [cell.profileImg setImage:[self contactPicture:[[[contactsArray objectAtIndex:indexPath.row] valueForKey:@"contact_id"] intValue]]];
            
        }
        
        
        cell.profileImg.clipsToBounds =YES;
        cell.profileImg.layer.cornerRadius = 23;
        [Utilities roundCornerImageView:cell.profileImg];
        
    }
    
    
    
    
    
    //this is to maintain checkmarks if user alerady selected
    
    if ( [pathStoreArray containsObject:indexPath]) {
        NSLog(@"- - - -%d",indexPath.row);
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (IBAction)inviteContacts:(id)sender
{
    
    if (invitesSendArray.count || contactsSendArray.count)
    {
        if ([Utilities isInternetConnectionExists])
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                [Utilities showLoading:self.view :FontColorHex and:@"#ffffff"];
            });
            
            isIvitesSend = YES;
            
            if (invitesSendArray.count)
            {
                for (int i = 0; i<invitesSendArray.count; i++) {
                    [contactsSendArray addObject:[invitesSendArray objectAtIndex:i]];
                }
            }
            
            NSData* data = [ NSJSONSerialization dataWithJSONObject:contactsSendArray options:NSJSONWritingPrettyPrinted error:nil ];
            NSString * jsonStri = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            
            NSString *newString = [[jsonStri componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            
            NSDictionary *requestDict;
            NSString *urlStr = [NSString stringWithFormat:@"%@inviteFriends",BASEURL];
            requestDict = @{
                            @"user_id":[Utilities getUserID],
                            @"friend_info":newString
                            
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
    else
    {
        [ISMessages showCardAlertWithTitle:nil
                                   message:@"Select atleast one person"
                                  duration:3.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeInfo
                             alertPosition:ISAlertPositionBottom
                                   didHide:^(BOOL finished) {
                                       NSLog(@"Alert did hide.");
                                   }];
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
                else
                {
                    invitesArray = [responseInfo valueForKey:@"invite_list"];
                    
                    contactsArray = [responseInfo valueForKey:@"contact_list"];
                    
                    [self.addinvitationTbl reloadData];
                    
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
