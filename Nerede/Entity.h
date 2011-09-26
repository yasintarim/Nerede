//
//  Entity.h
//  Nerede
//
//  Created by yasin on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>

@interface Entity : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationDistance distanceFromUser;

- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle coordinate:(CLLocationCoordinate2D) coordinate distance:(CLLocationDistance)distance;

- (NSComparisonResult)compare:(Entity *)otherObject;

- (NSString *)description;

@end
