//
//  DateUtils.h
//  date
//
//  Created by donghwan kim on 10. 10. 29..
//  Copyright 2010 webcash. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(DateUtils)

/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자를 NSString 날자 포멧으로 변환.
 
 @param format				@c NSString 날자포멧 @c setDateFormat Data Formatting Guide 참조
 @return Returns			@c NSString의 날자 포멧,
 */
- (NSString *)dateToString:(NSString *)format;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자를 NSString 날자 포멧으로 변환.
 
 @param format				@c NSString 날자포멧 @c setDateFormat Data Formatting Guide 참조
 @param localeIdentifier	@c NSString @c NSString 지역별 로케일 Identifier
 @return Returns			@c NSString의 날자 포멧,
 */
- (NSString *)dateToString:(NSString *)format localeIdentifier:(NSString *)localeIdentifier;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자의 년도를 가져오는 함수
 
 @return Returns			@c NSInteger 년도
 */
- (NSInteger)year;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자의 월를 가져오는 함수
 
 @return Returns			@c NSInteger 월
 */
- (NSInteger)month;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자의 일를 가져오는 함수
 
 @return Returns			@c NSInteger 월
 */
- (NSInteger)day;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자의 시간을 가져오는 함수(12시간제 표시)
 
 @return Returns			@c NSInteger 시간
 */
- (NSInteger)hour;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자의 시간을 가져오는 함수(24시간제 표시)
 
 @return Returns			@c NSInteger 시간
 */
- (NSInteger)hour24;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자의 분을 가져오는 함수
 
 @return Returns			@c NSInteger 분
 */
- (NSInteger)minute;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자의 quarter을 가져오는 함수
 
 @return Returns			@c NSInteger quarter
 */
- (NSInteger)quarter;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자의 초를 가져오는 함수
 
 @return Returns			@c NSInteger 초
 */
- (NSInteger)second;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자에 년을 더하는 함수
 
 @param years				@c NSInteger 해당년만큼 날자에 더해 준다.
 @return Returns			@c NSDate 더한 날자
 */
- (NSDate *)addYear:(NSInteger)years;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자에 월을 더하는 함수
 
 @param months				@c NSInteger 해당월만큼 날자에 더해 준다.
 @return Returns			@c NSDate 더한 날자
 */
- (NSDate *)addMonth:(NSInteger)months;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자에 일을 더하는 함수
 
 @param days				@c NSInteger 해당일만큼 날자에 더해 준다.
 @return Returns			@c NSDate 더한 날자
 */
- (NSDate *)addDay:(NSInteger)days;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 일자에 시간을 더하는 함수
 
 @param Hour				@c NSInteger 해당시간만큼 날자에 더해 준다.
 @return Returns			@c NSDate 더한 날자
 */
- (NSDate *)addHours:(NSInteger)hours;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 해당월의 첫번째 날자를 가져오는 함수
 
 @return Returns			@c NSDate 해당월의 첫 일자.
 */
- (NSDate *)firstDayOfMonth;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 해당월의 마지막 날자를 가져오는 함수
 
 @return Returns			@c NSDate 해당월의 마지막 일자.
 */
- (NSDate *)lastDayOfMonth;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 요일을 가져오는 함수.
 
 @return Returns			@c NSInteger 해당요일 숫자.
 */
- (NSInteger)dayOfWeek;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 양력 값으로 음력 구하기. Deprecated reason:기기에서 오류가 발생 하는데 원인을 알수 없음
 
 @param seperate			@c NSString 날자 기호
 @return Returns			@c NSString 음력일자 yyyyMMdd.
 */
//- (NSString *)lunarDateToString:(NSString *)seperate;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 양력 값으로 음력 구하기. Deprecated reason:기기에서 오류가 발생 하는데 원인을 알수 없음
 
 @param seperate			@c NSString 날자 기호
 @return Returns			@c NSString 음력일자 yyyyMMdd.
 */
- (NSString *)lunarDateToStringMMdd:(NSString *)seperate;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 양력 값으로 음력의 년도 구하기.
 
 @return Returns			@c NSInteger 음력의 년도 yyyy
 */
- (NSInteger)lunarDateYear;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 양력 값으로 음력의 월 구하기.
 
 @return Returns			@c NSInteger 음력의 월
 */
- (NSInteger)lunarDateMonth;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 양력 값으로 음력의 일자 구하기.
 
 @return Returns			@c NSInteger 음력의 일자
 */
- (NSInteger)lunarDateDay;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 년 월 일로 날자를 생성하는 함수
 
 @param year				@c NSInteger 년도
 @param month				@c NSInteger 월
 @param day					@c NSInteger 일
 @return Returns			@c NSDate 년 월 일의 날자.
 */
- (NSDate *)setDateYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;




/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 다른일자와 비교하여 이전일자인지 판변하는 함수
 
 @param date				@c NSDate 비교일자 .
 @return Returns			@c BOOL YES 비교날자 보다 이전이다. NO 비교날자 보다 이후일자이다.
 @see earlierDate:
 @see laterDate:
 @see isLaterThan;
 */
- (BOOL)isEarlierThan:(NSDate *)date;



/////////////////////////////////////////////////////////////////////////////////////////////
/** NSDate의 다른일자와 비교하여 이후일자인지 판변하는 함수
 
 @param date				@c NSDate 비교일자 .
 @return Returns			@c BOOL YES 비교날자 보다 이후이다. NO 비교날자 보다 이전일자이다.
 @see earlierDate:
 @see laterDate:
 @see isEarlierThan;
 
 */
- (BOOL)isLaterThan:(NSDate *)date;



- (NSString *)koreanDayName;




@end
