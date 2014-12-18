//
//  StrUtils.h
//  StrUtils
//
//  Created by 종욱 윤 on 10. 5. 12..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
enum  {
	ALGORITHM_AES256 = 0,
	ALGORITHM_AES128,
	ALGORITHM_AES256WITHMD5
};
typedef NSUInteger CRYPTO_ALPORITHM;



/////////////////////////////////////////////////////////////////////////////////////////////
/** @brief Defines a concrete @c StrUtils which String utility functions.
 
 @c StrUtils는 애플의 NSString관련한 편의 함수들을 Wrapping하여 개발측에 편의를 제공하는 함수들 이다.
 
 암호화 알고리즘을 위해 NSData+AES256.h를 include해야 함.
 더 많은 부분은 프로젝트 진행시 계속적으로 처리 할수 있게 들어갈 예정이다. 형태틑 NSString의 카테고리이다.
 
 */
@interface NSString (StrUtils)



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 Trim 처리 함수.
 
 NSString의 Trim 처리 함수로 내부적으로는 stringByTrimmingCharactersInSet을 이용하여 whitespaceCharacterSet를 처리한다.

 @return Returns			@c NSString로 Trim이 된 스트링을 반환 한다.
 */
- (NSString *)trim;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 AlphaNumeric인지를 구분한다.
 
 NSString의 상의 숫자로만 이루어져 있는지를 구분하는 함수이다.
 
 @return Returns			@c YES AlphaNumeric @c NO 문자내에 숫자이외의 문자 포함이다.
 */
- (BOOL)isAlphaNumeric;


/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 SpecialCharacter인지를 구분한다.
 
 NSString의 상의 특수문자 포함되어 있는지를 구분하는 함수이다.
 
 @return Returns			@c YES 특수문자 미포함 @c NO 문자내에 특수문자 포함이다.
 */
- (BOOL)isntSpecialCharacter;


/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 AlphaNumeric을 금액형태로 변환해 준다.
 
 NSString의 상의 숫자로만 이루어져 있는지를 구분하는 함수이다.
 
 @return Returns			@c NSString로 금액포멧 형태의 String
 */
- (NSString *)setCurrencyFormat;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 Float을 금액형태로 변환해 준다.
 
 NSString의 상의 숫자로만 이루어져 있는지를 구분하는 함수이다.
 
 @return Returns			@c NSString로 금액포멧 형태의 String
 */
- (NSString *)setCurrencyFloatFormat;





/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 Float을 금액형태로 변환해 준다.
 
 NSString의 상의 숫자로만 이루어져 있는지를 구분하는 함수이다.
 
 @return Returns			@c NSString로 숫자형태의 String
 */
- (NSString *)setNumberFloatFormat;


/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 sha1 해쉬해주는 함수이다.
 
 NSString의 상의 문자열을 sha1 해쉬 해주는 함수.
 
 @return Returns			@c NSString로 160bit(20Byte)의 문자열로 반환,
 */
- (NSString *)sha1String;





/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 sha1 해쉬후 Base64로 인코딩 함수.
 
 NSString의 상의 문자열을 sha1 해쉬 해주는 후 Base64로 인코딩 반환.
 
 @return Returns			@c NSString 문자열로 반환,
 */
- (NSString *)sha1EncodeBase64String;






/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 sha256 해쉬해주는 함수이다.
 
 NSString의 상의 문자열을 sha256 해쉬 해주는 함수.
 
 @return Returns			@c NSString로 256bit(32Byte)의 문자열로 반환,
 */
- (NSString *)sha256String;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 sha256 해쉬후 Base64로 인코딩 함수.
 
 NSString의 상의 문자열을 sha256 해쉬 해주는 후 Base64로 인코딩 반환.
 
 @return Returns			@c NSString 문자열로 반환,
 */
- (NSString *)sha256EncodeBase64String;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 sha512 해쉬해주는 함수이다.
 
 NSString의 상의 문자열을 sha512 해쉬 해주는 함수.
 
 @return Returns			@c NSString로 512bit(64Byte)의 문자열로 반환,
 */
- (NSString *)sha512String;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 sha256 해쉬후 Base64로 인코딩 함수.
 
 NSString의 상의 문자열을 sha512 해쉬 해주는 후 Base64로 인코딩 반환.
 
 @return Returns			@c NSString 문자열로 반환,
 */
- (NSString *)sha512EncodeBase64String;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 md5 해쉬해주는 함수이다.
 
 NSString의 상의 문자열을 md5 해쉬 해주는 함수.
 
 @return Returns			@c NSString로 128bit(16Byte)의 문자열로 반환,
 */
- (NSString *)md5String;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 Base64Encoding 함수
 
 NSString의 상의 문자열을 Base64Encoding 처리
 
 @param plainString			@c NSString 평문
 @return Returns			@c NSString 로 Base64의 문자열로 반환,
 */
- (NSString *)base64EncodeWithString:(NSString *)plainString;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSData의 값을 Base64Encoding 함수
 
 NSData 상의 값을 Base64Encoding 처리
 
 @param plainData			@c NSData 평문 NSData
 @return Returns			@c NSString로 Base64의 문자열로 반환,
 */
- (NSString *)base64EncodeWithData:(NSData *)plainData;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 Base64 값을 Decoding 함수
 
 NSString의 Base64 값을 평문을 Decoding 함수
 
 @param Base64String		@c NSString Base64인코딩된 값
 @return Returns			@c NSString로 평문 문자열로 반환,
 */
- (NSString *)base64DecodeWithString:(NSString *)Base64String;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 Base64 값을 Decoding 하여 NSData로 변환 함수
 
 NSString의 상의 문자열을 md5 해쉬 해주는 함수.
 
 @param Base64String		@c NSString Base64인코딩된 값
 @return Returns			@c NSData로 Decoding한 값 반환,
 */
- (NSData *)base64DecodeData:(NSString *)Base64String;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 문자열을 AES256 암호화 알고리즘을 통해 문자열을 암호화 하고 해당 경로에 파일로 저장하는 함수.
 
 NSString의 문자열을 AES256 암호화 알고리즘을 통해 문자열을 암호화 하고 해당 경로에 파일로 저장하는 함수.
 
 @param path				저장파일 경로
 @return Returns			@c YES 암호화 파일 저장성공 @c NO 암호화 파일 저장실패
 @see decryptFromFile:
 */
- (BOOL)encryptToFile:(NSString *)path;



/////////////////////////////////////////////////////////////////////////////////////////////
/** 해당경로 파일 내에 있는 암호화(AES256)내용을 복호화 하여 문자열로 반환 하는 함수.
 
 해당경로 파일 내에 있는 암호화(AES256)내용을 복호화 하여 문자열로 반환 하는 함수. 암호화 키는 m파일내부 
 Static 변수로 선언되어 있음.
 
 @param path				불러올파일
 @return Returns			@c NSString 복호화된 내용을 담고 있음.
 @see encryptToFile:
 */
+ (NSString *)decryptFromFile:(NSString *)path;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 암호화 알고리즘의 암호화로 암호화 하는 함수
 
 해당경로 파일 내에 있는 암호화(AES256)내용을 복호화 하여 문자열로 반환 하는 함수. 암호화 키는 m파일내부 
 Static 변수로 선언되어 있음.
 
 @param algorithm			CRYPTO_ALPORITH으로 해당 암호화 알고리즘으로 암호화
 @param key					@c NSString 암호화 키
 @return Returns			@c NSString 암호화된 데이터(BASE64로 인코딩 되어 있음.
 */
- (NSString *)encryptAlgorithmFromKey:(CRYPTO_ALPORITHM)algorithm key:(NSString *)Key;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 값을 암호화 알고리즘의 복호화로 암호화 하는 함수
 
 해당경로 파일 내에 있는 암호화(AES256)내용을 복호화 하여 문자열로 반환 하는 함수. 암호화 키는 m파일내부 
 Static 변수로 선언되어 있음.
 
 @param algorithm			CRYPTO_ALPORITH으로 해당 암호화 알고리즘으로 암호화
 @param key					@c NSString 암호화 키
 @return Returns			@c NSString 복호화된 데이터
 */
- (NSString *)decryptAlgorithmFromKey:(CRYPTO_ALPORITHM)algorithm key:(NSString *)Key;



/////////////////////////////////////////////////////////////////////////////////////////////
// 우리은행이전 지원함수 2011년 4월 6일 htjulia
////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)writeToEncrytionFile_AES256:(NSString*)path;
+ (NSString *)stringWithEncrytionFile_AES256:(NSString *)path;


/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString 내의 문자열(포멧이 csv일 경우)을 NSArray형태로 Row, column으로 전환 해주는 함수
 
 NSString 내의 문자열(포멧이 csv일 경우)을 NSArray형태로 Row, column으로 전환 해주는 함수로 NSScanner를
 통해 Parsing하고 처리 한다. 다만 대량의 경우는 NSString객체 이용 외에 char로 처리 하는 알고리즘을 사용 하는것이
 더욱 좋다 하지만 단순 csv의 파싱은 NSString 카테고리내의 함수를 사용 하는게 편의성을 도모 한다.
 
 @return Returns @c NSArray csv String parsing
 */

- (NSArray *)csvRows;

/////////////////////////////////////////////////////////////////////////////////////////////
/** NSString의 가로나 세로의 길이를 계산해주는 함수. 만일 string의 길이가 길거나 2줄이상일 경우 높이의 길이까지
 계산해서 return값으로 넘겨준다.

 @return height or width of string of the text
 */


- (CGFloat)measureTextHeight:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize constrainedToSize:(CGSize)constrainedToSize; 

@end
