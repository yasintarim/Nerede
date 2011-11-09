//
//  DataItem.m
//  Nerede
//
//  Created by yasin on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataItem.h"

@implementation DataItem

static ASINetworkQueue *m_networkQueue;

@synthesize m_title;
@synthesize m_subTitle;
@synthesize m_image;

-(id)initWithTitle:(NSString*)title subTitle:(NSString*)subTitle imageUrl:(NSString*)url
{
    if ((self = [super init])) {
        m_title = title;
        m_subTitle = subTitle;
        
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        [request setCompletionBlock:^{
            NSData *responseData = [request responseData];
            m_image = [UIImage imageWithData:responseData];
            NSLog(@"started");

        }];
        
        [request setFailedBlock:^{
            NSLog(@"Failed...");
        }];
        
        [m_networkQueue addOperation:request];
        
    }
    return self;
}

-(void)fetchImageFromUrl:(NSString*)url
{
    
}

+(void)initialize
{
    if (self == [DataItem class]) {
        m_networkQueue = [ASINetworkQueue queue];
        [m_networkQueue go];
    }
}

-(void)dealloc
{
    [super dealloc];
    [m_title release];
    [m_subTitle release];
    [m_image release];
}

@end
