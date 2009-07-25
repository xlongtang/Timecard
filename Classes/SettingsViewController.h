//
//  SettingsViewController.h
//  Timecard
//
//  Created by Jacob Rhoden on 12/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerViewController.h"

@interface SettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView* table;
	NSMutableArray* settings;
}

@property (retain) UITableView* table;


@end
