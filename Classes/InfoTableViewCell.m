//
//  ThreadTableViewCell.m
//  CorydorasWorldIphone
//
//  Created by Jacob Rhoden on 27/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InfoTableViewCell.h"


@implementation InfoTableViewCell

@synthesize label, value;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		UIView *myContentView = self.contentView;

		self.value = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17.0 bold:YES];
		self.value.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.value];
		[self.value release];

		UIColor *color = [UIColor colorWithRed: 6.0/16.0 green: 8.0/16.0 blue: 10.0/16.0 alpha:1];
        self.label = [self newLabelWithPrimaryColor: color selectedColor:[UIColor whiteColor] fontSize:13.0 bold:YES];
		self.label.textAlignment = UITextAlignmentRight; // default
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

	CGFloat distanceWidth = 40;
	//CGFloat distanceX = contentRect.origin.x+contentRect.size.width - distanceWidth - 4;

	//CGRect frame = CGRectMake(boundsX+8, 8, 80, 20);
	//self.activityIndicator.frame = frame;

	CGRect frame = CGRectMake(leftStart, 16, distanceWidth, 14);
	self.label.frame = frame;

	frame = CGRectMake(leftStart+distanceWidth+9, 10, titleWidth - distanceWidth - 4 , 22);
	self.value.frame = frame;

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

@end
