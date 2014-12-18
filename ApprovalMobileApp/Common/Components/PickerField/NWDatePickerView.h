//
//  NWDatePickerView.h
//  CheckBreakdownOfDealing
//
//  Created by coocon dev on 10. 4. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NWDatePickerField;

@interface NWDatePickerView : UIDatePicker {
@private
	CGRect hiddenFrame;
	CGRect visibleFrame;
	NWDatePickerField* _field;
	UIToolbar *tool;
	
}

@property(nonatomic, assign) CGRect hiddenFrame;
@property(nonatomic, assign) CGRect visibleFrame;
@property(nonatomic, assign) NWDatePickerField* field;

-(void) toggle;

@end 
