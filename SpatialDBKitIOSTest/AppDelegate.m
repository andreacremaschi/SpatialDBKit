//
//  AppDelegate.m
//  SpatialDBKit
//
//  Created by Andrea Cremaschi on 08/03/13.
//
// * This is free software; you can redistribute and/or modify it under
// the terms of the Mozilla Public License Version 1.1
//
// Alternatively, the contents of this file may be used under the terms of
// either the GNU General Public License Version 2 or later (the "GPL"), or
// the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
// See the LICENSE file for more information.


#import "AppDelegate.h"
#import "FMDatabase+SpatialDBKit.h"
#import <ShapeKit/ShapeKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString *sqliteVersion = [FMDatabase sqliteLibVersion];
    NSLog(@"sqlite version: %@", sqliteVersion);
    
    NSString *spatialiteVersion = [FMDatabase spatialiteLibVersion];
    NSLog(@"spatialite version: %@", spatialiteVersion);
    
    spatialite_init(TRUE);
    FMDatabase *db = [FMDatabase databaseWithPath: [[NSBundle mainBundle] pathForResource:@"Assets/test-2.3" ofType:@"sqlite"]] ;
    [db open];
    FMResultSet *rs = [db executeQuery:@"select AsText(geometry) AS text FROM Regions"];
    while ([rs next])
    {
        id object = [rs resultDict];
        NSLog(@"%@", object);
        
        // unpack the WKT to a cocoa object using ShapeKit
        object = [[ShapeKitFactory defaultFactory] geometryWithWKT: [object objectForKey:@"text"]];
        NSLog(@"%@", object);
    }
    
    spatialite_cleanup();
    
    
    return YES;
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
