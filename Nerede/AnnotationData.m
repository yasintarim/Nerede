//
//  AnnotationData.m
//  Nerede
//
//  Created by yasin on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnnotationData.h"


@implementation YsnAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


-(id)initWithCoordinate:(CLLocationCoordinate2D)coord
{
    if (self = [super init]) {
        coordinate = coord;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [title release];
    [subtitle release];
}

@end
