//
//  HomeViewController.m
//  Nerede
//
//  Created by yasin on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "DataItem.h"

@implementation HomeViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)] autorelease];
    [btn setTitle:@"Ömrümmmm" forState:UIControlStateNormal];
    [btn setTitle:@"Cemmmmmm" forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(yarbeni) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 40)] autorelease];
    lbl.text = @"Hatırlat";
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.backgroundColor = [UIColor redColor];
    lbl.tag = 333;
    lbl.userInteractionEnabled = YES;

    
    UITapGestureRecognizer *doubleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    doubleFingerTap.numberOfTapsRequired = 2;
    [lbl addGestureRecognizer:doubleFingerTap];
    [doubleFingerTap release];
    
    //DataItem *item = [[DataItem alloc] initWithTitle:@"df" subTitle:@"dfdf" imageUrl:@"http://www.google.com/logos/2011/curie11-hp.jpg"];
    //DataItem *item2 = [[DataItem alloc] initWithTitle:@"df" subTitle:@"dfdf" imageUrl:@"http://www.google.com/logos/2011/curie11-hp.jpg"];
    
    [self.view addSubview:lbl];
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btn];
}

- (void)handleTapGesture:(UIGestureRecognizer*)sender
{
    NSLog(@"right..");
}

-(void)yarbeni
{
    NSLog(@"Yar beni");
    
    UILabel *lbl = (UILabel*)[self.view viewWithTag:333];

    CGRect viewFrame = lbl.frame;
    CGRect originFrame = lbl.frame;
    
    viewFrame.origin.x += 200;
    viewFrame.origin.y += 100;
    viewFrame.size.width += 200;
    viewFrame.size.height += 100;
    
    [UIView animateWithDuration:5.0 
                          delay:0.0 
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         lbl.alpha = 0.5;
                         lbl.frame = viewFrame;
                    } 
                     completion:^(BOOL finished) {
                         lbl.frame = originFrame;
                         lbl.alpha = 1.0;
    }];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
