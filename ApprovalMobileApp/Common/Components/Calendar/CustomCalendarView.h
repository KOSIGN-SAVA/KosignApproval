//
//  CustomCalendarView.h
//
//  Created by changhwan lee on 11. 4. 16..
//  Copyright 2011 coocon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"
#import "KLCalendarView.h"

@interface CustomCalendarView : WCViewController<KLCalendarViewDelegate> {
	KLCalendarView*   _calendarView;
	
	NSDate*           _selectedDate;
	NSString*         _checkDateYN;
	UIDatePicker*     _datePicker;
	UIActionSheet*    _action;

	SEL _callback;
	id  _delegate;
    
    
}

@property (nonatomic, assign) NSString *checkDateYN;
@property (nonatomic) SEL callback;
@property (nonatomic, assign) id delegate;


- (id)initWithSelectedDate:(NSDate *)targetDate;

@end
