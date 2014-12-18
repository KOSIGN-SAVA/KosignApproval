    //
//  CustomCalendarView.m
//
//  Created by changhwan lee on 11. 4. 16..
//  Copyright 2011 coocon. All rights reserved.
//

#import "CustomCalendarView.h"
#import "AllUtils.h"
#import "AllEffects.h"
#import "Constants.h"
#import "SessionManager.h"



@implementation CustomCalendarView

@synthesize checkDateYN = _checkDateYN, callback = _callback, delegate = _delegate;



#pragma mark -
#pragma mark override Method
- (void)leftButtonClicked:(UIButton *)sender {
	//만일 분기 처리가 있을 경우 Back 이나 다른 부분을 처리 하자. Back만있을 경우 함수 자체를 삭제 해도 무방.
	[super leftButtonClicked:sender];
}


- (void)rightButtonClicked:(UIButton *)sender {
	//만일 분기 처리가 있을 경우 전체메뉴일 경우이다.
	[super rightButtonClicked:sender];
}


#pragma mark -
#pragma mark datePicker function (create, cancelbutton, donebutton)

- (void)doDatePickerTodayClick:(UIButton *)button {
    [_datePicker setDate:[NSDate date]];
}


- (void)doDatePickerCancelClick:(UIButton *)button {
	[_action dismissWithClickedButtonIndex:0 animated:YES];
}


- (void)doDatePickerDoneClick:(UIButton *)button {
	[_action dismissWithClickedButtonIndex:0 animated:YES];
	[_calendarView goDate:_datePicker.date];
}


- (void)createPopupDatepicker {
	
	// create actionsheet
	_action = [[UIActionSheet alloc] initWithTitle:@"" 
										 delegate:nil 
								cancelButtonTitle:nil
						   destructiveButtonTitle:nil
								otherButtonTitles:nil];
    
	// create datePicker
	_datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 0.0f, 0.0f)];
	_datePicker.datePickerMode = UIDatePickerModeDate;
	
	// create Toolbar (datePicker close button used)
	UIToolbar *datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	datePickerToolbar.barStyle   = UIBarStyleBlackOpaque;
	[datePickerToolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	
    UIBarButtonItem *btnGoToday       = [[UIBarButtonItem alloc] initWithTitle:@"오늘" 
                                                                         style:UIBarButtonItemStyleBordered 
                                                                        target:self 
                                                                        action:@selector(doDatePickerTodayClick:)];
    
    [barItems addObject:btnGoToday];
    [btnGoToday release];
    
    UIBarButtonItem *btnFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																					  target:self 
																					  action:nil];
	[barItems addObject:btnFlexibleSpace];
	[btnFlexibleSpace release];
    
	UIBarButtonItem *btnCancel        = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																					  target:self
																					  action:@selector(doDatePickerCancelClick:)];
	[barItems addObject:btnCancel];
	[btnCancel release];
	
	UIBarButtonItem *btnDone          = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																					  target:self
																					  action:@selector(doDatePickerDoneClick:)];
	[barItems addObject:btnDone];
	[btnDone release];
	
	[datePickerToolbar setItems:barItems animated:YES];
	[barItems release];
	
	[_action addSubview:datePickerToolbar];
	[_action addSubview:_datePicker];
	
	[datePickerToolbar release];
}



#pragma mark -
#pragma mark user function (common method)
- (void)downButtonClicked:(UIButton *)button {
	[_action showInView:self.view];
	[_action setBounds:CGRectMake(0.0f, 0.0f, 320.0f, 500.0f)];
}


#pragma mark -
#pragma mark LifeCycle Method
- (id)initWithSelectedDate:(NSDate *)targetDate {
     
    self = [super init];
	
    if (self) {
		self.callback = nil;
		self.delegate = nil;
		_selectedDate = [targetDate copy];
		_checkDateYN = @"NO";
		
		_calendarView = [[KLCalendarView alloc] initWithFrame:AREA_custom_calendar_CLIENT //월간
												delegate:self 
											  targetDate:targetDate
										   animationType:CalendarAnimationTypePush
												viewType:CalendarViewTypeMonth];  //월간달력
		
		
		[self.view addSubview:_calendarView];
		_calendarView.backgroundColor = [UIColor clearColor];
        
        //create the year button on the view (right side of the title)
        UIButton *yearListButton = [[UIButton alloc] initWithFrame:CGRectMake(209.0, 7.0f, 37.0f, 39.0f)];
        [yearListButton setBackgroundImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"z21300"]] forState:UIControlStateNormal];
        [yearListButton setBackgroundImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"z21310"]] forState:UIControlStateHighlighted];
        [yearListButton addTarget:self action:@selector(downButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        yearListButton.tag = 1001;
        [_calendarView addSubview:yearListButton];
        [yearListButton release];
        
        
        // actionsheet (datepicker) create
        [self createPopupDatepicker];
        
		
	}
	
	return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
	
	//타이틀의 기본 라벨의 위치를 선정하자.
//	self.titleAlignment = UITextAlignmentCenter;
	self.title = @"CALENDAR";
//	self.navigationType	= UINavigationCenterBG;

    
    
	
	//모든 오른쪽 버튼은 동일 하다.
	[AppUtils settingRightButton:self action:@selector(rightButtonClicked:) normalImageCode:@"c01100" highlightImageCode:@"c01100"];
	
	// 배경 이미지 설정
//	self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"a10100"]]];
	
	// 달력은 흰색 배경으로 처리한다. 
	//self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"q00300"]]];
	
	
	//기본 백그라운드 이미지
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"e00100"]]];
    backgroundImage.frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    [self.view addSubview:backgroundImage];
    [backgroundImage release];
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_selectedDate release];
	[_calendarView release];
	
    
    if ([SysUtils isNull:_action] == NO) {
        [_action release];
    }
    
    if ([SysUtils isNull:_datePicker] == NO) {
        [_datePicker release];
    }
    [super dealloc];
}

#pragma mark -
#pragma mark KLCalendarViewDelegate

- (void)wasSwipedToTheLeft {
} 


- (void)wasSwipedToTheRight {
}


- (void)didChangeMonths:(KLCalendarView *)calendarView {
}


- (void)willChangeMonths:(KLCalendarView *)calendarView {
}


// 우리은행 기업뱅킹 예약이체일 지정에서 수정...........................................
- (void)calendarView:(KLCalendarView *)calendarView tappedTile:(KLTile *)aTile {
	
	@try {
		if([_checkDateYN isEqualToString:@"YES"] == YES) {
//			NSString *exceptionName = @"inputError";
//			
//			NSDate *model				= [NSDate date];
//			NSUInteger fromDateInt		= [[model dateToString:@"yyyyMMdd" localeIdentifier:@"ko_kr"] integerValue];
//			
//			NSUInteger toDateInt		= [[[[NSDate date] addMonth:6] dateToString:@"yyyyMMdd" localeIdentifier:@"ko_kr"] integerValue];
//			NSUInteger selectedDateInt	= [[aTile.date dateToString:@"yyyyMMdd" localeIdentifier:@"ko_kr"] integerValue];
			
//			if(fromDateInt > selectedDateInt || toDateInt < selectedDateInt)
//				[NSException raise:exceptionName format:@"금일전날은 선택하실수 없습니다"];
//			
//			if(aTile.holiDay)
//				[NSException raise:exceptionName format:@"공휴일은 예약이체일로 지정하실 수 없습니다."];
		}
		
		if(self.delegate && self.callback && [self.delegate respondsToSelector:self.callback])
			[self.delegate performSelector:self.callback withObject:aTile.date];
		
		aTile.selected = YES;
		
		[self.navigationController popViewControllerAnimated:YES];
	}
	@catch(NSException * e) {
		[SysUtils showMessage:[e reason]];
	}

}


- (KLTile *)calendarView:(KLCalendarView *)calendarView createTileForDate:(NSDate *)date{
	KLTile *tile = [[[KLTile alloc] init] autorelease];
//	tile.lunarDisplay = YES;
	tile.selectedImageCode = [SysUtils imageCodeToFileName:kCalendarselectedImageCode];
	tile.todayImageCode    = [SysUtils imageCodeToFileName:kCalendartodayImageCode];
	
#if _DEBUG_
//	NSLog(@" ======================    holidays [%@] ", [SessionManager sharedSessionManager].searchHolidays);
#endif
// 음력표시	
//	if (tile.lunarDisplay) {
//		if ( ([date lunarDateDay] % 5) == 0)
//			tile.lunarLabel.text = [date lunarDateToStringMMdd:@"/"]; 
//	}
	
//	NSRange holiRang = [[SessionManager sharedSessionManager].searchHolidays rangeOfString:[date dateToString:@"yyyyMMdd" localeIdentifier:@"ko_kr"]];
//	
//	if (holiRang.location != NSNotFound)
//		tile.holiDay = YES;
	
//	for (NSDate *holiDate in [SessionManager sharedSessionManager].holidays) {
//		
//		if ([holiDate isEqualToDate:[date date]]) {
//			tile.holiDay = YES;
//			break;
//		}
//	}
//	
	if (_selectedDate && [date compare:_selectedDate] == NSOrderedSame)
		((KLTile *)tile).selected = YES;
	
	
	return tile;
}



@end
