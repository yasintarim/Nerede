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


@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
}
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *m_places;
@property (nonatomic) CLLocationCoordinate2D userLocation;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (MKAnnotationView *)viewForAnnotation:(id < MKAnnotation >)annotation;
- (void) findNearestPlace;
- (void) populateXmlData;
- (void) performBackgroundTask;
- (void) addAnnotations:(NSArray*) arr;
@end
