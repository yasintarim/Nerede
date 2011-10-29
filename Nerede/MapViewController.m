//
//  MapViewController.m
//  Nerede
//
//  Created by yasin on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "MapViewController.h"
#import "DetailViewController.h"
#import "defs.h"

@implementation MapViewController
@synthesize m_mapView;
@synthesize m_places;
@synthesize m_locationManager;
@synthesize m_userCoordinate;
@synthesize m_transparentView;
@synthesize m_slider;
@synthesize m_placesTemp;

-(void)viewDidLoad
{
    int sliderHeight = 20;
    CGRect bounds = self.view.bounds;
    CGRect mapRect = CGRectMake(0, sliderHeight, bounds.size.width, bounds.size.height - sliderHeight);
    
    m_mapView = [[MKMapView alloc] initWithFrame:mapRect];
    
    m_mapView.mapType = MKMapTypeStandard;
    m_mapView.delegate = self;
    m_mapView.showsUserLocation = YES;
    m_mapView.userLocation.title = NSLocalizedString(@"KONUM_BILGISI", nil); 
    
    MKCoordinateRegion region;
    region.center.latitude = 39.02;
    region.center.longitude = 35.15;
    region.span.latitudeDelta = 16;
    region.span.longitudeDelta = 4;
    
    m_mapView.region = region;
    [self.view addSubview:m_mapView];
    
    m_slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, sliderHeight)];
    [m_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [m_slider addTarget:self action:@selector(updateTitle) forControlEvents:UIControlEventValueChanged];
    m_slider.minimumValue = 0;
    m_slider.maximumValue = 250;
    m_slider.continuous = YES;
    m_slider.value = 25.0;
    [self.view addSubview:m_slider];
    
    self.navigationItem.title =  [NSString stringWithFormat:NSLocalizedString(@"MESAFE_FORMAT", nil), m_slider.value];
    
    if ([CLLocationManager locationServicesEnabled] == YES) {
        
        m_places = [[NSMutableArray alloc] init];
        m_placesTemp = [[NSMutableArray alloc] init];
      
        m_locationManager = [[CLLocationManager alloc] init];
        m_locationManager.delegate = self;
        m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        m_locationManager.distanceFilter = 10.0f;
        [m_locationManager startUpdatingLocation];
    }
    else
    {
        m_slider.enabled = NO;
        self.navigationItem.title = NSLocalizedString(@"KONUM_SERVISLERI_KAPALI", nil);
    }
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
    
    [m_transparentView release];
    m_transparentView = nil;
    
    [m_slider release];
    m_slider = nil;
    
    m_mapView.delegate = nil;
    [m_mapView release];
    m_mapView = nil;
    
    [m_places release];
    m_places = nil;
    
    [m_placesTemp release];
    m_placesTemp = nil;
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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:KEY_LOCATIONDATAFILENAME ofType:KEY_LOCATIONDATAFILETYPE];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    CXMLDocument *xmlParser = [[[CXMLDocument alloc] initWithData:data options:0 error:nil] autorelease];
    NSArray *resultNodes = [xmlParser nodesForXPath:KEY_TITLEPATH  error:nil];
    
    CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:m_userCoordinate.latitude longitude:m_userCoordinate.longitude];
    
    for (CXMLElement *node in resultNodes) {
        CLLocationCoordinate2D loc = 
        {
            [[[node nodeForXPath:KEY_LATITUDETAGNAME error:nil] stringValue] floatValue], 
            [[[node nodeForXPath:KEY_LONGTITUDETAGNAME error:nil] stringValue] floatValue]
        };
        
        CLLocation *entityLoc = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
        
        CLLocationDistance distance =  [userLoc distanceFromLocation:entityLoc];
        
        NSString *subTitle = [NSString stringWithFormat:NSLocalizedString(@"MESAFE_FORMAT", nil), distance/1000, [[node nodeForXPath:KEY_SUBTITLETAGNAME error:nil] stringValue]];
        
        Entity *entity = [[Entity alloc] 
                          initWithTitle: [[node nodeForXPath:KEY_TITLETAGNAME error:nil] stringValue]  
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

-(void) performBackgroundTask
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
   
    [self parseDataFromXml];
    
    NSArray *arr = [m_places sortedArrayUsingSelector:@selector(compare:)];
    [m_places removeAllObjects];
    [m_places addObjectsFromArray:arr];
    [self findPlacesWithinKilometer];
    [pool drain];
   
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Entity* data = (Entity*) view.annotation;
    DetailViewController *dvc = [[DetailViewController alloc] initWithTitle:data.title subtitle:data.subtitle coordinate:m_userCoordinate targetCoordinate:data.coordinate distance:data.distanceFromUser];
    [(UINavigationController*)self.parentViewController   pushViewController:dvc animated:YES];
    [dvc release];
}

- (void)zoomToAnnotations
 {   
     MKMapRect zoomRect = MKMapRectNull;
     NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:m_placesTemp];
     
     Entity *user = [[Entity alloc] initWithTitle:@"" subtitle:@"" coordinate:m_userCoordinate distance:0];
     [arr addObject:user];
     [user release];

     
     for (Entity *annotation in arr) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
 }
     [m_mapView setVisibleMapRect:MKMapRectMake(zoomRect.origin.x, zoomRect.origin.y, zoomRect.size.width * 1.3, zoomRect.size.height * 1.3) animated:YES ] ;
     [arr release];
     [self performSelector:@selector(addAnnotationObjects) withObject:nil afterDelay:0.5];
 }


- (void) addAnnotationObjects
{
    [m_mapView addAnnotations:m_placesTemp];
    
    [self performSelector:@selector(selectNearestAnnotation) withObject:nil afterDelay:2];

}
- (void)selectNearestAnnotation{
    if ([m_placesTemp count] > 0) {
        Entity *e =   (Entity*)[m_placesTemp objectAtIndex:0];
        [m_mapView selectAnnotation:e animated:YES];
    }
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
 
- (void) sliderAction:(id)sender
{
 
    [m_mapView removeAnnotations:m_places];
    [self performSelectorInBackground:@selector(findPlacesWithinKilometer) withObject:nil];
}

- (void) updateTitle
{
    self.navigationItem.title =  [NSString stringWithFormat:NSLocalizedString(@"MESAFE_FORMAT", nil), m_slider.value];
}

-(void)showLoadingView
{
	CGRect transparentViewFrame = m_mapView.frame;
	m_transparentView = [[UIView alloc] initWithFrame:transparentViewFrame];
	m_transparentView.backgroundColor = [UIColor lightGrayColor];
	m_transparentView.alpha = 0.8;
    
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = m_transparentView.center;
	[spinner startAnimating];
    
	UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 320, 30)];
	messageLabel.textAlignment = UITextAlignmentCenter;
	messageLabel.text = @"Lütfen bekleyiniz...";
    
	[m_transparentView addSubview:spinner];
	[m_transparentView addSubview:messageLabel];
    m_transparentView.tag = 111;
	[self.view addSubview:m_transparentView];
    
	[messageLabel release];
	[spinner release];
	[m_transparentView release];
    m_transparentView = nil;
}
- (void) findPlacesWithinKilometer
{
    [m_placesTemp removeAllObjects];
    
    
    float valinMeters = m_slider.value * 1000;
    for (Entity* e in m_places) {
        if (e.distanceFromUser <= valinMeters) {
            [m_placesTemp addObject:e];
        }
    }
  [self performSelectorOnMainThread:@selector(zoomToAnnotations) withObject:nil waitUntilDone:NO];
}
- (void) hideLoadingView
{
    [[self.view  viewWithTag:111] removeFromSuperview];
}

@end
