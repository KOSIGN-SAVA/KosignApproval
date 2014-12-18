//
//  UpDownButtonView.h
//  OfficeWB
//
//  Created by Yongjoo Park on 2/25/11.
//  Copyright 2011 Webcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysUtils.h"


/**
 Quick Start Guide
 
 1. 아래의 코드를 viewDidLoad 에 더한다.
 
 // set the buttons on right side of the navigation bar
 UpDownButtonView *rightSideButtons = [[[UpDownButtonView alloc] initWithFrame:CGRectMake(234, 0, 86, 44)] autorelease];
 self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightSideButtons] autorelease];
 
 
 2. 아래 함수를 이용해 버튼의 이벤트 핸들러를 설정한다.
 
 - (void)leftButtonAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
 - (void)rightButtonAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
 
 */



/**
 @brief Custom UIView for buttons on the right side of navigation bar
 */

@interface UpDownButtonView : UIView {
	UIButton *leftButton;
	UIButton *rightButton;
}

- (void)leftButtonAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)rightButtonAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@property (retain) UIButton *leftButton;
@property (retain) UIButton *rightButton;

@end




