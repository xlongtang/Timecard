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
	theDate = nil;
	start = nil;
	end = nil;
	breakHours = 1;
	breakMinutes = 0;
	changed = NO;

	return self;
}

-(id) initWithId: (long) aUid date:(NSDate*) aDate start: (NSDate*) startDate end: (NSDate*) endDate breakHours: (int) bHours breakMinutes:(int) bMinutes {
	if (!(self = [super init])) return self;
	
	[self setDate: aDate];
	[self setStart: startDate];
	[self setEnd: endDate];
	uid = aUid;
	breakHours = bHours;
	breakMinutes = bMinutes;
	changed = NO;

	return self;
	
}

-(id) initWithDate: (NSDate*) aDate breakHours: (int) bHours breakMinutes:(int) bMinutes {
	if (!(self = [super init])) return self;

	uid = 0;
	[self setDate: aDate];
	[self setStart: nil];
	[self setEnd: nil];
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
	if(theDate == nil) return @"";
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEEE"];
	NSString* day =[formatter stringFromDate: theDate];
	[formatter release];
	return day;
}

-(NSString*) label {
	if(theDate == nil) return @"";
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"MMMM d"];
	return [formatter stringFromDate: theDate];
}

-(void) setDate: (NSDate*) date {
	if(theDate != date) {
		[theDate release];
		theDate = [date retain];		
	}
	
	if(theDate == nil && start !=nil)
		theDate = [start retain];
	if(theDate == nil && end !=nil)
		theDate = [end retain];
	
	
	// Check start and end dates are consistent with the date
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *theParts = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:theDate];
	
	if(start!=nil) {
		NSDateComponents *startParts = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:start];	
		if(startParts.year!=theParts.year || startParts.month!=startParts.month || startParts.day!=theParts.day) {
			[startParts setYear: theParts.year-startParts.year];
			[startParts setMonth: theParts.month-startParts.month];
			[startParts setDay: theParts.day-startParts.day];
			[start autorelease];
			start = [[cal dateByAddingComponents:startParts toDate:start options:0] retain];
		}
	}

	if(end!=nil) {
		NSDateComponents *endParts = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:end];
		if(endParts.year!=theParts.year || endParts.month!=endParts.month || endParts.day!=theParts.day) {
			[endParts setYear: theParts.year-endParts.year];
			[endParts setMonth: theParts.month-endParts.month];
			[endParts setDay: theParts.day-endParts.day];
			[end autorelease];
			end = [[cal dateByAddingComponents:endParts toDate:end options:0] retain];
		}
	}
}

-(void) setStart: (NSDate*) date {
	changed = YES;
	if(date!=nil)
		date = [DateHelper removeSeconds: date];
	[start release];
	start = [date retain];
	if(date!=nil)
		[self setDate: theDate];
}

-(void) setEnd: (NSDate*) date {
	changed = YES;
	if(date!=nil)
		date = [DateHelper removeSeconds: date];
	[end release];
	end = [date retain];
	if(date!=nil)
		[self setDate: theDate];
}

-(NSString*) startDate {
	if(theDate==nil) return @"";	
	NSDateFormatter *localDate = [[NSDateFormatter alloc] init];
	//[localDate setDateFormat:@"yyyy-MM-dd"];
	[localDate setDateStyle: NSDateFormatterFullStyle];
	NSString* result = [localDate stringFromDate: theDate];
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
	if(theDate==nil) return @"";	
	NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
	[localTime setDateStyle: NSDateFormatterShortStyle];
	NSString* result =[localTime stringFromDate: theDate];
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
	if(theDate==nil) return -1;	
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	unsigned int unitFlags =  NSDayCalendarUnit;
	NSDateComponents *components = [currentCalendar components:unitFlags fromDate:theDate];
	return [components day];
}

-(int) startMonth {
	if(theDate==nil) return -1;	
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	unsigned int unitFlags =  NSMonthCalendarUnit;
	NSDateComponents *components = [currentCalendar components:unitFlags fromDate:theDate];
	return [components month];	
}

- (void)dealloc {
	start = nil; //Probable memory cleanup required test
	end = nil; //Probable memory cleanup required test
	[theDate release];
    [super dealloc];
}

@end
