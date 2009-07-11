//
//  DatePickerController.h
//  PlayViewBased
//
//  Created by Jacob Rhoden on 5/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayEntry.h"


@interface DatePickerController : UIViewController {
    IBOutlet UIDatePicker *datePicker;
    UIDatePicker *datePickerView;
    UIPickerView *myPickerView;
	DayEntry *dayEntry;
	int mode;
}

@property (nonatomic) int mode;
@property (nonatomic, retain) DayEntry *dayEntry;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, retain) UIPickerView *myPickerView;

@end
