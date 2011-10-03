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
        mapView.centerCoordinate = CLLocationCoordinate2DMake(43.076913,25.620117);
        
        [self performSelectorInBackground:@selector(performBackgroundTask) withObject:nil];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    
    [super viewDidUnload]; 
    
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
    // reuse a view, if one exists
    
    if ( mView.userLocation == annotation ) {
        return nil; // display default image
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

-(void)populateXmlData
{   
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    CXMLDocument *xmlParser = [[[CXMLDocument alloc] initWithData:data options:0 error:nil] autorelease];
    NSArray *resultNodes = [xmlParser nodesForXPath:@"/items/item" error:nil];
    CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:mapView.userLocation.coordinate.latitude longitude:mapView.userLocation.coordinate.longitude];
    
    for (CXMLElement *node in resultNodes) {
        CLLocationCoordinate2D loc = 
        {
            [[[node nodeForXPath:@"latitude" error:nil] stringValue] floatValue], 
            [[[node nodeForXPath:@"longtitude" error:nil] stringValue] floatValue]
        };
        
        CLLocation *entityLoc = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
        
        CLLocationDistance distance =  [userLoc distanceFromLocation:entityLoc];
        
        Entity *entity = [[Entity alloc] 
                          initWithTitle: [[node nodeForXPath:@"title" error:nil] stringValue]
                          subtitle:[[node nodeForXPath:@"subtitle" error:nil] stringValue]  coordinate:loc distance:distance];
        
        [m_places addObject:entity];
        [entityLoc release];
        [entity release];  
    }
    [userLoc release];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error code]);
}

- (void) findNearestPlace
{
    NSArray *arr = [m_places sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@", arr);    
    [self performSelectorOnMainThread:@selector(addAnnotations:) withObject:arr waitUntilDone:NO];
}

-(void) performBackgroundTask
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    [self populateXmlData];
    [self findNearestPlace];
    [pool drain];
}

- (void) addAnnotations:(NSArray*)arr
{
    [mapView addAnnotations:arr];
    [self performSelector:@selector(zoomToAnnotations) withObject:nil afterDelay:1];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    DetailViewController *dvc = [[DetailViewController alloc] init];
    [(UINavigationController*)self.parentViewController   pushViewController:dvc animated:YES];
    [dvc release];
}

- (void)zoomToAnnotations
{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    
    [mapView setVisibleMapRect:zoomRect animated:YES];
}

@end
