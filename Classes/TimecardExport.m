//
//  TimecardExport.m
//  Timecard
//
//  Created by Jacob Rhoden on 25/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimecardExport.h"
#import "WeekSelection.h"
#import "DateHelper.h"

@implementation TimecardExport

+(NSString*) string {
	WeekSelection *weeks = [[WeekSelection alloc] init];
	NSMutableString* result = [[NSMutableString alloc] init];

	for(int i=0; i<weeks.count; i++) {
		Week* week = [weeks week: i];
		[result appendString: week.name];
		[result appendString: @" ("];
		[result appendString: [DateHelper hourStringLong: week.hours]];
		[result appendString: @")\n"];
		[week loadDays];
		for(int i=0; i<7; i++) {
			DayEntry* day = [week day: i];
			if([day hours]>0) {
				[result appendString: [day dayOfWeek]]; 
				[result appendString: @": "];
				//cell.authorLabel.text = [day label];
				[result appendString: [DateHelper hourStringLong: [day hours]]];			
				[result appendString: @"\n"];
			}
			[day release];
		}		
		[result appendString: @"\n"];
		[week release];

	}
	
	return [result autorelease];
}

@end
