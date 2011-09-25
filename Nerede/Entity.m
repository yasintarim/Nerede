//
//  Entity.m
//  Nerede
//
//  Created by yasin on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@implementation Entity
@synthesize m_title;
@synthesize m_subtitle;
@synthesize m_coordinate;
@synthesize distanceFromUser;

- (id)init
{
    if (self = [super init]) {
        CLLocationCoordinate2D loc = {0.1f, 0.1f};
        [self initWithTitle:@"" subtitle:@"" coordinate:loc distance:0];
    }
    
    return self;
}

-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate distance:(CLLocationDistance)distance
{
    if (self = [super init]) {
        m_title = title;
        m_subtitle = subtitle;
        m_coordinate = coordinate;
        self.distanceFromUser = distance;
    }
    return self;
}

- (NSComparisonResult)compare:(Entity *)otherObject {
    return [[NSNumber numberWithDouble:self.distanceFromUser] compare:[NSNumber numberWithDouble:otherObject.distanceFromUser]];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"\n%@\ntitle: %@\nsubtitle: %@\nlatitude:%f\nlongtitude:%f\ndistance:%f\n\n", 
            [super description], 
            self.m_title, 
            self.m_subtitle,
            self.m_coordinate.latitude,
            self.m_coordinate.longitude,
            self.distanceFromUser];
}

-(void)dealloc
{
    m_title = nil;
    m_subtitle = nil;
    [super dealloc];
}

@end
