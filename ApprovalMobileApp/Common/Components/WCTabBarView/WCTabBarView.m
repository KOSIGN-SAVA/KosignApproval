    //
//  WCTabView.m
//  TabView
//
//  Created by 종욱 윤 on 10. 6. 20..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import "WCTabBarView.h"
#import "Constants.h"

@implementation WCTabBarView

@synthesize delegate = _Delegate;
@synthesize image2XSize = _image2XSize;

static const NSInteger backgroundTag = 2998;


// constructor
- (id)init {
	self = [super init];
	
	if (self != nil) {
		_MainToolbar            = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
        
        ////// Deprecated in ios 5.0 - ios5 적용 후 _MainToolbar.backgroundView 먹히지 않음. 툴바 tintColor 속성 추가. ///////
        _MainToolbar.tintColor  = [UIColor colorWithWhite:0.1f alpha:1.0f];
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
		_Groups                 = nil;
		_CurrentGroup           = 0;
		_image2XSize            = NO;
        
	}
	
	return self;
}






- (void)refresh {
	_MainToolbar.items = [_Groups objectAtIndex:_CurrentGroup];
}







////// Deprecated in ios 5.0 - ios5 적용 후 _MainToolbar.backgroundView 먹히지 않음. 툴바 tintColor 속성 추가. ///////
// backgroundView property accessors
- (UIView *)backgroundView {
	return [_MainToolbar viewWithTag:backgroundTag];
}






// backgroundView property setter
- (void)setBackgroundView:(UIView *)bgView {
	bgView.tag = backgroundTag;
	
	UIView *currentBackgroundView = [_MainToolbar viewWithTag:backgroundTag];
	
	if (currentBackgroundView != nil)
		[currentBackgroundView removeFromSuperview];
	
	[_MainToolbar addSubview:bgView];
	[_MainToolbar sendSubviewToBack:bgView];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////






// currentGroup property accessors
- (NSInteger)currentGroup {
	return _CurrentGroup;
}






// currentGroup property setter
- (void)setCurrentGroup:(NSInteger)group {
	if ((group < 0) || (group >= [_Groups count]))
		return;
	
	if (_CurrentGroup == group)
		return;
	
	_CurrentGroup = group;
	[self refresh];
}






- (UIImage *)receiveItemImage:(NSInteger)group item:(NSInteger)index {
	if ((_Delegate == nil) || ([_Delegate respondsToSelector:@selector(tabView:group:image:)] == NO))
		return nil;

	return [_Delegate tabView:self group:group image:index];
}






- (UIImage *)receiveHighlightedImage:(NSInteger)group item:(NSInteger)index {
	if ((_Delegate == nil) || ([_Delegate respondsToSelector:@selector(tabView:group:highlighted:)] == NO))
		return nil;
	
	return [_Delegate tabView:self group:group highlighted:index];
}






- (void)itemClicked:(id)sender {
    
	if ((_Delegate == nil) || ([_Delegate respondsToSelector:@selector(tabView:group:didSelectItem:)] == NO))
		return;
	
	[_Delegate tabView:self group:_CurrentGroup didSelectItem:[sender tag]];
}






- (void)makeGroupItems:(NSInteger)groupCount {
	NSInteger itemCount			= 0;
	NSMutableArray *items		= nil;
	UIButton *btnItem			= nil;
	UIImage *normalImage		= nil;
	UIImage *highlightedImage	= nil;
	UIBarButtonItem *barItem	= nil;
	
	for (NSInteger i = 0; i < groupCount; i++) {
		itemCount = [_Delegate tabView:self numberOfItemInGroup:i];
		
		if (itemCount < 1)
			continue;
		
		items = [[NSMutableArray alloc] initWithCapacity:itemCount + (itemCount - 1)];
		
		for (NSInteger j = 0; j < itemCount; j++) {
			btnItem				= [[UIButton alloc] init];
			btnItem.tag			= j;
			normalImage			= [self receiveItemImage:i item:j];
			highlightedImage	= [self receiveHighlightedImage:i item:j];
			
			if(_image2XSize){
				btnItem.frame		= CGRectMake(0.0f, 0.0f, normalImage.size.width, normalImage.size.height);
			} else {
				btnItem.frame		= CGRectMake(0.0f, 0.0f, normalImage.size.width, normalImage.size.height);
			}
			
			
			if (normalImage != nil)
				[btnItem setBackgroundImage:normalImage forState:UIControlStateNormal];
			
			if (highlightedImage != nil)
				[btnItem setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
			
			[btnItem addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btnItem setTitle:@"하원" forState:UIControlStateNormal];
            btnItem.titleLabel.font				= [UIFont fontWithName:kDefaultFontName size:9.0f];
            [btnItem setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
            [btnItem setTitleEdgeInsets:UIEdgeInsetsMake(34, 0, 0, 0)];
			barItem = [[UIBarButtonItem alloc] initWithCustomView:btnItem];
			[btnItem release];
			
			[items addObject:barItem];
			
			if (j < itemCount - 1)
				[items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease]];

			[barItem release];
		}
		
		[_Groups addObject:items];
		[items release];
	}
}






- (void)reloadData {
	NSInteger groupCount = [_Delegate numberOfGroups:self];
	
	if (groupCount < 1)
		return;
	
	if (_Groups != nil) {
		_MainToolbar.items = nil;
		[_Groups removeAllObjects];
	} else
		_Groups = [[NSMutableArray alloc] initWithCapacity:groupCount];

	[self makeGroupItems:groupCount];
	[self refresh];
}


#pragma mark-
#pragma mark Application lifecycle methods
#pragma mark-
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (_Delegate == nil)
		return;
	
	NSInteger groupCount = [_Delegate numberOfGroups:self];
	
	if (groupCount < 1)
		return;
	
	_CurrentGroup	= 0;
	
	[self.view addSubview:_MainToolbar];
	[self reloadData];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






- (void)viewDidUnload {
    [super viewDidUnload];
}






- (void)dealloc {
	if (_Groups != nil)
		[_Groups release];
	
	[_MainToolbar release];
    [super dealloc];
}

@end
