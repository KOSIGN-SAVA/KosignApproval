//
//  SecurityManager.h
//  XWSmartSample
//
//  Created by donghwan kim on 10. 4. 1..
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

enum {
	TRANS_METHOD_GET = 0,
	TRANS_METHOD_POST	
};
typedef NSUInteger SecurityMethod;


#define kSessionTimeOutNotification @"kSessionTimeOutNotification"
#define kUserAgentFormat1			@"Mozilla/5.0 (%@; U; CPU %@ %@ like Mac OS X; ko-kr) AppleWebKit/528.18 (KHTML, like Gecko) Mobile;nma-plf=[IPN];nma-plf-ver=[%@];nma-app-id=[%@]"
#define kUserAgentFormat2			@"%@;nma-plf=[IPN];nma-plf-ver=[%@];nma-app-id=[%@]"
#define kSiteID						@"I_W_G_2"
#define kBizKiupSiteID				@"I_B_G_1"
#define kContentType                @"application/x-www-form-urlencoded; charset=utf-8"

#define kTimeOut					120
#define kTimeOutInterval			1

#if _DEBUG_
#define _SM_GATEWAY_PATHURL            @"/CntsGateway/" //GATEWAY PATH

//#define _SM_GATEWAY_PATH            @"/MApprGateway" //GATEWAY PATH
//#define _SM_GATEWAY_URL             @"http://contentsdev.webcashcorp.com:82" //GATEWAY URL
#define _SM_GATEWAY_PATH            @"/MgGate" //GATEWAY PATH
#define _SM_GATEWAY_URL             @"http://sportal.dev.weplatform.co.kr:18880" //GATEWAY URL

#else
#define _SM_GATEWAY_PATHURL            @"/gateway.jsp/" //GATEWAY PATH

//#define _SM_GATEWAY_PATH            @"/MApprGateway" //GATEWAY PATH
//#define _SM_GATEWAY_URL             @"https://approval.appplay.co.kr" //GATEWAY URL
#define _SM_GATEWAY_PATH            @"/MgGate" //GATEWAY PATH
#define _SM_GATEWAY_URL             @"http://sportal.dev.weplatform.co.kr:18880" //GATEWAY URL

#endif


@class SecurityHandler;

@protocol SecurityManagerDelegate;

/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief Defines a concrete @c SecurityManager which XecureSmart Wrapping functions.
 
 @c SecurityManager는 Softforum XecureSmart 래핑 함수들로 UIWebView sigleton 개념으로 제작된 클래스임.
 */
@interface SecurityManager : UIWebView {
	SecurityHandler*	handler;
	NSString*			_serverTime;
	NSString*			_gateWayAddress;
	NSInteger			_sessionTimeOut;
	BOOL				_isStartSessionCheck;
}
/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c SecurityHandler delegate의 위임자.
 
 @warning Clients need to set this before using SecurityManager.
 */
@property(nonatomic, retain) SecurityHandler *handler;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c NSString ServerTime
 
 */
@property(nonatomic, copy)		NSString *			serverTime;
/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c NSString Gateway URL
 
 */
@property(nonatomic, readonly)  NSString *			gateWayAddress;
/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c NSInteger Sever session TimeOut Min
 
 */
@property(nonatomic)			NSInteger			sessionTimeOut;



@property(nonatomic)			BOOL				isStartSessionCheck;
/////////////////////////////////////////////////////////////////////////////////////////////
/** singletone fundciton
 
 @return Returns			@c SecurityManager id
 */
+ (SecurityManager *)sharedSecurityManager;



/////////////////////////////////////////////////////////////////////////////////////////////
/** WebSession Check function으로 웹의 세션의 시간 만료에 대한 타이머 동작을 여기서 시작 하게 된다.
 
 @see stopCheckSession
 */
- (void)startCheckSession;



/////////////////////////////////////////////////////////////////////////////////////////////
/** WebSession Check function으로 웹의 세션의 시간 만료에 대한 타이머 동작을 여기서 중지 하게 된다.
 
 @see startCheckSession
 */
- (void)stopCheckSession;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 보안 모듈로 연결할 위치와 쿼리 값을 날리는 함수 이다. 이부분은 암호화를 진행 하게 해주며 해당 URL 통신까지 처리 해준다.
 @param url					@c NSString 연결할 URL
 @param query				@c NSString Post나 Get상의 QueryString
 @param method				@c NSInteger 0 is Get 1 is Post
 @return Returns			@c Bool @c YES 함수상의 문제가 없을 경우 @c NO 함수내부에서 오류 해당 결과는 Delegate로 전달 된다. 
 */
- (BOOL)willConnect:(NSString *) url query:(NSString *) query method:(NSInteger) method;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 전문송수신 중 취소할 수 있는 여부 
 @return Returns			@c Bool @c YES 취소가능(통신중) @c NO 취소 가능 하지 않음(비통신중)
 */
- (BOOL)isCanCancel;
 

/////////////////////////////////////////////////////////////////////////////////////////////
/** 전문송수신 중 취소 함수
 */
- (void)cancelTransaction;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 현재 세션을 유지 하고 있는 시간을 표시한다.
 */
-(NSInteger)getCurrentSessionTime;



@end




/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief Defines a concrete @c SecurityManagerDelegate which XecureSmart Wrapping functions.
 
 @c SecurityManager의 Delegate 임.
 */
@protocol SecurityManagerDelegate<UIWebViewDelegate>

@optional

/////////////////////////////////////////////////////////////////////////////////////////////
/** XecureSmart 관련 함수 Delegate  @c willConnect:query:method: 함수 사용 시 리턴 Delegate
 @param returnResult		@c NSString 해당 각함수의 결과값 리턴 
 @param errorCode			@c NSInteger 에러에 관련한 값을 리턴 해당값이 에러 이면 returnResult의값은 없음.
 @param errorMessage		@c NSString 에러가 발생하면 에러에 대한 메세지가 리턴되는 변수
 
 */

-(void) returnResult:(NSString *)returnResult errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage;



@end
