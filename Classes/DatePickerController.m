//
//  DatePickerController.m
//  PlayViewBased
//
//  Created by Jacob Rhoden on 5/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DatePickerController.h"
#import "TimeEntries.h"

@implementation DatePickerController

@synthesize mode,datePickerView,myPickerView,datePicker,dayEntry;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	datePicker.datePickerMode = UIDatePickerModeTime;

	//[self createDatePicker];
    //datePickerView.datePickerMode = UIDatePickerModeDate;
	//datePickerView.hidden = NO;
	
	UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target:self action:@selector(save:)];
	self.navigationItem.rightBarButtonItem = save;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	switch (mode) {
		case 1:
			datePicker.datePickerMode = UIDatePickerModeDate;
			if([dayEntry start]!=nil) datePicker.date=[dayEntry start];
			break;
		case 2:
			datePicker.datePickerMode = UIDatePickerModeTime;
			if([dayEntry start]!=nil) datePicker.date=[dayEntry start];
			break;
		case 3:
			datePicker.datePickerMode = UIDatePickerModeTime;
			if([dayEntry end]!=nil) datePicker.date=[dayEntry end];
			break;
		case 4:
			datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
			datePicker.countDownDuration = [dayEntry breakHours]*60*60 + [dayEntry breakMinutes]*60;
			//if([dayEntry end]!=nil) datePicker.date=[dayEntry end];
			break;
		default:
			break;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

- (IBAction)save:(id)sender{
	switch (mode) {
		case 1:
			dayEntry.start = datePicker.date;
			break;
		case 2:
			dayEntry.start = datePicker.date;
			break;
		case 3:
			dayEntry.end = datePicker.date;
			break;
		case 4:
			dayEntry.breakHours = datePicker.countDownDuration/3600;
			dayEntry.breakMinutes = (datePicker.countDownDuration-((dayEntry.breakHours)*3600.0))/60.0;
			break;
		default:
			break;
	}
	[[TimeEntries instance] storeEntry: dayEntry];
	[self.navigationController popViewControllerAnimated: YES];
}

- (void)dealloc {
    [super dealloc];
}


@end

