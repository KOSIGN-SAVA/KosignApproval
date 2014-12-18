//
//  NWDatePickerField.m
//  CheckBreakdownOfDealing
//
//  Created by coocon dev on 10. 4. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NWDatePickerField.h"

#import "NSString+NSArrayExtension.h"
#import "NWDatePickerView.h"
#import "SysUtils.h"

NSString* UIDatePickerViewBoundsUserInfoKey = @"UIDatePickerViewBoundsUserInfoKey";
NSString* UIDatePickerViewWillShownNotification = @"UIDatePickerViewWillShownNotification";
NSString* UIDatePickerViewDidShowNotification = @"UIDatePickerViewDidShowNotification";
NSString* UIDatePickerViewWillHideNotification = @"UIDatePickerViewWillHideNotification";
NSString* UIDatePickerViewDidHideNotification = @"UIDatePickerViewDidHideNotification";

@implementation NWDatePickerField

@synthesize minDate, maxDate, date;

-(void)setMinDate:(NSDate*)inputDate {
	if (inputDate) [inputDate retain];
	if (minDate) [minDate release];
	
	minDate = inputDate;
}


-(void)setMaxDate:(NSDate*)inputDate { 
	if (inputDate) [inputDate retain];
	if (maxDate) [maxDate release];
	maxDate = inputDate;
}


-(NSDate*)date {
	return date;
}


-(void)setDate:(NSDate*)inputDate {
	if (inputDate) [inputDate retain];
	if (date) [date release];
	
	date = inputDate;
	
	if (date) {
		[pickerView setDate:date animated:NO];
		self.text = [[date description] substringWithRange: NSMakeRange(0, 10)];
	}
}


-(BOOL)canBecomeFirstResponder {
	return YES;
}


-(BOOL)becomeFirstResponder {
	// we will toggle our view here. This allows us to react properly 
    // when in a table cell.
	[pickerView setDate:date animated:YES];
	if (minDate)
		pickerView.minimumDate = minDate;

	if (maxDate)
		pickerView.maximumDate = maxDate;
	
    if (pickerView.hidden = YES)
        [pickerView toggle];
	
    return YES;
}


-(void)dealloc {
//	delegate = nil;
	self.date = nil;
	self.maxDate = nil;
	self.minDate = nil;
	
    // clean up..
	[pickerView release];
	[indicator release];

	[super dealloc];
}


-(void)didMoveToSuperview {
	// lets create a hidden picker view.
	pickerView = [[NWDatePickerView alloc] initWithFrame:CGRectZero];
	[pickerView addTarget:self action:@selector(datePickerSelect) forControlEvents:(UIControlEvents)UIControlEventValueChanged];
	pickerView.hidden = YES;
	pickerView.datePickerMode = UIDatePickerModeDate;
	pickerView.field = self;
	//pickerView.showsSelectionIndicator = YES;
	
	// lets load our indecicator image and get its size.
	CGRect bounds = self.bounds;
//	
	//UIImage* image = [UIImage imageNamed:@"e00800_a.png"];
	UIImage* image = [UIImage imageNamed:@"e03200_a.png"];
	CGSize imageSize = image.size;
//	
//	 create our indicator imageview and add it as a subview of our textview.
	CGRect imageViewRect = CGRectMake((bounds.origin.x + bounds.size.width) - imageSize.width -1/*- 5*/, (bounds.size.height/2) - (imageSize.height/2), imageSize.width, imageSize.height);
	indicator = [[UIImageView alloc] initWithFrame:imageViewRect];
	[self addSubview:indicator];
	indicator.image = image;
	indicator.hidden = NO;
//	
    // set our default format string.
//	self.formatString = @"%@";
}


-(void)pickerViewHidden:(BOOL)wasHidden {
	// hide our show our indicator when notified by the picker.
//	if (wasHidden){
//		indicator.image = [UIImage imageNamed:@"e00800_a.png"];	
//	}else {
//		indicator.image = [UIImage imageNamed:@"e00810_a.png"];	
//	}
	if (wasHidden){
		indicator.image = [UIImage imageNamed:@"e03200_a.png"];	
	}else {
		indicator.image = [UIImage imageNamed:@"e03200_a.png"];	
	}
	
	//	indicator.hidden = wasHidden;
}


-(void)didMoveToWindow {
	UIWindow* appWindow = [self window];
    
    // the app window can be null when being popped off 
    // the controller stack.
	if (appWindow != nil) {
        
		
		CGRect windowBounds = [appWindow bounds];
		
        // caluclate our hidden rect.
        CGRect pickerHiddenFrame = windowBounds;
        pickerHiddenFrame.origin.y = pickerHiddenFrame.size.height+216;
        pickerHiddenFrame.size.height = 216;
		
        // calucate our visible rect
        CGRect pickerVisibleFrame = windowBounds;
        pickerVisibleFrame.origin.y = windowBounds.size.height - 216;
        pickerVisibleFrame.size.height = 216;
		
        // tell the picker view the frames.
        pickerView.hiddenFrame = pickerHiddenFrame;
        pickerView.visibleFrame = pickerVisibleFrame;
		
        // set the initial frame so its hidden.
        pickerView.frame = pickerHiddenFrame;
		
        // add the picker view to our window so its top most like a keyboard.
		[appWindow addSubview:pickerView];
		
        //int component = 0;
		
        // select the first items in each component by default.
		//        for (component = 0; component < [pickerView numberOfComponents]; component++) 
		//            [self selectRow:0 inComponent:component animated:NO];
    }
}


-(void)datePickerSelect {
	self.date = pickerView.date;
}

@end
