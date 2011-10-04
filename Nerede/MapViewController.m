//
//  MapViewController.m
//  Nerede
//
//  Created by yasin on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "MapViewController.h"
#import "DetailViewController.h"

@implementation MapViewController
@synthesize mapView;
@synthesize m_places;
@synthesize m_locationManager;
@synthesize m_userCoordinate;
- (id)init
{
    self = [super init];
    if (self) {
        m_places = [[NSMutableArray alloc] init];
            
        mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        mapView.mapType = MKMapTypeStandard;
        mapView.delegate = self;
        mapView.showsUserLocation = YES;
        [self.view addSubview:mapView];

        MKCoordinateRegion region;
        region.center.latitude = 39.02;
        region.center.longitude = 35.15;
        region.span.latitudeDelta = 16;
        region.span.longitudeDelta = 4;
        
        mapView.region = region;

        m_locationManager = [[CLLocationManager alloc] init];
        m_locationManager.delegate = self;
        m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        m_locationManager.distanceFilter = 10.0f;
        [m_locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    
    [super viewDidUnload]; 
    
    m_locationManager.delegate = nil;
    [m_locationManager release];
    m_locationManager = nil;
    
    mapView.delegate = nil;
    [mapView release];
    mapView = nil;
    
    [m_places release];
    m_places = nil;
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (MKAnnotationView *) mapView: (MKMapView *) mView viewForAnnotation: (id<MKAnnotation>) annotation {
    
    if ( mView.userLocation == annotation ) {
        return nil;
    }
    
    MKPinAnnotationView *view = (MKPinAnnotationView*)[mView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (view != nil) {
        return view;
    }
    
    view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
    view.pinColor = MKPinAnnotationColorRed;
    view.canShowCallout = YES;
    view.animatesDrop = YES;
    
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return [view autorelease];
    
}

-(void)parseDataFromXml
{   
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    CXMLDocument *xmlParser = [[[CXMLDocument alloc] initWithData:data options:0 error:nil] autorelease];
    NSArray *resultNodes = [xmlParser nodesForXPath:@"/items/item" error:nil];
    CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:m_userCoordinate.latitude longitude:m_userCoordinate.longitude];
    
    for (CXMLElement *node in resultNodes) {
        CLLocationCoordinate2D loc = 
        {
            [[[node nodeForXPath:@"latitude" error:nil] stringValue] floatValue], 
            [[[node nodeForXPath:@"longtitude" error:nil] stringValue] floatValue]
        };
        
        CLLocation *entityLoc = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
        
        CLLocationDistance distance =  [userLoc distanceFromLocation:entityLoc];
        NSString *subTitle = [NSString stringWithFormat:@"(%0.1fkm) %@", distance/1000, [[node nodeForXPath:@"subtitle" error:nil] stringValue]];
        
        Entity *entity = [[Entity alloc] 
                          initWithTitle: [[node nodeForXPath:@"title" error:nil] stringValue]  
                          subtitle:subTitle  coordinate:loc distance:distance];
        
        [m_places addObject:entity];
        [entityLoc release];
        [entity release];  
    }
    [userLoc release];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"%@", [error code]);
}

- (void) findNearestPlace
{
   // yerleri mesafeye gore sirala -az dan çok  a dogru
   }

-(void) performBackgroundTask
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
   
    [self parseDataFromXml];
    
    NSArray *arr = [m_places sortedArrayUsingSelector:@selector(compare:)];
    [m_places removeAllObjects];
    [m_places addObjectsFromArray:arr];
    
    [self performSelectorOnMainThread:@selector(zoomToAnnotations) withObject:arr waitUntilDone:NO];

    [pool drain];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    DetailViewController *dvc = [[DetailViewController alloc] init];
    [(UINavigationController*)self.parentViewController   pushViewController:dvc animated:YES];
    [dvc release];
}

- (void)zoomToAnnotations
 {
     NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:m_places];
     Entity *user = [[Entity alloc] initWithTitle:@"" subtitle:@"" coordinate:m_userCoordinate distance:0];
     [arr addObject:user];
     [user release];
     
     MKMapRect zoomRect = MKMapRectNull;
     for (Entity *annotation in arr) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
 }
     [arr release];
     [mapView setVisibleMapRect:MKMapRectMake(zoomRect.origin.x, zoomRect.origin.y, zoomRect.size.width * 1.3, zoomRect.size.height * 1.3) animated:YES ] ;
     
     [self performSelector:@selector(addAnnotationObjects) withObject:nil afterDelay:0.5];
 }


- (void) addAnnotationObjects
{
    [mapView addAnnotations:m_places];   
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (abs([newLocation.timestamp timeIntervalSinceNow]) > 10.0) {
        return;
    }
    m_userCoordinate = newLocation.coordinate;
    [m_locationManager stopUpdatingLocation];
    [self performSelectorInBackground:@selector(performBackgroundTask) withObject:nil];
}
    

@end
