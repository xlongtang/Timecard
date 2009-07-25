//
//  TimeEntry.h
//  PlayViewBased
//
//  Created by Jacob Rhoden on 5/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayEntry : NSObject {
	int uid;
	NSDate *start;
	NSDate *end;
	int breakHours;
	int breakMinutes;
	bool changed;
	NSDate *theDate;
}

-(int) uid;
-(NSDate*) start;
-(NSDate*) end;
-(int) breakHours;
-(int) breakMinutes;
-(bool) changed;

-(void) setDate: (NSDate*) date;
-(void) setChanged: (bool) status;
-(void) setBreakHours: (int) value;
-(void) setBreakMinutes: (int) value;
	
-(id) initWithId: (long) aUid date:(NSDate*)aDate start: (NSDate*) startDate end: (NSDate*) endDate breakHours: (int) bHours breakMinutes:(int) bMinutes;
-(id) initWithDate: (NSDate*) aDate breakHours: (int) bHours breakMinutes:(int) bMinutes;
-(void) updateUid: (int) newUid;

-(double) hours;
-(double) breakTime;

-(NSString*) dayOfWeek;
-(NSString*) label;
-(NSString*) dayString;
-(int) startDay;
-(int) startMonth;
-(NSString*) startDate;
-(NSString*) startTime;
-(NSString*) endTime;
-(void) setStart: (NSDate*) date;
-(void) setEnd: (NSDate*) end;


@end
