//
//  NewsViewController.h
//  Nerede
//
//  Created by yasin on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *m_tableView;
@end
