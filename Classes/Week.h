//
//  Week.h
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayEntry.h"

@interface Week : NSObject {
	int uid;
	NSDate* start;
	NSDate* end;
	int days;
	double hours;
	DayEntry* dayEntries[7];
}

@property int uid;
@property double hours;
@property (retain) NSDate* start;
@property (retain) NSDate* end;

-(id) init: (NSDate*) start;
-(int) dayCount;
-(DayEntry*) day: (int) day;
-(double) hoursTotal;
-(bool) saveChanged;
-(void) loadDays;

-(NSString*) name;
-(NSString*) weekString;

@end
