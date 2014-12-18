//
//  SysUtils.m
//  SysUtils
//
//  Created by 종욱 윤 on 10. 5. 12..
//  Copyright 2010 (주) 쿠콘. All rights reserved.
//

#import "SysUtils.h"
#import "Constants.h"
#import "Reachability.h"
#import "IPAddress.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import "SecurityManager.h"
#import <sys/sysctl.h>



@implementation SysUtils



// 게이트웨이 주소를 포함하여 실제 이미지의 URL 주소를 보내주는 함수
+ (NSURL *)getRealImageURL:(NSString *)url {
    
    //return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@_thumbnail.png",_SM_GATEWAY_URL,url]];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
    
}

+ (NSURL *)getOriginalImageURL:(NSString *)url {
    
    //return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",_SM_GATEWAY_URL,url]];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
    
}


+ (BOOL)isNull:(id)obj {
    if (obj == nil || obj == [NSNull null])
        return YES;
    
    // obj가 NSString이거나 NSString을 상속받은 객체일 경우 empty string을 체크한다.
    if ([obj isKindOfClass:[NSString class]] == YES) {
        if ([(NSString *)obj isEqualToString:@""] == YES)
            return YES;
        
        if ([(NSString *)obj isEqualToString:@"<null>"] == YES)
            return YES;
        
        if ([(NSString *)obj isEqualToString:@"null"] == YES)
            return YES;
    }
    
    return NO;
}


// Null값 체크 후 Null값이면 빈스트링을 보내는 함수
+ (NSString *)isNullCheckAndReturnString:(NSString *)sender {
    
    if ([self isNull:sender] == YES) {
        return @"";
    } else {
        return sender;
    }
}

// -가 없는 전화번호를 넣으면 -이 있는 스트링을 보내는 함수
// 예) 027841690 => 02-784-1690

+ (NSString *)getHyphenPhonNumber:(NSString *)sender {
    
    
    if ([sender length] <= 4) {
        //너무 짧은 스트링은 내뱉는다
        
        return sender;
    }
    
    sender = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    sender = [sender stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //NSLog(@"sender : [%@]", sender);
    
    if ([[sender substringToIndex:2] isEqualToString:@"02"]) {
        //서울
        
        if ([[sender substringFromIndex:2] length] == 8) {
            
            NSRange range = {2,4};
            
            return [NSString stringWithFormat:@"%@-%@-%@", [sender substringToIndex:2], [sender substringWithRange:range], [sender substringFromIndex:6]];
            
        } else if ([[sender substringFromIndex:2] length] == 7) {
            
            NSRange range = {2,3};
            
            return [NSString stringWithFormat:@"%@-%@-%@", [sender substringToIndex:2], [sender substringWithRange:range], [sender substringFromIndex:5]];
            
        } else {
            
            return [NSString stringWithFormat:@"%@-%@", [sender substringToIndex:2], [sender substringFromIndex:2]];
        }
        
    } else {
        //그외 지역 및 핸드폰 번호
        
        
        if ([[sender substringFromIndex:3] length] == 8) {
            
            NSRange range = {3,4};
            
            return [NSString stringWithFormat:@"%@-%@-%@", [sender substringToIndex:3], [sender substringWithRange:range], [sender substringFromIndex:7]];
            
        } else if ([[sender substringFromIndex:3] length] == 7) {
            
            NSRange range = {3,3};
            
            return [NSString stringWithFormat:@"%@-%@-%@", [sender substringToIndex:3], [sender substringWithRange:range], [sender substringFromIndex:6]];
            
        } else {
            
            if ([sender length] == 8) {
                //1577 등 8자리로 된 전화번호 처리
                
                return [NSString stringWithFormat:@"%@-%@", [sender substringToIndex:4], [sender substringFromIndex:4]];
            } else {
                
                return [NSString stringWithFormat:@"%@-%@", [sender substringToIndex:3], [sender substringFromIndex:3]];
            }
            
        }
    }
    
    return sender;
}

// 테이블뷰 위의 컴포넌트의 인덱스를 빼오기위한 함수
+ (NSIndexPath *)getIndexForTableViewCellComPonent:(id)aComponent inTableView:(UITableView *)tableView{
    UIView *vSuperView = nil;
    
    if ([SysUtils getOSVersion] >= 70000) {
        vSuperView = [[[aComponent superview] superview] superview];
        
    } else {
        vSuperView = [[aComponent superview] superview];
        
    }
    
    if([vSuperView isKindOfClass:[UITableViewCell class]] == NO)
        return nil;
    
    return [tableView indexPathForCell:(UITableViewCell *)vSuperView];
}


+ (void)writeLogWithFormat:(NSString *)format, ... {
#if !_RELEASE_
    va_list vl;
    va_start(vl, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:vl];
    va_end(vl);
    
    NSLog(@"%@", message);
    [message release];
#endif
}


+ (void)writeLog:(NSString *)message {
#if !_RELEASE_
    NSLog(@"%@", message);
#endif
}


+ (void)writeLogFrame:(CGRect)rect {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"x[%f] y[%f]  w[%f] h[%f]", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
#endif
}


+ (NSString *)filenameFromDocDir:(NSString *)filename {
    NSArray *paths		= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir	= [paths objectAtIndex:0];
    
    return [docDir stringByAppendingPathComponent:filename];
}


+ (NSString *)imageCodeToFileName:(NSString *)imgCode {
    // imgCode가 null일 경우 이하 작업은 중단한다.
    if ([self isNull:imgCode] == YES)
        return nil;
    
    NSString *extension = nil;
    
    switch ((int)[imgCode characterAtIndex:kFileFormatIndex] - 48) {
        case 1:
            extension = @"gif";
            break;
            
        case 2:
            extension = @"jpg";
            break;
            
        case 3:
            extension = @"bmp";
            break;
            
        case 4:
            extension = @"icn";
            break;
            
        case 5:
            extension = @"avi";
            break;
            
        default:
            extension = @"png";
            break;
    }
    
    NSMutableString *resultString = [[[NSMutableString alloc] init] autorelease];
    [resultString appendString:imgCode];
    [resultString appendString:@"_a."];
    [resultString appendString:extension];
    return resultString;
    //	return [[NSString initWithFormat:@"%@_a.%@", imgCode, extension] autorelease];
}



+ (NSString *)skinedImageCodeToFileName:(NSString *)imgCode skinType:(NSInteger)skinType {
    if ([self isNull:imgCode] == YES)
        return nil;
    
    NSString *extension		= nil;
    NSString *skinTypeCode	= nil;
    
    switch ((int)[imgCode characterAtIndex:kFileFormatIndex] - 48) {
        case 1:
            extension = @"gif";
            break;
            
        case 2:
            extension = @"jpg";
            break;
            
        case 3:
            extension = @"bmp";
            break;
            
        case 4:
            extension = @"icn";
            break;
            
        case 5:
            extension = @"avi";
            break;
            
        default:
            extension = @"png";
            break;
    }
    
    switch (skinType) {
        case 0:
            skinTypeCode = @"a";
            break;
            
        case 1:
            skinTypeCode = @"b";
            break;
            
        case 2:
            skinTypeCode = @"c";
            break;
            
        case 3:
            skinTypeCode = @"d";
            break;
            
        default:
            skinTypeCode = @"a";
            break;
    }
    
    return [[[NSString alloc] initWithFormat:@"%@_%@.%@", imgCode, skinTypeCode, extension] autorelease];
    
}



+ (NSString *)integerToString:(NSInteger)value {
    return [[[NSString alloc] initWithFormat:@"%d", value] autorelease];
}


+ (NSString *)doubleToString:(double)value {
    return [[[NSString alloc] initWithFormat:@"%f", value] autorelease];
}


+ (NSString *)doubleToIntString:(double)value {
    return [self integerToString:[[NSNumber numberWithDouble:value]intValue]];
}


+ (NSString *)boolToString:(BOOL)value {
    return (value == YES ? @"YES" : @"NO");
}


+ (NSDate *)stringToDate:(NSString *)stringDate dateFormat:(NSString *)fmt {
    if ([self isNull:stringDate] == YES)
        return nil;
    
    NSString *dateFmt = fmt;
    
    if ([self isNull:dateFmt] == YES)
        dateFmt = @"yyyyMMddHHmmss";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFmt];
    
    NSDate *dateFromString = [dateFormatter dateFromString:stringDate];
    
    //	if ([self getOSVersion] == 40100) {
    //		NSTimeZone* currentTimeZone	= [NSTimeZone localTimeZone];
    //        NSInteger currentGMTOffset	= [currentTimeZone secondsFromGMT];
    //
    //        dateFromString = [dateFromString dateByAddingTimeInterval:currentGMTOffset];
    //	}
    
    [dateFormatter release];
    
    return dateFromString;
}


+ (NSString *)dateToString:(NSDate *)date dateFormat:(NSString *)format {
    if ([self isNull:date] == YES)
        return nil;
    
    NSString *dateFmt = format;
    
    if ([self isNull:dateFmt] == YES)
        dateFmt = @"yyyyMMddHHmmss";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFmt];
    
    //	if ([self getOSVersion] == 40100) {
    //		[dateFormatter setLocale:[NSLocale currentLocale]];
    //		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //
    //		NSTimeZone* currentTimeZone	= [NSTimeZone localTimeZone];
    //        NSInteger currentGMTOffset	= [currentTimeZone secondsFromGMT];
    //
    //        date = [date dateByAddingTimeInterval:currentGMTOffset];
    //		NSLog(@"%@", date);
    //	}
    
    
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    return stringFromDate;
}


+ (UIViewController *)openWithStringAndNumber:(NSString *)ctrlName action:(SEL)action value:(NSNumber *)value {
    //	if (ctrlName == nil || [ctrlName isEqualToString:@""] == YES)
    //		return nil;
    //
    //	Class class = nil;
    //	UIViewController *tempView = nil;
    //	class = [[NSBundle mainBundle]classNamed:ctrlName];
    //
    //	if (class != nil){
    //		if (action == nil){
    //			tempView = [[class alloc]init];
    //		}else{
    //			tempView = [class alloc];
    //			objc_msgSend(tempView, action, value);
    //		}
    //		return tempView;
    //	}
    
    return nil;
}



//+ (id)callmethod:(id)Target aMethod:(SEL)aMethod, ... {
//
//
//}

//+ (UIViewController *)openWithString:(NSString *)ctrlName action:(SEL)action paramCount:(NSNumber *)paramCount, ... {
//    
//    if (ctrlName == nil || [ctrlName isEqualToString:@""] == YES)
//        return nil;
//    
//    Class class = nil;
//    UIViewController *tempView = nil;
//    class = [[NSBundle mainBundle]classNamed:ctrlName];
//    
//    if (class != nil){
//        if (action == nil){
//            tempView = [[class alloc]init];
//        }else{
//            tempView = [class alloc];
//            va_list vl;
//            
//            va_start(vl, paramCount);
//            
//            NSMutableArray *argArray = [NSMutableArray arrayWithObject:paramCount];
//            
//            id object;
//            for(int i=0; i<[paramCount intValue] ; i++){
//                object = va_arg(vl, id);
//                [argArray addObject:object];
//            }
//            va_end(vl);
//            if ([argArray count] > 0 && [paramCount intValue] >0)
//                ((void(*)(id, SEL, id))objc_msgSend)(tempView, action, argArray);
//            else
//                ((void(*)(id, SEL))objc_msgSend)(tempView, action);
//        }
//        return tempView;
//    }
//    return nil;
//    
//}

+ (UIViewController *)openWithStringVarParam:(NSString *)ctrlName action:(SEL)action, ... {
    
    if (ctrlName == nil || [ctrlName isEqualToString:@""] == YES)
        return nil;
    
    Class class = nil;
    UIViewController *tempView = nil;
    Method *mlist;
    NSInvocation *invoke;
    NSMethodSignature *sig;
    unsigned int methodCount;
    int paramCount;
    
    //1. validation check.
#if _DEBUG_
    
    id object2;
    
    va_list vl;
    va_start(vl, action);
    
    for (int j=0; j<10; j++) {
        object2 = va_arg(vl, id);
        
        NSLog(@"%@", object2);
        
        
        if (object2 == nil) break;
    }
    va_end(vl);
#endif
    
    
    class = [[NSBundle mainBundle]classNamed:ctrlName];
    
    if (class == nil)
        return nil;
    
    
    
    
    
    @try {
        mlist = class_copyMethodList(class, &methodCount);
        
        if (action == nil) {
            tempView = [[class alloc] init];
        } else {
            tempView = [class alloc];
            
            for (int i=0;i<methodCount;i++) {
                SEL m = method_getName(mlist[i]);
                
#if DEBUG
                NSLog(@"%@", NSStringFromSelector(m));
                
#endif
                
                
                if (m == action){
                    sig = [NSMethodSignature signatureWithObjCTypes:method_getDescription(mlist[i])->types];
                    paramCount = [sig numberOfArguments] - 2;
                    
#if DEBUG
                    NSLog(@"함수의 인자 갯수 [%d]", [sig numberOfArguments]);
                    for (int t=0; t <[sig numberOfArguments]; t++){
                        NSLog(@"index[%d], paramType[%s]", t, [sig getArgumentTypeAtIndex:t]);
                    }
                    
                    NSLog(@"return type[%s] length[%d]", [sig methodReturnType], [sig methodReturnLength]);
#endif
                    
                    
                    
                    // 2.
                    va_list vl;
                    va_start(vl, action);
                    
                    invoke = [NSInvocation invocationWithMethodSignature:sig];
                    [invoke setTarget:tempView];
                    [invoke setSelector:m];
                    
                    id object;
                    for (int j=2; j<paramCount+2; j++) {
                        object = va_arg(vl, id);
                        [invoke setArgument:&object atIndex:j];
                    }
                    va_end(vl);
                    
                    [invoke invoke];
                    
                    break;
                }
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        free(mlist);
    }
    
    
    return tempView;
}


+ (UIViewController *)openWithStringAndDictionary:(NSString *)ctrlName action:(SEL)action dicData:(NSDictionary *)dicData {
    if (ctrlName == nil || [ctrlName isEqualToString:@""] == YES)
        return nil;
    
    Class class = nil;
    UIViewController *tempView = nil;
    class = [[NSBundle mainBundle]classNamed:ctrlName];
    
    if (class != nil){
        if (action == nil){
            tempView = [[class alloc] init];
        }else{
            tempView = [class alloc];
//            if (dicData != nil)
//                ((void(*)(id, SEL, id))objc_msgSend)(tempView, action, dicData);
//            else
//                ((void(*)(id, SEL, id))objc_msgSend)(tempView, action, dicData);
        }
        return tempView;
    }
    return nil;
}


+ (void)showMessageWithOwner:(NSString *)aMsg owner:(id)aOwner tag:(NSInteger)aTag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"안내"
                                                    message:aMsg
                                                   delegate:aOwner
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    
    alert.tag = aTag;
    
    [alert show];
    [alert release];
}


+ (void)showMessageWithOwner:(NSString *)aMsg owner:(id)aOwner {
    [self showMessageWithOwner:aMsg owner:aOwner tag:0];
}


+ (void)showMessage:(NSString *)aMsg {
    [self showMessageWithOwner:aMsg owner:nil tag:0];
}


+ (NSInteger)ceilMostSignificantDigit:(NSInteger)targetNumber {
    NSInteger i		= 0;
    NSInteger val	= targetNumber;
    
    while (val > 10) {
        i++;
        val /= 10;
    }
    
    val += 1; // next unit value
    
    while (i > 0) {
        i--;
        val *= 10;
    }
    
    return val;
}


+ (NSString *)getCurrentIPAddress {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    NSString *ipAddress = [NSString stringWithFormat:@"%s", ip_names[1]];
    FreeAddresses();
    
    return ipAddress;
}


+ (NSString *)getCurrentMACAddress {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    NSString *macAddress = [NSString stringWithFormat:@"%s", hw_addrs[1]];
    FreeAddresses();
    
    return macAddress;
}


+ (NSString *)getCurrentUDID {
    //	return [[UIDevice currentDevice] uniqueIdentifier];
    return @"";
}


+ (NSString *)getCurrentUUID {
    
    if ([SysUtils getOSVersion] < 60000) {
        
        NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        if (uuid == nil) {
            
            CFUUIDRef theUUID = CFUUIDCreate(NULL);
            CFStringRef string = CFUUIDCreateString(NULL, theUUID);
            CFRelease(theUUID);
            uuid = [NSString stringWithString:(NSString *)string];
            CFRelease(string);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        return uuid;
    } else {
        
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
    }
    
}


+ (NSString *)getDeviceModel {
    return [NSString stringWithFormat:@"%@ (%@)", [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion];
}


+ (NSInteger)getOSVersion {
    
    NSString* sOSVersion = [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"0"];
    
    if ([sOSVersion integerValue] < 10000)		// iOS 4.1부터는 버전 번호 자릿수가 3자리여서,
        return [sOSVersion integerValue] * 100;	// 5자리로 맞춰준다.
    else
        return [sOSVersion integerValue];
}





+ (NetworkStatus)getCurrentNetworkStatus {
    Reachability *wifiReach = [Reachability reachabilityForInternetConnection];
    [wifiReach startNotifer];
    
    
    //Notification을 받기 위해 HostName으로 Reachability를 설정하자.
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.ibk.com"];
    [reachability startNotifer];
    
    return [wifiReach currentReachabilityStatus];
}


+ (BOOL)applicationExecute:(NSString *)urlScheme {
    if ([self isNull:urlScheme] == NO)
        return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
    
    return NO;
}


+ (BOOL)canExecuteApplication:(NSString *)urlScheme {
    if ([self isNull:urlScheme] == YES)
        return NO;
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlScheme]];
}


+ (NSInteger)versionToInteger:(NSString *)aVersion {
    if ([self isNull:aVersion] == YES)
        return 0;
    
    NSMutableArray* arrInitVersion	= (NSMutableArray *)[@"0.0.0" componentsSeparatedByString:@"."];
    NSArray* arrVersion				= [aVersion componentsSeparatedByString:@"."];
    
    if (([self isNull:arrVersion] == YES) || ([arrVersion count] <= 0))
        return 0;
    
    for (NSInteger i = 0; i < [arrVersion count]; i++)
        [arrInitVersion replaceObjectAtIndex:i withObject:[arrVersion objectAtIndex:i]];
    
    NSMutableString* sConvertedVersion = [NSMutableString stringWithCapacity:3];
    
    for (NSString* sVersion in arrInitVersion)
        [sConvertedVersion appendString:sVersion];
    
    return [sConvertedVersion integerValue];
}


+ (BOOL)findAndResignFirstResponder:(UIView *)aView {
    if ([aView isFirstResponder] == YES) {
        [aView resignFirstResponder];
        
        return YES;
    }
    
    for (UIView *subView in aView.subviews) {
        if ([self findAndResignFirstResponder:subView])
            return YES;
    }
    
    return NO;
}


+ (NSString *)nullToVoid:(NSString *)aSource {
    if ([self isNull:aSource] == YES)
        return @"";
    
    return aSource;
}


+ (void)popViewControllerWithTag:(UIViewController *)view tag:(NSInteger)tag{
    for (UIViewController* viewCtrl in view.navigationController.viewControllers) {
        if (viewCtrl.view.tag == 9990) {
            [view.navigationController popToViewController:viewCtrl animated:YES];
            return;
        }
    }
}


+ (BOOL)isPad {
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}

+ (UIColor *)stringToColor:(NSString *)aHexDecimal {
    if ([self isNull:aHexDecimal] == YES)
        return nil;
    
    if ([aHexDecimal length] < 6)
        return nil;
    
    NSRange range;
    NSString* sRedValue		= nil;
    NSString* sGreenValue	= nil;
    NSString* sBlueValue	= nil;
    
    // RED 값 추출
    range.location	= 0;
    range.length	= 2;
    sRedValue		= [aHexDecimal substringWithRange:range];
    
    // GREEN 값 추출
    range.location	= 2;
    sGreenValue		= [aHexDecimal substringWithRange:range];
    
    // BLUE 값 추출
    range.location	= 4;
    sBlueValue		= [aHexDecimal substringWithRange:range];
    
    unsigned int iRedValue		= 0;
    unsigned int iGreenValue	= 0;
    unsigned int iBlueValue		= 0;
    
    [[NSScanner scannerWithString:sRedValue] scanHexInt:&iRedValue];
    [[NSScanner scannerWithString:sGreenValue] scanHexInt:&iGreenValue];
    [[NSScanner scannerWithString:sBlueValue] scanHexInt:&iBlueValue];
    
    return RGB(iRedValue, iGreenValue, iBlueValue);
}


+ (BOOL)checkPhoneCall {
    
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
    
    // Done with this
    free(name);
    
    
    // iPhone 이면 YES...
    if ([machine hasPrefix:@"iPhone"])
        return YES;
    
    
    // iPod, iPad는 NO...
    return NO;
}


+ (NSString *)md5String:(NSString*)userID:(NSString*)currentTime{
    //	if ([SysUtils isNull:self] == YES)
    //		return nil;
    
    NSString *combinationWord = [NSString stringWithFormat:@"%@%@8DuwK+WJSghk_!49",userID,currentTime];
    
    //	const char *cStr = [self UTF8String];
    const char *cStr = [combinationWord UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)tempMd5String:(NSString*)testString{
    //	if ([SysUtils isNull:self] == YES)
    //		return nil;
    
    NSString *combinationWord = [NSString stringWithFormat:@"%@8DuwK+WJSghk_!49",testString];
    
    //	const char *cStr = [self UTF8String];
    const char *cStr = [combinationWord UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

//+ (char *)MD5
+ (NSData *)md5tem:(NSString *)mD5 {
    
    // Create pointer to the string as UTF8
    const char *ptr = [mD5 UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    unsigned char *ccmd5Buffer = CC_MD5(ptr, strlen(ptr), md5Buffer);
    //NSLog(@"%s", ccmd5Buffer);
    
    
    NSData *md5Data = [[[NSData alloc] initWithBytes:ccmd5Buffer length:sizeof(ccmd5Buffer)] autorelease];
    //NSLog(@"%@", md5Data);
    
    //    NSString *md5String = [NSString stringWithCString:ccmd5Buffer encoding:NSASCIIStringEncoding];
    //    NSLog(@"%@", md5String);
    
    
    return md5Data;
    
    //
    //    
    //
    //    
    //    //	const char *cStr = [self UTF8String];
    //	const char *cStr = [mD5 UTF8String];
    //    
    //    NSLog(@"cStr : %@",cStr);
    //    
    //	unsigned char result[CC_MD5_DIGEST_LENGTH];
    //	CC_MD5( cStr, strlen(cStr), result);
    //	
    //	return result;
    
    
}

@end
