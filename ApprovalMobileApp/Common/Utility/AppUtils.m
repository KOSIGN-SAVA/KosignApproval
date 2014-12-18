//
//  AppUtils.m
//  
//
//  Created by 종욱 윤 on 10. 10. 5..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import "AppUtils.h"
#import "Constants.h"
#import "SysUtils.h"
#import "StrUtils.h"
#import "Reachability.h"
#import "SessionManager.h"
#import "JSON.h"
#import "ExtendedDevice.h"


@implementation AppUtils


+ (void)settingNavigationBarTitle:(id)aTarget title:(NSString *)title {
	
	if ([aTarget isKindOfClass:[UIViewController class]] == NO)
		return;
	
	UIViewController *viewController = aTarget;
	viewController.navigationItem.title = title;
}


+ (void)settingBackButton:(id)aTarget action:(SEL)aAction {
	if ([aTarget isKindOfClass:[UIViewController class]] == NO)
		return;

	UIViewController* calleeViewCtrl	= aTarget;
	UIImage* imgNormal					= [UIImage imageNamed:@"top_prev.png"];//[SysUtils imageCodeToFileName:aNormalImageCode]];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, imgNormal.size.width+7, imgNormal.size.height)];
        
        UIButton* btnNewLeft				= [[UIButton alloc] initWithFrame:CGRectMake(-5.0f, 0.0f, imgNormal.size.width, imgNormal.size.height)];
        [btnNewLeft setTag:kBackButtonTag];
        [btnNewLeft setBackgroundImage:imgNormal forState:UIControlStateNormal];
        
        if ([SysUtils isNull:@"top_prev_sel.png"] == NO)
            [btnNewLeft setBackgroundImage:[UIImage imageNamed:@"top_prev_sel.png"] forState:UIControlStateHighlighted];
        
        [btnNewLeft addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:btnNewLeft];
        
        UIBarButtonItem* btnNewBarLeft					= [[UIBarButtonItem alloc] initWithCustomView:imageView];
        calleeViewCtrl.navigationItem.leftBarButtonItem	= btnNewBarLeft;
        
        [btnNewBarLeft release];
        [btnNewLeft release];
        
    }else{
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, imgNormal.size.width+7, imgNormal.size.height)];
        
        UIButton* btnNewLeft				= [[UIButton alloc] initWithFrame:CGRectMake(6.0f, 0.0f, imgNormal.size.width, imgNormal.size.height)];
        [btnNewLeft setTag:kBackButtonTag];
        [btnNewLeft setBackgroundImage:imgNormal forState:UIControlStateNormal];
        
        if ([SysUtils isNull:@"top_prev_sel.png"] == NO)
            [btnNewLeft setBackgroundImage:[UIImage imageNamed:@"top_prev_sel.png"] forState:UIControlStateHighlighted];
        
        [btnNewLeft addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:btnNewLeft];
        
        UIBarButtonItem* btnNewBarLeft					= [[UIBarButtonItem alloc] initWithCustomView:imageView];
        calleeViewCtrl.navigationItem.leftBarButtonItem	= btnNewBarLeft;
        
        [btnNewBarLeft release];
        [btnNewLeft release];
        
    }
}


+ (void)settingLeftButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode {
	if ([aTarget isKindOfClass:[UIViewController class]] == NO)
		return;
    
	if ([SysUtils isNull:aNormalImageCode] == YES)
		return;
	
	UIViewController* calleeViewCtrl	= aTarget;
	UIImage* imgNormal					= [UIImage imageNamed:aNormalImageCode];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {

        UIButton* btnNewLeft				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgNormal.size.width/2, imgNormal.size.height/2)];
        
        [btnNewLeft setTag:kBackButtonTag];
        [btnNewLeft setBackgroundImage:imgNormal forState:UIControlStateNormal];
        
        if ([SysUtils isNull:aHighlightImageCode] == NO)
            [btnNewLeft setBackgroundImage:[UIImage imageNamed:aHighlightImageCode] forState:UIControlStateHighlighted];
        
        [btnNewLeft addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* btnNewBarLeft					= [[UIBarButtonItem alloc] initWithCustomView:btnNewLeft];
        calleeViewCtrl.navigationItem.leftBarButtonItem	= btnNewBarLeft;
        
        [btnNewBarLeft release];
        [btnNewLeft release];
    }else{
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, imgNormal.size.width, 44)];
        
        UIButton* btnNewLeft				= [[UIButton alloc] initWithFrame:CGRectMake(6.0f, (44-(imageView.frame.size.width/2))/2, imgNormal.size.width/2, imgNormal.size.height/2)];
        [btnNewLeft setTag:kBackButtonTag];
        [btnNewLeft setBackgroundImage:imgNormal forState:UIControlStateNormal];
        
        if ([SysUtils isNull:aHighlightImageCode] == NO)
            [btnNewLeft setBackgroundImage:[UIImage imageNamed:aHighlightImageCode] forState:UIControlStateHighlighted];
        
        [btnNewLeft addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:btnNewLeft];
        
        UIBarButtonItem* btnNewBarLeft					= [[UIBarButtonItem alloc] initWithCustomView:imageView];
        calleeViewCtrl.navigationItem.leftBarButtonItem	= btnNewBarLeft;
        
        [btnNewBarLeft release];
        [btnNewLeft release];
    }

    
}


+ (void)settingRightButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode {
	if ([aTarget isKindOfClass:[UIViewController class]] == NO)
		return;
	
	if ([SysUtils isNull:aNormalImageCode] == YES)
		return;
	
	UIViewController* calleeViewCtrl	= aTarget;
	UIImage* imgNormal					= [UIImage imageNamed:aNormalImageCode];
	UIButton* btnNewRight				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgNormal.size.width/2, imgNormal.size.height/2)];
	
	[btnNewRight setTag:kRightButtonTag];
	[btnNewRight setBackgroundImage:imgNormal forState:UIControlStateNormal];
	
	if ([SysUtils isNull:aHighlightImageCode] == NO)
		[btnNewRight setBackgroundImage:[UIImage imageNamed:aHighlightImageCode] forState:UIControlStateHighlighted];
	
	[btnNewRight addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* btnNewBarRight						= [[UIBarButtonItem alloc] initWithCustomView:btnNewRight];
	calleeViewCtrl.navigationItem.rightBarButtonItem	= btnNewBarRight;
	
	[btnNewBarRight release];
	[btnNewRight release];
}


+ (void)settingBackground:(id)aTarget dx:(CGFloat)dx dy:(CGFloat)dy {
	if ([aTarget isKindOfClass:[UIViewController class]] == NO)
		return;
    
	UIViewController* calleeViewCtrl	= aTarget;
	UIImageView* viewBackground			= [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"f01000"]]];
    
	if ([SysUtils isPad] == YES)
		viewBackground.frame			= CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
	else 	
		viewBackground.frame			= CGRectOffset(viewBackground.frame, dx, dy);
	
	viewBackground.tag					= kBackgroundTag;
	
	[calleeViewCtrl.view addSubview:viewBackground];
	[calleeViewCtrl.view sendSubviewToBack:viewBackground];
	[viewBackground release];
}	


+ (void)showWaitingSplash {
	[[NSNotificationCenter defaultCenter] postNotificationName:kShowWaitingViewNotification object:self userInfo:nil];
}


+ (void)closeWaitingSplash {
	[[NSNotificationCenter defaultCenter] postNotificationName:kCloseWaitingViewNotification object:self userInfo:nil];
}


+ (void)showActivityAlert {
	[[NSNotificationCenter defaultCenter] postNotificationName:kShowActivityAlertNotification object:self userInfo:nil];
}


+ (void)closeActivityAlert {
	[[NSNotificationCenter defaultCenter] postNotificationName:kCloseActivityAlertNotification object:self userInfo:nil];
}


+ (void)settingSubTitle:(id)target title:(NSString *) title {
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 5, 400, 21)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont fontWithName:kDefaultFontName size: 16.0];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = RGB(57, 108, 137);// [UIColor blackColor];
	titleLabel.text = title;
	[titleLabel sizeToFit];
	
	
	UIImageView *topShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"e02700"]]];
	topShadow.frame = CGRectMake(0.0f, 31.0f, 320.0f, 15.0f);
    
	
	if ([target isKindOfClass:[UIScrollView class]] == YES) {
		
		
		UIScrollView *temp  = target;
		
		[temp addSubview:titleLabel];
		[temp addSubview:topShadow];
		
	} else if ([target isKindOfClass:[UIViewController class]] == YES) {
		
		UIViewController *temp  = target;
		
		[temp.view addSubview:titleLabel];
		[temp.view addSubview:topShadow];				
		
	} else if ([target isKindOfClass:[UITableView class]] == YES) {
		
		UITableView *temp  = target;
		
		[temp addSubview:titleLabel];
		[temp addSubview:topShadow];				
		
	}
	
	
	[titleLabel release];
	[topShadow release];
}


+ (NSString *)getTimeFormat:(NSString *)tString {
	
	if (([tString isEqualToString:@""] == YES) || ([SysUtils isNull:tString] == YES)){
		return @"";
	}
	
	int timeValue = [[tString trim] intValue];
	
	if(timeValue >= 12) {
		
		if((timeValue == 24) || (timeValue == 0) || (timeValue == 00))
			return @"오전12시";
		
		else if(timeValue == 12)
			return @"오후12시";
		
		else
			return [NSString stringWithFormat:@"오후%@시", [SysUtils integerToString:timeValue-12]];
		
	} else {
		return [NSString stringWithFormat:@"오전%@시", [SysUtils integerToString:timeValue]];
	}
}

+ (void)cutCharaterAddDash:(NSString *)aDate {
  
//    if ([oldDate length] == 8){
        
        NSRange fRange,sRange,thRange;
        fRange.location = 0;
        fRange.length = 4;

        sRange.location = 4;
        sRange.length = 2;

        thRange.location = 6;
        thRange.length = 2;
        
        NSString* first = [aDate substringWithRange:fRange];
        NSString* second = [aDate substringWithRange:fRange];
        NSString* third = [aDate substringWithRange:fRange];
        
        [NSString stringWithFormat:@"%@-%@-%@",first,second,third];
//        NSString* dateString = 
//    }else{
//        return;
//    }
    
    

    
    
}


+ (BOOL)isAvailableDevice {
	switch ([[UIDevice currentDevice] getPlatformType]) {
		case 4:		// iPhone 1G
		case 5:		// iPhone 3G
		case 9:		// iPod 1G
		case 10:	// iPod 2G
		case 11:	// iPod 3G
			return NO;
	}
	
	return YES;
}


@end
