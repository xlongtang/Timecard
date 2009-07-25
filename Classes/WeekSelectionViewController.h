//
//  WeekSelectionViewController.h
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekSelection.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface WeekSelectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate> {
	IBOutlet UITableView* table;
	IBOutlet UIToolbar* toolbar;
	WeekSelection* week;
	IBOutlet UIBarButtonItem* settingsButton;
}

@property (retain) UITableView* table;
@property (retain) UIToolbar* toolbar;
@property (retain) UIBarButtonItem* settingsButton;

- (IBAction)doSettings:(id)sender;
- (IBAction)displayComposerSheet:(id) sender;

@end
