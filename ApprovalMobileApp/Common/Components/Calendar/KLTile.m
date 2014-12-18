/*
 * Copyright (c) 2008, Keith Lazuka, dba The Polypeptides
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *	- Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *	- Neither the name of the The Polypeptides nor the
 *	  names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY Keith Lazuka ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL Keith Lazuka BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

//
//    NOTES
//
//        (1) Everything is drawn relative to self's bounds so that
//            the graphics can be scaled nicely just by changing the bounds
//
//        (2) Since Core Animation can linearly interpolate the view's bounds
//            you can easily zoom the view into this tile and everything will
//            look nice as soon as you redraw it.
//
//        (3) When a tile is marked as "commented", the tile will display
//            a small circle indicator near the bottom middle of the tile.
//
//        (4) When a tile is marked as "checkmarked", a large green checkmark
//            will be drawn over the tile.
//
//        (5) If you change either the commented or the checkmarked properties
//            on this tile, you must call 'setNeedsDisplay' on the tile
//            in order for the changes to become visible.
//

#import "KLTile.h"
#import "Constants.h"
#import	"DateUtils.h"
#import "KLGraphicsUtils.h"
#import "SessionManager.h"

static CGGradientRef TextFillGradient;

__attribute__((constructor))        // Makes this function run when the app loads
static void InitKLTile(){
    // prepare the gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef rawColors[2];
    rawColors[0] = CreateRGB(0.173f, 0.212f, 0.255f, 1.0f);
    rawColors[1] = CreateRGB(0.294f, 0.361f, 0.435f, 1.0f);
    
    CFArrayRef colors = CFArrayCreate(NULL, (void*)&rawColors, 2, NULL);
	
    // create it
    TextFillGradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
	
    CGColorRelease(rawColors[0]);
    CGColorRelease(rawColors[1]);
    CFRelease(colors);
    CGColorSpaceRelease(colorSpace);
}

@interface KLTile ()
- (CGFloat)thinRectangleWidth;
@end

@implementation KLTile

@synthesize date				= _date;
@synthesize dateLabel			= _dateLabel;
@synthesize lunarLabel			= _lunarLabel;
@synthesize selectedImageCode	= _selectedImageCode;
@synthesize todayImageCode		= _todayImageCode;
@synthesize holiDay				= _holiDay;
@synthesize iconDisplay			= _iconDisplay;
@synthesize lunarDisplay		= _lunarDisplay;
@synthesize haveIcontype1		= _haveIcontype1;
@synthesize haveIcontype2		= _haveIcontype2;
@synthesize haveIcontype3		= _haveIcontype3;

#pragma mark -
#pragma mark touchEvent
#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { [[self superview] touchesBegan:touches withEvent:event]; }


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event { [[self superview] touchesMoved:touches withEvent:event]; }


- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1)
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    else
        [[self superview] touchesEnded:touches withEvent:event];
}


#pragma mark -
#pragma mark UIControl Method
#pragma mark -
- (id)init {
	if (![super initWithFrame:CGRectMake(0.f, 0.f, 42.5, kCalendardayrowHeight)])
        return nil;
	
	_selectedImage		= nil;
	self.todayImageCode = nil;
    self.clipsToBounds	= YES;
	self.holiDay		= NO;
	self.lunarDisplay	= NO;
	self.iconDisplay	= NO;
    caleString = [[NSString alloc]init];

    //달력의 이미지 배경이 올라가면 일자 라벨을 넣어주는 Label
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 11.0f, 42.5, 14.0f)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = RGB(251, 86, 84);
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_dateLabel];
    
//        //음력 표시
//        _lunarLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 22.0f, 38.0f, 16.0f)];
//        _lunarLabel.backgroundColor = [UIColor clearColor];
//        _lunarLabel.textAlignment = UITextAlignmentLeft;
//        _lunarLabel.font = [UIFont systemFontOfSize:14.0f];
//        _lunarLabel.text = @"";
//        [self addSubview:_lunarLabel];
  

	

	
	
	self.backgroundColor = [UIColor colorWithCGColor:kCalendarBodyLightColor];
	
    return self;
}


- (void)dealloc {
	self.selectedImageCode = nil;
	self.todayImageCode = nil;
	
	if(_iconArray) 
		[_iconArray release];
	
	
	[_dateLabel release];
	[_lunarLabel release];
	
    [super dealloc];
}


- (void)drawInnerShadowRect:(CGRect)rect percentage:(CGFloat)percentToCover context:(CGContextRef)ctx {
    CGFloat width = floorf(rect.size.width);
    CGFloat height = floorf(rect.size.height) + 4;
    CGFloat gradientLength = percentToCover * height;
    
    CGColorRef startColor = CreateRGB(0.0f, 0.0f, 0.0f, 0.4f);  // black 40% opaque
    CGColorRef endColor = CreateRGB(0.0f, 0.0f, 0.0f, 0.0f);    // black  0% opaque
    CGColorRef rawColors[2] = { startColor, endColor };
    CFArrayRef colors = CFArrayCreate(NULL, (void*)&rawColors, 2, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
	
    CGContextClipToRect(ctx, rect);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,0), CGPointMake(0, gradientLength), kCGGradientDrawsAfterEndLocation); // top
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(width,0), CGPointMake(width-gradientLength, 0) , kCGGradientDrawsAfterEndLocation); // right
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,height), CGPointMake(0, height-gradientLength), kCGGradientDrawsAfterEndLocation); // bottom
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,0), CGPointMake(gradientLength, 0) , kCGGradientDrawsAfterEndLocation); // left
	
    CGGradientRelease(gradient);
    CFRelease(colors);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(startColor);
    CGColorRelease(endColor);
}


- (CGFloat)thinRectangleWidth { 
	return 1 + floorf(0.02f * self.bounds.size.width); 
}       


- (void)drawTextInContext:(CGContextRef)ctx{
	_dateLabel.hidden = YES;
    CGContextSaveGState(ctx);
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat numberFontSize = floorf(0.5f * width);
    
    CGContextSetFillColorWithColor(ctx, kDarkCharcoalColor);
    CGContextSetTextDrawingMode(ctx, kCGTextClip);
	
    for (NSInteger i = 0; i < [_dateLabel.text length]; i++) {
        NSString *letter = [_dateLabel.text substringWithRange:NSMakeRange(i, 1)];
        CGSize letterSize = [letter sizeWithFont:[UIFont boldSystemFontOfSize:numberFontSize]];
		
        CGContextSaveGState(ctx);  // I will need to undo this clip after the letter's gradient has been drawn
        [letter drawAtPoint:CGPointMake(4.0f+(letterSize.width*i), 0.0f) withFont:[UIFont boldSystemFontOfSize:numberFontSize]];
		
        if ([[self.date dateToString:@"yyyyMMdd"] isEqualToString:[[NSDate date]dateToString:@"yyyyMMdd"]]) {
            CGContextSetFillColorWithColor(ctx, kWhiteColor);
            CGContextFillRect(ctx, self.bounds);  
        } else {
            CGContextDrawLinearGradient(ctx, TextFillGradient, CGPointMake(0,0), CGPointMake(0, height/3), kCGGradientDrawsAfterEndLocation);
        }
		
        CGContextRestoreGState(ctx);  // get rid of the clip for the current letter        
    }
    
    CGContextRestoreGState(ctx);
}


- (void)drawRect:(CGRect)rect{
	if(!_selectedImageCode)
	{
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		CGFloat width = self.bounds.size.width;
		CGFloat height = self.bounds.size.height;
		CGFloat lineThickness = [self thinRectangleWidth];  // for grid shadow and highlight
		
		// dark grid line
		CGContextSetFillColorWithColor(ctx, kGridDarkColor);
		CGContextFillRect(ctx, CGRectMake(0, 0, width, lineThickness));                    // top
		CGContextFillRect(ctx, CGRectMake(width-lineThickness, 0, lineThickness, height)); // right
		
		// highlight
		CGContextSetFillColorWithColor(ctx, kGridLightColor);
		CGContextFillRect(ctx, CGRectMake(0, lineThickness, width-lineThickness, lineThickness));                      // top
		CGContextFillRect(ctx, CGRectMake(width-2*lineThickness, lineThickness, lineThickness, height-lineThickness)); // right
		
		// Highlight if this tile represents today
		if ([[self.date dateToString:@"yyyyMMdd"] isEqualToString:[[NSDate date]dateToString:@"yyyyMMdd"]]) {
			CGContextSaveGState(ctx);
			CGRect innerBounds = self.bounds;
			innerBounds.size.width	-= lineThickness;
			innerBounds.size.height -= lineThickness;
			innerBounds.origin.y	+= lineThickness;
			CGContextSetFillColorWithColor(ctx, kSlateBlueColor);
			CGContextFillRect(ctx, innerBounds);
			[self drawInnerShadowRect:innerBounds percentage:0.1f context:ctx];
			CGContextRestoreGState(ctx);
		}
		
		[self drawTextInContext:ctx];
	}
}


#pragma mark -
#pragma mark Pubilic Method
#pragma mark -


- (void)addIconImage:(IconTypes)types imageName:(NSString *)imageName{
	if (!_iconDisplay) {
		return;
	}
	
	if(!_iconArray)
		_iconArray = [[NSMutableArray alloc] init];

	UIImageView *addIconView = nil;
	
	switch (types) {
		case IconType1:
			if (_haveIcontype1) return;
			_haveIcontype1 = YES;
			break;
		case IconType2:
			if (_haveIcontype2) return;
			_haveIcontype2 = YES;
			break;
		case IconType3:
			if (_haveIcontype3) return;
			_haveIcontype3 = YES;
			break;
	}
	
	
	
	if ([imageName isEqualToString:@""] == NO) {
		addIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
		addIconView.contentMode = UIViewContentModeRight;
		addIconView.frame = CGRectMake(0.0f, 0.0f, 11.0f, 10.0f);
		
		[self insertSubview:addIconView aboveSubview:self.dateLabel];
		[addIconView release];
	}
	
	// 중앙 하단에 표시되는 아이콘이 여러개인경우 차례로 배치한다.
	CGFloat totalIconsWidth = 0.f;
	CGFloat startXPoint = 0.f;
	
	for (UIImageView* iconView in _iconArray)
		totalIconsWidth += iconView.frame.size.width;
	
	startXPoint = (self.frame.size.width - totalIconsWidth) / 2;

	for (int i = 0; i < [_iconArray count]; i++) {
		UIImageView *iconView = [_iconArray objectAtIndex:i];
		
		iconView.frame = CGRectMake(startXPoint, self.frame.size.height - iconView.frame.size.height - 3, 
									iconView.frame.size.width, iconView.frame.size.height);
		
		startXPoint += iconView.frame.size.width;
	}
}


- (void)addBadge:(NSInteger)count imageName:(NSString *)imageName {
    
        // background image
    UIImageView *addIconView = nil;
    addIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_planbullet.png"]];
    addIconView.frame = CGRectMake(19, 26, 5, 5);
    addIconView.backgroundColor = [UIColor clearColor];
//    addIconView.layer.masksToBounds         = YES;
//    addIconView.layer.cornerRadius          = 40;
    
    [self insertSubview:addIconView aboveSubview:self.dateLabel];
    [addIconView release];
    
//        //Badge 건수표시
//        _BadgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 2.0f, 29.0f, 21.0f)];
//        _BadgeLabel.backgroundColor = [UIColor grayColor];
//        _BadgeLabel.textAlignment   = UITextAlignmentCenter;
//        _BadgeLabel.textColor       = RGB(155,55,255);
//        _BadgeLabel.font            = [UIFont systemFontOfSize:18.0f];
//        [addIconView addSubview:_BadgeLabel];
//
//        _BadgeLabel.text            = [NSString stringWithFormat:@"1%d",count];
    

}


- (BOOL)isHaveIcon{
	if (_iconArray) {
		return [_iconArray count] > 0;
	}
	return NO;
}


- (void)flash{
    self.backgroundColor = [UIColor lightGrayColor];
}


- (void)restoreBackgroundColor{
    self.backgroundColor = [UIColor colorWithCGColor:kCalendarBodyLightColor];
}


#pragma mark -
#pragma mark property Method
#pragma mark -
- (void)setSelectedImageCode:(NSString *)value {
	if(_selectedImageCode)
		[_selectedImageCode release];
	
	_selectedImageCode = [value copy];
	
	self.backgroundColor = [UIColor clearColor];
}


- (void)setDate:(NSDate *)inDate {
	if (_date) [_date release];

	_date = [inDate copy];

	if (!_date) return;
	
	_dateLabel.text = [NSString stringWithFormat:@"%d", [_date day]];
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 음력을 여기서 표시 할 경우 Distribution compile시 아래와 같이 죽는 문제가 발생 함으로 반드시 밖에서 tile.lunarLabel.text로 assign바람.
	// SDK의 버그 이거나 오류를 찾지 못하는 부분이다.
	// 죽는 사유 : <Error>: *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[UILabel VerticalOffset:]: unrecognized selector sent to instance 0x46dc470'
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	NSInteger weekday = [_date dayOfWeek];
	
        _dateLabel.textColor  = RGB(43, 43, 43);
        _lunarLabel.textColor = RGB(43, 43, 43);
        
        if (!self.holiDay)
            self.holiDay = weekday == 1;
        
        if (weekday == 7){
            _dateLabel.textColor = RGB(25, 145, 229);
            _lunarLabel.textColor = RGB(25, 145, 229);
        }
        
        
        if (self.holiDay) {
            _dateLabel.textColor = RGB(246, 123, 123);
            _lunarLabel.textColor = RGB(246, 123, 123);
        }
        
        // today
        if ([[_date dateToString:@"yyyyMMdd"] isEqualToString:[[NSDate date]dateToString:@"yyyyMMdd"]] && _todayImageCode){
                UIImageView *todayBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_circle01.png"]];
                todayBackgroundView.frame = CGRectMake(8.6, 6.3, 26, 26);
                [self insertSubview:todayBackgroundView belowSubview:_dateLabel];
                [todayBackgroundView release];
            
            
        }
        
        
//        for (NSDictionary *calDic in [SessionManager sharedSessionManager].calData) {
//            
//            if ([[calDic objectForKey:@"START_DATE"] isEqualToString:[_date dateToString:@"yyyyMMdd"]]) { 
//                if ([caleString isEqualToString:[calDic objectForKey:@"START_DATE"]]) {
//                    [SessionManager sharedSessionManager].calCount += 1;
//                }else {
//                    caleString = [NSString stringWithFormat:@"%@",[calDic objectForKey:@"START_DATE"]];
//                    [SessionManager sharedSessionManager].calCount = 1;
//                }
//                UIImageView *inScheduleBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"b04900_a.png"]];
//                inScheduleBackgroundView.frame = CGRectMake(27, 15, 15, 15);
//                [self insertSubview:inScheduleBackgroundView belowSubview:_dateLabel];
//                UILabel *dayCount = [[UILabel alloc] initWithFrame:CGRectMake(4, 2.0f, 11.0f, 11.0f)];
//                dayCount.font = [UIFont boldSystemFontOfSize:11.0];
//                NSString *dayCountString = [NSString stringWithFormat:@"%d",[SessionManager sharedSessionManager].calCount];
//                dayCount.text = dayCountString;
//                dayCount.textColor = RGB(255, 255, 255);
//                dayCount.backgroundColor = [UIColor clearColor];
//                [inScheduleBackgroundView addSubview:dayCount];
//                [dayCount release];
//                
//                [inScheduleBackgroundView release];
//            }
//        }
    


	
}


- (void)setSelected:(BOOL)selection {
	super.selected = selection;
	
        if (_selectedImageCode)	{
            if (super.selected && !_selectedImage) {
                if ([[_date dateToString:@"yyyyMMdd"] isEqualToString:[[NSDate date]dateToString:@"yyyyMMdd"]] && _todayImageCode){
                    _selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_circle02.png"]];
                    _selectedImage.frame = CGRectMake(8.6, 6.3, 26, 26);
                    [self insertSubview:_selectedImage atIndex:1];
                    [_selectedImage release];
                }else {
                    _selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_circle02.png"]];
                    [self insertSubview:_selectedImage atIndex:0];
                    _selectedImage.frame = CGRectMake(8.6, 6.3, 26, 26);
                    [_selectedImage release];
                }
                
            } else if (!super.selected && _selectedImage) {
                [_selectedImage removeFromSuperview];
                _selectedImage = nil;
            }
        }
        else {
            if (super.selected)
                [self flash];
            else 
                [self restoreBackgroundColor];
        }
    
}



@end