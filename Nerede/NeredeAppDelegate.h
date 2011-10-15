//
//  NeredeAppDelegate.h
//  Nerede
//
//  Created by yasin on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NeredeViewController;

@interface NeredeAppDelegate : NSObject <UIApplicationDelegate>
{
    
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) NeredeViewController *viewController;

@end
