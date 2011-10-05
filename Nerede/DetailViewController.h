//
//  DetailViewController.h
//  Nerede
//
//  Created by yasin on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>

@interface DetailViewController : UIViewController
@property (nonatomic) CLLocationCoordinate2D m_coordinate;
@property (nonatomic) CLLocationCoordinate2D m_targetCoordinate;
@property (nonatomic) CLLocationDistance m_distance;
@property (nonatomic, copy)NSString* m_title;
@property (nonatomic, copy)NSString* m_subtitle;
-(id)initWithTitle:(NSString*)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate targetCoordinate:(CLLocationCoordinate2D)targetCoordinate distance:(CLLocationDistance)distance;
-(void)buttonAction;
@end
