//
//  TitleBoxView.m
//
//  Created by donghwan kim on 11. 3. 30..
//  Copyright 2011 webcash. All rights reserved.
//

#import "TitleBoxView.h"
#import "Constants.h"
#import "AllUtils.h"
#import "AllEffects.h"


@implementation TitleBoxView


- (void)setTitle:(NSString *)title{
	UILabel *titleLabel = (UILabel *)[self viewWithTag:99999];
	titleLabel.text = title;
}


- (id)initWithFrameWithTitle:(CGRect)frame title:(NSString *)title boxType:(TitleBoxType)boxType{
    self = [super initWithFrame:frame];

    if (self) {
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		
		UIImageView *backgroundView = nil;
		UIImage* boxImage = nil; 
		switch (boxType) {
			case TitleBoxTypeCommon:
				boxImage = [[UIImage imageNamed:[SysUtils imageCodeToFileName:@"a10200"]] scaleToSize:CGSizeMake(310.0f, 49.0f)];
				break;
			case TitleBoxTypeBIZ:
				boxImage = [[UIImage imageNamed:[SysUtils imageCodeToFileName:@"q04500"]] scaleToSize:CGSizeMake(310.0f, 49.0f)];
				break;
		}
				
		//소상자 Background Image
		backgroundView = [[UIImageView alloc] initWithImage:[boxImage stretchableImageWithLeftCapWidth:0 topCapHeight:44]];
		backgroundView.frame = CGRectMake(0.0f, 0.0f, 310.0f, frame.size.height);
		backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[self addSubview:backgroundView];
		[backgroundView release];
		
		
		switch (boxType) {
			case TitleBoxTypeCommon:
				//소상자 아이콘
				backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"z07800"]]];
				backgroundView.frame = CGRectMake(8.0f, 10.0f, 24.0f, 23.0f);
				[self addSubview:backgroundView];
				
				break;
			case TitleBoxTypeBIZ:

				break;
		}
		

		
		//소상자 타이틀
		UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(38.0f, 12.0f, 270.0f, 20.0f)];
		subTitle.font = [UIFont fontWithName:kDefaultFontName size:18];
		subTitle.textColor = RGB(0, 0, 0);
//		subTitle.textAlignment = UITextAlignmentLeft;
        subTitle.textAlignment = NSTextAlignmentLeft;
		subTitle.text = title;
		subTitle.tag = 99999;
		subTitle.backgroundColor = [UIColor clearColor];
		[self addSubview:subTitle];
		[subTitle release];
	}	
	
	return self;
}


- (void)dealloc {
    [super dealloc];
}


@end
