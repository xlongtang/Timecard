//
//  DateHelper.h
//  Timecard
//
//  Created by Jacob Rhoden on 11/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateHelper : NSObject {

}

+(NSDate*) backToSunday: (NSDate*) date;
+(NSDate*) addWeek: (NSDate*) date;
+(NSDate*) addDay: (NSDate*) date days: (int) days;
+(int) daysBetween: (NSDate*) startDate end: (NSDate*) endDate;
+(NSDate*) removeSeconds: (NSDate*) date;
+(NSString*) hourString: (double) hour;
+(NSString*) hourStringLong: (double) hour;

@end
