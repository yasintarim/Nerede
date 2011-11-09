//
//  NeredeAppDelegate.h
//  Nerede
//
//  Created by yasin on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "MapViewController.h"

@class NeredeViewController;

@interface NeredeAppDelegate : NSObject <UIApplicationDelegate>
{
    
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) NeredeViewController *viewController;
@property (nonatomic, retain) DataModel *m_dataModel;
@property (nonatomic, retain) MapViewController *m_mapViewController;
-(void)postUpdate:(NSString*)newToken;

@end
