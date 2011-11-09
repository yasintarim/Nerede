//
//  NewsViewController.m
//  Nerede
//
//  Created by yasin on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "DataItemCell.h"

@implementation NewsViewController
@synthesize m_tableView;

-(void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = tableView;
    [tableView release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DataItemCell *cell = (DataItemCell*)[tableView dequeueReusableCellWithIdentifier:@"cem"];
    if (cell == nil) {
        cell = [[[DataItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cem"] autorelease];
	}
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row] * 20;
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    ((UITableView*)self.view).delegate = nil;
    
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
