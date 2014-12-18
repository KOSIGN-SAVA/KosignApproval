//
//  WCTabView.h
//  TabView
//
//  Created by 종욱 윤 on 10. 6. 20..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCTabBarView;


/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief @c WCTabBarView의 Delegate이다.
 */
@protocol WCTabBarViewDelegate<NSObject>;

@required
/////////////////////////////////////////////////////////////////////////////////////////////
/** 탭바의 총 그룹 개수를 질의하는 메소드이다. (필수)
 
 @param tabBarView			메소드를 질의한 탭바 객체(@c WCTabBarView)
 @return					총 그룹 개수
 */
- (NSInteger)numberOfGroups:(WCTabBarView *)tabBarView;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 현재 그룹의 메뉴 개수를 질의하는 메소드이다. (필수)
 
 @param tabBarView			메소드를 질의한 탭바 객체(@c WCTabBarView)
 @param group				메뉴 개수를 질의한 그룹 인덱스
 @return					총 메뉴 개수
 */
- (NSInteger)tabView:(WCTabBarView *)tabBarView numberOfItemInGroup:(NSInteger)group;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 현재 그룹의 각 메뉴별 일반 상태 이미지를 질의하는 메소드이다. (필수)
 
 @param tabBarView			메소드를 질의한 탭바 객체(@c WCTabBarView)
 @param groupIndex			메뉴 이미지를 질의한 그룹 인덱스
 @param index				메뉴 이미지를 질의한 그룹의 메뉴 인덱스
 @return					@c UIImage 타입의 메뉴 이미지
 */
- (UIImage *)tabView:(WCTabBarView *)tabBarView group:(NSInteger)groupIndex image:(NSInteger)index;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 탭바에서 실제 사용자가 터치한 메뉴의 인덱스를 반환하는 메소드이다. (필수)
 
 @param tabBarView			메소드를 질의한 탭바 객체(@c WCTabBarView)
 @param groupIndex			사용자가 터치한 메뉴의 그룹 인덱스
 @param index				사용자가 터치한 메뉴의 인덱스
 */
- (void)tabView:(WCTabBarView *)tabBarView group:(NSInteger)groupIndex didSelectItem:(NSInteger)index;

@optional
/////////////////////////////////////////////////////////////////////////////////////////////
/** 현재 그룹의 각 메뉴별 하이라이트 상태 이미지를 질의하는 메소드이다. (선택)
 
 @param tabBarView			메소드를 질의한 탭바 객체(@c WCTabBarView)
 @param groupIndex			메뉴 이미지를 질의한 그룹 인덱스
 @param index				메뉴 이미지를 질의한 그룹의 메뉴 인덱스
 @return					@c UIImage 타입의 하이라이트 메뉴 이미지
 */
- (UIImage *)tabView:(WCTabBarView *)tabBarView group:(NSInteger)groupIndex highlighted:(NSInteger)index;
@end



/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief 앱 하단의 탭바 메뉴 클래스이다.
 
	탭바 메뉴를 그룹으로 구성하여 특정 메뉴에 따라 그룹을 변경하여 탭바 메뉴 구성을 달리한다.
 */
@interface WCTabBarView : UIViewController {
	UIToolbar *_MainToolbar;
	NSMutableArray *_Groups;
	NSInteger _CurrentGroup;
	id<WCTabBarViewDelegate> _Delegate;
	BOOL _image2XSize;

}

/////////////////////////////////////////////////////////////////////////////////////////////
/** 탭바의 배경을 구성하는 @c UIView를 반환하거나 설정한다.
 
    Deprecated in ios 5.0
 */
@property (nonatomic, retain) UIView *backgroundView;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 현재 탭바 메뉴의 그룹 인덱스를 반환하거나 설정한다.
 */
@property (nonatomic) NSInteger currentGroup;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 탭바의 delegate 객체이다. @c WCTabBarViewDelegate protocol을 따른다. 
 */
@property (nonatomic, assign) id<WCTabBarViewDelegate> delegate;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 탭바의 이미지 사이즈를 조정한다 320 or 640. @c BOOL YES 640*960  NO 430.480. 
 */
@property (nonatomic) BOOL image2XSize;


- (void)reloadData;

@end
