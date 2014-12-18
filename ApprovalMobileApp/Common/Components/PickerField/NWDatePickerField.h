//
//  NWDatePickerField.h
//  CheckBreakdownOfDealing
//
//  Created by coocon dev on 10. 4. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString* UIDatePickerViewBoundsUserInfoKey;

extern NSString* UIDatePickerViewWillShownNotification;
extern NSString* UIDatePickerViewDidShowNotification;
extern NSString* UIDatePickerViewWillHideNotification;
extern NSString* UIDatePickerViewDidHideNotification;

@class NWDatePickerView;

@interface NWDatePickerField : UITextField {
@private
    NWDatePickerView*			pickerView;
	NSDate *minDate, *maxDate, *date;
	UIImageView*				indicator;
}

@property(nonatomic, retain) NSDate*	date;
@property(nonatomic, retain) NSDate*	minDate;
@property(nonatomic, retain) NSDate*	maxDate; 

@end