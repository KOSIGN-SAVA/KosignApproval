//
//  WCTabBarView2.h
//
//  Created by donghwan kim on 11. 4. 11..
//  Copyright 2011 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCTabBarView2Delegate;

@interface WCTabBarView2 : UIView {
	id<WCTabBarView2Delegate>		_Delegate;
	BOOL							_image2XSize;
	UIScrollView*					_mainScroll;
	NSInteger						_currentGroup;
    
    NSInteger                       selectInt;
}

- (void)reloadData;


/////////////////////////////////////////////////////////////////////////////////////////////
/** 탭바의 delegate 객체이다. @c WCTabBarViewDelegate protocol을 따른다. 
 */
@property (nonatomic, assign) id<WCTabBarView2Delegate> delegate;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 탭바의 이미지 사이즈를 조정한다 320 or 640. @c BOOL YES 640*960  NO 430.480. 
 */
@property (nonatomic) BOOL image2XSize;


@property (nonatomic) NSInteger currentGroup;

@end



@protocol WCTabBarView2Delegate<NSObject>

@required
/////////////////////////////////////////////////////////////////////////////////////////////
/** 탭바의 총 그룹 개수를 질의하는 메소드이다. (필수)
 
 @param tabBarView			메소드를 질의한 탭바 객체(@c WCTabBarView)
 @return					총 그룹 개수
 */
- (NSInteger)numberOfGroup:(WCTabBarView2 *)tabBarView;

- (NSInteger)numberOfItems:(WCTabBarView2 *)tabBarView groupIndex:(NSInteger)groupIndex;

- (UIImage *)tabView:(WCTabBarView2 *)tabBarView groupIndex:(NSInteger)groupIndex image:(NSInteger)index;

- (void)tabView:(WCTabBarView2 *)tabBarView groupIndex:(NSInteger)groupIndex didSelectItem:(NSInteger)index;


@optional
- (UIImage *)tabView:(WCTabBarView2 *)tabBarView groupIndex:(NSInteger)groupIndex highlighted:(NSInteger)index;



@end