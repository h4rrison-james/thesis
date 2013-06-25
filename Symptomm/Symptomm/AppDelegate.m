//
//  AppDelegate.m
//  Symptomm
//
//  Created by Harrison Sweeney on 1/05/13.
//  Copyright (c) 2013 Harrison Sweeney. All rights reserved.
//

#import "AppDelegate.h"
#import "DataController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Restore the symptom array, or create it if it doesn't yet exist
    if ([defaults objectForKey:@"symptomArray"]) {
        [DataController sharedClient].symptomArray = [[defaults objectForKey:@"symptomArray"] mutableCopy];
    }
    else {
        [DataController sharedClient].symptomArray = [[NSMutableArray alloc] init];
    }
    
    // Restore the symptom array, or create it if it doesn't yet exist
    if ([defaults objectForKey:@"mainArray"]) {
        [DataController sharedClient].mainArray = [[defaults objectForKey:@"mainArray"] mutableCopy];
    }
    else {
        [DataController sharedClient].mainArray = [[NSMutableArray alloc] init];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[DataController sharedClient].symptomArray forKey:@"symptomArray"];
    [defaults setObject:[DataController sharedClient].mainArray forKey:@"mainArray"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Restore the symptom array, or create it if it doesn't yet exist
    if ([defaults objectForKey:@"symptomArray"]) {
        [DataController sharedClient].symptomArray = [[defaults objectForKey:@"symptomArray"] mutableCopy];
    }
    else {
        [DataController sharedClient].symptomArray = [[NSMutableArray alloc] init];
    }
    
    // Restore the symptom array, or create it if it doesn't yet exist
    if ([defaults objectForKey:@"mainArray"]) {
        [DataController sharedClient].mainArray = [[defaults objectForKey:@"mainArray"] mutableCopy];
    }
    else {
        [DataController sharedClient].mainArray = [[NSMutableArray alloc] init];
    }
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
