//
//  IconLableView.h
//
//  Created by donghwan kim on 11. 3. 30..
//  Copyright 2011 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>


/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief Defines a concrete @c IconLableView 아이콘이 있는 Label View
 
 @c IconLableView는 좌측 이미지 이후 라벨이 있을 경우 사용하는 뷰
 */
@interface IconLableView : UIView {

}
@property (nonatomic, assign) UIFont* font;
@property (nonatomic, assign) UIColor* textColor;
@property (nonatomic, assign) NSString* text;
//@property (nonatomic) UITextAlignment textAlignment;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) NSInteger numberOfLines;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 생성 함수
 
 @param frame				@c CGRect frame
 @param IconImageName		@c NSString IconImageName

 @return @c id 생성된 객체 전달
 
 */
- (id)initWithFrameAndIcon:(CGRect)frame IconImageName:(NSString *)IconImageName;


@end
