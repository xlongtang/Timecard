//
//  WeekViewController.m
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WeekViewController.h"
#import "DayViewController.h"
#import "WeekTableViewCell.h"
#import "DateHelper.h"
#import "TimeEntries.h"

@implementation WeekViewController

@synthesize week,table;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if([week saveChanged])
		[self.table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section==0)
		return [week dayCount];
	else
		return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WeekTableViewCell";
    WeekTableViewCell* cell = (WeekTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
		cell = [[[WeekTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if([indexPath section]==0) {
		DayEntry* day = [week day: [indexPath row]];
		cell.nameLabel.text = [day dayOfWeek]; 
		cell.authorLabel.text = [day label];
		cell.dateLabel.text = [DateHelper hourStringLong: [day hours]];
		[cell setTarget: self];
		[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
		[cell setEditingAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	} else {
		NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init]; 
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		
		double pay = 0;
		cell.nameLabel.text = [DateHelper hourStringLong: [week hours]];
		double payRate = [[[TimeEntries instance] getPreference: @"pay rate"] doubleValue];
		BOOL overtime = [[[TimeEntries instance] getPreference: @"overtime"] boolValue];
		if(overtime==YES) {
			double overtimeRate = [[[TimeEntries instance] getPreference: @"overtime rate"] doubleValue];
			double overtimeStart = [[[TimeEntries instance] getPreference: @"overtime start"] doubleValue];
			if([week hours]>overtimeStart) {
				pay=overtimeStart*payRate + ([week hours]-overtimeStart)*overtimeRate;
			} else {
				pay=[week hours]*payRate;
			}			
		} else {
			pay=[week hours]*payRate;
		}
		NSString* payString = [formatter stringFromNumber: [NSNumber numberWithDouble: pay]];
		cell.authorLabel.text = payString; //[DateHelper hourString: pay];
		[formatter release];
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 0) {
		DayViewController *dayViewController = [[DayViewController alloc] initWithNibName:@"DayView" bundle:nil];
		dayViewController.dayEntry = [week day: [indexPath row]];
		dayViewController.title = [dayViewController.dayEntry label];
		[self.navigationController pushViewController:dayViewController animated:YES];
		[dayViewController release];		
	} else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}

}

@end
