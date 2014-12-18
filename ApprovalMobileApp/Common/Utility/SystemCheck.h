//
//  SystemCheck.h
//
//  Created by donghwan kim on 10. 10. 8..
//  Copyright 2010 webcash. All rights reserved.
//  desc : system에 관련한 체크 및 함수 모음.

#import <Foundation/Foundation.h>


@interface SystemCheck : NSObject {
    
}

+ (NSString *) checkSystemFromDate:(NSDate *)today;
+ (BOOL) checkSystemFromBool;


@end
