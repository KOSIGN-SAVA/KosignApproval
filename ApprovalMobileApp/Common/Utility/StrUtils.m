//
//  StrUtils.m
//  StrUtils
//
//  Created by 종욱 윤 on 10. 5. 12..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "StrUtils.h"
#import "SysUtils.h"
#import "NSData+AES256.h"
#import "Constants.h"


@implementation NSString (StrUtils)

#define ArrayLength(x) (sizeof(x)/sizeof(*(x)))
static char encodingTable[]				= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const NSString *KeyPrefix		= @"BizplayKey";
static const NSString *KEY_PREFIX_VALUE	= @"BizplayKey"; //우리은행 키로 이 부분이 있어야 암호화를 풀수 있다.




#pragma mark --
#pragma mark private function
#pragma mark --
+ (NSString *)getEncryptKey {
	NSString *encKey = [KeyPrefix stringByAppendingString:@"BizplayKey"];
	return [encKey sha512String];
}


/*
    BASE64 Encode Byte Calcurate
    Base64 Size = (BYTE+2((BYTE+2)MOD3))/3*4 
*/

- (NSString *)encode:(const uint8_t*)input length:(NSInteger)length {
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
			
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
		
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    encodingTable[(value >> 18) & 0x3F];
        output[index + 1] =                    encodingTable[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? encodingTable[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? encodingTable[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[[NSString alloc] initWithData:data
                                  encoding:NSASCIIStringEncoding] autorelease];
}


- (NSData *)decode:(const char*)string length:(NSInteger)inputLength {
	if ((string == NULL) || (inputLength % 4 != 0)) {
		return nil;
	}
	
	static char decodingTable[128];
	
	memset(decodingTable, 0, ArrayLength(decodingTable));
	for (NSInteger i = 0; i < ArrayLength(encodingTable); i++) {
		decodingTable[encodingTable[i]] = i;
	}
	
	while (inputLength > 0 && string[inputLength - 1] == '=') {
		inputLength--;
	}
	
	NSInteger outputLength = inputLength * 3 / 4;
	NSMutableData* data = [NSMutableData dataWithLength:outputLength];
	uint8_t* output = data.mutableBytes;
	
	NSInteger inputPoint = 0;
	NSInteger outputPoint = 0;
	while (inputPoint < inputLength) {
		char i0 = string[inputPoint++];
		char i1 = string[inputPoint++];
		char i2 = inputPoint < inputLength ? string[inputPoint++] : 'A'; /* 'A' will decode to \0 */
		char i3 = inputPoint < inputLength ? string[inputPoint++] : 'A';
		
		output[outputPoint++] = (decodingTable[i0] << 2) | (decodingTable[i1] >> 4);
		if (outputPoint < outputLength) {
			output[outputPoint++] = ((decodingTable[i1] & 0xf) << 4) | (decodingTable[i2] >> 2);
		}
		if (outputPoint < outputLength) {
			output[outputPoint++] = ((decodingTable[i2] & 0x3) << 6) | decodingTable[i3];
		}
	}
	
	return data;
}


+ (NSString *)getEncryptionKey {
	NSString *key = [KEY_PREFIX_VALUE stringByAppendingString:@"BizplayKey"];
	return [key sha512String];
}


- (BOOL)writeToEncrytionFile_AES256:(NSString *)path {
	NSData *encData = [[NSData alloc] encryptStringToData:self withKey:[NSString getEncryptionKey]];
	return [encData writeToFile:path atomically:NO];
}


+ (NSString *)stringWithEncrytionFile_AES256:(NSString *)path {
	NSData *encData = [NSData dataWithContentsOfFile:path];
	return [encData decryptDataToString:encData withKey:[NSString getEncryptionKey]];
}



#pragma mark --
#pragma mark public function
#pragma mark --
- (NSString *)trim {
	return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


- (BOOL)isAlphaNumeric {
	if ([SysUtils isNull:self])
		return NO;
	
	int charCode = 0;
	
	for (int i = 0; i < [self length]; i++) {
		charCode = (int)[self characterAtIndex:i];
		
		// 첫 자리가 "-"이면 음수로 간주해서 허용한다.
		if ((i == 0) && (charCode == 45))
			continue;
		
		// 0 ~ 9까지의 숫자 체크
		if ((charCode >= 48) && (charCode <= 57))
			continue;
		
		// A ~ Z까지의 대문자 체크
		if ((charCode >= 65) && (charCode <= 90))
			continue;
		
		// a ~ z까지의 소문자 체크
		if ((charCode >= 97) && (charCode <= 122))
			continue;
		
		return NO;
	}
	
	return YES;
}



- (BOOL)isntSpecialCharacter {
	if ([SysUtils isNull:self])
		return NO;
	
	NSInteger charCode = 0;
	
	for (NSInteger i = 0; i < [self length]; i++) {
		charCode = (int)[self characterAtIndex:i];
		
		// 0 ~ 39까지의 시스템 명령 코드와 특수 기호들은 허용하지 않는다.
		if (charCode < 40)
			return NO;
		
		if (((charCode >= 40) && (charCode <= 127)) || ((charCode >= 44032) && (charCode <= 55203))) {
			// ":", ";", "?"는 허용하지 않는다.
			switch (charCode) {
				case 58:
				case 59:
				case 63:
				case 127:
					return NO;
			}
		} else 
			return NO;
	}
	
	return YES;
}


- (NSString *)setCurrencyFormat {
	NSNumberFormatter *numFormat = [[[NSNumberFormatter alloc] init] autorelease];
	[numFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSLocale *krLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_kr"];
	[numFormat setLocale:krLocale];
	[krLocale release];
	
	return [numFormat stringFromNumber:[NSNumber numberWithLongLong:[self longLongValue]]];
}


- (NSString *)setCurrencyFloatFormat {
	NSNumberFormatter *numFormat = [[[NSNumberFormatter alloc] init] autorelease];
	[numFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numFormat setNumberStyle:NSNumberFormatterDecimalStyle];

	NSLocale *krLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_kr"];
	[numFormat setLocale:krLocale];
	[krLocale release];
	
	NSRange floatRange = [self rangeOfString:@"."];
	NSString *floatString = @"";
	
	if (floatRange.location != NSNotFound) {
		floatRange.length = [self length] - floatRange.location;
		
		if (floatRange.length > 0){
			floatRange.location;
			floatString = [self substringWithRange:floatRange];
		}	
	}
	
	
	return [NSString stringWithFormat:@"%@%@", [numFormat stringFromNumber:[NSNumber numberWithLongLong:[self longLongValue]]], floatString];
}


- (NSString *)setNumberFloatFormat {
	NSNumberFormatter *numFormat = [[[NSNumberFormatter alloc] init] autorelease];

	NSRange floatRange = [self rangeOfString:@"."];
	NSString *floatString = @"";
	
	if (floatRange.location != NSNotFound) {
		floatRange.length = [self length] - floatRange.location;
		
		if (floatRange.length > 0){
			floatRange.location;
			floatString = [self substringWithRange:floatRange];
		}	
	}
	
	
	return [NSString stringWithFormat:@"%@%@", [numFormat stringFromNumber:[NSNumber numberWithLongLong:[self longLongValue]]], floatString];
}


- (NSString *)sha1String {
	if ([SysUtils isNull:self] == YES)
		return nil;
	
	const char *cStr = [self UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(cStr, strlen(cStr), result);
	
	NSString *resultStr = [[[NSString alloc] init] autorelease];
	
	for (NSInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		resultStr = [resultStr stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%02X", result[i]]];
	
	return resultStr;
}


- (NSString *)sha1EncodeBase64String {
	if ([SysUtils isNull:self] == YES)
		return nil;
	
	const char *cStr = [self UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(cStr, strlen(cStr), result);
    
    NSData* byteData = [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
    return [self base64EncodeWithData:byteData];
}


- (NSString *)sha256String {
	if ([SysUtils isNull:self] == YES)
		return nil;
	
	const char *cStr = [self UTF8String];
	unsigned char result[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256(cStr, strlen(cStr), result);
	
	NSString *resultStr = [[[NSString alloc] init] autorelease];
	
	for (NSInteger i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
		resultStr = [resultStr stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%02X", result[i]]];
	
	return resultStr;
}


- (NSString *)sha256EncodeBase64String {
	if ([SysUtils isNull:self] == YES)
		return nil;
	
	const char *cStr = [self UTF8String];
	unsigned char result[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256(cStr, strlen(cStr), result);
    
    
    NSData* byteData = [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
    return [self base64EncodeWithData:byteData];
}




- (NSString *)sha512String {
	if ([SysUtils isNull:self] == YES)
		return nil;
	
	const char *cStr = [self UTF8String];
	unsigned char result[CC_SHA512_DIGEST_LENGTH];
	CC_SHA512(cStr, strlen(cStr), result);
	
	NSString *resultStr = [[[NSString alloc] init] autorelease];
	
	for (NSInteger i = 0; i < 64; i++)
		resultStr = [resultStr stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%02X", result[i]]];
	
	return resultStr;
}


- (NSString *)sha512EncodeBase64String {
	if ([SysUtils isNull:self] == YES)
		return nil;
	
	const char *cStr = [self UTF8String];
	unsigned char result[CC_SHA512_DIGEST_LENGTH];
	CC_SHA512(cStr, strlen(cStr), result);
    
    
    NSData* byteData = [NSData dataWithBytes:result length:CC_SHA512_DIGEST_LENGTH];
    return [self base64EncodeWithData:byteData];
}



- (NSString *)md5String {
	if ([SysUtils isNull:self] == YES)
		return nil;

	const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result);
	
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}


- (NSString *)base64EncodeWithString:(NSString *)plainString{
	/*
	 static char decodingTable[128];
	 
	 memset(decodingTable, 0, ArrayLength(decodingTable));
	 for (NSInteger i = 0; i < ArrayLength(encodingTable); i++) {
	 decodingTable[encodingTable[i]] = i;
	 }
	 */
	NSData *aData = [plainString dataUsingEncoding: NSASCIIStringEncoding];
	return [self encode:(const uint8_t*) aData.bytes length:aData.length];
}


- (NSString *)base64EncodeWithData:(NSData *)plainData{
	return [self encode:(const uint8_t*) plainData.bytes length:plainData.length];
}


- (NSString *)base64DecodeWithString:(NSString *)Base64String{
	return [[[NSString alloc] initWithData:[self decode:[Base64String cStringUsingEncoding:NSASCIIStringEncoding] length:Base64String.length]encoding:NSUTF8StringEncoding] autorelease];
}


- (NSData *)base64DecodeData:(NSString *)Base64String{
	return [self decode:[Base64String cStringUsingEncoding:NSASCIIStringEncoding] length:Base64String.length];
}


- (BOOL)encryptToFile:(NSString *)path {
	NSData *encData = [[NSData alloc] encryptStringToData:self withKey:[NSString getEncryptKey]];
	return [encData writeToFile:path atomically:NO];
}


+ (NSString *)decryptFromFile:(NSString *)path {
	NSData *encData = [NSData dataWithContentsOfFile:path];
	return [encData decryptDataToString:encData withKey:[self getEncryptKey]];
}


- (NSString *)encryptAlgorithmFromKey:(CRYPTO_ALPORITHM)algorithm key:(NSString *)key{
	NSString *keyString = nil;
	NSData *encData		= nil;
	
	// 암호화 알고리듬별로 해당 암호화를 처리하자.
	switch (algorithm) {
		case ALGORITHM_AES256:
			if (!key || [key isEqualToString:@""]) 
				keyString = [[NSString getEncryptKey] substringToIndex:32];
			else
				keyString = [[key sha512String] substringToIndex:32];
			
#if TARGET_IPHONE_SIMULATOR
			NSLog(@"======================KEYDATA[%@] HASHDATA[%@]",key, keyString);		
#endif
			
			encData = [[NSData data] encryptStringToData:self withKey:keyString];
			break;

		case ALGORITHM_AES128:
			if (!key || [key isEqualToString:@""]) 
				keyString = [[NSString getEncryptKey] substringToIndex:16];
			else
				keyString = [[key sha512String] substringToIndex:16];
			
			
			encData = [[NSData data] encryptStringToDataAES128:self withKey:keyString];
			break;
			
		case ALGORITHM_AES256WITHMD5:
			if (!key || [key isEqualToString:@""]) 
				keyString = [[NSString getEncryptKey] substringToIndex:32];
			else
				keyString = [[key md5String] substringToIndex:32];
			
			
			encData = [[NSData data] encryptStringToData:self withKey:keyString];
			break;
	}
	
	return [self base64EncodeWithData:encData];
}


- (NSString *)decryptAlgorithmFromKey:(CRYPTO_ALPORITHM)algorithm key:(NSString *)key{
	NSString *keyString		= nil;
	NSString *returnString	= nil;
	NSData *encData			= [self base64DecodeData:self];
	
	
	switch (algorithm) {
		case ALGORITHM_AES256:
			if (!key || [key isEqualToString:@""]) 
				keyString = [[NSString getEncryptKey] substringToIndex:32];
			else
				keyString = [[key sha512String] substringToIndex:32];

			returnString = [encData decryptDataToString:encData withKey:keyString];

			break;

		case ALGORITHM_AES128:
			if (!key || [key isEqualToString:@""])
				keyString = [[NSString getEncryptKey] substringToIndex:16];
			else
				keyString = [[key sha512String] substringToIndex:16];
			
			returnString = [encData decryptDataToStringAES128:encData withKey:keyString];
			break;
			
		
		case ALGORITHM_AES256WITHMD5:
			if (!key || [key isEqualToString:@""]) 
				keyString = [[NSString getEncryptKey] substringToIndex:32];
			else
				keyString = [[key md5String] substringToIndex:32];
			
			returnString = [encData decryptDataToString:encData withKey:keyString];	

			break;
	}
	
	return returnString;
}


- (NSArray *)csvRows {
    NSMutableArray *rows = [NSMutableArray array];
	
    // Get newline character set
    NSMutableCharacterSet *newlineCharacterSet = (id)[NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [newlineCharacterSet formIntersectionWithCharacterSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];
	
    // Characters that are important to the parser
    NSMutableCharacterSet *importantCharactersSet = (id)[NSMutableCharacterSet characterSetWithCharactersInString:@",\""];
    [importantCharactersSet formUnionWithCharacterSet:newlineCharacterSet];
	
    // Create scanner, and scan string
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    while ( ![scanner isAtEnd] ) {        
        BOOL insideQuotes = NO;
        BOOL finishedRow = NO;
        NSMutableArray *columns = [NSMutableArray arrayWithCapacity:10];
        NSMutableString *currentColumn = [NSMutableString string];
        while ( !finishedRow ) {
            NSString *tempString;
            if ( [scanner scanUpToCharactersFromSet:importantCharactersSet intoString:&tempString] ) {
                [currentColumn appendString:tempString];
            }
			
            if ( [scanner isAtEnd] ) {
                if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
                finishedRow = YES;
            }
            else if ( [scanner scanCharactersFromSet:newlineCharacterSet intoString:&tempString] ) {
                if ( insideQuotes ) {
                    // Add line break to column text
                    [currentColumn appendString:tempString];
                }
                else {
                    // End of row
                    if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
                    finishedRow = YES;
                }
            }
            else if ( [scanner scanString:@"\"" intoString:NULL] ) {
                if ( insideQuotes && [scanner scanString:@"\"" intoString:NULL] ) {
                    // Replace double quotes with a single quote in the column string.
                    [currentColumn appendString:@"\""]; 
                }
                else {
                    // Start or end of a quoted string.
                    insideQuotes = !insideQuotes;
                }
            }
            else if ( [scanner scanString:@"," intoString:NULL] ) {  
                if ( insideQuotes ) {
                    [currentColumn appendString:@","];
                }
                else {
                    // This is a column separating comma
                    [columns addObject:currentColumn];
                    currentColumn = [NSMutableString string];
                    [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:NULL];
                }
            }
        }
        if ( [columns count] > 0 ) [rows addObject:columns];
    }
	
    return rows;
}

- (CGFloat)measureTextHeight:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize constrainedToSize:(CGSize)constrainedToSize {
//    CGSize mTempSize = [text sizeWithFont:[UIFont fontWithName:fontName size:fontSize] constrainedToSize:constrainedToSize lineBreakMode:UILineBreakModeWordWrap];
    CGSize mTempSize;
#ifdef IS_IOS_7_OR_LATER
    CGRect textRect = [text boundingRectWithSize:mTempSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]} context:nil];
    
    mTempSize = textRect.size;
#else
    mTempSize = [text sizeWithFont:[UIFont fontWithName:fontName size:fontSize] constrainedToSize:constrainedToSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
//    mTempSize = [text sizeWithFont:[UIFont fontWithName:fontName size:fontSize] constrainedToSize:constrainedToSize lineBreakMode:NSLineBreakByWordWrapping];
    
    
    return mTempSize.height;
    //    return mTempSize.width;
    
}


@end
