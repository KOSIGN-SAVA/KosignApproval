//
//  WCViewController.h
//
//  Created by donghwan kim on 11. 3. 25..
//  Copyright 2011 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecurityManager.h"
#import "Constants.h"


typedef enum {
    UINavigationCustomBG	= 0,
    UINavigationLeftBG		= 1,
    UINavigationLeftRightBG = 2,
    UINavigationCenterBG    = 3,
	UINavigationNoneBG		= 100,
} UINavigationType;


typedef enum {
	UINavigationCommon		= 0,
	UINavigationBIZ			= 1,
	
} UINavigationBizType;




@interface WCViewController : UIViewController<SecurityManagerDelegate> {
	BOOL						_navigationHidden;
	UINavigationType			_navigationType;
	UINavigationBizType			_navigationBizType;
	BOOL						_defaultLeftButton;
    BOOL                        _defaultRightButton;
	BOOL						_numberPadDoneEnabled;
	BOOL						_waitSplashEnabled;
	BOOL						_isShowKeypad;
	BOOL						_isPortrait;
    BOOL                        _swipeEnabled;
//	UITextAlignment				_titleAlignment;
    Alignment                _titleAlignment;
    
	UIButton*					_btnKeyboardDone;
}

/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c BOOL navigationHidden 
	네비게이션 바 숨김 기능.
 */
@property (nonatomic) BOOL navigationHidden;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c BOOL navigationType 
 네비게이션 백그라운드 이미지 타입.
 */
@property (nonatomic) UINavigationType navigationType;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c BOOL navigationType 
 네비게이션 백그라운드 이미지 업무 공통 영역 분리.
 */
@property (nonatomic) UINavigationBizType navigationBizType;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c BOOL defaultLeftButton
	네비게이션 좌측 버튼 기본 버튼 사용 유무
 */
@property (nonatomic) BOOL defaultLeftButton;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c BOOL defaultRightButton
 네비게이션 우측 버튼 기본 버튼 사용 유무
 */
@property (nonatomic) BOOL defaultRightButton;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c BOOL numberPadDoneEnabled
	numberPAD의 확인 버튼 사용 유무 처리.
 */
@property (nonatomic) BOOL numberPadDoneEnabled;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c BOOL waitSplashEnabled
	전문 통신시 waitSplash 사용 유무
 */
@property (nonatomic) BOOL waitSplashEnabled;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c BOOL swipeEnabled
 swipeGesture 사용 유무 (default : YES) 
 swipeRight gesture 사용시 leftButtonClicked
 */
@property (nonatomic) BOOL swipeEnabled;


@property (nonatomic) BOOL isShowKeypad;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c BOOL waitSplashEnabled
	타이틀 영역의 Alignment
 */
//@property (nonatomic) UITextAlignment titleAlignment;
@property (nonatomic) Alignment titleAlignment;




/////////////////////////////////////////////////////////////////////////////////////////////
/** All Close KeyPad function  
 
 */
- (void)closeKeyboard;


/////////////////////////////////////////////////////////////////////////////////////////////
/** leftButton Click Method
 @param sender			@c UIButton left Button
 
 */
- (void)leftButtonClicked:(UIButton *)sender;



/////////////////////////////////////////////////////////////////////////////////////////////
/** rightButton Click Method
 @param sender			@c UIButton left Button
 
 */
- (void)rightButtonClicked:(UIButton *)sender;




- (void)titleClicked:(UIButton *)sender;



- (void)subTitleClicked:(UIButton *)sender;



/////////////////////////////////////////////////////////////////////////////////////////////
/** numberPadDone hidden Method
 @param hidden			@c BOOL YES hidden NO show
 
 */
- (void)numberPadDoneHidden:(BOOL)hidden;


/////////////////////////////////////////////////////////////////////////////////////////////
/** transaction Electri
 @param transCode		@c NSString Transation Code
 @param requestDictionary	@c NSDictionary request Data
 
 */
- (void)sendTransaction:(NSString *)transCode requestDictionary:(NSDictionary *)requestDictionary;


/////////////////////////////////////////////////////////////////////////////////////////////
/** transaction Electri
 @param transCode		@c NSString Transation Code
 @param requestDictionary	@c NSDictionary request Data
 
 */
- (void)sendTransactionNew:(NSString *)transCode requestDictionary:(NSDictionary *)requestDictionary;


/////////////////////////////////////////////////////////////////////////////////////////////
/** transaction Electri
 @param transCode		@c NSString Transation Code
 @param responseDictionary	@c NSDictionary response Data
 @param success			@c BOOL success
 
 */
- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success;




/////////////////////////////////////////////////////////////////////////////////////////////
/** privateShowIndicator
 
 @see privateCloseIndicator
 */
- (void)privateShowIndicator;


/////////////////////////////////////////////////////////////////////////////////////////////
/** privateCloseIndicator
 
 @see privateShowIndicator
 */
- (void)privateCloseIndicator; 


@end
