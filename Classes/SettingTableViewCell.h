//
//  ThreadTableViewCell.h
//  CorydorasWorldIphone
//
//  Created by Jacob Rhoden on 27/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingInfo.h"

@interface SettingTableViewCell : UITableViewCell<UITextFieldDelegate> {
	UILabel* label;
	UILabel* value;
	UITextField* textField;
	UISwitch* switchField;
	SettingInfo* setting;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier setting:(SettingInfo*) aSetting;
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *value;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UISwitch *switchField;
@property (nonatomic, retain) SettingInfo* setting;

@end