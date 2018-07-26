//
//  addInvitationViewController.h
//  foodieApp
//
//  Created by ashwin challa on 12/13/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface addInvitationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *addinvitationTbl;

@property UISearchController *searchController;


@end
