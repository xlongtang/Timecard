//
//  WeekSelection.h
//  DeleteMe2
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Week.h"

@interface WeekSelection : NSObject {
	NSDate* start;
	NSDate* end;
	NSMutableArray* weeks;
}

-(id)init;
-(int) count;
-(Week*) week: (int) week;

@end
