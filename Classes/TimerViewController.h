//
//  TimerViewController.h
//  Timecard
//
//  Created by Jacob Rhoden on 25/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingInfo.h"

@interface TimerViewController : UIViewController {
    IBOutlet UIDatePicker *timer;
	SettingInfo* setting;
}

@property (retain) SettingInfo* setting;
@property (retain) UIDatePicker* timer;

@end
