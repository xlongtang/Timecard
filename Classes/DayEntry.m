//
//  TimeEntry.m
//  PlayViewBased
//
//  Created by Jacob Rhoden on 5/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DayEntry.h"
#import "DateHelper.h"

@implementation DayEntry

-(id) init {
	if (!(self = [super init])) return self;
	
	uid = 0;
	start = nil;
	end = nil;
	breakHours = 1;
	breakMinutes = 0;
	changed = NO;

	return self;
}

-(id) initWithId: (long) aUid start: (NSDate*) startDate end: (NSDate*) endDate breakHours: (int) bHours breakMinutes:(int) bMinutes {
	if (!(self = [super init])) return self;
	
	[self setStart: startDate];
	[self setEnd: endDate];
	uid = aUid;
	breakHours = bHours;
	breakMinutes = bMinutes;
	changed = NO;

	return self;
	
}

-(id) initWithStart: (NSDate*) startDate end: (NSDate*) endDate breakHours: (int) bHours breakMinutes:(int) bMinutes {
	if (!(self = [super init])) return self;

	uid = 0;
	[self setStart: startDate];
	[self setEnd: endDate];
	breakHours = bHours;
	breakMinutes = bMinutes;
	changed = NO;

	return self;
}

-(int) uid {
	return uid;
}
-(NSDate*) start {
	return start;
}
-(NSDate*) end {
	return end;
}
-(int) breakHours {
	return breakHours;
}
-(int) breakMinutes {
	return breakMinutes;
}

-(void) setBreakHours: (int) value {
	changed = YES;
	breakHours = value;
}

-(void) setBreakMinutes: (int) value {
	changed = YES;
	breakMinutes = value;
}

-(void) updateUid: (int) newUid {
	if(uid==0)
		uid = newUid;
}

-(bool) changed {
	return changed;
}

-(void) setChanged: (bool) status {
	changed = status;
}

-(NSString*) dayOfWeek {
	if(start == nil) return @"";
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEEE"];
	NSString* day =[formatter stringFromDate: start];
	[formatter release];
	return day;
}

-(NSString*) label {
	if(start == nil) return @"";
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"MMMM d"];
	return [formatter stringFromDate: start];
}


-(void) setStart: (NSDate*) date {
	changed = YES;
	[start release];
	if(date!=nil)
		date = [DateHelper removeSeconds: date];
	if(end==nil || date==nil) {
		start = date;
		[start retain];
		return;
	}
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *endParts = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:end];
	NSDateComponents *parts = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:date];
	
	if(endParts.year!=parts.year || endParts.month!=parts.month || endParts.day!=parts.day) {
		[parts setYear: endParts.year-parts.year];
		[parts setMonth: endParts.month-parts.month];
		[parts setDay: endParts.day-parts.day];
		start = [[cal dateByAddingComponents:parts toDate:date options:0] retain];
	} else {
		start = date;
		[start retain];
	}
	
}

-(void) setEnd: (NSDate*) date {
	changed = YES;
	if(date!=nil)
		date = [DateHelper removeSeconds: date];
	if(start==nil || date==nil) {
		end = date;
		[end retain];
		return;
	}
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *startParts = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:start];
	NSDateComponents *parts = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:date];
	
	if(startParts.year!=parts.year || startParts.month!=parts.month || startParts.day!=parts.day) {
		[parts setYear: startParts.year-parts.year];
		[parts setMonth: startParts.month-parts.month];
		[parts setDay: startParts.day-parts.day];
		end = [[cal dateByAddingComponents:parts toDate:date options:0] retain];
	} else {
		end = date;
		[end retain];
	}
}

-(NSString*) startDate {
	if(start==nil) return @"";	
	NSDateFormatter *localDate = [[NSDateFormatter alloc] init];
	//[localDate setDateFormat:@"yyyy-MM-dd"];
	[localDate setDateStyle: NSDateFormatterFullStyle];
	NSString* result = [localDate stringFromDate: start];
	[localDate release];
	return result;
}

-(NSString*) startTime {
	if(start==nil) return @"";
	NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
	//[localTime setDateFormat:@"HH:mm"];
	[localTime setTimeStyle: NSDateFormatterShortStyle];
	NSString* result = [localTime stringFromDate: start];
	[localTime release];
	return result;
}

-(NSString*) endTime {
    if(end==nil) return @"";
    NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
    [localTime setTimeStyle: NSDateFormatterShortStyle];
	NSString* result = [localTime stringFromDate: end];
	[localTime release];
    return result;
}

-(NSString*) dayString {
	if(end==nil) return @"";	
	NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
	[localTime setDateStyle: NSDateFormatterShortStyle];
	NSString* result =[localTime stringFromDate: end];
	[localTime release];
	return result;
}

-(double) hours {
	if(start==nil || end==nil) return 0;
	
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [currentCalendar components: NSMinuteCalendarUnit
													  fromDate: start
														toDate: end
													   options: 0];
	double minutes = [components minute];
	
	double result = minutes/60.0 - self.breakTime;
	if(result<0) return 0;

	return result;
}

-(double) breakTime {
	return breakHours + ((double)breakMinutes)/60.0;
}

-(int) startDay {
	if(start==nil) return -1;	
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	unsigned int unitFlags =  NSDayCalendarUnit;
	NSDateComponents *components = [currentCalendar components:unitFlags fromDate:start];
	return [components day];
}

-(int) startMonth {
	if(start==nil) return -1;	
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	unsigned int unitFlags =  NSMonthCalendarUnit;
	NSDateComponents *components = [currentCalendar components:unitFlags fromDate:start];
	return [components month];	
}

- (void)dealloc {
	start = nil; //Probable memory cleanup required test
	end = nil; //Probable memory cleanup required test
    [super dealloc];
}

@end
