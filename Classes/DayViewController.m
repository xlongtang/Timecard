//
//  DayViewController.m
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DayViewController.h"
#import "DatePickerController.h"
#import "InfoTableViewCell.h"
#import "DateHelper.h"

@implementation DayViewController

@synthesize table,dayEntry;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.table reloadData];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section==1)
		return 1;
	else
		return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InfoTableViewCell";
    InfoTableViewCell* cell = (InfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
		cell = [[[InfoTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	
	if([indexPath section]==1) {
		cell.label.text = @"hours";
		cell.value.text = [DateHelper hourString: [dayEntry hours]];
	} else {
		
    // Set up the cell...
    switch([indexPath row]) {
        case 0:
			cell.label.text = @"date";
            cell.value.text = [dayEntry startDate];
            break;
        case 1:
			cell.label.text = @"start";
            cell.value.text = dayEntry.startTime;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
			cell.label.text = @"end";
            cell.value.text = dayEntry.endTime;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
		case 3:
			cell.label.text = @"break";
			cell.value.text = [DateHelper hourStringLong: [dayEntry breakTime]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
	}
}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"day item selected");
	
	DatePickerController *controller = [[DatePickerController alloc] initWithNibName:@"DatePicker" bundle:nil];
	controller.dayEntry = dayEntry;
	switch([indexPath row]) {
		case 0:
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			[controller release];
			return;
		case 1:
			controller.title = @"Start time";
			controller.mode=2;
			break;
		case 2:
			controller.title = @"Finish time";
			if(dayEntry.end == nil) dayEntry.end = [[NSDate alloc] init];
			controller.mode=3;
			break;
		case 3:
			controller.title = @"Break time";
			controller.mode=4;
			break;
	}
	[self.navigationController pushViewController:controller animated: YES];
	[controller release];
	
}


@end
