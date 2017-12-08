//
//  AppDelegate.h
//  foodieApp
//
//  Created by ashwin challa on 12/8/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

