//
//  MenuManager.h
//
//  Created by 종욱 윤 on 11. 1. 4..
//  Copyright 2011 (주) 쿠콘. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MenuManager : NSObject {
	NSMutableArray*	_arrTileMenus;
	NSMutableArray*	_arrIllustMenus;
	NSMutableArray*	_arrFlowMenus;
	NSMutableArray*	_arrMyMenus;
	NSMutableArray*	_arrTabMenu;
	NSString*		_sSourceFileName;
}

@property (nonatomic, retain) NSArray* tileMenus;
@property (nonatomic, retain) NSArray* illustMenus; // 사용안함.
@property (nonatomic, retain) NSArray* flowMenus;
@property (nonatomic, retain) NSArray* myMenus;
@property (nonatomic, retain) NSArray* tabMenu;
@property (nonatomic, copy) NSString* sourceFileName;


+ (MenuManager *)sharedMenuManager;

- (NSDictionary *)getTileMenuInfoFromMenuID:(NSString *)aMenuID;
- (NSDictionary *)getTileMenuInfoFromIndex:(NSInteger)aIndex;
- (NSInteger)getIndexFromTileMenusWithMenuID:(NSString *)aMenuID;
- (NSDictionary *)getFlowMenuInfoFromMenuID:(NSString *)aMenuID;
- (NSDictionary *)getFlowMenuInfoFromIndex:(NSInteger)aIndex;
- (NSInteger)getIndexFromFlowMenusWithMenuID:(NSString *)aMenuID;
- (NSDictionary *)getMyMenuInfoFromMenuID:(NSString *)aMenuID;
- (NSDictionary *)getMyMenuInfoFromIndex:(NSInteger)aIndex;
- (NSInteger)getIndexFromMyMenusWithMenuID:(NSString *)aMenuID;
- (NSDictionary *)getIllustMenuInfoFromMenuID:(NSString *)aMenuID;
- (NSDictionary *)getIllustMenuInfoFromIndex:(NSInteger)aIndex;
- (NSInteger)getIndexFromIllustMenusWithMenuID:(NSString *)aMenuID;

@end
