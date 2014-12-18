//
//  WCTabBarView2.m
//
//  Created by donghwan kim on 11. 4. 11..
//  Copyright 2011 webcash. All rights reserved.
//

#import "WCTabBarView2.h"
#import "Constants.h"
#import "SysUtils.h"
#import "SessionManager.h"
@implementation WCTabBarView2
@synthesize delegate		= _Delegate;
@synthesize image2XSize		= _image2XSize;


//                                  #Lighter r,g,b,a                    #Darker r,g,b,a
#define MAIN_COLOR_COMPONENTS       { 0.053, 0.053, 0.053, 1.0, 0, 0, 0, 1.0 }
#define LIGHT_COLOR_COMPONENTS      { 0.124, 0.124, 0.124, 1.0, 0.124, 0.124, 0.124, 1 }

#pragma mark -
#pragma mark Private Method
- (NSInteger)getNumberOfGroup {
	if (!_Delegate || ![_Delegate respondsToSelector:@selector(numberOfGroup:)]) {
		return 0;
	}
	
	return [_Delegate numberOfGroup:self];
}


- (NSInteger)getNumberOfItems:(NSInteger)group {
	if (!_Delegate || ![_Delegate respondsToSelector:@selector(numberOfItems:groupIndex:)]) {
		return 0;
	}
	
	return [_Delegate numberOfItems:self groupIndex:group];
}


- (UIImage *)receiveItemImage:(NSInteger)group index:(NSInteger)index {
	if ((_Delegate == nil) || ([_Delegate respondsToSelector:@selector(tabView:groupIndex:image:)] == NO))
		return nil;
	
	return [_Delegate tabView:self groupIndex:group image:index];
}


- (UIImage *)receiveHighlightedImage:(NSInteger)group index:(NSInteger)index {
	if ((_Delegate == nil) || ([_Delegate respondsToSelector:@selector(tabView:groupIndex:highlighted:)] == NO))
		return nil;
	
	return [_Delegate tabView:self groupIndex:group highlighted:index];
}


// currentGroup property accessors
- (NSInteger)currentGroup {
	return _currentGroup;
}






// currentGroup property setter
- (void)setCurrentGroup:(NSInteger)group {
	if (_currentGroup == group) {
		return;
	}
	
	if ((group + 1) *320 > _mainScroll.contentSize.width) {
		return;
	}
	
	[_mainScroll setContentOffset:CGPointMake(group * 320, 0.0f) animated:NO];
	_currentGroup = group;
}



#pragma mark -
#pragma mark Event Mehtod
- (void)itemClicked:(UIButton *)sender {

    if ([SessionManager sharedSessionManager].isNetworkStuts == NO) {
        for (int i = 10000; i <= selectInt; i++) {
            UIButton *deSelectBt = ((UIButton *)[self viewWithTag:i]);
            deSelectBt.selected = NO;
        }
        
        
        UIButton *selectBt = ((UIButton *)[self viewWithTag:[sender tag]]);
        
        if (selectBt.selected == NO) {
            selectBt.selected = YES;
        }
        
        div_t remain;
        if (_Delegate && [_Delegate respondsToSelector:@selector(tabView:groupIndex:didSelectItem:)]) {
            remain = div(sender.tag, 100);
            [_Delegate tabView:self groupIndex:remain.quot didSelectItem:remain.rem];
        }
    }

}


#pragma mark -
#pragma mark Public Method
- (void)reloadData {
	NSInteger nGroup = [self getNumberOfGroup];
	NSInteger nCount = 0;
	
	
	if (nGroup == 0) {
		return;
	}
	
	_mainScroll.contentSize = CGSizeMake(320.0f * nGroup, 0.0f);
	
	
	CGFloat fWidth = 0; ;
	CGFloat fDefault = 0;
	UIImage *normalImage = nil;
	UIImage *highlightImage = nil;
	
    for (int i = 10000; i <= 10005; i++) {
        UIButton *deSelectBt = ((UIButton *)[self viewWithTag:i]);
        [deSelectBt removeFromSuperview];
    }
    
	UIButton *button;
	for (int j=0; j<nGroup; j++) {
		nCount = [self getNumberOfItems:j];
		
		fDefault = 320.0f * j;
		fWidth = 320.0f/nCount;

		for (int i=0; i<nCount; i++) {
			button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.tag = i + (j * 100) + 10000;
            selectInt = button.tag;
			button.frame = CGRectMake(fDefault + fWidth*i, 0.0f, fWidth, 49.0f);
			
			normalImage = [self receiveItemImage:j index:i];
            
			highlightImage = [self receiveHighlightedImage:j index:i];
			
			if (normalImage)
				[button setImage:normalImage forState:UIControlStateNormal];

			if (highlightImage)
				[button setImage:highlightImage forState:UIControlStateSelected];
            
            
            
            [button setBackgroundImage:[[UIImage imageNamed:@"bg_bottom.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"bg_bottom_on.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
            [button setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
            
            UILabel* buttonLabel			= [[UILabel alloc] initWithFrame:CGRectMake(0, 35, fWidth, 10)];
            buttonLabel.backgroundColor	= [UIColor clearColor];
            buttonLabel.textAlignment     = NSTextAlignmentCenter;
            buttonLabel.font				= [UIFont fontWithName:kDefaultFontName size:9];
            buttonLabel.text              = [[[SessionManager sharedSessionManager].menuArray objectAtIndex:i] objectForKey:@"menuName"];
            buttonLabel.textColor                         = RGB(255, 255, 255);
            [button addSubview:buttonLabel];

			[button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
			[_mainScroll addSubview:button];
		}
	}
}



#pragma mark -
#pragma mark LifeCycle Method
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        
		_currentGroup = 0;

		_Delegate = nil;
		_image2XSize = NO;
		_mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 49.0f)];
		_mainScroll.scrollEnabled = NO;
		_mainScroll.contentSize = CGSizeMake(320.0f, 49.0f);
		_mainScroll.backgroundColor = [UIColor clearColor];
        
        
		[self addSubview:_mainScroll];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabbarResetNotification:) name:kTabbarResetNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabbarSelectBtNotification:) name:kTabbarSelectBtNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabbarCarBtSelectNotification:) name:kTabbarCarBtSelectNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabbarNotiSelectBtNotification:) name:kTabbarNotiSelectBtNotification object:nil];


    }
	
    return self;
}

- (void)TabbarNotiSelectBtNotification:(NSNotification *)note {
    for (int i = 10000; i <= 10005; i++) {
        UIButton *deSelectBt = ((UIButton *)[self viewWithTag:i]);
        if ([SysUtils isNull:deSelectBt] == NO) {
            deSelectBt.selected = NO;
            
        }
    }
    

    NSInteger menuArrInt = 0;
    if ([SessionManager sharedSessionManager].bIsLogin == YES && [SysUtils isNull:[SessionManager sharedSessionManager].userID] == NO)
        
        for (NSDictionary *dataDic in  [SessionManager sharedSessionManager].menuArray) {
            if ([[dataDic objectForKey:@"menuName"]isEqualToString:@"알림내역"]) {
                UIButton *deSelectBt = ((UIButton *)[self viewWithTag:10000+ menuArrInt]);
                deSelectBt.selected = YES;
            }
            menuArrInt++;
        }
    

}
- (void)TabbarCarBtSelectNotification:(NSNotification *)note {
    UIButton *deSelectBt = ((UIButton *)[self viewWithTag:10000+ [[[note userInfo] objectForKey:@"selectBt"] integerValue]]);
    deSelectBt.selected = YES;
}

- (void)TabbarSelectBtNotification:(NSNotification *)note {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstView"] integerValue] != 0) {
        UIButton *deSelectBt = ((UIButton *)[self viewWithTag:10000+[[[NSUserDefaults standardUserDefaults] objectForKey:@"firstView"] integerValue]-1]);
        deSelectBt.selected = YES;

    }

    
}
- (void)TabbarResetNotification:(NSNotification *)note {
    for (int i = 10000; i <= 10005; i++) {
        UIButton *deSelectBt = ((UIButton *)[self viewWithTag:i]);
        if ([SysUtils isNull:deSelectBt] == NO) {
            deSelectBt.selected = NO;

        }
    }
    
}
- (void)drawRect:(CGRect)rect {

	// emulate the tint colored bar
	CGContextRef context			= UIGraphicsGetCurrentContext();
	CGFloat locations[2]			= {0.0, 1.0};
	CGColorSpaceRef myColorspace	= CGColorSpaceCreateDeviceRGB();

	// Top Background 
	CGFloat topComponents[8]	= LIGHT_COLOR_COMPONENTS;
	CGGradientRef topGradient	= CGGradientCreateWithColorComponents(myColorspace, topComponents, locations, 2);
	CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, 0), CGPointMake(0, self.frame.size.height/2), 0);
	CGGradientRelease(topGradient);

	// Bottom Background 
	CGFloat botComponents[8]	= MAIN_COLOR_COMPONENTS;
	CGGradientRef botGradient	= CGGradientCreateWithColorComponents(myColorspace, botComponents, locations, 2);
	CGContextDrawLinearGradient(context, botGradient,
	CGPointMake(0,self.frame.size.height/2), CGPointMake(0, self.frame.size.height), 0);

	CGGradientRelease(botGradient);
	CGColorSpaceRelease(myColorspace);

	// top Line 
//	CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
//	CGContextMoveToPoint(context, 0, 0);
//	CGContextAddLineToPoint(context, self.frame.size.width, 0);
//	CGContextStrokePath(context);


	// bottom line
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
	CGContextMoveToPoint(context, 0, self.frame.size.height);
	CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
	CGContextStrokePath(context);
}


- (void)dealloc {
	[_mainScroll release];
    [super dealloc];
}


@end
