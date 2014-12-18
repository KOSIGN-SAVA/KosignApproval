//
//  SysUtils.h
//  SysUtils
//
//  Created by 종욱 윤 on 10. 5. 12..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief Defines a concrete @c SysUtils which String utility functions.
 
 @c SysUtils는 개발에 필요한 시스템 적인 정보 및 관련 함수를 내장 하고 있습니다.
 */
@interface SysUtils : NSObject


// 게이트웨이 주소를 포함하여 실제 이미지의 URL 주소를 보내주는 함수
+ (NSURL *)getRealImageURL:(NSString *)url;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString 형의 값을 Null값 체크 후 Null값이면 빈스트링을 보내는 함수
 
 @param obj					nil체크할 NSString 형의 객체
 @return Returns			@c sender @c @"" 둘 다 assign 값이긴 하나 nsstring not mutable이기에 값은 변화가 없다
 */
+ (NSString *)isNullCheckAndReturnString:(NSString *)sender;

/////////////////////////////////////////////////////////////////////////////////////////////
/** id 형의 모든 Object의 nil값 체크 함수
 
 @param obj					nil체크할 객체
 @return Returns			@c YES nil @c NO assign
 */
+ (BOOL)isNull:(id) obj;


////////////////////////////////////////////////////////////////////////////////
// -가 없는 전화번호를 넣으면 -이 있는 스트링을 보내는 함수
// 예) 027841690 => 02-784-1690
////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getHyphenPhonNumber:(NSString *)sender;


/////////////////////////////////////////////////////////////////////////////////////////////
/** 테이블뷰 위의 버튼의 인덱스를 빼오기위한 함수
 
 @param tableView   테이블뷰
 @param aComponent  해당 셀의 컴포넌트
 
 @return        NSIndexPath
 **/
+ (NSIndexPath *)getIndexForTableViewCellComPonent:(id)aComponent inTableView:(UITableView *)tableView;

/////////////////////////////////////////////////////////////////////////////////////////////
/** NSLog및 로그의 기록 및 console print등으로 활장하기 위한 함수로 현재는 사용되어지고 있지않음.
 
 
 @param format				format string
 @param ....				argument
 */
+ (void)writeLogWithFormat:(NSString *) format, ...;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSLog및 로그의 기록 및 console print등으로 활장하기 위한 함수로 현재는 사용되어지고 있지않음.
 
 
 @param message				log string
 */
+ (void)writeLog:(NSString *) message;



/////////////////////////////////////////////////////////////////////////////////////////////
/** CGFrame의 로그를 쉽게 기록하기 위한 함수.
 
 
 @param rect				@c CGRect
 */
+ (void)writeLogFrame:(CGRect)rect;



/////////////////////////////////////////////////////////////////////////////////////////////
/** Documents폴더의 풀 경로를 구해서 파일경로까지 구하는 함수
 
 
 @param filename			@c 파일이름
 @return Returns			@c NSString full file path return
 
 */
+ (NSString *)filenameFromDocDir:(NSString *) filename;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 이미지 코드를 변환 하여 이미지 파일 이름을 구해 주는 함수로 웹케시 이미지코드화 기반으로 이루어진 함수.
 
 
 @param imgCode				imgCode
 @return Returns			@c NSString 실제파일이름.
 
 */
+ (NSString *)imageCodeToFileName:(NSString *)imgCode;



+ (NSString *)skinedImageCodeToFileName:(NSString *)imgCode skinType:(NSInteger)skinType;
/////////////////////////////////////////////////////////////////////////////////////////////
/** integer형을 String으로 변환 편의 함수.
 
 
 @param value				integer형 값
 @return Returns			@c NSString value.
 @see doubleToString:
 @see doubleToIntString:
 @see boolToString:
 */
+ (NSString *)integerToString:(NSInteger) value;



/////////////////////////////////////////////////////////////////////////////////////////////
/** Dobule형을 String으로 변환 편의 함수
 
 
 @param value				double형 값
 @return Returns			@c NSString value.
 @see integerToString:
 @see doubleToIntString:
 @see boolToString:
 
 */
+ (NSString *)doubleToString:(double) value;



/////////////////////////////////////////////////////////////////////////////////////////////
/** Dobule형을 integer 영역 String으로 변환 편의 함수
 
 
 @param value				double형 값
 @return Returns			@c NSString value.
 @see integerToString:
 @see doubleToString:
 @see boolToString:
 */
+ (NSString *)doubleToIntString:(double) value;



/////////////////////////////////////////////////////////////////////////////////////////////
/** Boolean형을 String으로 변환 편의 함수
 
 
 @param value				Boolean형 값
 @return Returns			@c NSString value.
 @see integerToString:
 @see doubleToString:
 @see doubleToIntString:
 */
+ (NSString *)boolToString:(BOOL) value;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString형의 Date를 NSDate로 변환 편의 함수
 
 
 @param stringDate			@c NSString 날자형 문자열 값
 @param fmt					@c NSString 날자형 포멧으로 포멧이 없을 경우 "yyyyMMddHHmmss"기본형으로 변환
 @return Returns			@c NSDate value.
 @see dateToString:format
 @see boolToString:
 */
+ (NSDate *)stringToDate:(NSString *)stringDate dateFormat:(NSString *)fmt;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate형을 NSString로 변환 편의 함수
 
 
 @param date				@c NSDate 날자형 문자열 값
 @param format				@c NSString 날자형 포멧으로 포멧이 없을 경우 "yyyyMMddHHmmss"기본형으로 변환
 @return Returns			@c NSString value.
 @see stringToDate:fmt
 */
+ (NSString *)dateToString:(NSDate *)date dateFormat:(NSString *)format;




/////////////////////////////////////////////////////////////////////////////////////////////
/** UIController의 실제 파일 이름으로 현재 뷰를 로딩 할 수 있게 하는 함수.
 내부적으로는 Bundle 내부의 파일을 찾아 Class로 로딩 하고 함수의 Parameter는 objc_msgSend을 통해 전달 하는 구조
 이 함수를 사용 시 해당 뷰의 header include 없이 사용 할 수 있는 구조로 소스간 접점을 최소화 할 수 있다.
 
 
 @param ctrlName			@c NSString UIViewController의 실제 파일명
 @param action				@c SEL		UIViewController Public 함수 호출
 @param paramCount			@c NSNumber	함수의 인자 갯수
 @param ....				arugment 리스트로 va_list 구조
 @return Returns			@c UIViewController 해당 Class리턴.
 @see OpenWithStringAndNumber:action:value:
 @see OpenWithStringAndDictionary:action:dicData:
 */
//+ (UIViewController *)openWithString:(NSString *)ctrlName action:(SEL)action paramCount:(NSNumber *)paramCount, ...NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
+ (UIViewController *)openWithString:(NSString *)ctrlName action:(SEL)action paramCount:(NSNumber *)paramCount, ...;


/////////////////////////////////////////////////////////////////////////////////////////////
/** UIController의 실제 파일 이름으로 현재 뷰를 로딩 할 수 있게 하는 함수.
 내부적으로는 Bundle 내부의 파일을 찾아 Class로 로딩 하고 함수의 Parameter는 objc_msgSend을 통해 전달 하는 구조
 이 함수를 사용 시 해당 뷰의 header include 없이 사용 할 수 있는 구조로 소스간 접점을 최소화 할 수 있다.
 
 
 @param ctrlName			@c NSString UIViewController의 실제 파일명
 @param action				@c SEL		UIViewController Public 함수 호출
 @param paramCount			@c NSNumber	함수의 인자 갯수
 @param ....				arugment 리스트로 va_list 구조
 @return Returns			@c UIViewController 해당 Class리턴.
 @see OpenWithStringAndNumber:action:value:
 @see OpenWithStringAndDictionary:action:dicData:
 */
+ (UIViewController *)openWithStringVarParam:(NSString *)ctrlName action:(SEL)action, ... NS_REQUIRES_NIL_TERMINATION;



/////////////////////////////////////////////////////////////////////////////////////////////
/** UIController의 실제 파일 이름으로 현재 뷰를 로딩 할 수 있게 하는 함수.
 내부적으로는 Bundle 내부의 파일을 찾아 Class로 로딩 하고 함수의 Parameter는 objc_msgSend을 통해 전달 하는 구조
 이 함수를 사용 시 해당 뷰의 header include 없이 사용 할 수 있는 구조로 소스간 접점을 최소화 할 수 있다.
 
 
 @param ctrlName			@c NSString UIViewController의 실제 파일명
 @param action				@c SEL		UIViewController Public 함수 호출
 @param value				@c NSNumber	action의 인자 NSNumber의 값을 전달
 @return Returns			@c UIViewController 해당 Class리턴.
 @see OpenWithString:action:paramCount:
 @see OpenWithStringAndDictionary:action:dicData:
 */
+ (UIViewController *)openWithStringAndNumber:(NSString *)ctrlName action:(SEL)action value:(NSNumber *)value NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);



/////////////////////////////////////////////////////////////////////////////////////////////
/** UIController의 실제 파일 이름으로 현재 뷰를 로딩 할 수 있게 하는 함수.
 내부적으로는 Bundle 내부의 파일을 찾아 Class로 로딩 하고 함수의 Parameter는 objc_msgSend을 통해 전달 하는 구조
 이 함수를 사용 시 해당 뷰의 header include 없이 사용 할 수 있는 구조로 소스간 접점을 최소화 할 수 있다.
 nㅇ
 
 @param ctrlName			@c NSString UIViewController의 실제 파일명
 @param action				@c SEL		UIViewController Public 함수 호출
 @param dicData				@c NSDictionary	action의 인자 NSDictionary의 값을 전달
 @return Returns			@c UIViewController 해당 Class리턴.
 @see OpenWithString:action:paramCount:
 @see OpenWithStringAndNumber:action:value:
 */
+ (UIViewController *)openWithStringAndDictionary:(NSString *)ctrlName action:(SEL)action dicData:(NSDictionary *)dicData;
//NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);



/////////////////////////////////////////////////////////////////////////////////////////////
/** UIAlertview를 간략히 사용 위함 함수
 
 
 @param aMsg					@c NSString 전달 메세지
 @see showMessageWithOwner:owner:tag:
 */
+ (void)showMessage:(NSString *)aMsg;



/////////////////////////////////////////////////////////////////////////////////////////////
/** UIAlertview를 간략히 사용 위함 함수
 
 
 @param aMsg				@c NSString 전달 메세지
 @param aOwner				@c id 부모의 객체
 @see showMessageWithOwner:owner:tag:
 */
+ (void)showMessageWithOwner:(NSString *)aMsg owner:(id)aOwner;



/////////////////////////////////////////////////////////////////////////////////////////////
/** UIAlertview를 간략히 사용 위함 함수
 
 
 @param aMsg				@c NSString 전달 메세지
 @param aOwner				@c id 부모의 객체
 @param aTag				@c NSInteger UIAlertView가 사용할 tag
 @see showMessageWithOwner:owner:
 */
+ (void)showMessageWithOwner:(NSString *)aMsg owner:(id)aOwner tag:(NSInteger)aTag;

/////////////////////////////////////////////////////////////////////////////////////////////
/** integer값의 해당 10진수 값중 10의 몫만 남기는 함수
 
 
 @param targetNumber		@c NSInteger 처리 할 값
 @return Returns			@c NSInteger value.
 */
+ (NSInteger)ceilMostSignificantDigit:(NSInteger)targetNumber;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당 기기의 IP Address를 구하는 함수 이다. 현재 지원은 wifi, 3G모두 구해온다.
 
 
 @return Returns			@c NSString IPAddress xxx.xxx.xxx.xxx .
 @see getCurrentMACAddress
 @see getCurrentUDID
 @see getDeviceModel
 @see getOSVersion
 */
+ (NSString *)getCurrentIPAddress;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당 기기의 MAC Address를 구하는 함수 이다. 현재 지원은 wifi, 3G모두 구해온다.
 
 
 @return Returns			@c NSString IPAddress xx:xx:xx:xx:xx:xx .
 @see getCurrentIPAddress
 @see getCurrentUDID
 @see getDeviceModel
 @see getOSVersion
 */
+ (NSString *)getCurrentMACAddress;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당 기기의 UDID를 구하는 함수 이다. UIDevice의 편의 함수
 
 
 @return Returns			@c NSString UDID .
 @see getCurrentIPAddress
 @see getCurrentMACAddress
 @see getDeviceModel
 @see getOSVersion
 */
+ (NSString	*)getCurrentUDID;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당 기기의  모델을 구하는 함수 이다. UIDevice의 편의 함수
 
 
 @return Returns			@c NSString Model.
 @see getCurrentIPAddress
 @see getCurrentMACAddress
 @see getCurrentUDID
 @see getOSVersion
 */
+ (NSString *)getDeviceModel;


/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당 기기의 OS 버전을 구하는 함수 이다. UIDevice의 편의 함수
 
 
 @return Returns			@c NSInteger OS version.
 @see getCurrentIPAddress
 @see getCurrentMACAddress
 @see getCurrentUDID
 @see getDeviceModel
 */
+ (NSInteger)getOSVersion;


/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당 기기의  모델 버전을 구하는 함수 이다. UIDevice의 편의 함수
 
 
 @return Returns			@c NSInteger Device Version
 */
+ (NSInteger)getDeviceVersion;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 현재 내트웍의 상태를 구한다.
 
 
 @return Returns			@c NetworkStatus 3G, wifi None 등.
 */
+ (NetworkStatus)getCurrentNetworkStatus;



/////////////////////////////////////////////////////////////////////////////////////////////
/** urlScheme를 이용한 타 어플리게이션 실행
 
 
 @param urlScheme			@c NSInteger 타 Application의 URLScheme
 @return Returns			@c Bool  @c YES success @c NO fail.
 @see canExecuteApplication:
 */
+ (BOOL)applicationExecute:(NSString *)urlScheme;



/////////////////////////////////////////////////////////////////////////////////////////////
/** urlScheme를 이용한 타 어플리게이션 실행 할 수 있는 여부의 함수
 
 
 @param urlScheme			@c NSInteger 타 Application의 URLScheme
 @return Returns			@c Bool  @c YES can execute @c can't execute.
 @see applicationExecute:
 */
+ (BOOL)canExecuteApplication:(NSString *)urlScheme;


/////////////////////////////////////////////////////////////////////////////////////////////
/** 문자열로 된 버전을 Integer형으로 변환하여 반환한다. (예: 2.0.3 --> 203)
 
 
 @param aVersion			@c NSString 문자열로 된 버전 정보
 @return					@c NSInteger @c Integer형으로 변환된 버전 정보
 */
+ (NSInteger)versionToInteger:(NSString *)aVersion;

+ (BOOL)findAndResignFirstResponder:(UIView *)aView;

+ (NSString *)nullToVoid:(NSString *)aSource;

+ (void)popViewControllerWithTag:(UIViewController *)view tag:(NSInteger)tag;

+ (BOOL)isPad;

+ (UIColor *)stringToColor:(NSString *)aHexDecimal;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당 기기의 전화 기능 여부를 리턴한다.
 
 
 @return Returns			@c BOOL Phone Call Flag
 */
+ (BOOL)checkPhoneCall;

/////////////////////////////////////////////////////////////////////////////////////////////
/** md5로 암호화시키는 함수
 
 해당 타이틀 뷰에 폰트 및 색상 그리고 뷰를 Assign하여 처리 하는 함수 입니다.
 
 @return Returns			@c NSInteger OS version.
 */


+ (NSString *)md5String:(NSString*)userID:(NSString*)currentTime;
/////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////
/** md5로 암호화시키는 함수
 
 해당 타이틀 뷰에 폰트 및 색상 그리고 뷰를 Assign하여 처리 하는 함수 입니다.
 
 @return Returns			@c NSInteger OS version.
 */


+ (NSString *)tempMd5String:(NSString*)testString;
/////////////////////////////////////////////////////////////////////////////////////////////

+ (NSData *)md5tem:(NSString *)mD5;
//+ (char *)MD5;

@end
