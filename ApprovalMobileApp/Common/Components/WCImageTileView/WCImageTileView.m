//
//  WCImageTileView.m
//  ImageTileView
//
//  Created by 종욱 윤 on 10. 6. 11..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import "WCImageTileView.h"
#import "CustomPageControl.h"
#import "Constants.h"

#define KBackgroundImage	 99998
#define KBadgeLabel			 99999
@interface  WCImageTileView()
- (UIImage *)getTileImage:(NSInteger)aIndex;
- (UIImage *)getSelectedTileImage:(NSInteger)aIndex;
- (NSString *)getTileTitle:(NSInteger)aIndex;
- (NSUInteger)getTileBadgeCount:(NSInteger)aIndex;
- (UIImage *)getTileBadgeBackground:(NSInteger)aIndex;
@end




@interface UIBadgeButton : UIButton{
	NSInteger		_badgeCount;
	id				_owner;
	UIImage*		_normalImage;
	UIImage*		_disabledImage;
	UIImage*		_highlightedImage;
	
}
@property (nonatomic)NSInteger badgeCount;
@property (nonatomic, assign)id owner;

- (void)setChangeState:(BOOL)normalState;

@end

@implementation UIBadgeButton
@synthesize badgeCount;
@synthesize owner = _owner;


- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_normalImage = nil;
		_disabledImage = nil;
		_highlightedImage = nil;
	}
	return self;
}


- (void)dealloc {
	if (_normalImage)
		[_normalImage release];
	
	if (_disabledImage)
		[_disabledImage release];
	
	if (_highlightedImage)
		[_highlightedImage release];
	
	[super dealloc];
}


- (NSInteger)BadgeCount{
	return _badgeCount;
}


- (void)setBadgeCount:(NSInteger)aBadgeCount{
	_badgeCount = aBadgeCount;
	UILabel* label = nil;
	UIImageView* backgroundView = nil;
	
	if (aBadgeCount > 0) {
		backgroundView = (UIImageView *)[self viewWithTag:KBackgroundImage]; 
		if (!backgroundView) {
			UIImage *temp = [((WCImageTileView *)_owner) getTileBadgeBackground:self.tag]; //[((WCImageTileView *)_owner).delegate imgTileView:self badgeBackgroundImage:self.tag];
			if (!temp) return;
			
			backgroundView = [[UIImageView alloc] initWithImage:temp];
			backgroundView.frame = CGRectMake(((WCImageTileView *)_owner).startBadgePoint.x, ((WCImageTileView *)_owner).startBadgePoint.y, 30.0f, 24.0f);
			backgroundView.tag = KBackgroundImage;
			[self addSubview:backgroundView];
			[backgroundView release];
		}
		if (backgroundView) {
			backgroundView.hidden = NO;

			label = (UILabel *)[backgroundView viewWithTag:KBadgeLabel];
			if (!label) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *appBudleNm = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleName"]];
                
                if ([appBudleNm isEqualToString:@"Bizwere"] == YES)
                {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 19.0f)];
//                    label.textAlignment = UITextAlignmentCenter;
                    label.textAlignment = AlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = RGB(200,7,3);
                    label.tag = KBadgeLabel;
                    label.font = [UIFont boldSystemFontOfSize:12.5];
                    [backgroundView addSubview:label];
                    [label release];
                }else{
//                    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 22.0f)];
//                    label.textAlignment = UITextAlignmentCenter;
//                    label.backgroundColor = [UIColor clearColor];
//                    label.textColor = RGB(255,255,255);
//                    label.tag = KBadgeLabel;
//                    label.font = [UIFont boldSystemFontOfSize:14];
//                    [backgroundView addSubview:label];
//                    [label release];
                    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 19.0f)];
//                    label.textAlignment = UITextAlignmentCenter;
                    label.textAlignment = AlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    label.textColor = RGB(200,7,3);
                    label.tag = KBadgeLabel;
                    label.font = [UIFont boldSystemFontOfSize:12.5];
                    [backgroundView addSubview:label];
                    [label release];
                    
                }

			}
			label.text = [NSString stringWithFormat:@"%d", aBadgeCount];
		}	
	} else {
		backgroundView = (UIImageView *)[self viewWithTag:KBackgroundImage];
		if (backgroundView) {
			backgroundView.hidden = YES;
		}
	}
}


- (void)setImageState:(NSInteger)status imageData:(UIImage *)imageData { 
	switch (status) {
		case 0: //normal
			_normalImage = [imageData retain];
			break;
		case 1: //highlighted
			break;
			_highlightedImage = [imageData retain];

		case 2: //disalbed
			_disabledImage = [imageData retain];
			break;
	}
}


- (void)setChangeState:(BOOL)normalState {

	if (normalState || !_disabledImage) {
		[self setBackgroundImage:_normalImage forState:UIControlStateNormal];
	} else {
		[self setBackgroundImage:_disabledImage forState:UIControlStateNormal];
	}
}


@end


@implementation WCImageTileView

@synthesize startImagePoint		= _startImagePoint;
@synthesize startBadgePoint     = _startBadgePoint; 
@synthesize horizontalSpace		= _horizontalSpace;
@synthesize verticalSpace		= _verticalSpace;
@synthesize tileCount			= _tilesCount;
@synthesize delegate			= _delegate;
@synthesize showPageIndicator	= _showPageIndicator;
@synthesize keepSelection		= _keepSelection;
@synthesize image2XSize			= _image2XSize;
@synthesize showBadge			= _showBadge;

static const NSInteger PageControlHeight	= 20;
static const NSInteger BackgroundViewTag	= 987;


- (void)internalInit {
	if (self == nil)
		return;
	
	_mainScroll			= [[UIScrollView alloc] init];
	_pageCtrl			= [[CustomPageControl alloc] init];
//    _pageCtrl.imageNormal = [UIImage imageNamed:@"z21200_a.png"];
//    _pageCtrl.imageCurrent = [UIImage imageNamed:@"z21210_a.png"];
	_startImagePoint	= CGPointMake(0.0f, 0.0f);
	_startBadgePoint	= CGPointMake(0.0f, 0.0f);
	_tilesCount			= 0;
	_horizontalSpace	= 10.0f;
	_verticalSpace		= 10.0f;
	_pageCount			= 1;
	_selectedTileIndex	= -1;
	_showPageIndicator	= NO;
	_keepSelection		= NO;
	_image2XSize		= NO;
	_showBadge			= NO;
	
	_mainScroll.pagingEnabled	= NO;
	_mainScroll.delegate		= self;
}


- (id)init {
	self = [super init];
	
	if (self != nil)
		[self internalInit];
	
	return self;
}


- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self != nil)
		[self internalInit];
	
	return self;
}


- (void)dealloc {
	UIView* viewBackground = ((UIView *)[self viewWithTag:BackgroundViewTag]);
	
	if (viewBackground != nil)
		[viewBackground removeFromSuperview];
	
	if (_pageCtrl != nil)
		[_pageCtrl release];
	
	[_mainScroll release];
    [super dealloc];
}


- (void)setStateChagne:(NSArray *)views status:(BOOL)status {
	for (UIView *subview in views) {
		if ([subview.subviews count] > 1 ) {
			[self setStateChagne:subview.subviews status:status];	
		}

		if ([subview isKindOfClass:[UIButton class]] == YES) {
			if (_selectedTileIndex != ((UIButton *)subview).tag) {
				((UIButton *)subview).selected = NO;
				[((UIBadgeButton *)subview) setChangeState:status];	
			}
		}
	}
}


- (void)initTiles {
	[self setStateChagne:_mainScroll.subviews status:NO];
	_selectedTileIndex = -1;
}


- (void)initTiles2 {
	[self setStateChagne:_mainScroll.subviews status:NO];
}

- (void)removeAllTiles {
	for (UIView *subview in _mainScroll.subviews) {
		[subview removeFromSuperview];
	}
	
	_tilesCount			= 0;
	_pageCount			= 1;
	_selectedTileIndex	= -1;
}


// background property accessors
- (UIView *)background {
	return ((UIView *)[self viewWithTag:BackgroundViewTag]);
}


// pagingEnabled property accessors
- (BOOL)pagingEnabled {
	return _mainScroll.pagingEnabled;
}


// showsHorizontalScrollIndicator property accessors
- (BOOL)showsHorizontalScrollIndicator {
	return _mainScroll.showsHorizontalScrollIndicator;
}


// showsVerticalScrollIndicator property accessors
- (BOOL)showsVerticalScrollIndicator {
	return _mainScroll.showsVerticalScrollIndicator;
}


// selectedTileIndex property accessors
- (NSInteger)selectedTileIndex {
	return _selectedTileIndex;
}


// background property setter
- (void)setBackground:(UIView *)aView {
	UIView* viewBackground = ((UIView *)[self viewWithTag:BackgroundViewTag]);
	
	if (viewBackground != nil)
		[viewBackground removeFromSuperview];
	
	if (aView == nil)
		return;
	
	aView.tag	= BackgroundViewTag;
	
	[self addSubview:aView];
	[self sendSubviewToBack:aView];
}


// pagingEnabled property setter
- (void)setPagingEnabled:(BOOL)aEnabled {
	_mainScroll.pagingEnabled = aEnabled;
}


// showsHorizontalScrollIndicator property setter
- (void)setShowsHorizontalScrollIndicator:(BOOL)aShow {
	_mainScroll.showsHorizontalScrollIndicator = aShow;
}


// showsVerticalScrollIndicator property setter
- (void)setShowsVerticalScrollIndicator:(BOOL)aShow {
	_mainScroll.showsVerticalScrollIndicator = aShow;
}


// selectedTileIndex property setter
- (void)setSelectedTileIndex:(NSInteger)aIndex {
	if ((aIndex < 0) || (aIndex >= _tilesCount)) {
		[self initTiles];
		return;
	}
	
	if (aIndex == _selectedTileIndex)
		return;
	
	for (UIView *subview in _mainScroll.subviews) {
		if ([subview isKindOfClass:[UIButton class]] == YES) {
			if (((UIButton *)subview).tag == aIndex) {
				((UIButton *)subview).selected	= YES;
				_selectedTileIndex				= aIndex;
				
				return;
			}
		}
	}
}


- (UIImage *)getTileImage:(NSInteger)aIndex {
	if (_delegate == nil || [_delegate respondsToSelector:@selector(imgTileView:image:)] == NO)
		return nil;
	
	return [_delegate imgTileView:self image:aIndex];
}


- (UIImage *)getSelectedTileImage:(NSInteger)aIndex {
	if (_delegate == nil || [_delegate respondsToSelector:@selector(imgTileView:selectedImage:)] == NO)
		return nil;
	
	return [_delegate imgTileView:self selectedImage:aIndex];
}


- (UIImage *)getDisabledTileImage:(NSInteger)aIndex {
	if (_delegate == nil || [_delegate respondsToSelector:@selector(imgTileView:disabledImage:)] == NO)
		return nil;
	
	return [_delegate imgTileView:self disabledImage:aIndex];
}


- (NSString *)getTileTitle:(NSInteger)aIndex {
	if (_delegate == nil || [_delegate respondsToSelector:@selector(imgTileView:title:)] == NO)
		return nil;
	
	return [_delegate imgTileView:self title:aIndex];
}


- (NSUInteger)getTileBadgeCount:(NSInteger)aIndex{
	if (_delegate == nil || [_delegate respondsToSelector:@selector(imgTileView:badgeIndex:)] == NO)
		return 0;
	
	return [_delegate imgTileView:self badgeIndex:aIndex];
}


- (UIImage *)getTileBadgeBackground:(NSInteger)aIndex{
	if (_delegate == nil || [_delegate respondsToSelector:@selector(imgTileView:badgeBackgroundImage:)] == NO)
		return nil;
	
	return [_delegate imgTileView:self badgeBackgroundImage:aIndex];
}




- (void)didSelectItem:(NSInteger)aIndex {
	if (_delegate == nil || [_delegate respondsToSelector:@selector(imgTileView:didSelectItem:)] == NO)
		return;
	
	[_delegate imgTileView:self didSelectItem:aIndex];
}


- (void)drawContents {
	NSInteger nIndex		= 0;
	CGFloat fNextPos_x		= _startImagePoint.x;
	CGFloat fNextPos_y		= _startImagePoint.y;
	CGFloat fViewWidth		= self.frame.size.width;
	CGFloat fTotalWidth		= fViewWidth - _startImagePoint.x;
	
	UIBadgeButton* btnImageTile	= nil;
	UIImage* imgNormal		= nil;
	UIImage* imgHighlighted	= nil;
	UIImage* imgDisabled	= nil;
	NSString* sTitle		= nil;
	
	CGRect rectTile;
	
	while (nIndex < _tilesCount) {
		imgNormal		= [self getTileImage:nIndex];
		imgHighlighted	= [self getSelectedTileImage:nIndex];
		imgDisabled		= [self getDisabledTileImage:nIndex];
		sTitle			= [self getTileTitle:nIndex];
		rectTile.origin	= CGPointMake(fNextPos_x, fNextPos_y);

		if (_image2XSize) {
			rectTile.size.width	 = imgNormal.size.width /2;
			rectTile.size.height = imgNormal.size.height /2;
		} else {
			rectTile.size	= imgNormal.size;
		}
		
		btnImageTile	= [UIBadgeButton buttonWithType:UIButtonTypeCustom];
		
		
		if (imgNormal != nil) {
			[btnImageTile setBackgroundImage:imgNormal forState:UIControlStateNormal];
			[btnImageTile setImageState:0 imageData:imgNormal];
		}
	
		
		if (imgHighlighted != nil) {
			if (_keepSelection == YES)
				[btnImageTile setBackgroundImage:imgHighlighted forState:UIControlStateSelected];

			[btnImageTile setBackgroundImage:imgHighlighted forState:UIControlStateHighlighted];
			[btnImageTile setImageState:1 imageData:imgHighlighted];
		}
		
		
		if (imgDisabled != nil) {
			[btnImageTile setBackgroundImage:imgDisabled forState:UIControlStateDisabled];
			[btnImageTile setImageState:2 imageData:imgDisabled];
		}
		
		
		if (sTitle != nil) {
			
			[btnImageTile setTitle:sTitle forState:UIControlStateNormal];
			[btnImageTile setTitleColor:RGB(35, 35, 35) forState:UIControlStateNormal];
			[btnImageTile setTitleEdgeInsets:UIEdgeInsetsMake(80.0f, 0.0f, 10.0f, 0.0f)];
//			[btnImageTile.titleLabel setTextAlignment:UITextAlignmentCenter];
            [btnImageTile.titleLabel setTextAlignment:NSTextAlignmentCenter];
            //[btnImageTile setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
            btnImageTile.titleLabel.contentMode = UIControlContentVerticalAlignmentTop;
//			btnImageTile.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
   			btnImageTile.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            btnImageTile.titleLabel.numberOfLines = 2;
			btnImageTile.titleLabel.font = [UIFont systemFontOfSize:11];
		}
		
		
		[btnImageTile addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		btnImageTile.tag	= nIndex;
		btnImageTile.frame	= rectTile;
		btnImageTile.owner	= self;
	
		if (_showBadge) {
			btnImageTile.badgeCount = [self getTileBadgeCount:nIndex];
		}
		
		[_mainScroll addSubview:btnImageTile];
		
		nIndex++;
		fNextPos_x += rectTile.size.width + _horizontalSpace;
		
		if (nIndex < _tilesCount) {
			if (fNextPos_x + rectTile.size.width >= fTotalWidth) {
				fNextPos_x = _startImagePoint.x;
				fNextPos_y += rectTile.size.height + _verticalSpace;
			}
		}
	} // end of while loop
	
	_mainScroll.contentSize = CGSizeMake(fViewWidth, fNextPos_y + rectTile.size.height);
	_mainScroll.showsVerticalScrollIndicator	= YES;
	_mainScroll.showsHorizontalScrollIndicator	= NO;
}


- (void)drawPages {
	NSInteger nIndex		= 0;
	NSInteger nPageNum		= 0;
	CGFloat fNextPos_x		= 0.0f;
	CGFloat fNextPos_y		= 0.0f;
	CGFloat fViewWidth		= self.frame.size.width;
	CGFloat fViewHeight		= self.frame.size.height;
	
	UIBadgeButton* btnImageTile	= nil;
	UIView* viewPage		= nil;
	UIImage* imgNormal		= nil;
	UIImage* imgHighlighted	= nil;
	UIImage* imgDisabled	= nil;
	NSString* sTitle		= nil;
	CGFloat fPageHeight		= 0.0f;
	
	CGRect rectTile;
	
	while (nIndex < _tilesCount) {
		fPageHeight		= fViewHeight;
		
		if (_showPageIndicator == YES)
			fPageHeight	-= PageControlHeight;
		
		viewPage		= [[UIView alloc] init];
		viewPage.frame	= CGRectMake(nPageNum * fViewWidth, 0.0f, fViewWidth, fPageHeight);
		
		fNextPos_x		= _startImagePoint.x;
		fNextPos_y		= _startImagePoint.y;
		
		while (nIndex < _tilesCount) {
			imgNormal		= [self getTileImage:nIndex];
			imgHighlighted	= [self getSelectedTileImage:nIndex];
			imgDisabled		= [self getDisabledTileImage:nIndex];
			sTitle			= [self getTileTitle:nIndex];
			rectTile.origin	= CGPointMake(fNextPos_x, fNextPos_y);
			if (_image2XSize) {
				rectTile.size.width	 = imgNormal.size.width /2;
				rectTile.size.height = imgNormal.size.height /2;
			} else {
				rectTile.size	= imgNormal.size;
			}
			
			
			btnImageTile = [UIBadgeButton buttonWithType:UIButtonTypeCustom];
			
			if (imgNormal != nil) {
				[btnImageTile setBackgroundImage:imgNormal forState:UIControlStateNormal];

				[btnImageTile setImageState:0 imageData:imgNormal];
			}
			
			if (imgHighlighted != nil) {
				if (_keepSelection == YES)
					[btnImageTile setBackgroundImage:imgHighlighted forState:UIControlStateSelected];
				
				[btnImageTile setBackgroundImage:imgHighlighted forState:UIControlStateHighlighted];
				[btnImageTile setImageState:1 imageData:imgHighlighted];
			}
			
			if (imgDisabled != nil) {
				[btnImageTile setBackgroundImage:imgDisabled forState:UIControlStateDisabled];
				[btnImageTile setImageState:2 imageData:imgDisabled];
			}
			
			if (sTitle != nil)
				[btnImageTile setTitle:sTitle forState:UIControlStateNormal];
			
			[btnImageTile addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
			
			btnImageTile.frame							= rectTile;
			btnImageTile.tag							= nIndex;
			btnImageTile.adjustsImageWhenHighlighted	= YES;
			btnImageTile.owner							= self;
			
			
			if (_showBadge) {
				btnImageTile.badgeCount = [self getTileBadgeCount:nIndex];
			}
			
			
			[viewPage addSubview:btnImageTile];
			
			nIndex++;
			fNextPos_x += (rectTile.size.width + _horizontalSpace);
			
			if (fNextPos_x + rectTile.size.width >= fViewWidth) {
				fNextPos_x	= _startImagePoint.x;
				fNextPos_y	+= (rectTile.size.height + _verticalSpace);
				
				if (fNextPos_y + rectTile.size.height >= fViewHeight)
					break;
			}
		} // end of inner while loop
		
		[_mainScroll addSubview:viewPage];
		[viewPage release];
		
		nPageNum++;
	} // end of outter while loop
	
	_pageCount = nPageNum;
	
	_mainScroll.contentSize = CGSizeMake(nPageNum * fViewWidth, fViewHeight);
	_mainScroll.showsVerticalScrollIndicator	= YES;
	_mainScroll.showsHorizontalScrollIndicator	= NO;
	
	_pageCtrl.frame = CGRectMake(0, fViewHeight - 20, fViewWidth, 20);
	_pageCtrl.numberOfPages = _pageCount;
	_pageCtrl.currentPage	= 0;
}


- (void)pageTurn:(UIPageControl *)page {
	NSInteger whichPage = page.currentPage;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	_mainScroll.contentOffset = CGPointMake(_mainScroll.frame.size.width * whichPage, 0.0f);
	[UIView commitAnimations];
}


- (void)buttonClicked:(id)sender {
	UIButton *selBtn	= sender;
	_selectedTileIndex	= selBtn.tag;

	if (_keepSelection == YES) {
		[self initTiles2];
		selBtn.enabled = YES;
		selBtn.selected = YES;
	}
	
	[self didSelectItem:_selectedTileIndex];
}


#pragma mark -
#pragma mark Public Method
- (void)reloadData {
	// view 위의 모든 타일을 제거한다.
	[self removeAllTiles];
	
	[self setNeedsDisplay];
	
	BOOL bLaysoutScroll	= NO;
	BOOL bLaysoutPage	= NO;
	
	for (UIView *subview in self.subviews) {
		if ([subview isKindOfClass:[UIScrollView class]] == YES)
			bLaysoutScroll = YES;
		
		if ([subview isKindOfClass:[UIPageControl class]] == YES)
			bLaysoutPage = YES;
	}
	
	// 현재 View 위에 UIScrollView가 없다면 View에 포함시킨다.
	if (bLaysoutScroll == NO) {
		[self addSubview:_mainScroll];
		_mainScroll.frame = [self bounds];
	}
	
	// 현재 View 위에 UIPageControl가 없다면 View에 포함시킨다.
	if (bLaysoutPage == NO) {
		_pageCtrl.userInteractionEnabled	= YES;
		_pageCtrl.autoresizesSubviews		= YES;
		_pageCtrl.contentMode				= UIViewContentModeScaleToFill;
		_pageCtrl.hidesForSinglePage		= YES;
		
		[_pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_pageCtrl];
		
		_pageCtrl.hidden = !_showPageIndicator;
	}
	
	// delegate가 nil이면 할 수 있는 부분이 없어 종료한다.
	if (_delegate == nil)
		return;
	
	// numberOfTiles: 함수 구현은 필수이다.
	if ([_delegate respondsToSelector:@selector(numberOfTiles:)] == NO)
		return;
	
	_tilesCount	= [_delegate numberOfTiles:self];
	
	// 타일 개수가 0이면 화면에 그릴 부분이 없어 이하 진행이 필요없다.
	if (_tilesCount == 0)
		return;
	
	if (self.pagingEnabled == YES)
		[self drawPages];
	else
		[self drawContents];
	
	_pageCtrl.hidden = !_showPageIndicator;
}


- (void)allNormal {
	[self setStateChagne:_mainScroll.subviews status:YES];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGPoint offset = _mainScroll.contentOffset;
	_pageCtrl.currentPage = offset.x / _mainScroll.frame.size.width;
}


@end
