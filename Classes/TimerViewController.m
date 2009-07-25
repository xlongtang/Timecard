//
//  TimerViewController.m
//  Timecard
//
//  Created by Jacob Rhoden on 25/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimerViewController.h"
#import "TimeEntries.h"

@implementation TimerViewController

@synthesize setting,timer;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target:self action:@selector(save:)];
	self.navigationItem.rightBarButtonItem = save;
	[save release];
}

- (void)viewWillAppear:(BOOL)animated {
	timer.countDownDuration = setting.timerValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)save:(id)sender{
	setting.timerValue = timer.countDownDuration;
	[[TimeEntries instance] setPreference: setting.label value: [NSString stringWithFormat: @"%d", setting.timerValue]];
	[self.navigationController popViewControllerAnimated: YES];
}

- (void)dealloc {
	setting = nil;
	timer = nil;
    [super dealloc];
}


@end
