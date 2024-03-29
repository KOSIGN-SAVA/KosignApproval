//
//  Created by Evgeny Yagrushkin on 2012-08-15.
//  Copyright (c) 2012 Evgeny Yagrushkin. All rights reserved.
// base on
// http://stackoverflow.com/questions/3348247/uidatepicker-select-month-and-year

// TODO disable months for max and min years
// TODO return last date of the month date and last date, next last date
// TODO add to guthub
// TODO optional selection for the current month and date
// showCurrentDate

#import "UIMonthYearPicker.h"

// Identifiers of components
#define MONTH ( 1 )
#define YEAR ( 0 )

// Identifies for component views
#define LABEL_TAG 43

@interface UIMonthYearPicker()

@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;

-(NSArray *)nameOfYears;
-(NSArray *)nameOfMonths;
-(CGFloat)componentWidth;

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected;
-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(NSIndexPath *)todayPath;
-(NSInteger)bigRowMonthCount;
-(NSInteger)bigRowYearCount;
-(NSString *)currentMonthName;
-(NSString *)currentYearName;

@end

@implementation UIMonthYearPicker

const NSInteger bigRowCounts = 1;
NSInteger minYears = 2000;
NSInteger maxYears = 2030;
const CGFloat rowHeights = 44.f;
const NSInteger numberOfComponentss = 2;

@synthesize todayIndexPath;
@synthesize months;
@synthesize years = _years;
@synthesize maximumDate;
@synthesize minimumDate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.months = [self nameOfMonths];
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
    
    self.delegate = self;
    self.dataSource = self;
}

- (void) setMaximumDate:(NSDate *)aMaximumDate{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:aMaximumDate];
    maxYears = [components year];
    if (maxYears < minYears) {
        minYears = maxYears;
        minimumDate = aMaximumDate;
    }
    maximumDate = aMaximumDate;
    self.years = [self nameOfYears];
    
    [self reloadComponent:YEAR];
}

- (void) setMinimumDate:(NSDate *)aMinimumDate{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:aMinimumDate];
    minYears = [components year];
    if (maxYears < minYears) {
        maxYears = minYears;
        maximumDate = aMinimumDate;
    }
    minimumDate = aMinimumDate;
    self.years = [self nameOfYears];
    [self reloadComponent:YEAR];
}

- (void) setDate:(NSDate *)aDate{
    [self setDate:aDate animated:NO];
}

- (void) setDate:(NSDate *)aDate animated:(BOOL)animated{
    
    int dateYear;
    int dateMonth;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:aDate];
    dateMonth = [components month];
    components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:aDate];
    dateYear = [components year];
    
    [self selectRow: dateMonth - 1
        inComponent: MONTH
           animated: NO];
    
    int rowIndex = dateYear - minYears;
    if (rowIndex < 0) {
        rowIndex = 0;
    }
    
    [self selectRow: rowIndex
        inComponent: YEAR
           animated: animated];
}

-(NSDate *)date
{
    NSInteger monthCount = [self.months count];
    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
    
    NSInteger yearCount = [self.years count];
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; [formatter setDateFormat:@"yyyyMM"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@",year,month]];
    
    return date;
}

#pragma mark - UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView
           viewForRow: (NSInteger)row
         forComponent: (NSInteger)component
          reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == MONTH)
    {
        NSInteger monthCount = [self.months count];
        NSString *monthName = [self.months objectAtIndex:(row % monthCount)];
        NSString *currentMonthName = [self currentMonthName];
        if([monthName isEqualToString:currentMonthName] == YES)
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger yearCount = [self.years count];
        NSString *yearName = [self.years objectAtIndex:(row % yearCount)];
        NSString *currenrYearName  = [self currentYearName];
        if([yearName isEqualToString:currenrYearName] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent: component selected: selected];
    }
    
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return rowHeights;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self._delegate) {
        if ([self._delegate respondsToSelector:@selector(pickerView:didChangeDate:)]) {
            [self._delegate pickerView:self didChangeDate:self.date];
        }
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponentss;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return [self bigRowMonthCount];
    }
    return [self bigRowYearCount];
}

#pragma mark - Util
-(NSInteger)bigRowMonthCount
{
    return [self.months count]  * bigRowCounts;
}

-(NSInteger)bigRowYearCount
{
    return [self.years count]  * bigRowCounts;
}

-(CGFloat)componentWidth
{
    return self.bounds.size.width / numberOfComponentss;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        NSInteger monthCount = [self.months count];
        return [self.months objectAtIndex:(row % monthCount)];
    }
    NSInteger yearCount = [self.years count];
    return [self.years objectAtIndex:(row % yearCount)];
}


-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected
{
    CGRect frame = CGRectMake(0.f, 0.f, [self componentWidth],rowHeights);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = AlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.f];
    label.userInteractionEnabled = NO;
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSArray *)nameOfMonths
{
    return [[NSMutableArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];;
}

-(NSArray *)nameOfYears
{
    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = minYears; year <= maxYears; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%i", year];
        [years addObject:yearStr];
    }
    return years;
}

-(void)selectToday
{
    [self selectRow: self.todayIndexPath.row
        inComponent: MONTH
           animated: NO];
    
    [self selectRow: self.todayIndexPath.section
        inComponent: YEAR
           animated: NO];
}

-(NSIndexPath *)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year  = [self currentYearName];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            section = section + [self bigRowYearCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}


@end