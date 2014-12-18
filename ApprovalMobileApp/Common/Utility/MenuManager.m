//
//  MenuManager.m
//
//  Created by 종욱 윤 on 11. 1. 4..
//  Copyright 2011 (주) 쿠콘. All rights reserved.
//

#import "MenuManager.h"
#import "SysUtils.h"
#import "StrUtils.h"
#import "AppUtils.h"
#import "Constants.h"
#import "SessionManager.h"
#import "JSON.h"
//#import "UserPreferences.h"


@implementation MenuManager

@synthesize tileMenus	= _arrTileMenus;
@synthesize illustMenus	= _arrIllustMenus;
@synthesize flowMenus	= _arrFlowMenus;
@synthesize myMenus		= _arrMyMenus;
@synthesize tabMenu		= _arrTabMenu;


static MenuManager* _menuMgr = nil;


+ (MenuManager *)sharedMenuManager {
	if ([SysUtils isNull:_menuMgr] == YES)
		_menuMgr = [[MenuManager alloc] init];
	
	return _menuMgr;
}


- (id)init {
	self = [super init];
	
	if ([SysUtils isNull:self] == NO) {
		_sSourceFileName	= nil;
		_arrTileMenus		= [[NSMutableArray alloc] init];
		_arrFlowMenus		= [[NSMutableArray alloc] init];
		_arrMyMenus			= [[NSMutableArray alloc] init];
		_arrTabMenu			= [[NSMutableArray alloc] init];
		
		if ([AppUtils isAvailableDevice] == YES)
			_arrIllustMenus	= [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (void)extractMenuInformations:(NSArray *)aMenuInformations {
	if (([SysUtils isNull:aMenuInformations] == YES) || ([aMenuInformations count] <= 0))
		return;
	
	BOOL bMyMenu				= NO;
	BOOL bTileMenu				= NO;
	BOOL bIllustMenu			= NO;
	BOOL bFlowMenu				= NO;
	BOOL bTabMenu				= NO;
	NSArray* arrSubMenus		= nil;
	NSString* sAvailableVersion	= nil;
	BOOL bAvailableService		= NO;
#if _DEBUG_
	int i = 0;
#endif
	
	for (NSDictionary* dicItem in aMenuInformations) {
		sAvailableVersion	= [dicItem objectForKey:@"c_available_ver"];
		bAvailableService	= [[dicItem objectForKey:@"c_available_service"] boolValue];
		
		// 현재 버전에서 실행 가능한 메뉴인지 확인한다.
//		if ([SysUtils isNull:sAvailableVersion] == NO) {
//			if ([SysUtils versionToInteger:sAvailableVersion] > [SessionManager sharedSessionManager].versionNumber)
//				continue;
//		}
		
#if _DEBUG_
		NSLog(@"SEQ[%d][%@]", i++, [dicItem objectForKey:@"c_menu_title"]);
#endif
		
		bTileMenu		= [[dicItem objectForKey:@"c_menu_type1"] boolValue];//타일메뉴
		bFlowMenu		= [[dicItem objectForKey:@"c_menu_type2"] boolValue];//커버플루
		bMyMenu			= [[dicItem objectForKey:@"c_menu_type3"] boolValue];//마이메뉴
		bTabMenu		= [[dicItem objectForKey:@"c_menu_type4"] boolValue];//탭바구분.

		if (bAvailableService == NO)
			bFlowMenu	= NO;
		
		if (bMyMenu == YES)
			[_arrMyMenus addObject:dicItem];
		
		if (bTileMenu == YES)
			[_arrTileMenus addObject:dicItem];
		
		if (bFlowMenu == YES)
			[_arrFlowMenus addObject:dicItem];
		
		if (bIllustMenu == YES)
			[_arrIllustMenus addObject:dicItem];
		
		if (bTabMenu == YES)
			[_arrTabMenu addObject:dicItem];

		
		arrSubMenus = [dicItem objectForKey:kKeyOfSubMenus];
		
		if (([SysUtils isNull:arrSubMenus] == NO) && ([arrSubMenus count] > 0))
			[self extractMenuInformations:arrSubMenus];
	}
}


- (NSString *)sourceFileName {
	return _sSourceFileName;
}


- (void)setSourceFileName:(NSString *)aFileName {
	if ([SysUtils isNull:aFileName] == YES)
		return;
	
	if ([aFileName isEqualToString:_sSourceFileName] == YES)
		return;
	
	if ([SysUtils isNull:_sSourceFileName] == NO)
		[_sSourceFileName release];
	
	_sSourceFileName = [aFileName copy];
	
	NSString* sMenuDoc				= [NSString decryptFromFile:_sSourceFileName];
	NSDictionary* dicMenuDoc		= [sMenuDoc JSONValue];
	NSArray* arrResData				= [dicMenuDoc objectForKey:kTransResponseData];
	NSDictionary* dicConfigItems	= [arrResData objectAtIndex:0];
	NSArray* arrMenus				= [dicConfigItems objectForKey:kKeyOfSubMenus];
	
	[self extractMenuInformations:arrMenus];
	
	// 타일 메뉴 정보를 정렬한다.
	NSSortDescriptor* seqSort = [[NSSortDescriptor alloc] initWithKey:@"c_grid_seq" ascending:YES];
	[_arrTileMenus sortUsingDescriptors:[NSArray arrayWithObjects:seqSort, nil]];
	[seqSort release];
	
	// flow 메뉴 정보를 정렬한다.
	seqSort = [[NSSortDescriptor alloc] initWithKey:@"c_slide_seq" ascending:YES];
	[_arrFlowMenus sortUsingDescriptors:[NSArray arrayWithObjects:seqSort, nil]];
	[seqSort release];

	// 일러스트 메뉴를 정렬한다. ==> 포털에만 적용 가능한 이야기
	if ([SysUtils isNull:_arrIllustMenus] == NO) {
		seqSort = [[NSSortDescriptor alloc] initWithKey:@"c_illust_seq" ascending:YES];
		[_arrIllustMenus sortUsingDescriptors:[NSArray arrayWithObjects:seqSort, nil]];
		[seqSort release];
	}
}


- (NSDictionary *)getTileMenuInfoFromMenuID:(NSString *)aMenuID {
	if ([SysUtils isNull:aMenuID] == YES)
		return nil;

	if (([SysUtils isNull:_arrTileMenus] == YES) || ([_arrTileMenus count] <= 0))
		return nil;

	NSString* sMenuID	= nil;
	
	for (NSDictionary* dicItem in _arrTileMenus) {
		sMenuID = [dicItem objectForKey:kKeyOfMenuID];
		
		if ([sMenuID isEqualToString:aMenuID] == YES)
			return dicItem;
	}
	
	return nil;
}


- (NSDictionary *)getTileMenuInfoFromIndex:(NSInteger)aIndex {
	if (([SysUtils isNull:_arrTileMenus] == YES) || ([_arrTileMenus count] <= 0))
		return nil;
	
	if ((aIndex < 0) || (aIndex >= [_arrTileMenus count]))
		return nil;
	
	return [_arrTileMenus objectAtIndex:aIndex];
}


- (NSInteger)getIndexFromTileMenusWithMenuID:(NSString *)aMenuID {
	if ([SysUtils isNull:aMenuID] == YES)
		return 0;
	
	if (([SysUtils isNull:_arrTileMenus] == YES) || ([_arrTileMenus count] <= 0))
		return 0;
	
	NSString* sMenuID		= nil;
	NSDictionary* dicItem	= nil;
	
	for (NSInteger i = 0; i < [_arrTileMenus count]; i++) {
		dicItem	= [_arrTileMenus objectAtIndex:i];
		sMenuID	= [dicItem objectForKey:kKeyOfMenuID];

		if ([sMenuID isEqualToString:aMenuID] == YES)
			return i;
	}
	
	return 0;
}


- (NSDictionary *)getFlowMenuInfoFromMenuID:(NSString *)aMenuID {
	if ([SysUtils isNull:aMenuID] == YES)
		return nil;
	
	if (([SysUtils isNull:_arrFlowMenus] == YES) || ([_arrFlowMenus count] <= 0))
		return nil;
	
	NSString* sMenuID	= nil;
	
	for (NSDictionary* dicItem in _arrFlowMenus) {
		sMenuID = [dicItem objectForKey:kKeyOfMenuID];
		
		if ([sMenuID isEqualToString:aMenuID] == YES)
			return dicItem;
	}
	
	return nil;
}


- (NSDictionary *)getFlowMenuInfoFromIndex:(NSInteger)aIndex {
	if (([SysUtils isNull:_arrFlowMenus] == YES) || ([_arrFlowMenus count] <= 0))
		return nil;
	
	if ((aIndex < 0) || (aIndex >= [_arrFlowMenus count]))
		return nil;
	
	return [_arrFlowMenus objectAtIndex:aIndex];
}


- (NSInteger)getIndexFromFlowMenusWithMenuID:(NSString *)aMenuID {
	if ([SysUtils isNull:aMenuID] == YES)
		return 0;
	
	if (([SysUtils isNull:_arrFlowMenus] == YES) || ([_arrFlowMenus count] <= 0))
		return 0;
	
	NSString* sMenuID		= nil;
	NSDictionary* dicItem	= nil;
	
	for (NSInteger i = 0; i < [_arrFlowMenus count]; i++) {
		dicItem	= [_arrFlowMenus objectAtIndex:i];
		sMenuID	= [dicItem objectForKey:kKeyOfMenuID];
		
		if ([sMenuID isEqualToString:aMenuID] == YES)
			return i;
	}
	
	return 0;
}


- (NSDictionary *)getMyMenuInfoFromMenuID:(NSString *)aMenuID {
	if ([SysUtils isNull:aMenuID] == YES)
		return nil;
	
	if (([SysUtils isNull:_arrMyMenus] == YES) || ([_arrMyMenus count] <= 0))
		return nil;
	
	NSString* sMenuID	= nil;
	
	for (NSDictionary* dicItem in _arrMyMenus) {
		sMenuID = [dicItem objectForKey:kKeyOfMenuID];
		
		if ([sMenuID isEqualToString:aMenuID] == YES)
			return dicItem;
	}
	
	return nil;
}


- (NSDictionary *)getMyMenuInfoFromIndex:(NSInteger)aIndex {
	if (([SysUtils isNull:_arrMyMenus] == YES) || ([_arrMyMenus count] <= 0))
		return nil;
	
	if ((aIndex < 0) || (aIndex >= [_arrMyMenus count]))
		return nil;
	
	return [_arrMyMenus objectAtIndex:aIndex];
}


- (NSInteger)getIndexFromMyMenusWithMenuID:(NSString *)aMenuID {
	if ([SysUtils isNull:aMenuID] == YES)
		return 0;
	
	if (([SysUtils isNull:_arrMyMenus] == YES) || ([_arrMyMenus count] <= 0))
		return 0;
	
	NSString* sMenuID		= nil;
	NSDictionary* dicItem	= nil;
	
	for (NSInteger i = 0; i < [_arrMyMenus count]; i++) {
		dicItem	= [_arrMyMenus objectAtIndex:i];
		sMenuID	= [dicItem objectForKey:kKeyOfMenuID];
		
		if ([sMenuID isEqualToString:aMenuID] == YES)
			return i;
	}
	
	return 0;
}


- (NSDictionary *)getIllustMenuInfoFromMenuID:(NSString *)aMenuID {
	if ([SysUtils isNull:aMenuID] == YES)
		return nil;
	
	if (([SysUtils isNull:_arrIllustMenus] == YES) || ([_arrIllustMenus count] <= 0))
		return nil;
	
	NSString* sMenuID	= nil;
	
	for (NSDictionary* dicItem in _arrIllustMenus) {
		sMenuID = [dicItem objectForKey:kKeyOfMenuID];
		
		if ([sMenuID isEqualToString:aMenuID] == YES)
			return dicItem;
	}
	
	return nil;
}


- (NSDictionary *)getIllustMenuInfoFromIndex:(NSInteger)aIndex {
	if (([SysUtils isNull:_arrIllustMenus] == YES) || ([_arrIllustMenus count] <= 0))
		return nil;
	
	if ((aIndex < 0) || (aIndex >= [_arrIllustMenus count]))
		return nil;
	
	return [_arrIllustMenus objectAtIndex:aIndex];
}


- (NSInteger)getIndexFromIllustMenusWithMenuID:(NSString *)aMenuID {
	if ([SysUtils isNull:aMenuID] == YES)
		return 0;
	
	if (([SysUtils isNull:_arrIllustMenus] == YES) || ([_arrIllustMenus count] <= 0))
		return 0;
	
	NSString* sMenuID		= nil;
	NSDictionary* dicItem	= nil;
	
	for (NSInteger i = 0; i < [_arrIllustMenus count]; i++) {
		dicItem	= [_arrIllustMenus objectAtIndex:i];
		sMenuID	= [dicItem objectForKey:kKeyOfMenuID];
		
		if ([sMenuID isEqualToString:aMenuID] == YES)
			return i;
	}
	
	return 0;
}


#pragma mark-
- (id)copyWithZone:(NSZone *)zone {
	return self;
}


- (id)retain {
	return self;
}


- (NSUInteger)retainCount {
	return NSUIntegerMax;
}


- (void)release {
	// do nothing
}


- (id)autorelease {
	return self;
}


- (void)dealloc {
	if ([SysUtils isNull:_arrTileMenus] == NO)
		[_arrTileMenus release];
	
	if ([SysUtils isNull:_arrIllustMenus] == NO)
		[_arrIllustMenus release];
	
	if ([SysUtils isNull:_arrFlowMenus] == NO)
		[_arrFlowMenus release];
	
	if ([SysUtils isNull:_arrMyMenus] == NO)
		[_arrMyMenus release];
	
	if ([SysUtils isNull:_arrTabMenu] == NO)
		[_arrTabMenu release];
	

	if ([SysUtils isNull:_sSourceFileName] == NO)
		[_sSourceFileName release];
	
	
	[_menuMgr release];
	[super dealloc];
}



@end
