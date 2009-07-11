//
//  WeekSelectionViewController.m
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WeekSelectionViewController.h"
#import "WeekViewController.h"
#import "SelectionTableViewCell.h"
#import "DateHelper.h"

@implementation WeekSelectionViewController

@synthesize toolbar,table;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Timecards";
	week = [[WeekSelection alloc] init: [[NSDate alloc] init] end: [[NSDate alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void) viewWillDissapear {
	
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [week weekCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SelectionTableViewCell";
    SelectionTableViewCell* cell = (SelectionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
		cell = [[[SelectionTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	
	Week* entry = [week week: [indexPath row]];
	cell.label.text = [entry name];
	cell.subtitle.text = [DateHelper hourStringLong: [entry hours]];
	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	[cell setEditingAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  WeekViewController *weekViewController = [[WeekViewController alloc] initWithNibName:@"WeekView" bundle:nil];
  weekViewController.week = [week week: [indexPath row]];
  [weekViewController.week loadDays];
  weekViewController.title = weekViewController.week.name;
  [self.navigationController pushViewController:weekViewController animated:YES];
  [weekViewController release];
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */



@end
