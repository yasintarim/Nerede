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

@property (nonatomic, retain) MKMapView *m_mapView;
@property (nonatomic, retain) NSMutableArray *m_places;
@property (nonatomic, retain) NSMutableArray *m_placesTemp;
@property (nonatomic, retain) CLLocationManager *m_locationManager;
@property (nonatomic) CLLocationCoordinate2D m_userCoordinate;
@property (nonatomic, retain) UIView* m_transparentView;
@property (nonatomic, retain) UISlider *m_slider;
- (void) parseDataFromXml;
- (void) performBackgroundTask;
- (void) zoomToAnnotations;
- (void) sliderAction:(id)sender;
- (void) updateTitle;
- (void) showLoadingView;
- (void) hideLoadingView;
- (void) findPlacesWithinKilometer;
- (void) selectNearestAnnotation;
@end
