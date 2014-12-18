//
//  WCTabMenuView.h
//  TabMenuView
//
//  Created by 종욱 윤 on 10. 10. 15..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WCTabMenuView;


@protocol WCTabMenuViewDelegate<NSObject>;
@required
- (NSInteger)numberOfItems:(WCTabMenuView *)aTabMenuView;
- (UIImage *)tabMenu:(WCTabMenuView *)aTabMenuView image:(NSInteger)aIndex;
- (void)tabMenu:(WCTabMenuView *)aTabMenuView didSelectItem:(NSInteger)aIndex;

@optional
- (UIImage *)tabMenu:(WCTabMenuView *)aTabMenuView highlighted:(NSInteger)aIndex;

@end


@interface WCTabMenuView : UIView<UIScrollViewDelegate> {
	UIScrollView*				_viewContents;
	UIButton*					_btnLeftNavigation;
	UIButton*					_btnRightNavigation;
	CGFloat						_horizontalSpace;
	BOOL						_showNavigation;
	BOOL						_drewMenus;
	BOOL						_keepSelection;
	NSUInteger					_menuCount;
	NSUInteger					_totalPages;
	NSInteger					_selectedIndex;
	NSInteger					_initSelectIndex;
	UIImage*					_imgLeftEnabledNavigation;
	UIImage*					_imgLeftDisabledNavigation;
	UIImage*					_imgRightEnabledNavigation;
	UIImage*					_imgRightDisabledNavigation;
	UIImage*					_imgMenuSeparator;
	
	id<WCTabMenuViewDelegate>	_delegate;
	
	BOOL						_image2XSize;
}

@property (nonatomic) CGFloat horizontalSpace;
@property (nonatomic) BOOL showNavigation;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, retain) UIImage* leftEnabledNavigationImage;
@property (nonatomic, retain) UIImage* leftDisabledNavigationImage;
@property (nonatomic, retain) UIImage* rightEnabledNavigationImage;
@property (nonatomic, retain) UIImage* rightDisabledNavigationImage;
@property (nonatomic, retain) UIImage* menuSeparator;
@property (nonatomic, assign) id<WCTabMenuViewDelegate> delegate;
@property (nonatomic) BOOL image2XSize;
@property (nonatomic) BOOL keepSelection;

- (void)reloadData;

@end
