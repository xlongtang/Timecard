//
//  SettingInfo.h
//  Timecard
//
//  Created by Jacob Rhoden on 12/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingInfo : NSObject {
	NSString* label;
	int type;
	NSDate *dateValue;
	NSString* stringValue;
	bool boolValue;
	double doubleValue;
}

@property (retain) NSString* label;
@property int type;
@property (retain) NSString* stringValue;
@property (retain) NSDate* dateValue;
@property bool boolValue;
@property double doubleValue;

@end
