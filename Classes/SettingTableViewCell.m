//
//  ThreadTableViewCell.m
//  CorydorasWorldIphone
//
//  Created by Jacob Rhoden on 27/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingTableViewCell.h"


@implementation SettingTableViewCell

@synthesize setting, label, value, textField, switchField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier setting:(SettingInfo*) aSetting {

	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		UIView *myContentView = self.contentView;
		self.setting = aSetting;
		
		if(setting.type == 4) {
			self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
			self.textField.text = [NSString stringWithFormat: @"%.2f", setting.doubleValue];	
			self.textField.delegate = self;
			self.textField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
			self.textField.returnKeyType = UIReturnKeyDone;
			self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
			[myContentView addSubview:self.textField];
			[self.textField release];
		} else if(setting.type == 3) {
			self.switchField =  [[UISwitch alloc] initWithFrame:CGRectZero];
			//self.textField.text = [NSString stringWithFormat: @"%.2f", setting.doubleValue];			
			[myContentView addSubview:self.switchField];
			[self.switchField release];
		} else if(setting.type == 2) {
			self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
			self.textField.text = setting.stringValue;			
			self.textField.delegate = self;
			self.textField.returnKeyType = UIReturnKeyDone;
			[myContentView addSubview:self.textField];
			[self.textField release];
		} else {
			self.value = [[UITextField alloc] initWithFrame:CGRectZero];
			self.value.text = @"...";
			[myContentView addSubview:self.value];
			[self.value release];
			
		}

		UIColor *color = [UIColor colorWithRed: 6.0/16.0 green: 8.0/16.0 blue: 10.0/16.0 alpha:1];
        self.label = [self newLabelWithPrimaryColor: color selectedColor:[UIColor whiteColor] fontSize:13.0 bold:YES];
		self.label.textAlignment = UITextAlignmentRight; // default
		self.label.text = setting.label;
		[myContentView addSubview:self.label];
		[self.label release];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;

	CGFloat leftStart = contentRect.origin.x+8;
	CGFloat titleWidth = contentRect.size.width - 8 - leftStart;

	CGFloat distanceWidth = 90;
	//CGFloat distanceX = contentRect.origin.x+contentRect.size.width - distanceWidth - 4;

	//CGRect frame = CGRectMake(boundsX+8, 8, 80, 20);
	//self.activityIndicator.frame = frame;

	CGRect frame = CGRectMake(leftStart, 16, distanceWidth, 14);
	self.label.frame = frame;

	if(setting.type == 4) {
		frame = CGRectMake(leftStart+distanceWidth+9, 11, titleWidth - distanceWidth - 4 , 22);
		self.textField.frame = frame;
	} else if(setting.type == 3) {
		frame = CGRectMake(leftStart+distanceWidth+9, 11, titleWidth - distanceWidth - 4 , 22);
		self.switchField.frame = frame;
	} else if(setting.type == 2) {
		frame = CGRectMake(leftStart+distanceWidth+9, 11, titleWidth - distanceWidth - 4 , 22);
		self.textField.frame = frame;
	} else {
		frame = CGRectMake(leftStart+distanceWidth+9, 11, titleWidth - distanceWidth - 4 , 22);
		self.value.frame = frame;
	}

}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	
    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
	
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	//newLabel.backgroundColor = [UIColor greenColor];
	newLabel.opaque = NO;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}


- (void)dealloc {
	//[nameLabel dealloc];
	//[authorLabel dealloc];
	//[dateLabel dealloc];
	[super dealloc];
}
/*
- (void)textFieldDidEndEditing:(UITextField *)aTextField {
	NSString* result = textField.text;
	NSLog(@"Editing finished %@", result);
	//[textField setEditing: FALSE animated: FALSE];
	[aTextField resignFirstResponder];
	self.setting.doubleValue = [result doubleValue];
}
*/

-(BOOL)textFieldShouldReturn: (UITextField *)theTextField {
	NSString* result = textField.text;
	NSLog(@"Editing finished %@", result);
	//[textField setEditing: FALSE animated: FALSE];
	[theTextField resignFirstResponder];
	self.setting.doubleValue = [result doubleValue];
	return YES;
}


@end
