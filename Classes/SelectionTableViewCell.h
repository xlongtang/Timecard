//
//  ThreadTableViewCell.h
//  CorydorasWorldIphone
//
//  Created by Jacob Rhoden on 27/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SelectionTableViewCell : UITableViewCell {
	UILabel *label;
	UILabel *subtitle;
	UILabel *dateLabel;
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *subtitle;
@property (nonatomic, retain) UILabel *dateLabel;

@end
