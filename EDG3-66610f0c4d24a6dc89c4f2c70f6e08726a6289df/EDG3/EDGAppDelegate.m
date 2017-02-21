//
//  EDGAppDelegate.m
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import "EDGAppDelegate.h"
#import <Socialize/Socialize.h>

@implementation EDGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.98 green:0.38 blue:0.18 alpha:1]];

    // set the socialize api key and secret
    [Socialize storeConsumerKey:@"18d39114-2091-4017-99e7-94391a06bab3"];
    [Socialize storeConsumerSecret:@"264e1d8d-edb2-4b3b-9759-4decaa843df7"];
    
    //set up Twitter and FB keys
    [SZFacebookUtils setAppId:@"547102758694127"];
    [SZTwitterUtils setConsumerKey:@"2XnW6E55BrJc4E5mNstQ" consumerSecret:@"OBbT0rwuZL6ohwXpMKoqTKdYJOmIcWTqXslKIBS8Xbo"];
    
    // Register for Apple Push Notification Service
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    // Handle Socialize notification at launch
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil)
    {
        [self handleNotification:userInfo];
    }

    return YES;
}

- (void)handleNotification:(NSDictionary*)userInfo
{
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
    {
        if ([SZSmartAlertUtils openNotification:userInfo])
        {
            NSLog(@"Socialize handled the notification (background).");
        }
        else
        {
            NSLog(@"Socialize did not handle the notification (background).");
        }
    }
    else
    {
        NSLog(@"Notification received in foreground");
        
        if ([SZSmartAlertUtils openNotification:userInfo])
        {
            NSLog(@"Socialize handled the notification (foreground).");
        }
        else
        {
            NSLog(@"Socialize did not handle the notification (foreground).");
        }
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken
{
    // If you are testing development (sandbox) notifications, you should instead pass development:YES
    
#if DEBUG
    [SZSmartAlertUtils registerDeviceToken:deviceToken development:YES];
#else
    [SZSmartAlertUtils registerDeviceToken:deviceToken development:NO];
#endif
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [Socialize handleOpenURL:url];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
