//
//  AppDelegate.m
//  foodieApp
//
//  Created by ashwin challa on 12/8/17.
//  Copyright © 2017 Bhargav. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "Constants.h"
#import "Utilities.h"
#import "Reachability.h"
#import "LcnManager.h"
#import "SDImageCache.h"
#import "homeTabViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Contacts/Contacts.h>
#import <UserNotifications/UserNotifications.h>
#import "SingleTon.h"

@import GoogleMaps;
@import Firebase;
@import FirebaseMessaging;

@interface AppDelegate ()<UIApplicationDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate>
{
    SingleTon * singleTonInstance;
}
@end

@implementation AppDelegate





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
        [Fabric with:@[[Crashlytics class]]];
    // this is to set tabbar background color
    [[UITabBar appearance] setBarTintColor:REDCOLOR];
    
  
    
    singleTonInstance=[SingleTon singleTonMethod];

    
   [FIRApp configure];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    center.delegate = self;
    
    
    
    UNNotificationAction *ActionBtn1 = [UNNotificationAction actionWithIdentifier:@"actions_Id" title:@"Allow" options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *ActionBtn2 = [UNNotificationAction actionWithIdentifier:@"actions_Id" title:@"Denny" options:UNNotificationActionOptionDestructive];
    
    
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"actions_Id" actions:@[ActionBtn1,ActionBtn2] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    
    
    NSSet *categories = [NSSet setWithObject:category];
    
    [center setNotificationCategories:categories];
    
    
    
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound
    
    | UNAuthorizationOptionBadge;
    
    
    
    [center requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        
        
        
        
    }];
    
    [FIRMessaging messaging].remoteMessageDelegate = self;
    
    [application registerForRemoteNotifications];
    
    [FIRMessaging messaging];
    
    NSString *fcmToken = [[FIRInstanceID instanceID] token];
    
    NSLog(@"the FCM Token %@",fcmToken);
    
    
    
    [Utilities saveDeviceToken:fcmToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceToken"
                                                        object:nil];
    
    NSLog(@"check saved device token :%@",[Utilities getDeviceToken]);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    //AIzaSyBdVl-cTICSwYKrZ95SuvNw7dbMuDt1KG0
    
    //for google maps
    [GMSServices provideAPIKey:@"AIzaSyAZ0Ew159qSkFoihPStA5yO8w_2cbXFiK8"]; // using iosdevelopersaanvi@gmail.com
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.google.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];

    
    //*************** SOCIAL LOGINS *************//
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [GIDSignIn sharedInstance].clientID = @"278267048792-82rs5o58h12i7f6tk1k5gqq327iqr0oc.apps.googleusercontent.com";
   // [GIDSignIn sharedInstance].serverClientID = @"";

    
    return YES;
}








-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    
    
    
    //NSLog(@"when app is active ");
  //  completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    
    
    
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
    {
        NSLog( @"INACTIVE" );
        completionHandler(UNNotificationPresentationOptionAlert);
    }
    else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
    {
        NSLog( @"BACKGROUND" );
        completionHandler( UNNotificationPresentationOptionAlert );
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated"
                                                            object:self];
        NSLog( @"FOREGROUND" );
        
    }
    
    
    
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}




- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    
    //NSLog(@"FCM registration token: %@", fcmToken);
    
    
    singleTonInstance.devicetoken = fcmToken;
    
   // NSLog(@"FCM registration token: %@", singleTonInstance.devicetoken);
    
    [Utilities saveDeviceToken:fcmToken];
    
    NSLog(@"FCM registration token: %@",[Utilities getDeviceToken]);
    
}



- (void)application:(UIApplication *)application

didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    
    NSString *tokenString = [deviceToken description];
    
    NSLog(@"Push Notification deviceToken is %@",deviceToken);

    
    tokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSLog(@"Push Notification tokenstring is %@",tokenString);
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:tokenString forKey:@"DeviceTokenFinal"];
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
}







/*!
 @abstract      reachabilityChanged
 @param         NSNotification
 @discussion    reachabilityChanged method used to change network
 @return        nill
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}
/*!
 @abstract      Net work Reachability
 @param         Reachability
 @discussion    updateInterfaceWithReachability method used to change network
 @return        nill
 */
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        BOOL connectionRequired = [reachability connectionRequired];
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
            NSMutableDictionary *ReachabilityDict = [[NSMutableDictionary alloc] init];
            [ReachabilityDict setObject:@"Failure"  forKey:@"Message"];
            //            [NOTIFICATIONCENTER postNotificationName:RECHABILITYCHECK_NOTIFY_NOTIFY object:self userInfo:ReachabilityDict];
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
            NSMutableDictionary *ReachabilityDict = [[NSMutableDictionary alloc] init];
            [ReachabilityDict setObject:@"Failure" forKey:@"Message"];
                        [NOTIFICATIONCENTER postNotificationName:RECHABILITYCHECK_NOTIFY_NOTIFY object:self userInfo:ReachabilityDict];
        }
    }
    if (reachability == self.internetReachability)
    {
        
        NSMutableDictionary *ReachabilityDict = [[NSMutableDictionary alloc] init];
        [ReachabilityDict setObject:@"Success"  forKey:@"Message"];
        // [NOTIFICATIONCENTER postNotificationName:RECHABILITYCHECK_NOTIFY_NOTIFY object:self userInfo:ReachabilityDict];
    }
}

#pragma - Social login  -
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
{
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url   sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if  ([((AppDelegate *)[[UIApplication sharedApplication]delegate]).socialLoginType isEqualToString:@"Facebook"])
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    else
    {
        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"foodieApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
