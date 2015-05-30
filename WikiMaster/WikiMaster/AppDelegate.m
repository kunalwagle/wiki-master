//
//  AppDelegate.m
//  WikiMaster
//
//  Created by Kunal Wagle on 20/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
//#import "ServerCommunication.h"
#import "UtilityMethods.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

NSString *FACEBOOK_SCHEME = @"fb990493707649722";
NSString *GOOGLE_PLUS_SCHEME = @"com.googleusercontent.apps.976248599268-4u6e0njbk439n9epjv6a5jrrnn6dmu4h";

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UtilityMethods initColours];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      //    [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"LoggedIn"];
    if (![defaults objectForKey:@"wasLaunchedBefore"]) {
        [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"LoggedIn"];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"wasLaunchedBefore"];
        [defaults setObject:[NSNumber numberWithInt:7] forKey:@"colourIndex"];
        [defaults setObject:[NSNumber numberWithInt:30] forKey:@"timer"];
    }
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@", [url scheme]);
    
    if([[url scheme] isEqualToString:FACEBOOK_SCHEME])
    {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                     openURL:url
                                                           sourceApplication:sourceApplication
                                                                  annotation:annotation];
        
    }
    else if([[url scheme] isEqualToString:GOOGLE_PLUS_SCHEME])
    {
        
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
        
    }
    return NULL;
}

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Override point for customization after application launch.
//    return YES;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
