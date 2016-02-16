//
//  SecurityManager.mm
//
//  Created by  on 10. 4. 1..
//  Copyright 2010 Apple Inc. All rights reserved.
//  DONE LIST
//    1.
//  TODO LIST
//    1.

#import "SecurityManager.h"
#import "SessionManager.h"
#import "AllUtils.h"
#import "Constants.h"

@interface SecurityHandler:NSObject <SecurityManagerDelegate>{
	id					delegate;
	UIWebView*			web;
	NSString*			_userAgent;
	SecurityMethod		_method;
	NSInteger			_localsessionTime;
	NSString*			_url;
	NSString*			_setCookie;
	BOOL				_isCanCancel;
	NSURLConnection*	_connection;
    NSMutableData*		_responseData;
	NSString*			_encodingName;
	NSInteger			_statusCode;
    
	
	NSString*			_sessionId;
}
@property (nonatomic, retain)	id					delegate;
@property (nonatomic, retain)	UIWebView*			web;
@property (nonatomic, retain)	NSString*			userAgent;
@property (nonatomic)			SecurityMethod		method;
@property (nonatomic)			NSInteger			localsessionTime;
@property (nonatomic, copy)		NSString*			url;
@property (nonatomic)			BOOL				isCanCancel;
@property (nonatomic, retain)	NSURLConnection*	connection;
@property (nonatomic, retain)	NSMutableData*		responseData;

- (void)cancel;

- (void)sendTransaction:(NSString *)query;

@end

@implementation SecurityHandler
@synthesize delegate;
@synthesize web;
@synthesize userAgent			= _userAgent;
@synthesize method				= _method;
@synthesize localsessionTime	= _localsessionTime;
@synthesize url					= _url;
@synthesize connection			= _connection;
@synthesize responseData		= _responseData;
@synthesize isCanCancel			= _isCanCancel;
static NSString	*isTimeOutMsg	= @"{\"_tran_cd\":\"ERROR\",\"_tran_res_data\":[{\"_error_action\":\"1000\",\"_error_cd\":\"100\",\"_error_msg\":\"통신 시간이 만로되었습니다. 출금 거래 중이신 고객은 계좌 거래내역 조회 등을 통해 반드시 출금 결과를 확인하여 주시기 바랍니다.\"}]}";
static NSTimer *_transactionTimer		= nil;
int _timeOut;

- (id)init{
    if (self = [super init]) {
		_url				= nil;
		_method				= TRANS_METHOD_GET;
		_localsessionTime	= 0;
		_statusCode			= -1;
		_timeOut			= 0;
		_setCookie			= nil;
		_connection			= nil;
		_encodingName		= nil;
		_isCanCancel		= NO;
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appIDstring = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleIdentifier"]];
        
		_userAgent			= [[NSString stringWithFormat:kUserAgentFormat1,
                                [[UIDevice currentDevice] model],
                                [[UIDevice currentDevice] systemName],
                                [[[UIDevice currentDevice] systemVersion]stringByReplacingOccurrencesOfString:@"." withString:@"_"],
                                [[UIDevice currentDevice] systemVersion],
                                appIDstring] copy];
        
        NSDictionary *userAgentDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_userAgent, @"UserAgent", nil];
		[[NSUserDefaults standardUserDefaults] registerDefaults:userAgentDictionary];
		[userAgentDictionary release];
        
	}
	return self;
}


- (void)dealloc{
	if (_url) {
		[_url release];
	}
	
	
	[_responseData release];
	[super dealloc];
}


- (void)OnTimeout:(NSTimer *)timer {
	_timeOut += kTimeOutInterval;
	
	if (kTimeOut <= _timeOut) {
		//Notificaition 처리 하고 나오자.
		[_transactionTimer invalidate];
		[_transactionTimer release];
		_transactionTimer = nil;
		_timeOut= 0;
		[self cancel];
		
		if (self.delegate && [self.delegate respondsToSelector:@selector(returnResult:errorCode:errorMessage:)]) {
			[self.delegate returnResult:isTimeOutMsg errorCode:1004 errorMessage:@"통신중 시간 만료되었습니다. 잠시 후 다시 확인하여 주시기 바랍니다."];
		}
	}
}


- (void)cancel{
	if (self.connection){
		_isCanCancel = NO;
		[self.connection cancel];
		
		if (_transactionTimer) {
			[_transactionTimer invalidate];
			[_transactionTimer release];
			_transactionTimer = nil;
			_timeOut= 0;
		}
		
		_connection = nil;
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
}


- (void)sendTransaction:(NSString *)query{
	NSMutableURLRequest	*aURLRequest	= nil;
	
	aURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
	
	switch (_method) {
		case TRANS_METHOD_GET:
			[aURLRequest setHTTPMethod:@"GET"];
			break;
            
		case TRANS_METHOD_POST:
			NSData *Body = [query dataUsingEncoding: NSUTF8StringEncoding];
			[aURLRequest setHTTPMethod:@"POST"];
			[aURLRequest setHTTPBody:Body];
			break;
	}
	[aURLRequest addValue:_userAgent forHTTPHeaderField:@"User-Agent"];
	
//    if ([SessionManager sharedSessionManager].isNewMemo == YES) {
//        //한글 인코딩 문제로 인해, Content_Type을 강제지정.
//        [aURLRequest addValue:kContentType forHTTPHeaderField:@"Content-Type"];
//    }
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
#if _DEBUG_
	NSLog(@"URL[%@]query[%@]", _url, query);
#endif
	_statusCode = -1;
	_connection = [[NSURLConnection alloc] initWithRequest:aURLRequest delegate:self];
	_isCanCancel = (_connection != nil);
    
	if (_connection) {
		_transactionTimer = [[NSTimer scheduledTimerWithTimeInterval:kTimeOutInterval target:self selector:@selector(OnTimeout:) userInfo:nil repeats:YES] retain];
	}
}


#pragma mark -
#pragma mark UIWebViewDelegate implementation
#pragma mark -
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest  navigationType:(UIWebViewNavigationType)aNavigationType{
	BOOL flag = YES;
	
	//현재 맨처음 웹에서 초기화 할때 User-Agent 의 값이 내려오게 되어 있음.
	NSDictionary *AllHeader	= (NSDictionary *) [aRequest allHTTPHeaderFields];
	NSString* sUserAgent	= [AllHeader valueForKey:@"User-Agent"];
	
	if ((sUserAgent != nil) && ([sUserAgent isEqualToString:@""] == NO)) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appIDstring = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleIdentifier"]];
        
		_userAgent = [[NSString stringWithFormat:kUserAgentFormat2, (NSString *)[AllHeader valueForKey:@"User-Agent"], [[UIDevice currentDevice] systemVersion], appIDstring] copy];
    }
    
#if _DEBUG_
	NSLog(@"============WebView Agent [%@]", _userAgent);
#endif
    
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
		flag = [self.delegate webView:web shouldStartLoadWithRequest:aRequest navigationType:aNavigationType];
	}
	
	
	return flag;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
		[self.delegate webView:web didFailLoadWithError:error];
	}
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
		[self.delegate webViewDidFinishLoad:web];
	}
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	_localsessionTime = 0;
//    [SessionManager sharedSessionManager].loginTimeInt = [[[[NSDate date] addDay:1] dateToString:@"ddHHmm"] intValue];

	if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
		[self.delegate webViewDidStartLoad:web];
	}
}



#pragma mark -
#pragma mark URLConnectionDelegate implementation
#pragma mark -
// AllowsAnyHTTPSCertificate 대체한 Delegate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


// AllowsAnyHTTPSCertificate 대체한 Delegate
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		//  if ([trustedHosts containsObject:challenge.protectionSpace.host])
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	//http Status code 초기화
	_statusCode = 0;
	_localsessionTime = 0;
//    [SessionManager sharedSessionManager].loginTimeInt = [[[[NSDate date] addDay:1] dateToString:@"ddHHmm"] intValue];

    self.responseData = [NSMutableData data];    // start off with new data
	_encodingName = [response textEncodingName];
	
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		_statusCode   = ((NSHTTPURLResponse *)response).statusCode;
	}
#if _DEBUG_
	NSLog(@"response[%@] _statusCode[%d]", [response description], _statusCode);
#endif
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_responseData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _connection   = nil;
	_responseData = nil;
	_isCanCancel  = NO;
    
	//타임아웃 체크 제외
	if (_transactionTimer) {
		[_transactionTimer invalidate];
		[_transactionTimer release];
		_transactionTimer = nil;
	}
	_timeOut      = 0;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//2010-04-15 서버통신오류는 Action을 1002로 내보내면 안됨. 로그아웃은 안됨.
	if (self.delegate && [self.delegate respondsToSelector:@selector(returnResult:errorCode:errorMessage:)]) {
		[self.delegate returnResult:@"" errorCode:1004 errorMessage:[NSString stringWithFormat:@"통신중 오류가 발생 하였습니다.[%d]", _statusCode]];
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _connection	  = nil;
	_isCanCancel  = NO;
    
	//타임아웃 체크 제외
	if (_transactionTimer) {
		[_transactionTimer invalidate];
		[_transactionTimer release];
		_transactionTimer = nil;
	}
	_timeOut      = 0;
	
	
	NSString *_responseString = nil;
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	if (_statusCode == 200) {
		if ([_encodingName isEqualToString:@"euc-kr"] == YES){
            
			//암호화 되지 않은 에러를 처리 할때 _error_cd
			_responseString = [[[[[NSString alloc] initWithData:_responseData encoding:-2147481280] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"];
		}
		//else if ([_encodingName isEqualToString:@"utf-8"] == YES){
        else {
			//_responseString = [[[[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"];
            _responseString = [[[[[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"㈜" withString:@"(주)"] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        }
        
        
        NSString *decodedString = [_responseString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
#if _DEBUG_
		NSLog(@"ResultData [%@]", _responseString);
        
        // URL Decode
        NSLog(@"decoded string :\n%@", decodedString);
#endif
		
		
		NSRange aData = [decodedString rangeOfString:@"_error_cd"];
		_responseData = nil;
		
		if (aData.length > 0){
			//평문 에러 처리를 위한 delegate
			if (self.delegate && [self.delegate respondsToSelector:@selector(returnResult:errorCode:errorMessage:)]) {
				[self.delegate returnResult:decodedString errorCode:0 errorMessage:@""];
			}
			return;
		}
		
		//전문 결과 처리
		if (self.delegate && [self.delegate respondsToSelector:@selector(returnResult:errorCode:errorMessage:)]) {
			[self.delegate returnResult:decodedString errorCode:0 errorMessage:@""];
		}
		
	} else {
		//2010-04-15 서버통신오류는 Action을 1002로 네보내면 안됨. 로그아웃은 안됨.
		if (self.delegate && [self.delegate respondsToSelector:@selector(returnResult:errorCode:errorMessage:)]) {
			[self.delegate returnResult:@"" errorCode:1004 errorMessage:[NSString stringWithFormat:@"통신중 오류가 발생 하였습니다.[%d]", _statusCode]];
			return;
		}
	}
}

@end



@implementation SecurityManager
@synthesize handler;
@synthesize serverTime		= _serverTime;
@synthesize gateWayAddress	= _gateWayAddress;
@synthesize sessionTimeOut	= _sessionTimeOut;
@synthesize	isStartSessionCheck = _isStartSessionCheck;

static SecurityManager				*securityMgr		= nil;
static NSString						*_udid				= nil;
static NSTimer						*_sessionTimer		= nil;

+ (SecurityManager *)sharedSecurityManager{
	if (securityMgr == nil) {
		securityMgr				= [[SecurityManager alloc] init];
        
		//user-agent 의 기본값을 만들자.
		_udid					= @"";//[[[UIDevice currentDevice] uniqueIdentifier] copy];
	}
	
	return securityMgr;
}


- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super initWithCoder:decoder]) {
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
		handler = [[SecurityHandler alloc] init];
		handler.web = self;
        super.delegate = handler;
		_isStartSessionCheck		= NO;
		
		_serverTime				= nil;
		_sessionTimeOut			= 10;
		_gateWayAddress		= [[NSString stringWithFormat:@"%@", [SessionManager sharedSessionManager].gateWayUrl] copy];
	}
	
    return self;
}


- (void)dealloc{
	self.delegate = nil;
    
	if (!handler) {
		handler.delegate = nil;
		[handler release];
	}
	
	if (_gateWayAddress) {
		[_gateWayAddress release];
	}
	[super dealloc];
}


- (void)setDelegate:(id)aDelegate{
	if (handler) {
		[super setDelegate:handler];
		handler.delegate = aDelegate;
	}
}


- (id)delegate{
	return [handler delegate];
}


- (void)OnTimer:(NSTimer *)timer {
	handler.localsessionTime += 10;
    
	if (((86400) <= handler.localsessionTime) && (_isStartSessionCheck == YES)) {
		//Notificaition 처리 하고 나오자.
		[_sessionTimer invalidate];
		[_sessionTimer release];
		_sessionTimer = nil;
        
		[[NSNotificationCenter defaultCenter] postNotificationName: kSessionTimeOutNotification object: nil];
	}
}


- (void)startCheckSession {
	if (_isStartSessionCheck == YES) {
		handler.localsessionTime = 0;
		return;
	}
	
	_sessionTimer				= [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(OnTimer:) userInfo:nil repeats:YES] retain];
	_isStartSessionCheck			= YES;
}


- (void)stopCheckSession {
	handler.localsessionTime	= 0;
	_isStartSessionCheck			= NO;
}


#pragma mark -
#pragma mark _secrityManager function implementation
#pragma mark -
- (BOOL)willConnect:(NSString *)url query:(NSString *)query method:(NSInteger)method {
	if (handler.connection)
		return NO;
    
#if _DEBUG_
	NSLog(@"URL[%@]query[%@]", url, query);
#endif
    
	//2010년 4월 7일
    //handler.url			= [NSString stringWithFormat:@"%@%@", _SM_GATEWAY_URL, _SM_GATEWAY_PATH];
    
    if (url == nil) {
        
        handler.url			= [NSString stringWithFormat:@"%@%@?", _SM_GATEWAY_URL, _SM_GATEWAY_PATH];
        query = [NSString stringWithFormat:@"master_id=%@", MasterID];
    } else {
        
        handler.url			= [SessionManager sharedSessionManager].gateWayUrl;
        query = [[[[[NSString stringWithFormat:@"JSONData=%@", query] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"&" withString:@"%26"] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    }
    
    //query = [[[[NSString stringWithFormat:@"JSONData=%@", query] stringByAddingPercentEscapesUsingEncoding:-2147481280] stringByReplacingOccurrencesOfString:@"&" withString:@"%26"] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//    query = [[[[[NSString stringWithFormat:@"JSONData=%@", query] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"&" withString:@"%26"] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    
	handler.method		= method;
	
	[handler sendTransaction:query];
    
	return YES;
}


- (BOOL)isCanCancel{
	return handler.isCanCancel;
}


- (void)cancelTransaction{
	if (self.handler.connection) {
		[self.handler cancel];
	}
}


-(NSInteger)getCurrentSessionTime{
	if (_isStartSessionCheck) {
		return handler.localsessionTime;
	}
	return -1;
}


@end