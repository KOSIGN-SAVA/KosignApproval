//
//  WCPushService.h
//  ApplePush
//
//  Created by donghwan kim on 10. 11. 26..
//  Copyright 2010 webcash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
	WCPUSH_STATUS_MESSAGE = 0,			//Push Remote 메세지가 반환 되었을때 전달.
	WCPUSH_STATUS_LOCAL_MESSAGE,		//Push Local 메세지가 반환 되었을때 전달.
	WCPUSH_STATUS_GET_TOKENDEVICE,		//토큰정보를 받았을때
	WCPUSH_STATUS_SET_REGISTERSERVER,	//업무서버로 토큰 정보 및 전달이 성공 되었을 경우.
	WCPUSH_STATUS_SET_UNREGISTERSERVER,	//업무서버로 토큰 정보 및 전달을 해제 성공 되었을 경우.
	WCPUSH_STATUS_ERROR,				//에러가 발생 하였을 때 전달
	WCPUSH_STATUS_INFO					//정보성 로그를 반환 할때 전달
};
typedef NSUInteger WCPushStatus;


enum {
	WCPUSH_ERROR_NONE = 0,			//에러가 없을 경우
	WCPUSH_ERROR_METHODHOOK,		//초기화 중 Push함수들의 위임에 실패 하였을 경우
	WCPUSH_ERROR_REGISTERAPPLE,		//디바이스 토큰 획득 실패 및 SDK상에서 오류 발생 시 리턴
	WCPUSH_ERROR_REGISTERSERVER,	//업무 서버로 등록 시 에러나 통신상 장애등이 있을 경우 리턴
	WCPUSH_ERROR_TURNOFFPUSH,		//Push 서비스가 꺼져 있음.
	WCPUSH_ERROR_INVALIDPARAM		//Prarmeter가 잘못 되었을 경우 발생
	
};
typedef NSUInteger WCPushError;

#define kAPNLaunchMessageCode			@"UIApplicationLaunchOptionsRemoteNotificationKey"


@protocol WCPushServiceDelegate;


/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief Defines a concrete @c WCPushService which APNs Bussiness utility Class.
 
 @c WCPushService는 Push서버 및 해당 업무 서버에 디바이스토큰 처리 및 메세지를 Delegate해주는 Class이다.
 */
@interface WCPushService : NSObject {
	NSString*		_deviceTokken;
	NSString*		_serverAddress;
	NSDictionary*	_notificationAPN;
	id				_delegate;				//정보 에러 메세지 알림 Delegate
}
/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c NSString deviceToken 스트링(64byte)ex)5dc532868189262e153125fd0d21f0e2fff8345921bb390e27726a13dfa055b2
 */
@property (nonatomic, retain)NSString*		deviceTokken;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c NSString 서버게이트웨이 주소
 */
@property (nonatomic, retain)NSString*		serverAddress;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c WCPushServiceDelegate
 */
@property (nonatomic, assign)id				delegate;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sets or returns the @c NSDictionay 푸쉬 메세지를 받은 Dictionary
 */
@property (nonatomic, retain)NSDictionary*	notificationAPN;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Sigletone의 객체를 가져오는 함수
 
 @return Returns			@c WCPushService Push서비스 객체 return
 */
+ (WCPushService *)sharedPushService;


/////////////////////////////////////////////////////////////////////////////////////////////
/** Push서비스를 시작 하는 함수로 AppDelegate의 didFinishLaunchingWithOptions의 인자를 받아 Push메세지를 전달 및 처리하는 함수
 
 @param launchOptions		@c id didFinishLaunchingWithOptions의 launchOptions(NSDictionary)를 넘겨주면 된다.
 @param serverAddress		@c NSString 운영서버 Gateway URL주소를 전달하면 된다. ex)http://smart.webcash.co.kr/smart/gateway/gateway.jsp
 @param types				@c UIRemoteNotificationType Push의 등록 타입인 @c UIRemoteNotificationTypeBadge, @c UIRemoteNotificationTypeSound, @c UIRemoteNotificationTypeAlert 전달
 
 */
- (void)startPushService:(id)launchOptions serverAddress:(NSString *)serverAddress types:(UIRemoteNotificationType)types;



/////////////////////////////////////////////////////////////////////////////////////////////
/** Push서비스를 업무서버에서 등록 하는 함수
 */
- (void)registerAPN;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Push서비스를 업무서버에서 등록 하는 함수 relation_key, company_id(업체 ID)전달
 */
- (void)registerAPNKey : (NSString *)relation_key companyID : (NSString *)companyString;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Push서비스를 업무서버에서 해제 하는 함수
 */
- (void)unRegisterAPN;



/////////////////////////////////////////////////////////////////////////////////////////////
/** Push서비스를 업무서버에서 업무 코드(연계아이디)를 해제 하는 함수
 @param BusinessCode		@c NSString 해당 연계 서버로 보넬 업무 코드
 */
- (void)unRegisterBusinessCodeAPN:(NSString *)BusinessCode;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당 연계 서버로 보넬 업무 코드(연계아이디)를 통신 처리하는 함수 이다.
 
 @param BusinessCode		@c NSString 해당 연계 서버로 보넬 업무 코드
 */
- (void)registerBusinessCodeAPN:(NSString *)BusinessCode;



/////////////////////////////////////////////////////////////////////////////////////////////
/** Push서비스를 업무서버에서 를 해제 하는 함수
 @param BusinessCode		@c NSString 해당 연계 서버로 보넬 업무 코드
 */
- (void)unRegisterCompanyCodeAPN:(NSString *)BusinessCode;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당 연계 서버로 보넬 업무 코드(연계아이디)를 통신 처리하는 함수 이다.
 
 @param BusinessCode		@c NSString 해당 연계 서버로 보넬 업무 코드
 */
- (void)registerCompanyCodeAPN:(NSString *)BusinessCode;




/////////////////////////////////////////////////////////////////////////////////////////////
/** 설정의 Push가 켜져 있는지를 확인 하는 함수
 
 @return Returns			@c BOOL YES 설정에 푸쉬가 켜져 있는 상태 NO 설정에 푸쉬가 꺼져 있는 상태
 */
- (BOOL)pushStatus;

@end







/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief Defines a concrete @c WCPushServiceDelegate which Push Infomation Delegate.
 
 */
@protocol WCPushServiceDelegate<NSObject>


@optional
/////////////////////////////////////////////////////////////////////////////////////////////
/** Push모든 메세지, 에러 상태, 로그등을 반환 하는 함수
 @param returnAPN		@c WCPushService	객체 리턴
 @param statusCode		@c WCPushStatus		현재 상태를 반환 한다.
 @param errorCode		@c WCPushError		에러의 종류를 반환 한다.
 @param errorMessage	@c NSString			에러가 발생하면 에러에 대한 메세지가 리턴되는 변수
 
 */
-(void) returnAPN:(WCPushService *)returnAPN statusCode:(WCPushStatus)statusCode errorCode:(WCPushError)errorCode errorMessage:(NSString *)errorMessage;

@end






