//
//  UpDownButtonView.m
//  OfficeWB
//
//  Created by Yongjoo Park on 2/25/11.
//  Copyright 2011 Webcash. All rights reserved.
//

#import "UpDownButtonView.h"





@interface UpDownButtonView ()

- (void)initialize;

@end



@implementation UpDownButtonView : UIView

@synthesize leftButton, rightButton;

- (void)initialize {
	// configure left button
	UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	UIImage *upNormalImage = [UIImage imageNamed:[SysUtils imageCodeToFileName:@"a11200"]];
	[upButton setBackgroundImage:upNormalImage forState:UIControlStateNormal];
	UIImage *upHighlightedImage = [UIImage imageNamed:[SysUtils imageCodeToFileName:@"a11210"]];
	[upButton setBackgroundImage:upHighlightedImage forState:UIControlStateHighlighted];
	[upButton setBackgroundImage:upHighlightedImage forState:UIControlStateDisabled];
	
	upButton.frame = CGRectMake(0, 0, 43, 44);
	[self addSubview:upButton];
	
	leftButton = upButton;
	
	// configure right button
	UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	UIImage *downNormalImage = [UIImage imageNamed:[SysUtils imageCodeToFileName:@"a11300"]];
	[downButton setBackgroundImage:downNormalImage forState:UIControlStateNormal];
	UIImage *downHighlightedImage = [UIImage imageNamed:[SysUtils imageCodeToFileName:@"a11310"]];
	[downButton setBackgroundImage:downHighlightedImage forState:UIControlStateHighlighted];
	[downButton setBackgroundImage:downHighlightedImage forState:UIControlStateDisabled];
	
	downButton.frame = CGRectMake(43, 0, 43, 44);
	[self addSubview:downButton];
	
	rightButton = downButton;
}


- (id)init {
	if (self = [super init]) {
		[self initialize];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initialize];
	}
	return self;
}


- (void)leftButtonAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	[leftButton addTarget:target action:action forControlEvents:controlEvents];
}


- (void)rightButtonAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	[rightButton addTarget:target action:action forControlEvents:controlEvents];
}



@end




