/*
 *  WaitingSplashView.m
 *
 *  Created by 종욱 윤 on 10. 10. 5..
 *  Copyright 2010 (주) 쿠콘. All rights reserved.
 *
 */

#import <QuartzCore/QuartzCore.h>
#import "WaitingSplashView.h"
#import "SysUtils.h"
#import "Constants.h"
#import <UIKit/UIKit.h>
#import "SessionManager.h"

@interface WaitingSplashView()
- (void)changeView:(UIInterfaceOrientation)orient;
@end


@implementation WaitingSplashView
BOOL bOrientation = YES;
static NSInteger kIndicatorSize = 32;

#pragma mark -
#pragma mark private Method
- (void)changeView:(UIInterfaceOrientation)orient {
	UIImageView *tempView = (UIImageView *)[self viewWithTag:55000];
    CGRect screenRect = [[UIScreen mainScreen] bounds];

	self.frame = screenRect;
    
    if ([SessionManager sharedSessionManager].isSyncView == YES) {
        tempView.frame = CGRectMake((screenRect.size.width/2) - 55 - ((screenRect.size.width-120)),(screenRect.size.height/2)-55, 110, 100);

    }else{
        tempView.frame = CGRectMake((screenRect.size.width/2) - 55,(screenRect.size.height/2)-55, 110, 100);
    }

	
}


#pragma mark -
#pragma mark Public Method
- (void)show {
	[CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:0.1f] forKey:kCATransactionAnimationDuration]; //0.0f
    
	CATransition* push	= [CATransition animation];
    push.type			= kCATransitionPush;
    push.subtype		= kCATransitionFromTop;
	
    [self.layer addAnimation:push forKey:kCATransition];
	[self changeView:UIInterfaceOrientationPortrait];
	
	[CATransaction flush];
    [CATransaction commit];
}


- (void)chageText:(NSString *)text{
	UIImageView *tempView = (UIImageView *)[self viewWithTag:3000];
    
    if (self.frame.size.height >= 500) {
        tempView.image = [UIImage imageNamed:@"a10110_a.png"];
        tempView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 568.0);
    }
    else {
        tempView.image = [UIImage imageNamed:@"a10100_a.png"];
        tempView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0);
    }
    
	
}


- (void)close {
//    UIActivityIndicatorView *indicator  = (UIActivityIndicatorView *)[self viewWithTag:220000];
//    [indicator stopAnimating];

    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:0.3f] forKey:kCATransactionAnimationDuration];
	
    CATransition* push	= [CATransition animation];
	push.type			= kCATransitionPush;
    push.subtype		= kCATransitionFromBottom;
	
    [self.layer addAnimation:push forKey:kCATransition];
	
	//	if ([SysUtils isPad] == NO)
	self.frame = CGRectMake(0.0f, [[UIScreen mainScreen] applicationFrame].size.height+40, 0, 0);
	
    [CATransaction commit];
	bOrientation = YES;
	
}


- (void)changeOrientation:(UIInterfaceOrientation)orient {
	[self changeView:orient];		
}


#pragma mark -
#pragma mark LifeCycle Method
- (void)internalInit {
	if (self == nil)
		return;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
//    int width = 0;
//    if ([SessionManager sharedSessionManager].isSyncView == YES){
//        width = 100;
//    }
    
//    UIImageView* lodingImageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenRect.size.width/2) - 55,(screenRect.size.height/2)-55, 110, 100)];
//    lodingImageView.image        = [UIImage imageNamed:@"loading_bg.png"];
//
//    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 70, 60)];
//    
//    animatedImageView.animationImages = [NSArray arrayWithObjects:
//                                         [UIImage imageNamed:@"loading_img01"],
//                                         [UIImage imageNamed:@"loading_img02"],
//                                         [UIImage imageNamed:@"loading_img03"],
//                                         [UIImage imageNamed:@"loading_img04"],
//                                         [UIImage imageNamed:@"loading_img05"],
//                                         [UIImage imageNamed:@"loading_img06"],
//
//                                         nil];
//    
//    animatedImageView.animationDuration = 1.0;
//    animatedImageView.animationRepeatCount = 0;
//    [lodingImageView addSubview:animatedImageView];
//    lodingImageView.tag = 55000;
//
//    [self addSubview:lodingImageView];
//
//    [animatedImageView startAnimating];
    
    
    //로딩중 이미지 처리
    UIActivityIndicatorView *indicator	= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)UIActivityIndicatorViewStyleGray];
    indicator.frame						= CGRectMake(([[UIScreen mainScreen] bounds].size.width - 16.0f) / 2, ([[UIScreen mainScreen] bounds].size.height - 16.0f) / 2, 16.0f, 16.0f);
    indicator.tag                       = 3002;
    indicator.hidesWhenStopped			= YES;
    
    
    [self addSubview:indicator];
    [indicator startAnimating];
    //[indicator release];
    
}


- (id)init {
	self = [super init];
	
	if ([SysUtils isNull:self] == NO)
		[self internalInit];

	return self;
}


@end
