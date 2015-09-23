
#import "KLCalendarView.h"
#import "KLCalendarModel.h"
#import "KLGridView.h"
#import "THCalendarInfo.h"
#import "KLGraphicsUtils.h"
#import "Constants.h"
#import "DateUtils.h"
#import "SysUtils.h"

@interface KLCalendarView ()
- (void)addUI;
- (void)addTilesToGrid:(KLGridView *)grid;
- (void)refreshViewWithPushDirection:(UIViewAnimationTransition)transition;
- (void)showPreviousMonth;
- (void)showPreviousYear;
- (void)showFollowingMonth;
- (void)showFollowingYear;
@end

@implementation KLCalendarView
@synthesize delegate; 
@synthesize grid = _grid;
@synthesize animationType = _animationType;
@synthesize calendarType  = _calendarType;
@synthesize _weekNumberOfMonth;

- (CGFloat)headerHeight {
	return 
	(_headerMonthImage && _headerWeekImage) ? 
	_headerWeekImage.frame.origin.y + _headerWeekImage.frame.size.height : 0.13707f * self.bounds.size.height;
}


- (id)initWithFrame:(CGRect)frame 
		   delegate:(id <KLCalendarViewDelegate>)aDelegate
		 targetDate:(NSDate *)targetDate
	  animationType:(CalendarAnimationType)type
		   viewType:(CalendarVeiwType)calendarViewType {
	
    if (![super initWithFrame:frame])
        return nil;
	
	_calendarType      = calendarViewType; //주간, 월간 Type 지정
	_weekNumberOfMonth = 0;  // 1달중의 몇번째 주 (초기화)
    
    if (_calendarType == MainCalendarViewTypeMonth){ //월간
//        _headerMonthImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:kCalendarheaderMonthImageName]]];
//        _headerMonthImage.frame = Main_headerMonth_ImageRect;
//        [self addSubview:_headerMonthImage];
//        
    }else{
        _headerMonthImage = [[UIImageView alloc] init];
        _headerMonthImage.frame = AREA_headerMonth_ImageRect;
//        [self addSubview:_headerMonthImage];
        
        _headerWeekImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:kCalendarheaderWeekImageName]]];
        _headerWeekImage.frame = AREA_headerWeek_ImageRect; 
//        [self addSubview:_headerWeekImage];
    }


	if (_calendarType == CalendarViewTypeWeek) {
		_gridDayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:kCalendarWeeklygridImageName]]];
		_gridDayImage.frame = AREA_Weekly_grid_ImageRect; // 
	} else if (_calendarType == CalendarViewTypeMonth){ //월간
		_gridDayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:kCalendargridImageName]]];
		_gridDayImage.frame = AREA_grid_ImageRect; // 
	} else if (_calendarType == MainCalendarViewTypeMonth){ //메인 월간
		_gridDayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:kCalendargridImageName]]];
		_gridDayImage.frame = CGRectMake(0, 0, 300.0f, 200); //
	}
	
    
    _headerWeekImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:kCalendarheaderWeekImageName]]];
    _headerWeekImage.frame = AREA_headerWeek_ImageRect;
    [self addSubview:_headerWeekImage];

    self.delegate = aDelegate;
    self.backgroundColor = [UIColor clearColor];
	//해당 아래의 옵션을 주면 사이즈의 문제가 발생.  htjulia
	//    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//    self.autoresizesSubviews = YES;
    _trackedTouchPoints = [[NSMutableArray alloc] init];
    _model = [[KLCalendarModel alloc] init];
	
	if (targetDate){
		_model.selectedDate = targetDate;
		_selectedDate = [targetDate copy];
	} else {
		_model.selectedDate = [NSDate date];
		_selectedDate = [[NSDate date] copy];
	}

	
	_animationType = type;
	
    [self addUI];     // Draw the calendar itself (arrows, month & year name, empty grid)
    [self refreshViewWithPushDirection:0]; // add tiles to the grid    
    
    return self;
}


- (void)refreshCalendar{
	[self refreshViewWithPushDirection:0];
}


// Draw the day names (Sunday, Monday, Tuesday, etc.) across the top of the grid
- (void)drawDayNamesInContext:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, kTileRegularTopColor);
    
    UIColor *aColor =  RGB(136, 136, 136);
    [aColor setFill];
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0.0f, -1.0f), 1.0f, kWhiteColor);
	
	NSArray *dayNames = [_model dayNames];
	
	NSUInteger columnIndex = 0;
	for (NSString *header in dayNames) {
        CGFloat columnWidth = 300 / 7;
        CGFloat fontSize = 0.25f * columnWidth;
        CGFloat xOffset = columnIndex * columnWidth;
        CGFloat yOffset = (2.94f * [self headerHeight]) - fontSize+10;
        
//        [header drawInRect:CGRectMake(xOffset, yOffset, columnWidth, fontSize) withFont: [UIFont boldSystemFontOfSize:11] lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];
#ifdef IS_IOS_7_OR_LATER 
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode            = NSLineBreakByClipping;
        paragraphStyle.alignment                = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:11], NSParagraphStyleAttributeName: paragraphStyle};
        
        [header drawInRect:CGRectMake(xOffset, yOffset, columnWidth, fontSize) withAttributes:attributes];
#else
        [header drawInRect:CGRectMake(xOffset, yOffset, columnWidth, fontSize) withFont: [UIFont boldSystemFontOfSize:11] lineBreakMode: NSLineBreakByClipping alignment: AlignmentCenter];
#endif
        
		columnIndex++;
	}
    
    CGContextRestoreGState(ctx);
}



// --------------------------------------------------------------------------------------------
// Draw the subtle gray vertical gradient behind the month, year, arrows, and day names
//
// 타이틀의 배경에 색상을 설정함 
- (void)drawGradientHeaderInContext:(CGContextRef)ctx{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef rawColors[2] = { kCalendarHeaderLightColor, kCalendarHeaderDarkColor };
    CFArrayRef colors = CFArrayCreate(NULL, (void*)&rawColors, 2, NULL);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,0), CGPointMake(0, [self headerHeight]), kCGGradientDrawsBeforeStartLocation);
    
    CGGradientRelease(gradient);
    CFRelease(colors);
    CGColorSpaceRelease(colorSpace);
}


// --------------------------------------------------------------------------------------------
//
// 타이틀 배경 영역을 그림
- (void)drawRect:(CGRect)frame{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if (!_headerMonthImage)
		[self drawGradientHeaderInContext:ctx];
  
//	if (!_headerWeekImage)
		[self drawDayNamesInContext:ctx];
}


// --------------------------------------------------------------------------------------------
//
// 선택한 날짜를 반전
- (void)tileInSelectedMonthTapped:(KLTile *)tile{
 
     _model.selectedDate = tile.date;

	[self.grid deselectAllTiles];
    [self.delegate calendarView:self tappedTile:tile];
}

// --------------------------------------------------------------------------------------------
// 
//      Add tiles for each date in the weeks of the selected month to the scene.
//      This is called when the calendar is first loaded and whenever the user
//      switches between months. The KLGridView will handle laying out the tiles.
//
//		If you're looking for places to optimize, this code should probably
//		be modified to re-use tiles instead of just trashing them to create new ones
//		every time the user switches between months.
//
//      캘린더의 일자를 계산하여 Label을 표시한다. (전월, 현재월, 다음월 고려하여 표시)
//      버튼클릭 이동시 일자 재계산하여 표시한다.
//
- (void)addTilesToGrid:(KLGridView *)grid{
	NSUInteger dayCount = 0; // 전체 일수 체크를 위해 사용한다.
	NSUInteger daysInPreMonth = [[_model daysInFinalWeekOfPreviousMonth] count]; // 전달 마지막주의 일수 
	
#if DEBUG
	NSLog(@"daysInPreMonth: %d", daysInPreMonth);
#endif
	BOOL selectedday = NO;
    // tiles for dates that belong to the final week of the previous month
	// 전달 마지막주 일자를 표시한다. 
	// ---- 주간달력의 경우 이번주가 첫주가 아니면 무조건 통과 ----
    for (NSDate *date in [_model daysInFinalWeekOfPreviousMonth]) {
		
		if ((_calendarType == CalendarViewTypeWeek) && (_weekNumberOfMonth != 1)) break;
		
		dayCount++;
		KLTile *tile = [self.delegate calendarView:self createTileForDate:date];
        [tile addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        tile.date = date;
        tile.opaque = NO;
        tile.alpha = 0.4f;
		if (_selectedDate) {
            
			if ([[_selectedDate dateToString:@"yyyyMMdd"] isEqualToString:[date dateToString:@"yyyyMMdd"]]){
                
				tile.selected = YES;
				selectedday = YES;
			}
		}
		
        [grid addTile:tile];
    }
    
    // tiles for dates that belong to the selected month
	// 현재월 (선택된 월)의 일자를 표시한다. 
	// ---- 주간달력의 경우 이번주가 포함된 주간만 표시한하고 나머지 주간은 통과 ---- 
    NSArray *days = [_model daysInSelectedMonth];
	for (NSDate *date in days) {
		
		if (_calendarType == CalendarViewTypeWeek) {
			if (_weekNumberOfMonth == 1 && dayCount == 7) break;
			if (_weekNumberOfMonth  > 1 && dayCount <  7*(_weekNumberOfMonth-1) - daysInPreMonth) {
				dayCount++; 
				continue;
			}
		}
		
		dayCount++;
		KLTile *tile = [self.delegate calendarView:self createTileForDate:date];
        [tile addTarget:self action:@selector(tileInSelectedMonthTapped:) forControlEvents:UIControlEventTouchUpInside];
        tile.date = date;
		tile.opaque = NO;
		if (_model.selectedDate) {
			if ([[_model.selectedDate dateToString:@"yyyyMMdd"] isEqualToString:[date dateToString:@"yyyyMMdd"]]){
                
				tile.selected = YES;
				selectedday = YES;
			}
		}	
        [grid addTile:tile];
    }
    

    // tiles for dates that belong to the first week of the following month
	// 다음달의 첫주 일자를 표시한다. 
	// ---- 주간달력의 경우 이번주가 마지막주에 포함된 경우를 제외하고 통과한다. 
    for (NSDate *date in [_model daysInFirstWeekOfFollowingMonth]) {
		
		if ((_calendarType == CalendarViewTypeWeek) && (_weekNumberOfMonth != [_model selectedMonthNumberOfWeeks])) break;
		
		dayCount++;
		if (dayCount >= 40)
			break;
		
		KLTile *tile = [self.delegate calendarView:self createTileForDate:date];
        [tile addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
        tile.date = date;
        tile.opaque = NO;
        tile.alpha = 0.4f;
		if (_selectedDate) {
			if ([[_selectedDate dateToString:@"yyyyMMdd"] isEqualToString:[date dateToString:@"yyyyMMdd"]]){
				tile.selected = YES;
				selectedday = YES;
			}
		}
        [grid addTile:tile];
    }
	
	
	
	if (selectedday == NO){
		if (_selectedDate){ 
			[_selectedDate release];
			_selectedDate = nil;
		}
	}

}


/* calendar header UI setting */
// 년월 라벨 및 좌우 버튼 설정 
- (void)addUI {    
	if (_calendarType == CalendarViewTypeMonth)
    {
        _selectedMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(116.0f, 29.5f, 100, 22.0f)];
        _selectedMonthLabel.textColor =  RGB(34, 34, 34);       //[UIColor colorWithCGColor:kTileRegularTopColor];
        _selectedMonthLabel.backgroundColor = [UIColor clearColor];
        _selectedMonthLabel.font = [UIFont fontWithName:kDefaultFontName size:22.0f];
        _selectedMonthLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_selectedMonthLabel];
        
        UIImageView *titleImgaeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"a01500_a.png"]];
        titleImgaeView.frame = CGRectMake(123.0f, 47, 316.0f, 21);
        [self addSubview:titleImgaeView];
        [titleImgaeView release];
        
        UIImageView *titleImgaeBGView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"a01600_a.png"]];
        titleImgaeBGView.frame = CGRectMake(123.0f, 67, 315.0f, 199);
        [self addSubview:titleImgaeBGView];
        [titleImgaeBGView release];
        
        UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(91, 31, 10, 16)];
        [previousMonthButton setImage:[UIImage imageNamed:@"pre_btn.png"] forState:UIControlStateNormal];
        [previousMonthButton setImage:[UIImage imageNamed:@"pre_btn.png"] forState:UIControlStateHighlighted];
        previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:previousMonthButton];
        [previousMonthButton release];
        
        UIButton *previousMonthButtonSub = [[UIButton alloc] initWithFrame:CGRectMake(60, 16, 60, 36)];
        previousMonthButtonSub.backgroundColor = [UIColor clearColor];
        previousMonthButtonSub.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        previousMonthButtonSub.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [previousMonthButtonSub addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:previousMonthButtonSub];
        [previousMonthButtonSub release];
        
        UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(215, 31, 10, 16)];
        [nextMonthButton setImage:[UIImage imageNamed:@"next_btn.png"] forState:UIControlStateNormal];
        [nextMonthButton setImage:[UIImage imageNamed:@"next_btn.png"] forState:UIControlStateHighlighted];
        nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextMonthButton];
        [nextMonthButton release];
        
        UIButton *nextMonthButtonSub = [[UIButton alloc] initWithFrame:CGRectMake(195, 16, 60, 36)];
        nextMonthButtonSub.backgroundColor = [UIColor clearColor];
        nextMonthButtonSub.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        nextMonthButtonSub.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [nextMonthButtonSub addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextMonthButtonSub];
        [nextMonthButtonSub release];
        
        UIButton *todayButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 27, 35, 23)];
        [todayButton setImage:[UIImage imageNamed:@"today_btn.png"] forState:UIControlStateNormal];
        [todayButton setImage:[UIImage imageNamed:@"today_btn.png"] forState:UIControlStateHighlighted];
        todayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        todayButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [todayButton addTarget:self action:@selector(goToday) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:todayButton];
        [todayButton release];
        
        
        // The Grid of tiles
        self.grid = [[[KLGridView alloc] initWithFrame:CGRectMake(0, 70, 300.0f, 209)] autorelease];
        [self addSubview:self.grid];
    }

}

/* 당월 몇번째주인지 리턴한다. */
- (NSUInteger)weekOfMonth:(NSDate *)date {
	NSDate *saveDate = _model.selectedDate;
	_model.selectedDate = date;
	
	NSUInteger selectDay       = [_model.selectedDate day];
	NSUInteger weekNumber      = 0;
	
	// [[_model daysInFinalWeekOfPreviousMonth] count] : 0 ~ 6 
	//  ==> dayCntFirstWeek : 1 ~ 7
	NSUInteger dayCntFirstWeek = 7 - [[_model daysInFinalWeekOfPreviousMonth] count]; // 첫주의 일수 
	
	if (0 < selectDay && selectDay <= dayCntFirstWeek + 7*0) weekNumber = 1;
	else if (dayCntFirstWeek +7*0 < selectDay && selectDay <= dayCntFirstWeek + 7*1) weekNumber = 2;
	else if (dayCntFirstWeek +7*1 < selectDay && selectDay <= dayCntFirstWeek + 7*2) weekNumber = 3;
	else if (dayCntFirstWeek +7*2 < selectDay && selectDay <= dayCntFirstWeek + 7*3) weekNumber = 4;
	else if (dayCntFirstWeek +7*3 < selectDay && selectDay <= dayCntFirstWeek + 7*4) weekNumber = 5;
	else weekNumber = 6;
	
	_model.selectedDate = saveDate;
	return weekNumber;
}



- (void)clearAndFillGrid{
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(willChangeMonths:)])
		[self.delegate willChangeMonths:self];
	
	[self.grid removeAllTiles];
	[self addTilesToGrid:self.grid];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeMonths:)])	
		[self.delegate didChangeMonths:self];
	
}

// --------------------------------------------------------------------------------------------
// 
//      Triggered when the calendar is first created and whenever the selected month changes.
//
- (void)refreshViewWithPushDirection:(UIViewAnimationTransition)trainsition {
    // Update the header month and year
	NSDate* dateTitle = _model.selectedDate;
    NSString *monthString;
    
    switch (dateTitle.month) {
        case 1:
            monthString = [NSString stringWithFormat:@"January %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];
            break;
        case 2:
            monthString = [NSString stringWithFormat:@"February %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 3:
            monthString = [NSString stringWithFormat:@"March %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 4:
            monthString = [NSString stringWithFormat:@"April %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 5:
            monthString = [NSString stringWithFormat:@"May %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 6:
            monthString = [NSString stringWithFormat:@"June %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 7:
            monthString = [NSString stringWithFormat:@"July %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 8:
            monthString = [NSString stringWithFormat:@"August %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 9:
            monthString = [NSString stringWithFormat:@"September %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 10:
            monthString = [NSString stringWithFormat:@"October %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 11:
            monthString = [NSString stringWithFormat:@"November %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
        case 12:
            monthString = [NSString stringWithFormat:@"December %@",[dateTitle dateToString:@"yyyy" localeIdentifier:kLocaleIdentifierKOR]];

            break;
    }
    
    if (_calendarType == MainCalendarViewTypeMonth)
        _selectedMonthLabel.text = monthString;
    else
        _selectedMonthLabel.text = [dateTitle dateToString:@"yyyy년 MM월" localeIdentifier:kLocaleIdentifierKOR];

    _selectedMonthLabel.text = [dateTitle dateToString:@"yyyy.MM" localeIdentifier:kLocaleIdentifierKOR];


    if (trainsition <= 0) {   // refresh without animation

		/* 이부분에서 오늘이 포함된 주간을 체크 한다.  (초기값 세팅) */
		_weekNumberOfMonth = [self weekOfMonth:_model.selectedDate];
		
        [self clearAndFillGrid];
        return;
    }
	
    [self clearAndFillGrid];
//    [UIView commitAnimations];
}


- (void)showPreviousMonth{
    if (_calendarType == CalendarViewTypeWeek) { //주간달력
		[_model decrementWeek];
		
		if (_weekNumberOfMonth == 1) {
		    //첫주인 경우 한주이전이면 전달(이미 이동하였으므로 현재달) 마지막주가 된다.  
			_weekNumberOfMonth = [_model selectedMonthNumberOfWeeks]; //마지막주는 주의 개수와 같다. 
		} else {
			_weekNumberOfMonth--;
		}

	} else { //월간달력
		[_model decrementMonth];
        
		// 전달 마지막주가 현재주간이 된다.
		_weekNumberOfMonth = [_model selectedMonthNumberOfWeeks]; 
	}
	
    [self refreshViewWithPushDirection:UIViewAnimationTransitionCurlDown];
}
- (void)todayFollowingMonth{
    [_model setSelectedDate:[NSData data]];
    [self refreshViewWithPushDirection:UIViewAnimationTransitionCurlUp];

}

- (void)showFollowingMonth{
    if (_calendarType == CalendarViewTypeWeek) {
        
		if (_weekNumberOfMonth == [_model selectedMonthNumberOfWeeks]) {
			//이동전 달의 마지막주인경우 다음달의 첫주가 된다. 
		    _weekNumberOfMonth = 1;
		} else { //그외에는 1주씩 더한다. 
			_weekNumberOfMonth++;
		}

		[_model incrementWeek];
		
	} else {
		[_model incrementMonth];
		// 다음달 첫주가 현재주간이 된다. 
		_weekNumberOfMonth = 1;
	}

	
    [self refreshViewWithPushDirection:UIViewAnimationTransitionCurlUp];
}


- (void)showPreviousYear{
    [_model decrementYear];
    [self refreshViewWithPushDirection:UIViewAnimationTransitionCurlDown];
}


- (void)showFollowingYear{
    [_model incrementYear];
    [self refreshViewWithPushDirection:UIViewAnimationTransitionCurlUp];
}


- (NSString *)selectedMonthName{
    return [_model selectedMonthName];
}


- (NSInteger)selectedMonthNumberOfWeeks{
    return [_model selectedMonthNumberOfWeeks];
}


- (NSInteger)selectedMonth{
	return [_model selectedMonth];
}


- (NSInteger)selectedYear{
	return [_model selectedYear];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_trackedTouchPoints removeAllObjects];
    UITouch *touch = [touches anyObject];
    [_trackedTouchPoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    [_trackedTouchPoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    [_trackedTouchPoints addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
    
    if (![self.delegate respondsToSelector:@selector(wasSwipedToTheRight)]
        || ![self.delegate respondsToSelector:@selector(wasSwipedToTheLeft)])
        return;
    
    CGFloat minX, maxX, minY, maxY;
    minX = minY = INFINITY;
    maxX = maxY = 0.f;

    for (NSValue *v in _trackedTouchPoints) {
        CGPoint point = [v CGPointValue];
        minX = MIN(point.x, minX);
        maxX = MAX(point.x, maxX);
        minY = MIN(point.y, minY);
        maxY = MAX(point.y, maxY);
    }
    
    if (abs(minY-maxY) < 60) {	
		if (abs(minX-maxX) > 20) {
            // okay, it's long enough to be a swipe
            CGFloat firstX = [[_trackedTouchPoints objectAtIndex:0] CGPointValue].x;
            CGFloat lastX = [[_trackedTouchPoints lastObject] CGPointValue].x;
			
            if (firstX < lastX){
				[self showPreviousMonth];
				if (self.delegate && [self.delegate respondsToSelector:@selector(wasSwipedToTheRight)])
					[self.delegate wasSwipedToTheRight];
			}
            else{
				[self showFollowingMonth];
				if (self.delegate &&  [self.delegate respondsToSelector:@selector(wasSwipedToTheLeft)])
					[self.delegate wasSwipedToTheLeft]; 
			}
		}
    }
}


- (KLTile *)leftNeighborOfTile:(KLTile *)tile{
	return [self.grid leftNeighborOfTile:tile]; 
}


- (KLTile *)rightNeighborOfTile:(KLTile *)tile{ 
	return [self.grid rightNeighborOfTile:tile]; 
}


- (NSDate *)selectedDate {
	return _model.selectedDate;
}


- (void)setSelectedDate:(NSDate *)date{
	_model.selectedDate = date;
    [self refreshViewWithPushDirection:0]; // add tiles to the grid    
}


- (void)dealloc{

	[_headerMonthImage release]; 
	[_headerWeekImage release];
	[_gridDayImage release];
	
		
	//NSDate로 변경 하면서 해제 해주어야 한다.
	if (_selectedDate) {
		[_selectedDate release];
	}
	
    [_trackedTouchPoints release];
    [_model release];
    [_selectedMonthLabel release];
    [_grid release];
	[super dealloc];
}


/* 오늘날짜 화면으로 이동 : 화면상에 오늘이 표시되는 경우 이동하지 않는다 */
- (void)goToday{
	NSUInteger weekNubmer = [self weekOfMonth:[NSDate date]]; 
	
	if (_calendarType == CalendarViewTypeWeek) {//주간
		// 년 or 월 or 주 가 다른경우 이동한다. 
		if ([_model.selectedDate year] != [[NSDate date] year]  || [_model.selectedDate month] != [[NSDate date] month] || _weekNumberOfMonth != weekNubmer) {
			_model.selectedDate = [NSDate date];
			_weekNumberOfMonth = [self weekOfMonth:_model.selectedDate];

			if ([_model.selectedDate isEarlierThan:[NSDate date]]){
				[self refreshViewWithPushDirection:UIViewAnimationTransitionNone];
				
			} else {
				[self refreshViewWithPushDirection:UIViewAnimationTransitionNone];
			}
		}
	} else { //월간 
		//년 or 월이 현재값과 오늘과 다른경우만 이동한다. 
//		if ([_model.selectedDate year] != [[NSDate date] year]  || [_model.selectedDate month] != [[NSDate date] month]) {
			_model.selectedDate = [NSDate date];
			_weekNumberOfMonth = [self weekOfMonth:_model.selectedDate];

			if ([_model.selectedDate isEarlierThan:[NSDate date]]){
				[self refreshViewWithPushDirection:UIViewAnimationTransitionNone];
				
			} else {
				[self refreshViewWithPushDirection:UIViewAnimationTransitionNone];
			}
//		}
	}
}


/* 지정한 일자로 이동: 날짜 변경이 있으면 무조건 이동한다 (달력 재생성된) */
- (void)goDate:(NSDate *)date{
		// 날짜가 다른경우
		if([[_model.selectedDate dateToString:@"yyyyMMdd"] isEqualToString:[date dateToString:@"yyyyMMdd"]] == NO) {
			_model.selectedDate = date;
			_weekNumberOfMonth  = [self weekOfMonth:_model.selectedDate];
			
			if ([_model.selectedDate isEarlierThan:date]){
				[self refreshViewWithPushDirection:UIViewAnimationTransitionCurlUp];
			} else {
				[self refreshViewWithPushDirection:UIViewAnimationTransitionCurlDown];
			}
			
		}
}


@end