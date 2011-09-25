//
//  MapViewController.m
//  Nerede
//
//  Created by yasin on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "MapViewController.h"
#import "AnnotationData.h"
#import "Entity.h"

@implementation MapViewController
@synthesize mapView;
@synthesize locationManager;
@synthesize m_places;
@synthesize userLocation;


- (id)init
{
    self = [super init];
    if (self) {
        m_places = [[NSMutableArray alloc] init];
        mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        mapView.mapType = MKMapTypeHybrid;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        mapView.showsUserLocation = YES;
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
    [mapView setCenterCoordinate:userLocation]; 
    
    MKCoordinateRegion region;
    
    region.center.latitude = newLocation.coordinate.latitude;
    region.center.longitude = newLocation.coordinate.longitude;
    
    region.span.latitudeDelta = 0.0039;
    region.span.longitudeDelta = 0.0034;
    
    YsnAnnotation* a = [[YsnAnnotation alloc] initWithCoordinate:userLocation];
    [mapView addAnnotation:a  ];
    
    [a release];
    a.title = [NSString stringWithFormat:@"%f", userLocation.latitude];
    [mapView selectAnnotation:a animated:YES];
    
    [mapView setRegion:region animated:YES];
    
    [manager stopUpdatingLocation];
}

- (MKAnnotationView *)viewForAnnotation:(id < MKAnnotation >)annotation
{
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"ysn"];
    if (view != nil) {
        return  view;
    }
    
    view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ysn"];
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
    Entity *obj = (Entity*)[arr objectAtIndex:0];
    Entity *obj1 = (Entity*)[arr objectAtIndex:1];
    
    NSLog(@"%@", obj);
    NSLog(@"%@", obj1);
}

-(void) performBackgroundTask
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    [self populateXmlData];
    [self findNearestPlace];
    [pool drain];
}

@end
