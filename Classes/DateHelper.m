//
//  DateHelper.m
//  Timecard
//
//  Created by Jacob Rhoden on 11/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DateHelper.h"


@implementation DateHelper

+(NSDate*) backToSunday: (NSDate*) date {
	// Subtract enough days to take us to a sunday
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *dayOfWeekComponent = [cal components:(NSWeekdayCalendarUnit) fromDate:date];
	NSDateComponents *dayOfYearComponent = [cal components:(NSDayCalendarUnit) fromDate:date];
	
	if([dayOfWeekComponent weekday]>1) {
		[dayOfYearComponent setDay: 1-[dayOfWeekComponent weekday]];
		date = [[[cal dateByAddingComponents:dayOfYearComponent toDate:date options:0] retain] autorelease];
	}
	
	return [[date copy] autorelease];
}

+(NSDate*) addWeek: (NSDate*) date {
	// Add 7 days to specified date
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *dayOfYearComponent = [cal components:(NSDayCalendarUnit) fromDate:date];
	
	[dayOfYearComponent setDay: 7];
	date = [[[cal dateByAddingComponents:dayOfYearComponent toDate:date options:0] retain] autorelease];
	
	return [[date copy] autorelease];
}

+(NSDate*) addDay: (NSDate*) date days: (int) days {
	// Add 7 days to specified date
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *dayOfYearComponent = [cal components:(NSDayCalendarUnit) fromDate:date];
	
	[dayOfYearComponent setDay: days];
	date = [[[cal dateByAddingComponents:dayOfYearComponent toDate:date options:0] retain] autorelease];
	
	return [[date copy] autorelease];
}

+(int) daysBetween: (NSDate*) startDate end: (NSDate*) endDate {
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal components:NSDayCalendarUnit
									 fromDate:startDate
									   toDate:endDate
									  options:0];
	int days = [comps day];
	days=days/7;
	return days+1;
}

+(NSString*) hourString: (double) hour {
	//hour = ceil(hour*100)/100;
	if(hour == floor(hour))
		return [NSString stringWithFormat: @"%.0f", hour];
	if(hour*10 == floor(hour*10))
		return [NSString stringWithFormat: @"%.1f", hour];
	return [NSString stringWithFormat: @"%.2f", hour];
}

+(NSString*) hourStringLong: (double) hour {
	NSString* string = [DateHelper hourString: hour];
	if(hour == 1)
		return @"1 hour";
	else
		return [NSString stringWithFormat: @"%@ hours", string];
}

+(NSDate*) removeSeconds: (NSDate*) date {
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *parts = [cal components:(NSSecondCalendarUnit ) fromDate:date];
	
	if(parts.second!=0) {
		parts.second=-parts.second;
		date = [[[cal dateByAddingComponents:parts toDate:date options:0] retain] autorelease];
	}
	
	return [[date copy] autorelease];
}

@end
