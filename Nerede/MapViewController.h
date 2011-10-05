//
//  MapViewController.h
//  Nerede
//
//  Created by yasin on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import "TouchXML.h"
#import "Entity.h"

@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *m_places;
@property (nonatomic, retain) CLLocationManager *m_locationManager;
@property (nonatomic)CLLocationCoordinate2D m_userCoordinate;
- (void) parseDataFromXml;
- (void) performBackgroundTask;
- (void) zoomToAnnotations;
@end
