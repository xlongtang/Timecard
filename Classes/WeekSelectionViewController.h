//
//  WeekSelectionViewController.h
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekSelection.h"

@interface WeekSelectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView* table;
	IBOutlet UIToolbar* toolbar;
	WeekSelection* week;
}

@property (retain) UITableView* table;
@property (retain) UIToolbar* toolbar;

@end