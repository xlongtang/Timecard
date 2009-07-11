//
//  Week.m
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Week.h"
#import "TimeEntries.h"
#import "DateHelper.h"

@implementation Week

@synthesize start,end,uid,hours;

-(id) init: (NSDate*) startDate {
	if (!(self = [super init])) return self;
	self.start = startDate;
	self.end = [DateHelper addDay: start days:6];
	days = 7;
	for(int i=0;i<7;i++)
		dayEntries[i] = nil;
	hours = self.hoursTotal;
	return self;
}

-(void) loadDays {
	for(int i=0;i<7;i++)
		if(dayEntries[i] == nil)
			dayEntries[i] = [[TimeEntries instance] getEntry: [DateHelper addDay: start days: i]];
}

-(bool) saveChanged {
	bool dayChanged = NO;

	for(int i=0;i<7;i++)
		if(dayEntries[i].changed == YES) {
			dayEntries[i].changed == NO;
			[[TimeEntries instance] storeEntry: dayEntries[i]];
			dayChanged = YES;
		}
	
	if(dayChanged) {
		hours = self.hoursTotal;
		[[TimeEntries instance] storeWeek: self];
	}

	return dayChanged;
}

-(NSString*) weekString {
	if(end==nil) return @"";	
	NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
	[localTime setDateStyle: NSDateFormatterShortStyle];
	return [localTime stringFromDate: start];
}

-(int) dayCount {
	return days;
}

-(double) hoursTotal {
	double total = 0;
	for(int i=0;i<7;i++)
		if(dayEntries[i]!=nil) total += dayEntries[i].hours;
	return total;
}

-(DayEntry*) day: (int) day {
	if(dayEntries[day]==nil) {
		DayEntry* entry = [[DayEntry alloc] initWithStart: [DateHelper addDay: start days: day]
													  end: nil
											   breakHours: 1
											 breakMinutes: 0];
		dayEntries[day] = entry;
	}
	return dayEntries[day];
}

-(NSString*) name {
	NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
	[localTime setDateStyle: NSDateFormatterLongStyle];
	return [localTime stringFromDate: start];
}

@end
