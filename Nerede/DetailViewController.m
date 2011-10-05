//
//  DetailViewController.m
//  Nerede
//
//  Created by yasin on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController
@synthesize m_coordinate;
@synthesize m_title;
@synthesize m_subtitle;
@synthesize m_distance;
@synthesize m_targetCoordinate;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate targetCoordinate:(CLLocationCoordinate2D)targetCoordinate distance:(CLLocationDistance)distance
{
    if (self = [super init]) {
        m_title = title;
        m_subtitle = subtitle;
        m_coordinate = coordinate;
        m_distance = distance;
        m_targetCoordinate = targetCoordinate;
        self.view.backgroundColor = [UIColor redColor];
    }
    return  self;
}
/*
- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	self.view.backgroundColor = [UIColor yellowColor];
	
	UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 80)];
	myLabel.text = @"Isn't it amazing?";
	myLabel.textAlignment = UITextAlignmentCenter;	
	myLabel.backgroundColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:0.3];
	
	UILabel *myLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 200, 80)];
	myLabel2.text = @"only Xcode";
	myLabel2.textAlignment = UITextAlignmentCenter;
	myLabel2.textColor = [UIColor yellowColor];
	myLabel2.shadowColor = [UIColor whiteColor];
	myLabel2.shadowOffset = CGSizeMake(1,1);
	myLabel2.font = [UIFont fontWithName:@"Zapfino" size:20];
	myLabel2.backgroundColor = [UIColor greenColor];
	
    
	
    
	[self.view addSubview:myLabel];
	[self.view addSubview:myLabel2];
	[myLabel release];
	[myLabel2 release];
	[self.view release];
    
}
*/

- (void)loadView
{
    [super loadView];
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIView *view = self.view;
    view.backgroundColor = [UIColor redColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, bounds.size.width, 50)];
    title.text = m_title;
    title.textAlignment = UITextAlignmentCenter;
    [view addSubview:title];
    
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, bounds.size.width, 50)];
    subTitle.numberOfLines = 0;
    subTitle.text = m_subtitle;
    subTitle.textAlignment = UITextAlignmentLeft;
    
    
	UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, bounds.size.width, 50)];
	[myButton setTitle:@"Yol Tarifi Al" forState:UIControlStateNormal];
	[myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	myButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[myButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];

    
    [view addSubview:myButton];
    [myButton release];
    [view addSubview:subTitle];
    [title release];
    [subTitle release];
    
    
    
    
   // self.view = view;
  
    
}

-(void)buttonAction
{
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                     m_coordinate.latitude, m_coordinate.longitude,m_targetCoordinate.latitude, m_targetCoordinate.longitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.view release];
    
    [m_title release];
    m_title = nil;
    
    [m_subtitle release];
    m_subtitle = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
