//
//  ThreadTableViewCell.m
//  CorydorasWorldIphone
//
//  Created by Jacob Rhoden on 27/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SelectionTableViewCell.h"


@implementation SelectionTableViewCell

@synthesize label, subtitle, dateLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		UIView *myContentView = self.contentView;

		self.label = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17.0 bold:YES];
		self.label.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.label];
		[self.label release];
		
        self.subtitle = [self newLabelWithPrimaryColor:[UIColor darkGrayColor] selectedColor:[UIColor whiteColor] fontSize:11.0 bold:NO];
		self.subtitle.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.subtitle];
		[self.subtitle release];
		
        self.dateLabel = [self newLabelWithPrimaryColor:[UIColor blueColor] selectedColor:[UIColor whiteColor] fontSize:11.0 bold:NO];
		self.dateLabel.textAlignment = UITextAlignmentRight; // default
		[myContentView addSubview:self.dateLabel];
		[self.dateLabel release];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;

	CGFloat leftStart = contentRect.origin.x+8;
	CGFloat titleWidth = contentRect.size.width - 8 - leftStart;

	CGFloat distanceWidth = 80;
	CGFloat distanceX = contentRect.origin.x+contentRect.size.width - distanceWidth - 4;

	//CGRect frame = CGRectMake(boundsX+8, 8, 80, 20);
	//self.activityIndicator.frame = frame;

	CGRect frame = CGRectMake(leftStart, 4, titleWidth , 22);
	self.label.frame = frame;

	frame = CGRectMake(leftStart, 26, titleWidth - distanceWidth - 4, 14);
	self.subtitle.frame = frame;

	frame = CGRectMake(distanceX, 26, distanceWidth, 14);
	self.dateLabel.frame = frame;
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
	label = nil;
	subtitle = nil;
	dateLabel = nil;
	[super dealloc];
}

@end
