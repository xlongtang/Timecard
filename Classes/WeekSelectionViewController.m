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
#import "SettingsViewController.h"
#import "DateHelper.h"
#import "TimecardExport.h"

@implementation WeekSelectionViewController

@synthesize toolbar,table,settingsButton;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Timecards";
	week = [[WeekSelection alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) viewWillDissapear {	
}

- (void)dealloc {
	table = nil;
	toolbar = nil;
	settingsButton = nil;
	week = nil;
    [super dealloc];
}

- (IBAction)doSettings:(id)sender {
	NSLog(@"settings...");
	SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
	controller.title = @"Settings";
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	
}

// Displays an email composition interface inside the application. Populates all the Mail fields. 
- (void)displayComposerSheet : (id) sender {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Timecard details"];
    
    // Attach the timecard data as a text file
	NSMutableData* myData = [[NSMutableData alloc] init];
	char bom[3]={0xEF,0xBB,0xBF};  //Prepend the text file with a "BOM" indicating its UTF-8 encoded.
	[myData appendBytes:bom length:3];	
	[myData appendData: [[TimecardExport string] dataUsingEncoding: NSUTF8StringEncoding]];
    [picker addAttachmentData:myData mimeType:@"text/plain" fileName:@"Timecard Data.txt"];
    [myData release];

    // Fill out the email body text
    NSString *emailBody = @"Below are my most recent time cards.";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    //message.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return week.count;
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

@end
