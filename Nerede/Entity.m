//
//  Entity.m
//  Nerede
//
//  Created by yasin on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@implementation Entity
@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize distanceFromUser;

- (id)init
{
    if (self = [super init]) {
        CLLocationCoordinate2D loc = {0.1f, 0.1f};
        [self initWithTitle:@"" subtitle:@"" coordinate:loc distance:0];
    }
    
    return self;
}

-(id)initWithTitle:(NSString *)theTitle subtitle:(NSString *)theSubtitle coordinate:(CLLocationCoordinate2D)theCoordinate distance:(CLLocationDistance)theDistance
{
    if (self = [super init]) {
        self.title = theTitle;
        self.subtitle = theSubtitle;
        self.coordinate = theCoordinate;
        self.distanceFromUser = theDistance;
    }
    return self;
}

- (NSComparisonResult)compare:(Entity *)otherObject {
    return [[NSNumber numberWithDouble:self.distanceFromUser] compare:[NSNumber numberWithDouble:otherObject.distanceFromUser]];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"\n%@\ntitle: %@\nsubtitle: %@\nlatitude:%f\nlongtitude:%f\ndistanceFromUser:%f\n\n", 
            [super description], 
            self.title, 
            self.subtitle,
            self.coordinate.latitude,
            self.coordinate.longitude,
            self.distanceFromUser];
}

-(void)dealloc
{
    title = nil;
    subtitle = nil;
    [super dealloc];
}

@end
