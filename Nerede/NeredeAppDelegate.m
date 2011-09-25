//
//  NeredeAppDelegate.m
//  Nerede
//
//  Created by yasin on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NeredeAppDelegate.h"

#import "NeredeViewController.h"
#import "MapViewController.h"

@implementation NeredeAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //create window object
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor redColor];
    
    //create tabBarController
    
    tabBarController = [[UITabBarController alloc] init];

    UITabBarItem* tabMain = [[UITabBarItem alloc] initWithTitle:@"Arama" image:nil tag:1];
    UITabBarItem* tabUrunler = [[UITabBarItem alloc] initWithTitle:@"Bul" image:nil tag:2];
    
    UIViewController *view1 = [[MapViewController alloc] init];
    view1.view.backgroundColor = [UIColor yellowColor];
    view1.tabBarItem = tabMain;
    
    MapViewController *view2 = [[UIViewController alloc] init];
    view2.view.backgroundColor = [UIColor blueColor];
    view2.tabBarItem = tabUrunler;
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:view1,view2, nil];
    
    [window addSubview:tabBarController.view];
    [tabMain release];
    [tabUrunler release];
    [view1 release];
    [view2 release];
        
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [window release];
    [viewController release];
    [tabBarController release];
    [super dealloc];
}

@end
