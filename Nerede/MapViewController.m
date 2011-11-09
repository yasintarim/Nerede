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

- (void) refresh
{
    if ([CLLocationManager locationServicesEnabled] == YES) {
        
        MKCoordinateRegion region;
        region.center.latitude = 39.02;
        region.center.longitude = 35.15;
        region.span.latitudeDelta = 16;
        region.span.longitudeDelta = 4;
        
        m_mapView.region = region;

        m_slider.enabled = YES;
        self.navigationItem.title =  [NSString stringWithFormat:NSLocalizedString(@"MESAFE_FORMAT", nil), m_slider.value];
        [m_locationManager startUpdatingLocation];
    }
    else
    {
        [m_mapView removeAnnotations:m_placesTemp];
        m_slider.enabled = NO;
        self.navigationItem.title = NSLocalizedString(@"KONUM_SERVISLERI_KAPALI", nil);
    }
}

-(void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    int sliderHeight = 20;
    CGRect bounds = self.view.bounds;
    CGRect mapRect = CGRectMake(0, sliderHeight, bounds.size.width, bounds.size.height - sliderHeight);
    
    m_mapView = [[MKMapView alloc] initWithFrame:mapRect];
    
    m_mapView.mapType = MKMapTypeStandard;
    m_mapView.delegate = self;
    m_mapView.showsUserLocation = YES;
    m_mapView.userLocation.title = NSLocalizedString(@"KONUM_BILGISI", nil); 
        [self.view addSubview:m_mapView];
    
    m_slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, sliderHeight)];
    [m_slider addTarget:self action:@selector(findPlacesWithinKilometer) forControlEvents:UIControlEventTouchUpInside];
    [m_slider addTarget:self action:@selector(updateTitle) forControlEvents:UIControlEventValueChanged];
    m_slider.minimumValue = 0;
    m_slider.maximumValue = 250;
    m_slider.continuous = YES;
    m_slider.value = 25.0;
    [self.view addSubview:m_slider];
    
    m_mainQueue = dispatch_get_main_queue();
    

    m_places = [[NSMutableArray alloc] init];
    m_placesTemp = [[NSMutableArray alloc] init];
    
    m_locationManager = [[CLLocationManager alloc] init];
    m_locationManager.delegate = self;
    m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    m_locationManager.distanceFilter = 10.0f;
    [self refresh];
}
#pragma mark - Test
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    
    dispatch_release(m_queue);
    dispatch_release(m_findQueue);
    
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
        
        NSString *subTitle = [NSString stringWithFormat:NSLocalizedString(@"MESAFE_ADRES_FORMAT", nil), distance/1000, [[[node nodeForXPath:KEY_SUBTITLETAGNAME error:nil] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Entity* data = (Entity*) view.annotation;
    DetailViewController *dvc = [[DetailViewController alloc] 
                                 initWithTitle:data.title 
                                 subtitle:data.subtitle
                                 coordinate:m_userCoordinate 
                                 targetCoordinate:data.coordinate 
                                 distance:data.distanceFromUser];
    
    [(UINavigationController*)self.parentViewController  pushViewController:dvc animated:YES];
    [dvc release];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (abs([newLocation.timestamp timeIntervalSinceNow]) > 10.0) {
        return;
    }
    m_userCoordinate = newLocation.coordinate;
    [m_locationManager stopUpdatingLocation];
    
    if (!m_queue) {
        m_queue = dispatch_queue_create(KEY_QUEUE_NAME, NULL);
    }
    
    dispatch_async(m_queue, ^{
    
        [self parseDataFromXml];
        NSArray *arr = [m_places sortedArrayUsingSelector:@selector(compare:)];
        [m_places removeAllObjects];
        [m_places addObjectsFromArray:arr];
        [self findPlacesWithinKilometer];

    });
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
    [m_mapView removeAnnotations:m_placesTemp];
    [m_placesTemp removeAllObjects];    
    
    if (!m_findQueue) {
        m_findQueue = dispatch_queue_create(KEY_QUEUE_FIND, NULL);
    }
    
    dispatch_async(m_findQueue, ^{

        
        float valinMeters = m_slider.value * 1000;
        //find places within given range
        for (Entity* e in m_places) {
            if (e.distanceFromUser <= valinMeters) {
                [m_placesTemp addObject:e];
            }
        }
        
        //zoom to annotations range 
        MKMapRect zoomRect = MKMapRectNull;
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:m_placesTemp];

        [arr addObject:[[[Entity alloc] initWithTitle:@"" subtitle:@"" coordinate:m_userCoordinate distance:0] autorelease]];

        
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
        
        //zoom in main thread and select first annotation if one found
        dispatch_async(m_mainQueue, ^{

            [m_mapView setVisibleMapRect:MKMapRectMake(zoomRect.origin.x, zoomRect.origin.y, zoomRect.size.width * 1.3, zoomRect.size.height * 1.3) animated:YES ];
            [m_mapView addAnnotations:m_placesTemp];
            
            if ([m_placesTemp count] > 0) {
                [m_mapView selectAnnotation:[m_placesTemp objectAtIndex:0] animated:YES];
            }
        });
    });
}

- (void) hideLoadingView
{
    [[self.view  viewWithTag:111] removeFromSuperview];
}

@end
