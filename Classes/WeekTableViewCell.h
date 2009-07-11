//
//  ThreadTableViewCell.h
//  CorydorasWorldIphone
//
//  Created by Jacob Rhoden on 27/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeekTableViewCell : UITableViewCell {
	UILabel *nameLabel;
	UILabel *authorLabel;
	UILabel *dateLabel;
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *authorLabel;
@property (nonatomic, retain) UILabel *dateLabel;

@end
