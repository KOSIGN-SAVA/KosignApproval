//
//  SessionManager.h
//  
//
//  Created by Darksaint on 2010. 9. 10..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <CoreData/CoreData.h>

typedef enum {
	mailInBox   = 0,	// 받은편지함
	mailSendBox = 1,	// 보낸편지함
	mailDrafts  = 2,	// 임시보관함
    mailBox     = 3,    // 편지보관함 
	mailTrash   = 4	    // 지운편지함
} MailBoxTabType;

typedef enum {
    fsSmall		= 0,    // 작게
	fsMiddle	= 1,    // 중간
	fsLarge		= 2		// 크게
} FontSizeType;



@interface SessionManager : NSObject {
    NSMutableArray*             _menuArray;
    NSMutableArray*             _dVSN_RECarray;             //부서목록
    NSMutableArray*             _selectAttendDataArr;        //선택된 참여자 목록
    NSMutableArray*             _appInfoDataArr;             //앱 정보 목록
    NSMutableArray*             _categoryDataArr; //분류함 리스트(좌측 슬라이드 메뉴)
    
    NSString*                   _saveID;
    NSString*                   _latestVersion;
	NSString*                   _userID;                    // 사용자 ID
    NSString*                   _appUrl;                    //app down Url
    NSString*                   _userNameString;
    NSString*                   _menuTitleString;
    NSString*                   _selectedCategoryID; // 선택된 콜라보 분류함 일련번호 값(좌측 슬라이드 메뉴)
    NSString*                   _isWriteList;
    NSString*                   _sessionOutString;
    
    NSString*                   _gateWayUrl;                // 게이트 주소
    NSString*                   _channelID;                 // 채널 ID
    NSString*                   _portalID;                  // 포탈 ID

	BOOL                        _bIsLogin;                  // 로그인 여부
    BOOL                        _isNetworkStuts;
    BOOL                        _isSyncView;
    BOOL                        _isFirstSetUp;

    NSMutableDictionary*        _msgReceverSelect;          // 사용자 데이터
    NSMutableDictionary*        _loginDataDic;              // 로그인 후 데이터
    
    NSManagedObjectContext*     _managedObjectContext;      //coredata
    
    NSMutableDictionary*        _dataemployeeSelectDic;
//    NSMutableDictionary*        _dataemployeeGroupSelectDic;
    NSMutableArray*             _dataemployeeGroupArr;
    NSMutableArray*             _dataemployeeDpartArr;

    NSMutableDictionary*        _dataContactSelectDic;
    NSMutableDictionary*        _dataContactGroupSelectDic;

    NSMutableDictionary*        _dataPhoneListDic;

}

@property (nonatomic, retain) NSMutableArray* menuArray;
@property (nonatomic, retain) NSMutableArray* dVSN_RECarray;
@property (nonatomic, retain) NSMutableArray* selectAttendDataArr;
@property (nonatomic, retain) NSMutableArray* appInfoDataArr;
@property (nonatomic, retain) NSMutableArray* categoryDataArr;
@property (nonatomic, retain) NSMutableArray* dataemployeeGroupArr;
@property (nonatomic, retain) NSMutableArray* dataemployeeDpartArr;

@property (nonatomic, retain) NSString*       latestVersion;
@property (nonatomic, retain) NSString*       saveID;
@property (nonatomic, retain) NSString*       appUrl;
@property (nonatomic, retain) NSString*       userNameString;
@property (nonatomic, retain) NSString*       menuTitleString;
@property (nonatomic, retain) NSString*       isWriteList;
@property (nonatomic, retain) NSString*       sessionOutString;

@property (nonatomic, copy)   NSString* userID;
@property (nonatomic, copy)   NSString* selectedCategoryID;

@property (nonatomic, copy)   NSString* gateWayUrl;
@property (nonatomic, copy)   NSString* channelID;
@property (nonatomic, copy)   NSString* portalID;

@property (nonatomic)   NSInteger selectChildInt;
@property (nonatomic)   NSInteger selectReceive;

@property (nonatomic, retain) NSMutableDictionary*      loginDataDic;
@property (nonatomic, retain) NSManagedObjectContext*   managedObjectContext;

@property (nonatomic, retain) NSMutableDictionary*      dataemployeeSelectDic;
//@property (nonatomic, retain) NSMutableDictionary*      dataemployeeGroupSelectDic;
@property (nonatomic, retain) NSMutableDictionary*      dataContactSelectDic;
@property (nonatomic, retain) NSMutableDictionary*      dataContactGroupSelectDic;
@property (nonatomic, retain) NSMutableDictionary*      dataPhoneListDic;

@property (nonatomic) BOOL bIsLogin;
@property (nonatomic) BOOL isNetworkStuts;
@property (nonatomic) BOOL isSyncView;
@property (nonatomic) BOOL isFirstSetUp;

+ (SessionManager *)sharedSessionManager;


- (void)parsingMenuData:(NSArray *)menuData;

@end
