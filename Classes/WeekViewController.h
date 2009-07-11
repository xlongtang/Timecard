//
//  WeekViewController.h
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Week.h"

@interface WeekViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView* table;
	Week* week;
}

@property (retain) Week* week;
@property (retain) UITableView* table;

@end
