//
//  THCalendarInfo.m
//
//  Created by Scott Stevenson on 3/10/06.
//  Released under a BSD-style license. See THCalendarInfo_License.txt
//

#import "THCalendarInfo.h"

@interface THCalendarInfo (Private)
- (void) setupEnglishNames;
@end

@interface THCalendarInfo (PrivateAccessors)
-(CFCalendarRef)calendar;
-(void)setCalendar:(CFCalendarRef)newCalendar;
-(CFTimeZoneRef)timeZone;
-(void)setTimeZone:(CFTimeZoneRef)newTimeZone;
@end


static SDCalendarRoundingRule MyDefaultRoundingRule;
static SDCalendarHourFormat MyDefaultHourFormat;



@implementation THCalendarInfo

+ (void) initialize{
	MyDefaultRoundingRule = SDCalendarRoundDownRule;
	MyDefaultHourFormat   = SDCalendar24HourFormat;
}


- (id) init{
    [super init];
    _absoluteTime = CFAbsoluteTimeGetCurrent();
    _calendar     = CFCalendarCopyCurrent();
	
//	_calendar       = CFCalendarCreateWithIdentifier(nil, kCFGregorianCalendar);
//    _timeZone		= CFCalendarCopyTimeZone( _calendar );	
//    _timeZone	  = CFCalendarCopyTimeZone( _calendar );

//	NSUInteger weekday = 1;
//	CFCalendarSetFirstWeekday(_calendar, weekday);	
	
//	NSLog(@"%d", CFCalendarGetFirstWeekday(_calendar));
	
    _dayNames	  = nil;
    _monthNames	  = nil;
	
	
	
    
    [self setupEnglishNames];
	return self;
}


- (void) dealloc{
	if ( _calendar ) CFRelease( _calendar );
	if ( _timeZone ) CFRelease( _timeZone );
	
	[_dayNames release];
	[_monthNames release];
	
	[super dealloc];
}


+ (id) calendarInfo{
	return [[[THCalendarInfo alloc] init] autorelease];
}


+ (SDCalendarRoundingRule) defaultRoundingRule{
	return MyDefaultRoundingRule;
}


+ (void) setDefaultRoundingRule: (SDCalendarRoundingRule)roundingRule{
	MyDefaultRoundingRule = roundingRule;
}


+ (SDCalendarHourFormat) defaultHourFormat{
	return MyDefaultHourFormat;
}


+ (void) setDefaultHourFormat: (SDCalendarHourFormat)format{
	MyDefaultHourFormat = format;
}


#pragma mark -
#pragma mark Class Methods for Current Date and Time
+ (NSDate *) currentDate{
	return [NSDate date];
}


+ (CFAbsoluteTime) currentAbsoluteTime{
	return CFAbsoluteTimeGetCurrent();	
}


+ (int) currentDayOfWeek{
	return CFCalendarGetOrdinalityOfUnit (
	   CFCalendarCopyCurrent(),
	   kCFCalendarUnitDay,
	   kCFCalendarUnitWeek,
	   [self currentAbsoluteTime]
	);
}


+ (int) currentDayOfMonth{
	return CFCalendarGetOrdinalityOfUnit (
	   CFCalendarCopyCurrent(),
	   kCFCalendarUnitDay,
	   kCFCalendarUnitMonth,
	   [self currentAbsoluteTime]
	);
}


+ (int) currentMonth{
	return CFCalendarGetOrdinalityOfUnit (
	   CFCalendarCopyCurrent(),
	   kCFCalendarUnitMonth,
	   kCFCalendarUnitYear,
	   [self currentAbsoluteTime]
	);
}


+ (int) currentYear{
	return CFCalendarGetOrdinalityOfUnit (
	   CFCalendarCopyCurrent(),
	   kCFCalendarUnitYear,
	   kCFCalendarUnitEra,
	   [self currentAbsoluteTime]
	);
}


+ (int) currentHour{
	return [self currentHourIn24HourFormat];
}


+ (int) currentHourIn12HourFormat{
	int myHour = CFCalendarGetOrdinalityOfUnit (
	   CFCalendarCopyCurrent(),
	   kCFCalendarUnitHour,
	   kCFCalendarUnitDay,
	   [self currentAbsoluteTime]
	);
	
	// adjust for real-world expectations
	// otherwise, 3:45 is '4' (fouth hour)
	myHour--;

	// is it midnight?
	if ( myHour < 1 )
	{		
		myHour = 12;
		
	// afternoon/evening
	} else if ( myHour > 12 ) {
				
		myHour -= 12;
	}

	return myHour;	
}


+ (int) currentHourIn24HourFormat{
	int myHour = CFCalendarGetOrdinalityOfUnit (
	   CFCalendarCopyCurrent(),
	   kCFCalendarUnitHour,
	   kCFCalendarUnitDay,
	   [self currentAbsoluteTime]
	);

	// adjust for real-world expectations
	// otherwise, 3:45 is '4' (fouth hour)	
	myHour--;
	
	return myHour;
}


+ (int) currentMinute{
	int myMinute = CFCalendarGetOrdinalityOfUnit (
	   CFCalendarCopyCurrent(),
	   kCFCalendarUnitMinute,
	   kCFCalendarUnitHour,
	   [self currentAbsoluteTime]
	);
	
	// adjust for real-world expectations
	// otherwise, 3:10 is '11' (eleventh minute)
	myMinute--;
	
	return myMinute;	
}


+ (int) currentSecond{
	int mySecond = CFCalendarGetOrdinalityOfUnit (
	   CFCalendarCopyCurrent(),
	   kCFCalendarUnitSecond,
	   kCFCalendarUnitMinute,
	   [self currentAbsoluteTime]
	);
	
	// adjust for real-world expectations
	// otherwise, 3:10:09 is '10' (tenth second)
	mySecond--;
	
	return mySecond;
}


+ (int) daysInCurrentMonth{
	CFRange r = CFCalendarGetRangeOfUnit (
	   CFCalendarCopyCurrent(),
	   kCFCalendarUnitDay,
	   kCFCalendarUnitMonth,
	   [self currentAbsoluteTime]
	);
	
	return r.length;
}


+ (NSString *) currentDayName{
	return @"Undefined";
}                                                


+ (NSString *) currentMonthName{
	return @"Undefined";
}


#pragma mark -
#pragma mark Accessors for Reference Date

-(CFAbsoluteTime) absoluteTime {
	return _absoluteTime;
}


-(void) setAbsoluteTime:(CFAbsoluteTime)newAbsoluteTime {
	_absoluteTime = newAbsoluteTime;
}


- (NSDate *)date{
	// This looks weird to me, but this doc says it's okay:
	// http://developer.apple.com/documentation/Cocoa/Conceptual/MemoryMgmt/Concepts/CFObjects.html
	
	NSDate * newDate = (NSDate *) CFDateCreate( NULL, [self absoluteTime] );
	return [newDate autorelease];
}


- (void) setDate:(NSDate *)newDate{
	if ( newDate == NULL ) return;
	[self setAbsoluteTime: CFDateGetAbsoluteTime( (CFDateRef)newDate )];
}


- (void) resetDateAndTimeToCurrent{
	[self setAbsoluteTime: CFAbsoluteTimeGetCurrent()];
}


#pragma mark -
#pragma mark Info for Reference Date

- (int) dayOfWeek{
	return CFCalendarGetOrdinalityOfUnit (
	   [self calendar],
	   kCFCalendarUnitDay,
	   kCFCalendarUnitWeek,
	   [self absoluteTime]
	);
}


- (int) dayOfMonth{
	return CFCalendarGetOrdinalityOfUnit (
	   [self calendar],
	   kCFCalendarUnitDay,
	   kCFCalendarUnitMonth,
	   [self absoluteTime]
	);	
}


- (int) month{
	return CFCalendarGetOrdinalityOfUnit (
	   [self calendar],
	   kCFCalendarUnitMonth,
	   kCFCalendarUnitYear,
	   [self absoluteTime]
	);	
}


- (int) year{
	return CFCalendarGetOrdinalityOfUnit (
	   [self calendar],
	   kCFCalendarUnitYear,
	   kCFCalendarUnitEra,
	   [self absoluteTime]
	);	
}


- (int) hour{
	return [self hourIn24HourFormat];
}


- (int) hourIn12HourFormat{
	int myHour = CFCalendarGetOrdinalityOfUnit (
	   [self calendar],
	   kCFCalendarUnitHour,
	   kCFCalendarUnitDay,
	   [self absoluteTime]
	);
	
	// adjust for real-world expectations
	// otherwise, 3:45 is '4' (fouth hour)
	myHour--;

	// is it midnight?
	if ( myHour < 1 )
	{		
		myHour = 12;
		
	// afternoon/evening
	} else if ( myHour > 12 ) {
				
		myHour -= 12;
	}

	return myHour;	
}


- (int) hourIn24HourFormat{
	int myHour = CFCalendarGetOrdinalityOfUnit (
	   [self calendar],
	   kCFCalendarUnitHour,
	   kCFCalendarUnitDay,
	   [self absoluteTime]
	);

	// adjust for real-world expectations
	// otherwise, 3:45 is '4' (fouth hour)	
	myHour--;
	
	return myHour;
}


- (int) minute{
	int myMinute = CFCalendarGetOrdinalityOfUnit (
	   [self calendar],
	   kCFCalendarUnitMinute,
	   kCFCalendarUnitHour,
	   [self absoluteTime]
	);
	
	// adjust for real-world expectations
	// otherwise, 3:10 is '11' (eleventh minute)
	myMinute--;
	
	return myMinute;	
}


- (int) second{
	int mySecond = CFCalendarGetOrdinalityOfUnit (
	   [self calendar],
	   kCFCalendarUnitSecond,
	   kCFCalendarUnitMinute,
	   [self absoluteTime]
	);
	
	// adjust for real-world expectations
	// otherwise, 3:10:09 is '10' (tenth second)
	mySecond--;
	
	return mySecond;
}


- (int) daysInMonth{
	CFRange r = CFCalendarGetRangeOfUnit (
	   [self calendar],
	   kCFCalendarUnitDay,
	   kCFCalendarUnitMonth,
	   [self absoluteTime]
	);
	
	return r.length;
}


- (NSString *) dayName{
	unsigned currentDay = [self dayOfWeek];
	return [_dayNames objectAtIndex: (currentDay-1)];
}


- (NSString *) monthName{
	unsigned currentMonth = ([self month] - 1);
	return [_monthNames objectAtIndex: currentMonth];
}


// go forward in time by one unit

- (void) moveToNextDay{
	[self adjustDays: 1];
}


- (void) moveToNextMonth{
	[self adjustMonths: 1];
}


- (void) moveToNextYear{
	[self adjustYears: 1];	
}


// go back in time by one unit

- (void) moveToPreviousDay{
	[self adjustDays: -1];
}


- (void) moveToPreviousMonth{
	[self adjustMonths: -1];
}


- (void) moveToPreviousYear{
	[self adjustYears: -1];
}


// go back or forward in time an arbitrary number
// of units. negative numbers go backwards

- (void) adjustDays: (int)days{
	CFAbsoluteTime   newTime = [self absoluteTime];
	
	// calculate absolute time for new object
	// declaring the format separately suppresses warnings
	
	const char format[] = "d";
	CFCalendarAddComponents ( [self calendar], &newTime, 0, format, days );
	[self setAbsoluteTime: newTime];
}


- (void) adjustMonths: (int)months{
    CFAbsoluteTime   newTime = [self absoluteTime];

	// calculate absolute time for new object
	// declaring the format separately suppresses warnings
	
	if ( [THCalendarInfo defaultRoundingRule] == SDCalendarExactCountRule )
	{
		const char dFormat[] = "d";
		CFCalendarAddComponents ( [self calendar], &newTime, 0, dFormat, (months * 30) );
			
	} else {
		
		const char mFormat[] = "M";
		CFCalendarAddComponents ( [self calendar], &newTime, 0, mFormat, months );		
	}

	[self setAbsoluteTime: newTime];
}


- (void) adjustYears: (int)years{
	// TODO: What happens if we start at Feb 29 and move one year?
		
	CFAbsoluteTime newTime = [self absoluteTime];
	
	// calculate absolute time for new object
	// declaring the format separately suppresses warnings

	const char format[] = "y";
	CFCalendarAddComponents ( [self calendar], &newTime, 0, format, years );
	[self setAbsoluteTime: newTime];
}


- (void) moveToFirstDayOfMonth{
	CFAbsoluteTime newTime = 0;
    BOOL itWorked = NO;

	// build new time from current month and year
	// but with '1' for the day

	const char format[] = "yMdHms";
			
	itWorked = CFCalendarComposeAbsoluteTime (
		[self calendar],
		&newTime,
		format,
		[self year], [self month], 1, 0, 0, 0
	);
	
	if ( itWorked )
	{
		[self setAbsoluteTime: newTime];		
	}
}


// Added by Keith Lazuka
- (void) moveToBeginningOfDay{
	CFAbsoluteTime newTime = 0;
    BOOL itWorked = NO;
    
	// build new time from current month, day and year
	// but with the time set to 00:00
    
	const char format[] = "yMdHms";
    
	itWorked = CFCalendarComposeAbsoluteTime (
                                              [self calendar],
                                              &newTime,
                                              format,
                                              [self year], [self month], [self dayOfMonth], 0, 0, 0
                                              );
	
	if ( itWorked )
        {
            [self setAbsoluteTime: newTime];		
        }
}


- (void) moveToLastDayOfMonth {
	CFAbsoluteTime newTime	= 0;
    BOOL itWorked			= NO;
	
	// build new time from current month and year
	// but with '1' for the day
	
	const char format[] = "yMdHms";
	
	itWorked = CFCalendarComposeAbsoluteTime (
											  [self calendar],
											  &newTime,
											  format,
											  [self year], [self month], [self daysInMonth], 0, 0, 0
											  );
	
	if ( itWorked )
	{
		[self setAbsoluteTime: newTime];		
	}
}


// Added by Keith Lazuka
- (int)weekOfMonth{
    return (int)CFCalendarGetOrdinalityOfUnit([self calendar], kCFCalendarUnitWeek, kCFCalendarUnitMonth, [self absoluteTime]);
}


// Added by Keith Lazuka
- (int)weeksInMonth{
	
    NSDate *savedState = [self date];
    [self moveToFirstDayOfMonth];
    int firstWeek = [self weekOfMonth];
    
    [self moveToNextMonth];
    [self moveToFirstDayOfMonth];
    [self moveToPreviousDay];
    int finalWeek = [self weekOfMonth];
    
    if (firstWeek == 0)
        finalWeek++;

    [self setDate:savedState];
    return finalWeek;
}



#pragma mark -
#pragma mark Private
- (void) setupEnglishNames{
  _dayNames = [[NSArray alloc] initWithObjects: @"일", @"월", @"화", @"수", @"목", @"금", @"토", nil];
  _monthNames = [[NSArray alloc] initWithObjects: @"1월", @"2월", @"3월", @"4월", @"5월", @"6월", @"7월", @"8월", @"9월", @"10월", @"11월", @"12월", nil];
}


#pragma mark -
#pragma mark Private Accessors

-(CFCalendarRef)calendar {
	return _calendar;
}


-(void)setCalendar:(CFCalendarRef)newCalendar{
	CFCalendarRef temp = _calendar;
	_calendar = (CFCalendarRef)CFRetain( newCalendar );
	if ( temp ) CFRelease( temp );
}


-(CFTimeZoneRef)timeZone {
	return _timeZone;
}


-(void)setTimeZone:(CFTimeZoneRef)newTimeZone{
	CFTimeZoneRef temp = _timeZone;
	_timeZone = CFRetain( newTimeZone );
	if ( temp ) CFRelease( temp );
}


- (NSArray *)dayNames {
	return [[_dayNames copy] autorelease];
}

@end
