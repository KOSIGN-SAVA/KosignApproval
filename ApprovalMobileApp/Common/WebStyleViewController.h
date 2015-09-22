//
//  WebStyleViewController.h
//  iBrowser
//
//  Created by 종욱 윤 on 10. 3. 27..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecurityManager.h"
//#import "AprvRcvTabView.h"
#import "WCViewController.h"


@interface WebStyleViewController : WCViewController<SecurityManagerDelegate, UITabBarDelegate, UIWebViewDelegate> {
//	NSString*		_path;
//	NSString*		_originalParams;
//	NSString*		_menuURL;
	NSString*		_imageURL;
	NSString*       _docID;

	BOOL			_isAppBackAction;
	BOOL			_isCSAction;
	BOOL			_isLoading;
	BOOL			_isImageOpen;
	BOOL            _isTrSend;
	NSInteger		_maxImagePage;
	NSInteger		_currentImagePage;

	UITabBar*		_mainTab;
	
	UIWebView*		_web;
    
    NSString*       urlFirstString;
    NSString*       urlAllString;
    
    UIView *_ToolView;
	BOOL isTrDetail;
	BOOL isRefresh;
    
    BOOL _isOpenPDF; // 첨부파일의 pdf 파일 구분 값
}

@property (nonatomic, copy) NSString* menuURL;

- (id)initWithURL:(NSString *)aURL;
- (id)initWithParams:(NSDictionary *)aParams;
- (id)initWithPDFURL:(NSString *)aURL; // 첨부파일의 pdf 파일 open을 위한 init 함수

@end
