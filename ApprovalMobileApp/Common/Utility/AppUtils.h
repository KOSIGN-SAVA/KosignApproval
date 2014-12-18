//
//  AppUtils.h
//  
//
//  Created by 종욱 윤 on 10. 10. 5..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kBackgroundTag		9999
#define kBackButtonTag		9998
#define kRightButtonTag		9997


@interface AppUtils : NSObject

/////////////////////////////////////////////////////////////////////////////////////////////
/** 네비게이션 바 타이틀 설정 함수
 
 Navigation Bar Title setting
 
 @param target	UIViewController
 @param title	NSString
 */
+ (void)settingNavigationBarTitle:(id)target title:(NSString *)title;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 네비게이션 이전,Beck 버튼 세팅 함수 
 
 Navigation Bar left Back Button setting
 
 @param target UIViewController
 @param action Selector receive Action
 */
+ (void)settingBackButton:(id)aTarget action:(SEL)aAction;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 네비게이션 좌측 버튼 세팅 함수
 
 Navigation Bar left Button setting
 
 @param target				UIViewController
 @param action				Selector receive Action
 @param normalImageCode		Normal Image Code
 @param highlightImageCode	highlight Image Code
 
 @see settingBackButton:action:
 @see settingRightButton:action:normalImageCode:highlightImageCode:
 
 */
+ (void)settingLeftButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 네비게이션 우측 버튼 세팅 함수
 
 Navigation Bar Right Button setting
 
 @param target				UIViewController
 @param action				Selector receive Action
 @param normalImageCode		Normal Image Code
 @param highlightImageCode	highlight Image Code
 
 @see settingBackButton:action:
 @see settingLeftButton:action:normalImageCode:highlightImageCode:
 
 */
+ (void)settingRightButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode;



/////////////////////////////////////////////////////////////////////////////////////////////
/** UIView의 기본 배경 이미지 세팅 함수
 
 UIView의 배경 이미지 세팅 함수 배경 이미지의 이동을 위햐여 dx, dy의 좌표 변경 가능.
 
 @param target				UIViewController
 @param dx					The offset value for the x-coordinate.
 @param dy					The offset value for the y-coordinate.
 
 @see settingBackGroundShadow:
 */
+ (void)settingBackground:(id)aTarget dx:(CGFloat)dx dy:(CGFloat)dy;

/////////////////////////////////////////////////////////////////////////////////////////////
+ (void)showWaitingSplash;

+ (void)closeWaitingSplash;

/////////////////////////////////////////////////////////////////////////////////////////////
/* UIAlertView With Activity Indigator 사용 함수
 */
+ (void)showActivityAlert;

+ (void)closeActivityAlert;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 소 타이틀 라벨 변경 및 배경화면 이미지 처리 함수
 
 해당 타이틀 뷰에 폰트 및 색상 그리고 뷰를 Assign하여 처리 하는 함수 입니다.
 
 @param target				UIViewController
 @param title				소 타이틀 명.
 */
+ (void)settingSubTitle:(id)target title:(NSString *)title;



////////////////////////////////////////////////////////////////////////////////////////////////
/** 일반적인 날짜형 데이타(yyyyMMdd)가 아닌 String형 데이타의 경우에 yyyy-DD-mm으로 바꾸는 함수
 
 */

+ (void)cutCharaterAddDash:(NSString *)aDate;


+ (NSString *)getTimeFormat:(NSString *)tString;


+ (BOOL)isAvailableDevice;


@end
