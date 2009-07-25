//
//  TimeEntries.m
//  PlayViewBased
//
//  Created by Jacob Rhoden on 6/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimeEntries.h"
#import "DateHelper.h"

@implementation TimeEntries

static TimeEntries* timentries_instance = nil;

+(TimeEntries*)instance {
	
    @synchronized(timentries_instance) {
        if(timentries_instance == nil) {
            timentries_instance = [[TimeEntries alloc] init];
            NSLog(@"Initialised persistence layer");
        }
    }
	
    return timentries_instance;
}

+(void) cleanup {
	
    @synchronized(timentries_instance) {
        if(timentries_instance != nil) {
            [timentries_instance release];
            NSLog(@"Cleaned persistence layer");
            timentries_instance = nil;
        }
    }
	
}

- init {
    if(![super init]){
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex: 0];	
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"time.sqlite"];
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"time.sqlite"];
    NSError *error;
	if(![fileManager fileExistsAtPath: writableDBPath]) {
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSLog(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		} else {
			NSLog(0, @"Initialised database file for first time.");
		}
	}
	
    if (sqlite3_open([writableDBPath UTF8String], &database) != SQLITE_OK) {
        NSLog(@"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }

	return self;
}

-(NSDate*) getFirstWeek {	
	sqlite3_stmt *firstWeek = nil;

    static char *sql = "select min(start) from time_entry";
    if (sqlite3_prepare_v2(database, sql, -1, &firstWeek, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
	
	NSDate* first = nil;
    if(sqlite3_step(firstWeek) == SQLITE_ROW) {
		int dateValue = sqlite3_column_int(firstWeek, 0);
		if(dateValue != 0)
			first = [NSDate dateWithTimeIntervalSince1970: dateValue];
    }
	
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(firstWeek);
	if(first == nil)
		return nil;
	return [DateHelper backToSunday: first];
}

-(NSDate*) getLastWeek {	
	sqlite3_stmt *lastWeek = nil;
	
    static char *sql = "select max(start) from time_entry";
    if (sqlite3_prepare_v2(database, sql, -1, &lastWeek, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
	
	NSDate* first = nil;
    if(sqlite3_step(lastWeek) == SQLITE_ROW) {
		int dateValue = sqlite3_column_int(lastWeek, 0);
		if(dateValue != 0)
			first = [NSDate dateWithTimeIntervalSince1970: dateValue];
    }

    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(lastWeek);
	if(first == nil)
		return nil;
	return [DateHelper backToSunday: first];
}

-(DayEntry*) getEntry: (NSDate*) date {	
	sqlite3_stmt *loadEntry = nil;

	NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
	[localTime setDateStyle: NSDateFormatterShortStyle];
	NSString* dateString = [localTime stringFromDate: date];

    static char *sql = "select id,day,start,end,break_hours,break_minutes from time_entry where day=?";
    if (sqlite3_prepare_v2(database, sql, -1, &loadEntry, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_bind_text(loadEntry, 1, [dateString UTF8String], -1, SQLITE_TRANSIENT);

	DayEntry* entry = nil;
    if(sqlite3_step(loadEntry) == SQLITE_ROW) {
		int start = sqlite3_column_int(loadEntry, 2);
		int end = sqlite3_column_int(loadEntry, 3);
		NSDate* startDate = nil;
		NSDate* endDate = nil;
		if(start!=0)
			startDate = [[NSDate dateWithTimeIntervalSince1970: start] retain];
		if(end!=0)
			endDate = [[NSDate dateWithTimeIntervalSince1970: end] retain];
		NSDate* date = [localTime dateFromString: [NSString stringWithUTF8String:(char *)sqlite3_column_text(loadEntry, 1)]];

        entry = [[DayEntry alloc] initWithId: sqlite3_column_int(loadEntry, 0)
									    date: date
									   start: startDate
										 end: endDate
								  breakHours: sqlite3_column_int(loadEntry, 4)
								breakMinutes: sqlite3_column_int(loadEntry, 5)];
    }
	
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(loadEntry);
	[localTime release];
	
	return entry;
}

-(Week*) getWeek: (NSDate*) date {	
	sqlite3_stmt *loadWeek = nil;
	
	NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
	[localTime setDateStyle: NSDateFormatterShortStyle];
	NSString* dateString = [localTime stringFromDate: date];
	[localTime release];
	
    static char *sql = "select id,week,start,end,hours from week_entry where week=?";
    if (sqlite3_prepare_v2(database, sql, -1, &loadWeek, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_bind_text(loadWeek, 1, [dateString UTF8String], -1, SQLITE_TRANSIENT);
	
	Week* entry = nil;
    if(sqlite3_step(loadWeek) == SQLITE_ROW) {
        entry = [[Week alloc] init: [[NSDate dateWithTimeIntervalSince1970: sqlite3_column_int(loadWeek, 2)] retain]];
        entry.uid = sqlite3_column_int(loadWeek, 0);
        //entry.day = [[NSDate dateWithTimeIntervalSince1970: sqlite3_column_int(loadWeek, 1)] retain];
        //entry.start = [[NSDate dateWithTimeIntervalSince1970: sqlite3_column_int(loadWeek, 2)] retain];
        entry.hours = sqlite3_column_double(loadWeek, 4);
    }
	
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(loadWeek);
	
	return [entry autorelease];
}

-(void) storeWeek: (Week*) week {
	if(week.uid != 0) {
		[self updateWeek: week];
		return;
	}
	
    sqlite3_stmt *insert_week = nil;
	
    static char *sql = "INSERT INTO week_entry (week,start,end,hours) VALUES(?,?,?,?)";
    if (sqlite3_prepare_v2(database, sql, -1, &insert_week, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_bind_text(insert_week,1, [week.weekString UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_week, 2, [week.start timeIntervalSince1970]);
    sqlite3_bind_int(insert_week, 3, [week.end timeIntervalSince1970]);
    sqlite3_bind_double(insert_week, 4, week.hours);
    int success = sqlite3_step(insert_week);
	
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(insert_week);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    } else {
        // SQLite provides a method which retrieves the value of the most recently auto-generated primary key sequence
        // in the database. To access this functionality, the table should have a column declared of type
        // "INTEGER PRIMARY KEY"
        week.uid = sqlite3_last_insert_rowid(database);
    }
	
}

-(void) updateWeek: (Week*) week {
    sqlite3_stmt *update_week = nil;
	
    static char *sql = "update week_entry set week=?, start=?, end=?, hours=? where id=?";
    if (sqlite3_prepare_v2(database, sql, -1, &update_week, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_bind_text(update_week,1, [week.weekString UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(update_week, 2, [week.start timeIntervalSince1970]);
    sqlite3_bind_int(update_week, 3, [week.end timeIntervalSince1970]);
    sqlite3_bind_double(update_week, 4, week.hours);
    sqlite3_bind_int(update_week, 5, week.uid);
    int success = sqlite3_step(update_week);
	
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(update_week);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to update row in the database with message '%s'.", sqlite3_errmsg(database));
    }
	
}

-(NSMutableArray*) loadEntries {
	NSMutableArray* entries = [[NSMutableArray alloc] init];

	sqlite3_stmt *loadEntries = nil;
	NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
	[localTime setDateStyle: NSDateFormatterShortStyle];

    static char *sql = "select id,day,start,end,break_hours,break_minutes from time_entry order by start";
    if (sqlite3_prepare_v2(database, sql, -1, &loadEntries, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
	
    while(sqlite3_step(loadEntries) == SQLITE_ROW) {
        DayEntry* entry = nil;
		int start = sqlite3_column_int(loadEntries, 2);
		int end = sqlite3_column_int(loadEntries, 3);
		NSDate* startDate = nil;
		NSDate* endDate = nil;
		if(start!=0)
			startDate = [[NSDate dateWithTimeIntervalSince1970: start] retain];
		if(end!=0)
			endDate = [[NSDate dateWithTimeIntervalSince1970: end] retain];
		NSDate* date = [localTime dateFromString:  [NSString stringWithUTF8String:(char *)sqlite3_column_text(loadEntries, 1)]];
        entry = [[DayEntry alloc] initWithId: sqlite3_column_int(loadEntries, 0)
										date: date
									   start: startDate
										 end: endDate
								  breakHours: sqlite3_column_int(loadEntries, 4)
								breakMinutes: sqlite3_column_int(loadEntries, 5)];
        [entries addObject: [entry retain]];
    }

    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(loadEntries);
	[localTime release];

	return [entries autorelease];
}

-(void) setPreference: (NSString*) name value: (NSString*) value {
    sqlite3_stmt *set_preference = nil;
	
    static char *sql = "update preference set value=? where name=?";
    if (sqlite3_prepare_v2(database, sql, -1, &set_preference, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_bind_text(set_preference, 1, [value UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(set_preference, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
    int success = sqlite3_step(set_preference);
	
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(set_preference);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to update row in the database with message '%s'.", sqlite3_errmsg(database));
    }
	
}

-(NSString*) getPreference: (NSString*) name {
    sqlite3_stmt *get_preference = nil;
	NSString* value = nil;
	
    static char *sql = "select value from preference where name=?";
    if (sqlite3_prepare_v2(database, sql, -1, &get_preference, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_bind_text(get_preference, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    if(sqlite3_step(get_preference)) {
		value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(get_preference, 0)];
	} else {
        NSAssert1(0, @"Error: Problem reading preference from database with message '%s'.", sqlite3_errmsg(database));
	}
	
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(get_preference);
	
	return value;
}

-(void) storeEntry:(DayEntry*)entry {
	if(entry.uid != 0) {
		[self updateEntry: entry];
		return;
	}

    sqlite3_stmt *insert_statement = nil;

    static char *sql = "INSERT INTO time_entry (day,start,end,break_hours,break_minutes) VALUES(?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    //sqlite3_bind_int(insert_statement, 1, entry.uid);
    //sqlite3_bind_text(insert_statement, 2, [entry.start UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,1, [entry.dayString UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_statement, 2, [entry.start timeIntervalSince1970]);
    sqlite3_bind_int(insert_statement, 3, [entry.end timeIntervalSince1970]);
    sqlite3_bind_int(insert_statement, 4, entry.breakHours);
    sqlite3_bind_int(insert_statement, 5, entry.breakMinutes);
    int success = sqlite3_step(insert_statement);
	
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(insert_statement);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    } else {
        // SQLite provides a method which retrieves the value of the most recently auto-generated primary key sequence
        // in the database. To access this functionality, the table should have a column declared of type
        // "INTEGER PRIMARY KEY"
        [entry updateUid: sqlite3_last_insert_rowid(database)];
    }
		
}

-(void) updateEntry:(DayEntry*)entry {
    sqlite3_stmt *update_statement = nil;
	
    static char *sql = "update time_entry set day=?, start=?, end=?, break_hours=?, break_minutes=? where id=?";
    if (sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_bind_text(update_statement,1, [entry.dayString UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(update_statement, 2, [entry.start timeIntervalSince1970]);
    sqlite3_bind_int(update_statement, 3, [entry.end timeIntervalSince1970]);
    sqlite3_bind_int(update_statement, 4, entry.breakHours);
    sqlite3_bind_int(update_statement, 5, entry.breakMinutes);
    sqlite3_bind_int(update_statement, 6, entry.uid);
    int success = sqlite3_step(update_statement);
	
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(update_statement);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to update row in the database with message '%s'.", sqlite3_errmsg(database));
    }
	
}

-(void) deleteEntry: (long) uid {
    sqlite3_stmt *delete_statement = nil;

    static char *sql = "delete from time_entry where id=?";
    if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_bind_int(delete_statement, 1, uid);
    int success = sqlite3_step(delete_statement);

    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(delete_statement);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to delete row in the database with message '%s'.", sqlite3_errmsg(database));
    }

}

@end
