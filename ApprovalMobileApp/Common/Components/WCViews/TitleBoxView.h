//
//  TitleBoxView.h
//
//  Created by donghwan kim on 11. 3. 30..
//  Copyright 2011 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	TitleBoxTypeCommon	= 0,
	TitleBoxTypeBIZ		= 1,
} TitleBoxType;


/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief Defines a concrete @c TitleBoxView 타이틀을 포함한 ㅂ
 
 @c SecurityView는 질의 응답 OTP로 질의 값 입력에 의한 결과 입력을 처리 하는 보안 매체
 */
@interface TitleBoxView : UIView {

}

/////////////////////////////////////////////////////////////////////////////////////////////
/** 생성 함수
 
 @param frame				@c CGRect frame
 @param title				@c NSString title
 @return @c id 생성된 객체 전달
 
 */
- (id)initWithFrameWithTitle:(CGRect)frame title:(NSString *)title boxType:(TitleBoxType)boxType;


/////////////////////////////////////////////////////////////////////////////////////////////
/** title변경
 
 @param title				@c NSString title
 
 */
- (void)setTitle:(NSString *)title;

@end
