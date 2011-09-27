//
//  MapViewController.m
//  Nerede
//
//  Created by yasin on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "MapViewController.h"


@implementation MapViewController
@synthesize mapView;
@synthesize locationManager;
@synthesize m_places;
@synthesize userLocation;
@synthesize reverseGeocoder;


- (id)init
{
    self = [super init];
    if (self) {
        m_places = [[NSMutableArray alloc] init];
        mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        mapView.mapType = MKMapTypeStandard;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        mapView.delegate = self;
        
        //mapView.showsUserLocation = YES;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        [self.view addSubview:mapView];
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
    
    [mapView release];
    mapView = nil;
    
    [locationManager release];
    locationManager = nil;
    
    reverseGeocoder.delegate = nil;
    [reverseGeocoder release];
    reverseGeocoder = nil;
    
    [m_places release];
    m_places = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    userLocation = [newLocation coordinate];
    //[mapView setCenterCoordinate:userLocation]; 
    
   
    
    [manager stopUpdatingLocation];
}

- (MKAnnotationView *) mapView: (MKMapView *) mView viewForAnnotation: (id<MKAnnotation>) annotation {
    // reuse a view, if one exists
    MKPinAnnotationView *view = (MKPinAnnotationView*)[mView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (view != nil) {
        return view;
    }
    
    view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
    view.pinColor = MKPinAnnotationColorRed;
    view.canShowCallout = YES;
    view.animatesDrop = YES;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    [rightButton addTarget:self action:@selector(showDetailView) forControlEvents:UIControlEventTouchUpInside];
    view.rightCalloutAccessoryView = rightButton;
    return [view autorelease];
    
}
-(void)populateXmlData
{   
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    CXMLDocument *xmlParser = [[[CXMLDocument alloc] initWithData:data options:0 error:nil] autorelease];
    NSArray *resultNodes = [xmlParser nodesForXPath:@"/items/item" error:nil];
    CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:userLocation.latitude longitude:userLocation.longitude];
    
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

- (void) addAnnotations:(NSArray*) arr
{
    Entity* m = [arr objectAtIndex:0];
    [mapView setCenterCoordinate:m.coordinate];
    
    
    
    Entity *arg = (Entity*) [arr objectAtIndex:0];
    reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:arg.coordinate];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
    }

- (void) showDetailView
{

  
    
    
    
    /*NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", self.userLocation.latitude, self.userLocation.longitude, arg.coordinate.latitude, arg.coordinate.longitude];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];*/

}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"xx");
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    MKCoordinateRegion region;
    
    region.center.latitude = placemark.coordinate.latitude;
    region.center.longitude = placemark.coordinate.longitude;
    
    region.span.latitudeDelta = 0.05;
    region.span.longitudeDelta = 0.05;
    
    [mapView setRegion:region];

    
    [mapView addAnnotation:placemark];
    [mapView selectAnnotation:placemark animated:YES];
    NSLog(@"%@", placemark);
}



@end
