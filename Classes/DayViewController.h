//
//  DayViewController.h
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayEntry.h"

@interface DayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView* table;
	DayEntry* dayEntry;
}

@property (retain) UITableView* table;
@property (retain) DayEntry* dayEntry;

@end
