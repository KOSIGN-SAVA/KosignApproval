//
//  IconLableView.m
//
//  Created by donghwan kim on 11. 3. 30..
//  Copyright 2011 webcash. All rights reserved.
//

#import "IconLableView.h"
#import "AllUtils.h"
#import "AllEffects.h"


@implementation IconLableView
@synthesize font;
@synthesize textColor;
@synthesize textAlignment;
@synthesize text;
@synthesize numberOfLines;


- (id)initWithFrameAndIcon:(CGRect)frame IconImageName:(NSString *)IconImageName {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		
		UIImage* image = [UIImage imageNamed:[SysUtils imageCodeToFileName:IconImageName]];
		
		//Icon image view
		UIImageView* iconImageView = [[UIImageView alloc] initWithImage:image];
		iconImageView.tag = 1000;
		iconImageView.frame = CGRectMake(0.0f, frame.size.height/2 - image.size.height/4, image.size.width /2, image.size.height/2);
		[self addSubview:iconImageView];
		[iconImageView release];


		//Label view
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(image.size.width /2 + 5.0f, 0.0f, frame.size.width - (image.size.width /2 + 5.0f), frame.size.height)];
		label.backgroundColor = [UIColor clearColor];
		label.tag			= 2000;
		[self addSubview:label];
		[label release];
		
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (void)setFont:(UIFont *)aFont {
	UILabel *labelText = (UILabel *)[self viewWithTag:2000];
	labelText.font = aFont;
}


- (void)setText:(NSString *)aText {
	UILabel *labelText = (UILabel *)[self viewWithTag:2000];
	labelText.text = aText;
}


//- (void)setTextAlignment:(UITextAlignment)aAlign {
- (void)setTextAlignment:(NSTextAlignment)aAlign {
	UILabel *labelText = (UILabel *)[self viewWithTag:2000];
	labelText.textAlignment = aAlign;
}


- (void)setTextColor:(UIColor *)aColor {
	UILabel *labelText = (UILabel *)[self viewWithTag:2000];
	labelText.textColor = aColor;
}


- (void)setNumberOfLines:(NSInteger)aNumberOfLines {
	UILabel *labelText = (UILabel *)[self viewWithTag:2000];
	labelText.numberOfLines = aNumberOfLines;	
	
}

@end
