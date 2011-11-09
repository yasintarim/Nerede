//
//  NeredeAppDelegate.m
//  Nerede
//
//  Created by yasin on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NeredeAppDelegate.h"
#import "MapViewController.h"
#import "HomeViewController.h"
#import "NewsViewController.h"
#import <dispatch/dispatch.h>


@implementation NeredeAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize viewController;
@synthesize m_dataModel;
@synthesize m_mapViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    application.applicationIconBadgeNumber = 0;
    
    //window nesnesini olustur
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //tabBarController nesnesini olustur
    tabBarController = [[UITabBarController alloc] init];

    
    //haritanın görüntüleneceği viewcontroller nesnesini oluştur
    m_mapViewController  = [[MapViewController alloc] init];
    
    //harita view controller nesnesini içeren navigationcontroller nesnesini oluştur
    UINavigationController *navMap = [[UINavigationController alloc] initWithRootViewController:m_mapViewController];
    
    //map için tab bar item ı oluştur
    UITabBarItem *tabMap = [[UITabBarItem alloc] initWithTitle:@"En Yakın Yer" image:nil tag: 1];
    navMap.tabBarItem = tabMap;
    //[navMap setNavigationBarHidden:YES];    
    
    UIViewController *view2 = [[NewsViewController alloc] init];
    //view2.view.backgroundColor = [UIColor blueColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view2];
    UITabBarItem *tabEkstra = [[UITabBarItem alloc] initWithTitle:@"Ekstra" image:nil tag: 2];
    nav.tabBarItem = tabEkstra;
    
    
    UIViewController *homeController = [[UIViewController alloc] init];
    homeController.view.backgroundColor = [UIColor redColor];
    
    UITabBarItem *tabHome = [[UITabBarItem alloc] initWithTitle:@"Ana Sayfa" image:nil tag:3];
    homeController.tabBarItem = tabHome;
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:homeController, navMap,nav, nil];
    
    [window addSubview:tabBarController.view];
    [homeController release];
    [tabHome release];
    [tabEkstra release];
    [tabMap release];
    [view2 release];
    [nav release];
    [navMap release];
    
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
    
    [m_mapViewController refresh];
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
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //NSString *newToken = [deviceToken description];
//    [self performSelectorInBackground:@selector(postUpdate:) withObject:newToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

-(void)postUpdate:(NSString*)newToken
{
    m_dataModel = [[DataModel alloc] init];
    NSString *oldToken = [m_dataModel deviceToken];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([oldToken length] < 1 || [oldToken isEqualToString:newToken]) {
        
        [m_dataModel postUpdate:newToken];
        
    }

}
- (void)dealloc
{
    
    [window release];
    [viewController release];
    [tabBarController release];
    [m_dataModel release];
    [m_mapViewController release];
    [super dealloc];
}

@end
