//
//  WCTabMenuView.m
//  TabMenuView
//
//  Created by 종욱 윤 on 10. 10. 15..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import "WCTabMenuView.h"


@implementation WCTabMenuView

@synthesize horizontalSpace					= _horizontalSpace;
@synthesize showNavigation					= _showNavigation;
@synthesize leftEnabledNavigationImage		= _imgLeftEnabledNavigation;
@synthesize leftDisabledNavigationImage		= _imgLeftDisabledNavigation;
@synthesize rightEnabledNavigationImage		= _imgRightEnabledNavigation;
@synthesize rightDisabledNavigationImage	= _imgRightDisabledNavigation;
@synthesize menuSeparator					= _imgMenuSeparator;
@synthesize delegate						= _delegate;
@synthesize image2XSize						= _image2XSize;
@synthesize keepSelection					= _keepSelection;



static const NSUInteger kTagNoLeftNavigation	= 391;
static const NSUInteger kTagNoRightNavigation	= 392;
static const NSUInteger kStartTagNo				= 610;


- (void)internalInit {
	if (self == nil)
		return;
	
	_viewContents				= [[UIScrollView alloc] init];
	_horizontalSpace			= 0.0f;
	_showNavigation				= YES;
	_drewMenus					= NO;
	_menuCount					= 0;
	_totalPages					= 0;
	_selectedIndex				= -1;
	_initSelectIndex			= -1;
	_imgLeftEnabledNavigation	= nil;
	_imgLeftDisabledNavigation	= nil;
	_imgRightEnabledNavigation	= nil;
	_imgRightDisabledNavigation	= nil;
	_imgMenuSeparator			= nil;
	_image2XSize				= NO;
	_keepSelection				= YES;
	
	self.backgroundColor		= [UIColor clearColor];
	
	_viewContents.pagingEnabled						= YES;
	_viewContents.showsVerticalScrollIndicator		= NO;
	_viewContents.showsHorizontalScrollIndicator	= NO;
	_viewContents.bounces							= NO;
	_viewContents.delegate							= self;
									
	

	[self addSubview:_viewContents];
}


- (id)init {
	self = [super init];
	
	if (self != nil)
		[self internalInit];
	
	return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
        [self internalInit];
	
    return self;
}


- (void)dealloc {
	if (_imgLeftEnabledNavigation != nil)
		[_imgLeftEnabledNavigation release];
	
	if (_imgLeftDisabledNavigation != nil)
		[_imgLeftDisabledNavigation release];
	
	if (_imgRightEnabledNavigation != nil)
		[_imgRightEnabledNavigation release];
	
	if (_imgRightDisabledNavigation != nil)
		[_imgRightDisabledNavigation release];
	
	if (_imgMenuSeparator != nil)
		[_imgMenuSeparator release];
	
	[_viewContents release];
    [super dealloc];
}


- (UIImage *)getMenuImage:(NSInteger)aIndex {
	if (_delegate == nil || [_delegate respondsToSelector:@selector(tabMenu:image:)] == NO)
		return nil;
	
	return [_delegate tabMenu:self image:aIndex];
}


- (UIImage *)getHighlightedMenuImage:(NSInteger)aIndex {
	if (_delegate == nil || [_delegate respondsToSelector:@selector(tabMenu:highlighted:)] == NO)
		return nil;
	
	return [_delegate tabMenu:self highlighted:aIndex];
}


- (void)didSelectItem:(NSInteger)aIndex {
	if (_delegate == nil || [_delegate respondsToSelector:@selector(tabMenu:didSelectItem:)] == NO)
		return;
	
	[_delegate tabMenu:self didSelectItem:aIndex];
}


- (void)selectMenu:(NSInteger)aIndex {
	UIButton* btnSelected	= nil;
	NSInteger iCurrentPage	= -1;
	NSInteger iSelectedPage	= -1;
	_selectedIndex			= -1;
	
	for (UIView* subview in _viewContents.subviews) {
		if ([subview isKindOfClass:[UIView class]] == YES) {
			iCurrentPage++;
			
			for (UIView* button in subview.subviews) {
				if ([button isKindOfClass:[UIButton class]] == YES) {
					if (button.tag < kStartTagNo)
						continue;
					
					if (button.tag == aIndex) {
						btnSelected		= (UIButton *)button;
						iSelectedPage	= iCurrentPage;
					}
					
					if (_keepSelection == YES)
						((UIButton *)button).selected = NO;
				}
			}
		}
	}

	if (btnSelected != nil) {
		if (_keepSelection == YES)
			btnSelected.selected = YES;
		
		_selectedIndex = (btnSelected.tag - kStartTagNo);
		
		// 선택된 메뉴와 현재 화면에 보이는 페이지와 틀리면 페이지를 이동한다.
		if (_viewContents.contentOffset.x != (_viewContents.frame.size.width * iSelectedPage))
			_viewContents.contentOffset = CGPointMake(_viewContents.frame.size.width * iSelectedPage, 0.0f);
	}
	
	[self didSelectItem:_selectedIndex];
}


- (NSInteger)selectedIndex {
	return _selectedIndex;
}


- (void)setSelectedIndex:(NSInteger)aIndex {
	_initSelectIndex = aIndex;
	
	if (_drewMenus == YES)
		[self selectMenu:(aIndex + kStartTagNo)];
}


- (void)removeAll {
	for (UIView *subview in self.subviews) {
		if ([subview isKindOfClass:[UIButton class]] == YES)
			[((UIButton *)subview) removeFromSuperview];
	}
	
	for (UIView *subview in _viewContents.subviews) {
		if ([subview isKindOfClass:[UIButton class]] == YES)
			[((UIButton *)subview) removeFromSuperview];

		if ([subview isKindOfClass:[UIImageView class]] == YES)
			[((UIImageView *)subview) removeFromSuperview];
	}
	
	_menuCount		= 0;
	_selectedIndex	= -1;
	_drewMenus		= NO;
}


- (void)navigationButtonClicked:(id)aSender {
	NSInteger iIncrements	= 1;
	
	if ([aSender tag] == kTagNoLeftNavigation)
		iIncrements = -1;
	
	NSInteger iCurrentPage	= (_viewContents.contentOffset.x + _viewContents.frame.size.width) / _viewContents.frame.size.width;
	
	// 좌측 네비게이션 버튼을 클릭하고 현재 1페이지에 있다면 더 이상 이동할 수 없다.
	if ((iIncrements == -1) && (iCurrentPage == 1))
		return;

	// 우측 네비게이션 버튼을 클릭하고 마지막 페이지에 있다면 더 이상 이동할 수 없다.
	if ((iIncrements == 1) && (iCurrentPage == _totalPages))
		return;

	[_viewContents setContentOffset:CGPointMake(_viewContents.contentOffset.x + (iIncrements * _viewContents.frame.size.width), 0.0f) animated:YES];
}


- (void)buttonClicked:(id)aSender {
	[self selectMenu:[aSender tag]];
}


- (void)drawNavigation {
	// 좌측 네비게이션 버튼 생성
	_btnLeftNavigation			= [UIButton buttonWithType:UIButtonTypeCustom];
	_btnLeftNavigation.tag		= kTagNoLeftNavigation;
	
	if(_image2XSize) {
		_btnLeftNavigation.frame	= CGRectMake(0.0f, 
												 0.0f, 
												 _imgLeftEnabledNavigation.size.width / 2, 
												 _imgLeftEnabledNavigation.size.height / 2);
	} else {
		_btnLeftNavigation.frame	= CGRectMake(0.0f, 
												 0.0f, 
												 _imgLeftEnabledNavigation.size.width, 
												 _imgLeftEnabledNavigation.size.height);
	}
	
	
	[_btnLeftNavigation setBackgroundImage:_imgLeftEnabledNavigation forState:UIControlStateNormal];
	
	if (_imgLeftDisabledNavigation != nil)
		[_btnLeftNavigation setBackgroundImage:_imgLeftDisabledNavigation forState:UIControlStateDisabled];
	
	[_btnLeftNavigation addTarget:self action:@selector(navigationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:_btnLeftNavigation];
	
	// 우측 네비게이션 버튼 생성
	_btnRightNavigation			= [UIButton buttonWithType:UIButtonTypeCustom];
	_btnRightNavigation.tag		= kTagNoRightNavigation;

	if(_image2XSize) {
		_btnRightNavigation.frame	= CGRectMake(self.frame.size.width - _imgRightEnabledNavigation.size.width, 
												 0.0f, 
												 _imgRightEnabledNavigation.size.width / 2, 
												 _imgRightEnabledNavigation.size.height / 2);
	} else {
		_btnRightNavigation.frame	= CGRectMake(self.frame.size.width - _imgRightEnabledNavigation.size.width, 
												 0.0f, 
												 _imgRightEnabledNavigation.size.width, 
												 _imgRightEnabledNavigation.size.height);
	}
	
	
	[_btnRightNavigation setBackgroundImage:_imgRightEnabledNavigation forState:UIControlStateNormal];
	
	if (_imgRightDisabledNavigation != nil)
		[_btnRightNavigation setBackgroundImage:_imgRightDisabledNavigation forState:UIControlStateDisabled];
	
	[_btnRightNavigation addTarget:self action:@selector(navigationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:_btnRightNavigation];
}


- (void)drawMenus {
	NSInteger iIndex			= 0;
	NSInteger iPageNum			= 0;
	CGFloat fNextPos_x			= 0.0f;
	CGFloat ftempPos_x			= 0.0f;
	CGFloat fViewWidth			= _viewContents.frame.size.width;
	CGFloat fViewHeight			= _viewContents.frame.size.height;
	CGFloat fSeparatorWidth		= 0.0f;
	
	UIButton* btnMenu			= nil;
	UIView* viewPage			= nil;
	UIImage* imgNormal			= nil;
	UIImage* imgHighlighted		= nil;
	UIImageView* viewSeparator	= nil;
	CGRect rectMenu;
	
	while (iIndex < _menuCount) {
		viewPage		= [[UIView alloc] init];
		viewPage.frame	= CGRectMake(iPageNum * fViewWidth, 0.0f, fViewWidth, fViewHeight);
		fNextPos_x		= 0.0f;
		
		while (iIndex < _menuCount) {
			imgNormal		= [self getMenuImage:iIndex];
			imgHighlighted	= [self getHighlightedMenuImage:iIndex];
			rectMenu.origin	= CGPointMake(fNextPos_x, 0.0f);
			rectMenu.size	= imgNormal.size;
			btnMenu			= [UIButton buttonWithType:UIButtonTypeCustom];
			
			if (imgNormal != nil)
				[btnMenu setBackgroundImage:imgNormal forState:UIControlStateNormal];
			
			if (imgHighlighted != nil) {
				if (_keepSelection == YES){
					[btnMenu setBackgroundImage:imgHighlighted forState:UIControlStateSelected];
				} else {
					[btnMenu setBackgroundImage:imgHighlighted forState:UIControlStateHighlighted];
				}
			}
			
			
			if(_image2XSize){
				rectMenu.size.width =rectMenu.size.width/2;	
				rectMenu.size.height =rectMenu.size.height/2;	
			}
			
			[btnMenu addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
			
			btnMenu.frame						= rectMenu;
			btnMenu.tag							= kStartTagNo + iIndex;
			btnMenu.adjustsImageWhenHighlighted	= YES;
			
			[viewPage addSubview:btnMenu];
			
			iIndex++;
			
			if ((_imgMenuSeparator != nil) && (iIndex != _menuCount)) {
				fSeparatorWidth = _imgMenuSeparator.size.width;

				if(_image2XSize){
					fNextPos_x		+= (imgNormal.size.width/2 + (_horizontalSpace - fSeparatorWidth) / 2);
				}else {
					fNextPos_x		+= (imgNormal.size.width + (_horizontalSpace - fSeparatorWidth) / 2);
				}

				
				viewSeparator		= [[UIImageView alloc] initWithImage:_imgMenuSeparator];
				viewSeparator.frame	= CGRectMake(fNextPos_x, 0.0f, _imgMenuSeparator.size.width, _imgMenuSeparator.size.height);
				
				[viewPage addSubview:viewSeparator];
				[viewSeparator release];
				
				fNextPos_x		+= (viewSeparator.frame.size.width + (_horizontalSpace - fSeparatorWidth) / 2);
			} else {
				if(_image2XSize){
					fNextPos_x += (imgNormal.size.width/2 + _horizontalSpace);
				} else {
					fNextPos_x += (imgNormal.size.width + _horizontalSpace);
				}

			}
			
			if(_image2XSize){
				ftempPos_x = fNextPos_x + imgNormal.size.width/2;
			}else {
				ftempPos_x = fNextPos_x + imgNormal.size.width;
			}

			
			if (ftempPos_x > fViewWidth) {
				fNextPos_x	= 0.0f;
				break;
			}
		} // end of inner while loop
		
		[_viewContents addSubview:viewPage];
		[viewPage release];
		
		iPageNum++;
	} // end of outter while loop
	
	_viewContents.contentSize	= CGSizeMake(iPageNum * fViewWidth, fViewHeight);
	_totalPages					= iPageNum;
	_btnLeftNavigation.enabled	= NO;
	_btnRightNavigation.enabled	= !(iPageNum == 1);
	_drewMenus					= YES;
}


- (void)reloadData {
	// view 위의 모든 타일을 제거한다.
	[self removeAll];
	
	// delegate가 nil이면 할 수 있는 부분이 없어 종료한다.
	if (_delegate == nil)
		return;
	
	// numberOfItems: 함수 구현은 필수이다.
	if ([_delegate respondsToSelector:@selector(numberOfItems:)] == NO)
		return;
	
	_menuCount	= [_delegate numberOfItems:self];
	
	// 메뉴 개수가 0이면 화면에 그릴 부분이 없어 이하 진행이 필요없다.
	if (_menuCount == 0)
		return;

	CGFloat fWidth	= self.frame.size.width;
	CGFloat fPosX	= 0.0f;
	
	// 좌, 우측 네비게이션 버튼의 보여주기 옵션이 YES이면 좌, 우측 네비게이션 버튼의 이미지를 확인한다.
	if (_showNavigation == YES) {
		if (_imgLeftEnabledNavigation == nil)
			return;
		
		if (_imgRightEnabledNavigation == nil)
			return;
		
		[self drawNavigation];
		
		fPosX	= _imgLeftEnabledNavigation.size.width;
		fWidth	-= (fPosX + _imgRightEnabledNavigation.size.width);
	}
	
	_viewContents.frame = CGRectMake(fPosX, 0.0f, fWidth, self.frame.size.height);

	[self drawMenus];
	
	if (_initSelectIndex >= 0)
		[self selectMenu:(_initSelectIndex + kStartTagNo)];
	
	_initSelectIndex = -1;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGPoint offset = _viewContents.contentOffset;
	
	if (_showNavigation == YES) {
		_btnLeftNavigation.enabled	= (offset.x != 0.0f);
		_btnRightNavigation.enabled	= (offset.x != _viewContents.contentSize.width - _viewContents.frame.size.width);
	}
}




@end
