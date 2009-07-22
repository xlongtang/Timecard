//
//  SettingsViewController.m
//  Timecard
//
//  Created by Jacob Rhoden on 12/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingInfo.h"
#import "SettingTableViewCell.h"

@implementation SettingsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	settings = [[NSMutableArray alloc] init];
	[self setEditing: YES];

	SettingInfo* setting = [[SettingInfo alloc] init];

	setting = [[SettingInfo alloc] init];
	setting.label = @"pay rate";
	setting.type = 4;
	setting.doubleValue = [[[TimeEntries instance] getPreference: @"pay rate"] doubleValue];
	[settings addObject: setting];
	
	setting = [[SettingInfo alloc] init];
	setting.label = @"overtime";
	setting.type = 3;
	setting.boolValue = NO;
	[settings addObject: setting];

	setting = [[SettingInfo alloc] init];
	setting.label = @"overtime rate";
	setting.type = 4;
	setting.doubleValue = [[[TimeEntries instance] getPreference: @"overtime rate"] doubleValue];
	[settings addObject: setting];

	setting = [[SettingInfo alloc] init];
	setting.label = @"overtime start";
	setting.type = 4;
	setting.doubleValue = [[[TimeEntries instance] getPreference: @"overtime start"] doubleValue];
	[settings addObject: setting];
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	settings = nil;
	table = nil;
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [settings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	SettingInfo* setting = [settings objectAtIndex: [indexPath row]];
	SettingTableViewCell* cell = [[[SettingTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"settingcell" setting: setting] autorelease];
	
	//cell.label.text = setting.label;
	//cell.value.text = @"...";
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	//cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"day item selected");
	SettingInfo* setting = [settings objectAtIndex: [indexPath row]];
	if(setting.type == 4 || setting.type == 2) {
		SettingTableViewCell* cell = (SettingTableViewCell*)[tableView cellForRowAtIndexPath: indexPath];
		[cell.textField becomeFirstResponder];
	}
	return nil;
}

@end
