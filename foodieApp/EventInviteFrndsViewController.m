//
//  EventInviteFrndsViewController.m
//  foodieApp
//
//  Created by ashwin challa on 3/9/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "EventInviteFrndsViewController.h"
#import "addInvitationTableViewCell.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "Utilities.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "Constants.h"
#import "ISMessages.h"
#import "SingleTon.h"

@interface EventInviteFrndsViewController ()
{
    NSString *jsonString,*jsonContacts;
    NSMutableArray  * invitesArray,
    *invitesSendArray;
    NSMutableArray *contactList,*pathStoreArray;
    BOOL * isAddEventMembers;
    
}
@end

@implementation EventInviteFrndsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    invitesArray = [[NSMutableArray alloc]init];
    invitesSendArray = [[NSMutableArray alloc]init];
    pathStoreArray = [[NSMutableArray alloc]init];
    
    self.title = @"Invite Friends";
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
    }
    
    
    NSData* data = [ NSJSONSerialization dataWithJSONObject:contactList options:NSJSONWritingPrettyPrinted error:nil ];
    jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    [self userPhonebookserviceCall];
    // Do any additional setup after loading the view.
}




-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //[dOfPerson setObject:[NSString stringWithFormat:@"%@", lastName] forKey:@"lname"];
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
        [contactList addObject:dOfPerson];
        
    }
    
    
}


#pragma mark - service call delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return invitesArray.count;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    addInvitationTableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([invitesSendArray containsObject:[invitesArray objectAtIndex:path.row]]) {
            [invitesSendArray removeObject:[invitesArray objectAtIndex:path.row]] ;
            [pathStoreArray removeObject:path];

        }
        
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [pathStoreArray addObject:path];

        [invitesSendArray addObject:[invitesArray objectAtIndex:path.row]] ;
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
    
    [Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"fname"]];
    [Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"lname"]];
    
    cell.nameLbl.text = [NSString stringWithFormat:@"%@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
    
    cell.phoneNumberLbl.text = [NSString stringWithFormat:@"Home - %@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] ]] ;
    
    cell.workPhoneNumLbl.text = [NSString stringWithFormat:@"Work - %@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"] ]] ;
    cell.mobilePhoneLbl.text  = [NSString stringWithFormat:@"Mobile - %@",[Utilities null_ValidationString:[[invitesArray objectAtIndex:indexPath.row] objectForKey:@"mobilenumber"]]] ;
    
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
    
    
    
    
    
    
    cell.profileImg.clipsToBounds =YES;
    cell.profileImg.layer.cornerRadius = 23;
    [Utilities roundCornerImageView:cell.profileImg];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}







- (IBAction)addMembersAction:(id)sender {
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"Event Name";
//        
//    }];
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"Current password %@", [[alertController textFields][0] text]);
//        //compare the current password and do action here
//        
//    }];
//    [alertController addAction:confirmAction];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"Canelled");
//    }];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    isAddEventMembers = YES;
    
    [self addMembersToService];
    
}



#pragma mark - service call delegate methods


-(void)addMembersToService
{

    
    
    if ([Utilities isInternetConnectionExists])
    {
        
        NSData* data = [ NSJSONSerialization dataWithJSONObject:invitesSendArray options:NSJSONWritingPrettyPrinted error:nil ];
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
                
                
                if (isAddEventMembers)
                {
                    [Utilities displayToastWithMessage:@"Invitation Sent Successfully"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    invitesArray = [responseInfo valueForKey:@"invite_list"];
                    
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
