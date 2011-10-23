//
//  DataModel.h
//  Nerede
//
//  Created by yasin on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defs.h"
#import "ASIFormDataRequest.h"
@interface DataModel : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceToken;

-(id)init;
-(void)SetPrefKey:(NSString*)key value:(id)val;
-(void)postUpdate:(NSString*)deviceToken;

@end
