//
//  TimeEntries.h
//  PlayViewBased
//
//  Created by Jacob Rhoden on 6/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DayEntry.h"
#import "Week.h"

@interface TimeEntries : NSObject {
    sqlite3 *database;
}

+(TimeEntries*) instance;
+(void) cleanup;

-(DayEntry*) getEntry: (NSDate*) date;
-(void) storeEntry:(DayEntry*)entry;
-(void) updateEntry:(DayEntry*)entry;
-(void) deleteEntry: (long) uid;
-(NSMutableArray*) loadEntries;

-(NSDate*) getFirstWeek;
-(NSDate*) getLastWeek;

-(Week*) getWeek: (NSDate*) date;
-(void) storeWeek: (Week*) week;
-(void) updateWeek: (Week*) week;

-(void) setPreference: (NSString*) name value: (NSString*) value;
-(NSString*) getPreference: (NSString*) name;
	
@end
