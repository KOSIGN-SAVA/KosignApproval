/*
 * Copyright (c) 2008, Keith Lazuka, dba The Polypeptides
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *	- Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *	- Neither the name of the The Polypeptides nor the
 *	  names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY Keith Lazuka ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL Keith Lazuka BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "KLCalendarModel.h"
#import "THCalendarInfo.h"
#import "DateUtils.h"
#import "Constants.h"

@implementation KLCalendarModel

- (id)init{
    if (![super init])
        return nil;
    
    _calendarInfo = [[THCalendarInfo alloc] init];
    [_calendarInfo setDate:[NSDate date]];
	
    
    _cal = CFCalendarCopyCurrent();
    
    _dayNames = [[NSArray alloc] initWithObjects:@"일", @"월", @"화", @"수", @"목", @"금", @"토", nil];
    return self;
}


- (NSDate *)selectedDate{
	return [_calendarInfo date];
}


- (void)setSelectedDate:(NSDate *)date{
	[_calendarInfo setDate:date];
}


#pragma mark Public methods
- (void)decrementMonth{
    [_calendarInfo moveToPreviousMonth];
}


- (void)incrementMonth{
    [_calendarInfo moveToNextMonth];
}


- (void)decrementWeek{
	[_calendarInfo adjustDays:-7];
}


- (void)incrementWeek{
	[_calendarInfo adjustDays:7];
}


- (void)decrementDay{
	[_calendarInfo adjustDays:-1];
}


- (void)incrementDay{
	[_calendarInfo adjustDays:1];
}


- (void)decrementYear{
    [_calendarInfo moveToPreviousYear];
}


- (void)incrementYear{
    [_calendarInfo moveToNextYear];
}


- (NSString *)selectedMonthName{
    return [_calendarInfo monthName];
}


- (NSInteger)selectedYear{
    return [_calendarInfo year];
}


- (NSInteger)selectedMonth{
    return [_calendarInfo month];
}

//이번달의 주의 개수 
- (NSInteger)selectedMonthNumberOfWeeks{
    return (NSInteger)[_calendarInfo weeksInMonth];
}

//전달 마지막주의 일자
- (NSArray *)daysInFinalWeekOfPreviousMonth{
    NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];

    [_calendarInfo moveToFirstDayOfMonth];
    [_calendarInfo moveToPreviousDay];
    NSInteger year = [_calendarInfo year];
    NSInteger month = [_calendarInfo month];
    NSInteger lastDayOfPreviousMonth = [_calendarInfo dayOfMonth];
    NSInteger lastDayOfWeekInPreviousMonth = [_calendarInfo dayOfWeek];

    if (lastDayOfWeekInPreviousMonth != 7)
        for (NSInteger day = 1 + lastDayOfPreviousMonth - lastDayOfWeekInPreviousMonth; day <= lastDayOfPreviousMonth; day++) {
            NSDate *d = [[NSDate date] setDateYear:year month:month day:day];
            [days addObject:d];
        }

    [_calendarInfo setDate:savedState];
    return days;
}

//이번달의 일자 
- (NSArray *)daysInSelectedMonth{
    NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];
    
    NSInteger year = [savedState year];
    NSInteger month = [savedState month];
    NSInteger lastDayOfMonth = [[savedState lastDayOfMonth] day];
    
    for (NSInteger day = 1; day <= lastDayOfMonth; day++) {
        NSDate *d = [[NSDate date] setDateYear:year month:month day:day];
        [days addObject:d];
    }
    
    [_calendarInfo setDate:savedState];
    
    return days;
}

//다음달의 첫주의 일자 
- (NSArray *)daysInFirstWeekOfFollowingMonth{
    NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];
    
    [_calendarInfo moveToNextMonth];
    [_calendarInfo moveToFirstDayOfMonth];
    NSInteger year = [_calendarInfo year];
    NSInteger month = [_calendarInfo month];
    NSInteger firstDayOfWeekInFollowingMonth = [_calendarInfo dayOfWeek];
    
    if (firstDayOfWeekInFollowingMonth != 1)
        for (NSInteger day = 1; day <= 8-firstDayOfWeekInFollowingMonth; day++) {
            NSDate *d = [[NSDate date] setDateYear:year month:month day:day];
            [days addObject:d];
        }
    
    [_calendarInfo setDate:savedState];
    return days;
}

//이번주의 일자
- (NSArray *)daysInSelectedWeek{
	NSDate *savedState = [_calendarInfo date];
    NSMutableArray *days = [NSMutableArray array];

	while ([_calendarInfo dayOfWeek] > 1)
		[_calendarInfo moveToPreviousDay];
	
	for (NSUInteger i = 0; i < 7; i++) {
		NSDate *d = [[NSDate date] setDateYear:[_calendarInfo year] month:[_calendarInfo month] day:[_calendarInfo dayOfMonth]];
		[days addObject:d];
		[_calendarInfo moveToNextDay];
	}
    
    [_calendarInfo setDate:savedState];
    return days;
}


- (NSArray *)dayNames{
	NSArray *dayNames = [_calendarInfo dayNames];
	
	if (CFCalendarGetFirstWeekday(_cal) == 2)
	{
		NSMutableArray *mutableDayNames = [NSMutableArray arrayWithArray:dayNames];
		[mutableDayNames addObject: [mutableDayNames objectAtIndex:0]];
		[mutableDayNames removeObjectAtIndex:0];
		return mutableDayNames;
	}
	
	return dayNames;
}


- (NSInteger)daysInMonth {
	return [_calendarInfo daysInMonth];
}


- (NSInteger)selectedDay {
	return [_calendarInfo dayOfWeek];
}


- (void)dealloc{
    CFRelease(_cal);
    [_calendarInfo release];
    [_dayNames release];
    [super dealloc];
}

@end