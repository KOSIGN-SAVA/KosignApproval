//
//  SessionManager.m
//  
//
//  Created by 종욱 윤 on 10. 3. 29..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import "SessionManager.h"
#import "SysUtils.h"
#import "StrUtils.h"
#import "Constants.h"
//#import "JSON.h"


#define kSettingDic						@"settingDic"

@interface SessionManager()

- (void)saveSetting;
- (void)loadSetting;

@end



@implementation SessionManager

@synthesize dVSN_RECarray       = _dVSN_RECarray;
@synthesize menuArray           = _menuArray;
@synthesize saveID              = _saveID;
@synthesize userID				= _userID;
@synthesize bIsLogin		    = _bIsLogin;

@synthesize gateWayUrl          = _gateWayUrl;
@synthesize channelID           = _channelID;
@synthesize portalID            = _portalID;

@synthesize latestVersion       = _latestVersion;
@synthesize appUrl              = _appUrl;
@synthesize isNetworkStuts      = _isNetworkStuts;

@synthesize userNameString      = _userNameString;
@synthesize menuTitleString     = _menuTitleString;
@synthesize loginDataDic        = _loginDataDic;
@synthesize managedObjectContext   = _managedObjectContext;
@synthesize isWriteList         = _isWriteList;
@synthesize selectAttendDataArr = _selectAttendDataArr;
@synthesize appInfoDataArr      = _appInfoDataArr;
@synthesize categoryDataArr = _categoryDataArr;
@synthesize selectedCategoryID = _selectedCategoryID;
@synthesize isSyncView          = _isSyncView;
@synthesize isFirstSetUp        = _isFirstSetUp;

@synthesize dataemployeeSelectDic               = _dataemployeeSelectDic;
@synthesize dataContactSelectDic                = _dataContactSelectDic;
@synthesize dataContactGroupSelectDic           = _dataContactGroupSelectDic;
@synthesize dataPhoneListDic                    = _dataPhoneListDic;

@synthesize dataemployeeGroupArr               = _dataemployeeGroupArr;
@synthesize dataemployeeDpartArr               = _dataemployeeDpartArr;
@synthesize sessionOutString                   = _sessionOutString;

static SessionManager *sessionMgr = nil;


+ (SessionManager *)sharedSessionManager {
	if (sessionMgr == nil)
		sessionMgr = [[SessionManager alloc] init];
	
	
	return sessionMgr;
}


- (void)parsingMenuData:(NSArray *)menuData{
	[_menuArray removeAllObjects];
    NSMutableArray *menuArr = [[NSMutableArray alloc]init];
    NSString *imageString = nil;
    
//    0. 원아정보, 1.수납현황, 2.유치원공지사항, 3.행사일정, 4.식단표, 5.포토앨범 6.투약의뢰서 7.귀가동의서 8.커뮤니티 9.아이모아커뮤니티 10.알림메시지 11.등하원알림 12.승하차알림 13.차량변경요청현황 14.환경설정  15,우리아이정보 16.교육비납부 17.수납계좌정보 18.납부내역 19.차량노선정보
    NSMutableArray *menuDataArr;
    
    menuDataArr = [[NSMutableArray alloc]initWithObjects:@"원아정보",@"수납현황",@"공지사항",@"행사일정",@"식단표",@"포토앨범",@"투약의뢰서",@"귀가동의서",@"커뮤니티",@"아이모아 커뮤니티",@"알림메시지",@"등하원 알림",@"승하차 알림",@"차량변경요청현황",@"환경설정",@"우리아이정보",@"교육비조회",@"차량노선정보",@"공지사항",@"",@"",@"", nil];
    
    for (NSMutableDictionary *menuDic in menuData) {
//        if ([[menuDic objectForKey:@"APP_MENU"] isEqualToString:@"true"]) {
            [menuDic setObject:[menuDataArr objectAtIndex:[[menuDic objectForKey:@"MENU_ID"] integerValue]] forKey:@"menuName"];
            if ([[menuDic objectForKey:@"MENU_ID"] integerValue]+1 <= 9) {
                imageString = [NSString stringWithFormat:@"Main_icon0%d.png",[[menuDic objectForKey:@"MENU_ID"] integerValue]+1];
                
            }else{
                imageString = [NSString stringWithFormat:@"Main_icon%d.png",[[menuDic objectForKey:@"MENU_ID"] integerValue]+1];
                
                if ([[menuDic objectForKey:@"MENU_SEQ"] isEqualToString:@"15"]) {
                    imageString = [NSString stringWithFormat:@"Main_icon01.png"];
                    
                }else if ([[menuDic objectForKey:@"MENU_SEQ"] isEqualToString:@"16"]) {
                    imageString = [NSString stringWithFormat:@"Main_icon02.png"];
                    
                }else if ([[menuDic objectForKey:@"MENU_SEQ"] isEqualToString:@"17"]) {
                    imageString = [NSString stringWithFormat:@"Main_icon13.png"];
                    
                }else if ([[menuDic objectForKey:@"MENU_SEQ"] isEqualToString:@"18"]) {
                    imageString = [NSString stringWithFormat:@"Main_icon02.png"];
                    
                }
            }
            [menuDic setObject:imageString forKey:@"c_mymenu_normal_icon"];
            [menuDic setObject:imageString forKey:@"c_mymenu_click_icon"];
            
            [menuArr addObject:menuDic];

//        }else{
//        }
        
    }
    
    [_menuArray addObjectsFromArray:menuArr];
    
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:_menuArray forKey:@"menuArrSave"];
    [userD synchronize];
    
}

- (id)init {
	self = [super init];
	
	if (self != nil) {
        _dataemployeeGroupArr		= [[NSMutableArray alloc] init];
        _dataemployeeDpartArr		= [[NSMutableArray alloc] init];

		_dVSN_RECarray		= [[NSMutableArray alloc] init];
		_menuArray			= [[NSMutableArray alloc] init];
        _selectAttendDataArr = [[NSMutableArray alloc] init];
        _appInfoDataArr     = [[NSMutableArray alloc] init];
        _categoryDataArr    = [[NSMutableArray alloc] init];
        _loginDataDic       = [[NSMutableDictionary alloc]init];
        _menuTitleString    = nil;
        _saveID             = nil;
        _gateWayUrl			= nil;
        _channelID          = [[NSString alloc] init];
        _portalID           = [[NSString alloc] init];
        _userID             = [[NSString alloc]init];
        _selectedCategoryID = [[NSString alloc] init];
        _sessionOutString   = [[NSString alloc] init];
        _managedObjectContext = [[NSManagedObjectContext alloc] init];

        _latestVersion      = [[NSString alloc]init];
        _appUrl             = nil;
        _userNameString     = nil;
        _bIsLogin			= NO;
        _isNetworkStuts     = NO;
        _isWriteList        = [[NSString alloc]init];
        _isSyncView         = NO;
        _isFirstSetUp       = NO;

        _dataemployeeSelectDic          = [[NSMutableDictionary alloc]init];
        _dataContactSelectDic           = [[NSMutableDictionary alloc]init];
        _dataContactGroupSelectDic      = [[NSMutableDictionary alloc]init];
        _dataPhoneListDic               = [[NSMutableDictionary alloc]init];
        

	}
	
	return self;
}


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
	if ([SysUtils isNull:_menuArray] == NO)
		[_menuArray release];

    
    
	[super dealloc];
}




#pragma mark -
#pragma mark private Method
- (void)loadSetting{
	
	NSDictionary* settingDic = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingDic];
	   
	_saveID				= [settingDic objectForKey:@"_saveID"];							// 아이디 저장
	
	
#if _DEBUG_	
	NSLog(@"======================= %@", settingDic);
#endif
}


- (void)saveSetting{
	if (![SysUtils isNull:[[NSUserDefaults standardUserDefaults] objectForKey:kSettingDic]]) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:kSettingDic];
	}
	
	NSDictionary* settingDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_saveID], @"_saveID",
								nil];
	
	[[NSUserDefaults standardUserDefaults] setObject:settingDic forKey:kSettingDic];
	
#if _DEBUG_
	NSLog(@"saveBefore data[%@] ", settingDic);
	NSLog(@"settingData [%@]", [[NSUserDefaults standardUserDefaults] objectForKey:kSettingDic]);
#endif
	
}




- (void)setSaveID:(NSString *)aSaveID{
	_saveID = aSaveID;
	[self saveSetting];
}


- (NSString*)saveID{
	return _saveID;
}




@end
