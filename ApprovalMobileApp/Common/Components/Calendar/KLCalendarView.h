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


#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "KLTile.h"


@class KLCalendarModel, KLGridView, KLTile;
@protocol KLCalendarViewDelegate;

typedef enum {
	CalendarAnimationTypeCurl,
	CalendarAnimationTypePush
} CalendarAnimationType;

typedef enum {
    MainCalendarViewTypeMonth,
	CalendarViewTypeMonth,
	CalendarViewTypeWeek
} CalendarVeiwType;


@interface KLCalendarView : UIView
{
    IBOutlet id <KLCalendarViewDelegate> delegate;
    KLCalendarModel*		_model;
    UILabel*				_selectedMonthLabel;
    KLGridView*				_grid;
    NSMutableArray*			_trackedTouchPoints;  // the gesture's sequential position in calendar view coordinates
	
	UIImageView*			_headerMonthImage; 
	UIImageView*			_headerWeekImage; 
	UIImageView*			_gridDayImage;
	CalendarAnimationType	_animationType;
	CalendarVeiwType		_calendarType;
	NSDate*					_selectedDate;
	NSUInteger              _weekNumberOfMonth;
//	UIDatePicker*           _datePicker;
}

@property (nonatomic, assign) id <KLCalendarViewDelegate> delegate;
@property (nonatomic, retain) KLGridView *grid;
@property (nonatomic) CalendarAnimationType animationType;
@property (nonatomic) CalendarVeiwType calendarType;
@property (nonatomic) NSUInteger _weekNumberOfMonth;
@property (nonatomic, retain) NSDate *selectedDate;

- (id)initWithFrame:(CGRect)frame delegate:(id <KLCalendarViewDelegate>)delegate
		 targetDate:(NSDate *)targetDate animationType:(CalendarAnimationType)type viewType:(CalendarVeiwType)calendarViewType;

- (KLTile *)leftNeighborOfTile:(KLTile *)tile;
- (KLTile *)rightNeighborOfTile:(KLTile *)tile;
- (NSString *)selectedMonthName;
- (NSInteger)selectedMonthNumberOfWeeks;
- (NSInteger)selectedMonth;
- (NSInteger)selectedYear;
- (void)refreshCalendar;
- (void)goToday;               // 오늘날짜로 이동 
- (void)goDate:(NSDate *)date; // 특정일로 이동
- (void)showPreviousMonth;
- (void)showPreviousYear;
- (void)showFollowingMonth;
- (void)showFollowingYear;

@end

@protocol KLCalendarViewDelegate <NSObject>
@required
- (void)calendarView:(KLCalendarView *)calendarView tappedTile:(KLTile *)aTile;
- (KLTile *)calendarView:(KLCalendarView *)calendarView createTileForDate:(NSDate *)date;
- (void)didChangeMonths:(KLCalendarView *)calendarView;
- (void)willChangeMonths:(KLCalendarView *)calendarView;

@optional
- (void)wasSwipedToTheLeft;
- (void)wasSwipedToTheRight;

@end

