//
//  WeekSelection.m
//  DeleteMe2
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WeekSelection.h"
#import "TimeEntries.h"
#import "DateHelper.h"

@implementation WeekSelection

-(id)init: (NSDate*) startDate end: (NSDate*) endDate {
	if (!(self = [super init])) return self;

	// Work out start week
	start = [DateHelper backToSunday: startDate];
	NSDate* dbStart = [[TimeEntries instance] getFirstWeek];
	if(dbStart != nil)
		start = [start earlierDate: dbStart];

	// Work out end week
	end = [DateHelper addWeek: [DateHelper backToSunday: endDate]];
	NSDate* dbEnd = [[TimeEntries instance] getLastWeek];
	if(dbEnd != nil)
		end = [end laterDate: dbEnd];
	
	// Work out how many weeks are we displaying
	int count = [DateHelper daysBetween: start end: end];

	weeks = [[NSMutableArray alloc] init];
	for(int i=0;i<count; i++) {
		Week* entry = [[TimeEntries instance] getWeek: [DateHelper addDay: start days: i*7]];
		if(entry == nil) {
			entry = [[Week alloc] init: [DateHelper addDay: start days: i*7]];
			[[TimeEntries instance] storeWeek: entry];
		}
		[weeks addObject: entry];
	}

	return self;
}

-(Week*) week: (int) weekNumber {
	return [weeks objectAtIndex: weekNumber];
}

-(int) weekCount {
	return [weeks count];
}

- (void)dealloc {
	start = nil; //Probable memory cleanup required test
	end = nil; //Probable memory cleanup required test
	weeks = nil; //Probable memory cleanup required test
    [super dealloc];
}

@end
