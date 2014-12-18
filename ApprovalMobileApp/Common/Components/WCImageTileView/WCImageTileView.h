//
//  WCImageTileView.h
//  ImageTileView
//
//  Created by 종욱 윤 on 10. 6. 11..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WCImageTileView;
@class CustomPageControl;


@protocol ImageTileViewDelegate;


/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief 타일(그리드)형 메뉴를 구성하는 클래스이다.
 */
@interface WCImageTileView : UIView <UIScrollViewDelegate> {
	UIScrollView*				_mainScroll;
	CustomPageControl*			_pageCtrl;
	CGPoint						_startImagePoint;
	CGPoint						_startBadgePoint;
	NSInteger					_tilesCount;
	CGFloat						_horizontalSpace;
	CGFloat						_verticalSpace;
	NSInteger					_pageCount;
	BOOL						_pagingEnabled;
	BOOL						_showsHorizontalScrollIndicator;
	BOOL						_showsVerticalScrollIndicator;
	BOOL						_showPageIndicator;
	BOOL						_keepSelection;
	BOOL						_image2XSize;
	BOOL						_showBadge;
	NSInteger					_selectedTileIndex;
	
	id<ImageTileViewDelegate>	_delegate;
}

/////////////////////////////////////////////////////////////////////////////////////////////
/** 배경을 구성하는 @c UIView를 반환하거나 설정한다.
 */
@property (nonatomic, retain) UIView *background;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 타일 메뉴의 첫 시작 위치를 반환하거나 설정한다.
 */
@property (nonatomic) CGPoint startImagePoint;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 타일 메뉴의 Badge의 시작 위치를 반환하거나 설정한다.
 */
@property (nonatomic) CGPoint startBadgePoint;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 메뉴와 메뉴 사이의 수평 간격을 반환하거나 설정한다.
 */
@property (nonatomic) CGFloat horizontalSpace;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 메뉴와 메뉴 사이의 수직 간격을 반환하거나 설정한다.
 */
@property (nonatomic) CGFloat verticalSpace;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 타일 메뉴의 총 개수를 반환한다.
 */
@property (nonatomic, readonly, getter=getTileCount) NSInteger tileCount;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 전체 메뉴를 한 화면에 표현할 수 없을 경우 페이징 기능의 사용 유무를 설정하거나 반환한다.
 */
@property (nonatomic) BOOL pagingEnabled;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 수평 스크롤바의 표시 유무를 설정하거나 반환한다.
 */
@property (nonatomic) BOOL showsHorizontalScrollIndicator;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 수직 스크롤바의 표시 유무를 설정하거나 반환한다.
 */
@property (nonatomic) BOOL showsVerticalScrollIndicator;

/////////////////////////////////////////////////////////////////////////////////////////////
/** PageIndicator 표시 여부
 */
@property (nonatomic) BOOL showPageIndicator;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 아이콘닉의 선택된 상태로 유지 여부
 */
@property (nonatomic) BOOL keepSelection;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 타일뷰의 이미지 2배사이즈 처리 여부
 */
@property (nonatomic) BOOL image2XSize;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 타일뷰의 badge표시 여부
 */
@property (nonatomic) BOOL showBadge;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 선택된 메뉴의 인덱스를 반환하거나 특정 메뉴를 선택한다.
 */
@property (nonatomic) NSInteger selectedTileIndex;


/////////////////////////////////////////////////////////////////////////////////////////////
/** 타일 메뉴의 delegate 객체이다. @c ImageTileViewDelegate protocol을 따른다. 
 */
@property (nonatomic, assign) id<ImageTileViewDelegate> delegate;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 메뉴를 갱신하여 새로 그린다.
 */
- (void)reloadData;


- (void)allNormal;

@end


/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief @c WCImageTileView의 Delegate이다.
 */
@protocol ImageTileViewDelegate<NSObject>;

@required
/////////////////////////////////////////////////////////////////////////////////////////////
/** 총 메뉴 개수를 질의하는 메소드이다. (필수)
 
 @param tileView			메소드를 질의한 메뉴뷰 객체(@c WCImageTileView)
 @return					총 메뉴 개수
 */
- (NSInteger)numberOfTiles:(WCImageTileView *)aTileView;

/////////////////////////////////////////////////////////////////////////////////////////////
/** 각 메뉴별 일반 상태 이미지를 질의하는 메소드이다. (필수)
 
 @param tileView			메소드를 질의한 메뉴뷰 객체(@c WCImageTileView)
 @param index				메뉴 이미지를 질의한 메뉴 인덱스
 @return					@c UIImage 타입의 메뉴 이미지
 */
- (UIImage *)imgTileView:(WCImageTileView *)aTileView image:(NSInteger)aIndex;

@optional
/////////////////////////////////////////////////////////////////////////////////////////////
/** 각 메뉴별 타이틀를 질의하는 메소드이다. (선택)
 
 @param tileView			메소드를 질의한 메뉴뷰 객체(@c WCImageTileView)
 @param index				메뉴 타이틀을 질의한 메뉴 인덱스
 @return					해당 메뉴의 타이틀 문자열
 */
- (NSString *)imgTileView:(WCImageTileView *)aTileView title:(NSInteger)aIndex;


/////////////////////////////////////////////////////////////////////////////////////////////
/** 각 메뉴별 선택 상태 이미지를 질의하는 메소드이다. (선택)
 
 @param tileView			메소드를 질의한 메뉴뷰 객체(@c WCImageTileView)
 @param index				메뉴 이미지를 질의한 메뉴 인덱스
 @return					@c UIImage 타입의 메뉴 이미지
 */
- (UIImage *)imgTileView:(WCImageTileView *)aTileView selectedImage:(NSInteger)aIndex;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 각 메뉴별 하이라이트 상태 이미지를 질의하는 메소드이다. (선택)
 
 @param tileView			메소드를 질의한 메뉴뷰 객체(@c WCImageTileView)
 @param index				메뉴 이미지를 질의한 메뉴 인덱스
 @return					@c UIImage 타입의 메뉴 이미지
 */
- (UIImage *)imgTileView:(WCImageTileView *)aTileView disabledImage:(NSInteger)aIndex;


/////////////////////////////////////////////////////////////////////////////////////////////
/** 각 메뉴별 선택 시 선택 인덱스를 넘겨주는 메소드이다. (선택)
 
 @param tileView			메소드를 질의한 메뉴뷰 객체(@c WCImageTileView)
 @param index				메뉴 이미지를 질의한 메뉴 인덱스
 */
- (void)imgTileView:(WCImageTileView *)aTileView didSelectItem:(NSInteger)aIndex;


/////////////////////////////////////////////////////////////////////////////////////////////
/** 각 메뉴별 badge의 텍스트 폰트를 질의하는 메소드이다. (선택)
 
 @param tileView			메소드를 질의한 메뉴뷰 객체(@c WCImageTileView)
 @param index				메뉴 이미지를 질의한 메뉴 인덱스
 */
//- (UIFont *)imgTileView:(WCImageTileView *)aTileView badgeItem:(NSInteger)aIndex; 


/////////////////////////////////////////////////////////////////////////////////////////////
/** 각 메뉴별 Badge의 백그라운드 이미지 질의하는 메소드이다. (선택)
 
 @param tileView			메소드를 질의한 메뉴뷰 객체(@c WCImageTileView)
 @param index				벳지 백그라운드 이미지를 질의한 메뉴 인덱스
 @return					@c UIImage 타입의 메뉴 이미지
 */
- (UIImage *)imgTileView:(WCImageTileView *)aTileView badgeBackgroundImage:(NSInteger)aIndex;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 각 메뉴별 Badge의 수를 질의하는 메소드이다. (선택)
 
 @param tileView			메소드를 질의한 메뉴뷰 객체(@c WCImageTileView)
 @param index				badge 카운트를 질의한 메뉴 인덱스
 @return					@c UIImage 타입의 메뉴 이미지
 */
- (NSInteger)imgTileView:(WCImageTileView *)aTileView badgeIndex:(NSInteger)aIndex;

@end


