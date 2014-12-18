//
//  CDatePickerViewEx.h
//  MonthYearDatePicker
//
//  Created by Igor on 18.03.13.
//  Copyright (c) 2013 Igor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CDatePickerViewEx : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, readonly) NSDate *date;

-(void)selectToday;

@end
