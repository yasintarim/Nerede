//
//  DataModel.m
//  Nerede
//
//  Created by yasin on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize deviceId;
@synthesize deviceToken;

-(id)init
{
    if ((self = [super init])) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        deviceToken = [defaults objectForKey:KEY_APPID];
        deviceId = [defaults objectForKey:KEY_DEVICEID];
        
        if (deviceId.length < 1) {
            deviceId = [[UIDevice currentDevice] uniqueIdentifier];
        }
    }
    
    return self;
}

-(void)SetPrefKey:(NSString*)key value:(id)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:val forKey:key];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"\n deviceId: %@\n deviceToken: %@\n\n", 
            self.deviceId, 
            self.deviceToken];
}

-(void)postUpdate:(NSString*)newToken
{
    [self SetPrefKey:KEY_APPID value:newToken];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:KEY_SERVERURL]];
    
    [request setPostValue:@"push" forKey:@"push"];
    [request setPostValue:@"update" forKey:@"cmd"];
    [request setPostValue:self.deviceId forKey:KEY_DEVICEID];
    [request setPostValue:newToken forKey:KEY_APPID];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request setTimeOutSeconds:10];
    
    NSLog(@"%@", request);
    [request setCompletionBlock:^{
        NSLog(@"completed");
    }];
    
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"error : %@", [error description]);
    }];
    [request startAsynchronous];
   
}


-(void)dealloc
{
    [deviceId release];
    [deviceToken release];
    [super dealloc];
}

@end
