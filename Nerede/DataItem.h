//
//  DataItem.h
//  Nerede
//
//  Created by yasin on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@interface DataItem : NSObject
{

}
@property (nonatomic, copy) NSString *m_title;
@property (nonatomic, copy) NSString *m_subTitle;
@property (nonatomic, retain) UIImage *m_image;

-(id)initWithTitle:(NSString*)title subTitle:(NSString*)subTitle imageUrl:(NSString*)url;
-(void)fetchImageFromUrl:(NSString*)url;


@end
