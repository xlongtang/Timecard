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
#import "DateHelper.h"

@implementation SettingsViewController

@synthesize table;

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
	setting.boolValue = [[[TimeEntries instance] getPreference: @"overtime"] boolValue];;
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
	
	setting = [[SettingInfo alloc] init];
	setting.label = @"break time";
	setting.type = 5;
	setting.timerValue = [[[TimeEntries instance] getPreference: @"break time"] intValue];
	[settings addObject: setting];
	//[DateHelper hourStringLong: [dayEntry breakTime]]
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[table reloadData];
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
	SettingTableViewCell* cell = [[[SettingTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:setting.label setting: setting] autorelease];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SettingInfo* setting = [settings objectAtIndex: [indexPath row]];
	if(setting.type == 4 || setting.type == 2) {
		SettingTableViewCell* cell = (SettingTableViewCell*)[tableView cellForRowAtIndexPath: indexPath];
		[cell.textField becomeFirstResponder];
	}
	if(setting.type == 5)
		return indexPath;
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SettingInfo* setting = [settings objectAtIndex: [indexPath row]];
	if(setting.type ==5) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		TimerViewController *controller = [[TimerViewController alloc] initWithNibName:@"SettingsTimerView" bundle:nil];
		controller.setting = setting;
		[self.navigationController pushViewController:controller animated: YES];
		[controller release];		
	}
}

@end
