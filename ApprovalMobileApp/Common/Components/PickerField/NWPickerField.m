//
//  NWPickerField.m
//  NWFieldPicker
//
//  Created by Scott Andrew on 9/25/09.
//  Copyright 2009 NewWaveDigitalMedia. All rights reserved.
//
//  This source code is provided under BSD license, the conditions of which are listed below. 
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted 
//  provided that the following conditions are met:
//
//  • Redistributions of source code must retain the above copyright notice, this list of 
//   conditions and the following disclaimer.
//  • Redistributions in binary form must reproduce the above copyright notice, this list of conditions
//   and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  • Neither the name of Positive Spin Media nor the names of its contributors may be used to endorse or 
//   promote products derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY 
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
//  DAMAGE.

#import "NWPickerField.h"
#import "NSString+NSArrayExtension.h"
#import "NWPickerView.h"
#import "SysUtils.h"


NSString* UIPickerViewBoundsUserInfoKey = @"UIPickerViewBoundsUserInfoKey"; 
NSString* UIPickerViewWillShownNotification = @"UIPickerViewWillShownNotification";
NSString* UIPickerViewDidShowNotification = @"UIPickerViewDidShowNotification";
NSString* UIPickerViewWillHideNotification = @"UIPickerViewWillHideNotification";
NSString* UIPickerViewDidHideNotification = @"UIPickerViewDidHideNotification";



@implementation NWPickerField

@synthesize delegate;
@synthesize formatString;
@synthesize value;
@synthesize key = _key;

-(BOOL)canBecomeFirstResponder{
	return YES;
}


-(BOOL) becomeFirstResponder{
	// we will toggle our view here. This allows us to react properly 
    // when in a table cell.
    if (pickerView.hidden = YES)
        [pickerView toggle];
	
    return YES;
}


-(void) dealloc {
	delegate = nil;
	
    // clean up..
	[pickerView release];
	[componentStrings release];
	[componentKeys release];
	[formatString release];
	[indicator release];
    
	[super dealloc];
}


-(void) didMoveToSuperview { 
	// lets create a hidden picker view.
	pickerView = [[NWPickerView alloc] initWithFrame:CGRectZero];
	pickerView.hidden = YES;
	pickerView.dataSource = self;
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
	pickerView.field = self;
    pickerView.backgroundColor = [UIColor whiteColor];
	
	// lets load our indecicator image and get its size.
	//CGRect bounds = self.bounds;
	
	UIImage* image = [UIImage imageNamed:[SysUtils imageCodeToFileName:@"e03200"]];
	UIImage *stretchableButtonImageNormal = [image stretchableImageWithLeftCapWidth:32 topCapHeight:0];
	
	//CGSize imageSize = stretchableButtonImageNormal.size;
	// create our indicator imageview and add it as a subview of our textview.
	//CGRect imageViewRect = CGRectMake((bounds.origin.x + bounds.size.width) - imageSize.width -1/*- 5*/, (bounds.size.height/2) - (imageSize.height/2), imageSize.width, imageSize.height);
	//CGRect imageViewRect = CGRectMake((bounds.origin.x ), (bounds.size.height/2) - (imageSize.height/2), bounds.size.width, imageSize.height);
    //	indicator = [[UIImageView alloc] initWithFrame:imageViewRect];
	[self addSubview:indicator];
	indicator.image = stretchableButtonImageNormal;
	indicator.hidden = NO;
	
    // set our default format string.
	self.formatString = @"%@";
}


-(void) didMoveToWindow {
	UIWindow* appWindow = [self window];
    
	
	UIViewController* viewCtrl;
	
    // the app window can be null when being popped off 
    // the controller stack.
	if (appWindow != nil) {
		
        CGRect windowBounds;
		
        //		if ([SysUtils isPad] == NO) {
        windowBounds = [appWindow bounds];
        //		} else {
        //			if (delegate && [delegate isKindOfClass:[UIViewController class]]) {
        //				viewCtrl = ((UIViewController*)delegate);
        //				windowBounds = [viewCtrl.view bounds];
        //			} else {
        //				windowBounds = [appWindow bounds];
        //			}
        //		}
		
		
		CGRect pickerHiddenFrame;
		CGRect pickerVisibleFrame;
		
		// caluclate our hidden rect.
		pickerHiddenFrame = windowBounds;
		pickerHiddenFrame.origin.y = pickerHiddenFrame.size.height + 216;
		pickerHiddenFrame.size.height = 216;
		
		// calucate our visible rect
		
		pickerVisibleFrame = windowBounds;
		pickerVisibleFrame.origin.y = windowBounds.size.height - 216;
		pickerVisibleFrame.size.height = 216;
        
		
        // tell the picker view the frames.
        pickerView.hiddenFrame = pickerHiddenFrame;
        pickerView.visibleFrame = pickerVisibleFrame;
        
        // set the initial frame so its hidden.
        pickerView.frame = pickerHiddenFrame;
        
        // add the picker view to our window so its top most like a keyboard.
		if ([SysUtils isPad] == NO) {
			[appWindow addSubview:pickerView];
		} else {
			if (delegate && [delegate isKindOfClass:[UIViewController class]]) {
				viewCtrl = ((UIViewController*)delegate);
				[viewCtrl.view addSubview:pickerView];
			} else {
				[appWindow addSubview:pickerView];
			}
		}
	}
}


-(void) selectRowFirst {
	
	int component = 0;
	// select the first items in each component by default.
	for (component = 0; component < [pickerView numberOfComponents]; component++) 
        [self selectRow:0 inComponent:component animated:NO];
}

-(void) selectRowSecond {
	
	int component = 0;
	// select the first items in each component by default.
	for (component = 0; component < [pickerView numberOfComponents]; component++) 
        [self selectRow:1 inComponent:component animated:NO];
}




-(void) pickerViewHidden:(BOOL)wasHidden {
	//UIImage* image = [UIImage imageNamed:[SysUtils imageCodeToFileName:@"e03200"]];
	//UIImage *stretchableButtonImageNormal = [image stretchableImageWithLeftCapWidth:32 topCapHeight:0];
    //	indicator.image = stretchableButtonImageNormal;//[UIImage imageNamed:[SysUtils imageCodeToFileName:@"e03200"]];	
    /*	
     if (wasHidden){
     CGRect imageViewRect = CGRectMake((bounds.origin.x ), (bounds.size.height/2) - (imageSize.height/2), bounds.size.width, imageSize.height);
     
     indicator.image = stretchableButtonImageNormal;//[UIImage imageNamed:[SysUtils imageCodeToFileName:@"e03200"]];	
     }else {
     indicator.image = [UIImage imageNamed:[SysUtils imageCodeToFileName:@"e03200"]];	
     } 
     */ 
}

#pragma mark -
#pragma mark UIPickerView wrappers
#pragma mark -

-(void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
	
	// when selection is given then make sure we update our edit control and the picker.
	[pickerView selectRow:row inComponent:component animated:animated];
	[self pickerView:pickerView didSelectRow:row inComponent:component];
}


-(NSInteger) selectedRowInComponent:(NSInteger)component {
    return [pickerView selectedRowInComponent:component];
}

#pragma mark -
#pragma mark UIPickerViewDataSource handlers
#pragma mark -

// returns the number of 'columns' to display.
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	// we always have 1..
	NSInteger count = [delegate numberOfComponentsInPickerField:self];
	NSInteger item = 0;
	
    // if we have component strings release them.
    if (componentStrings != nil)
        [componentStrings release];
    
    
	
	componentStrings = [[NSMutableArray alloc] init];
	
    // put a blank place holder in here for nothing.
	for (item = 0; item < count; item++) {
		[componentStrings addObject:@""];
	}
    
	return count;
}


-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {	
	NSInteger cnt = [delegate pickerField:self numberOfRowsInComponent:component];
	
	if (component == 0){
		if (componentKeys != nil)
			[componentKeys release];
		
		componentKeys = [[NSMutableArray alloc] init];
		
		for (int item = 0; item < cnt; item++) {
			if (delegate && [delegate respondsToSelector:@selector(pickerField:keyForRow:forComponent:)]){
				NSString *strObj = [delegate pickerField:self keyForRow:item forComponent:component];
				[componentKeys addObject:strObj];
			} else {
				[componentKeys addObject:@""];
			}
		}
        //		_key = [componentKeys objectAtIndex:0];
	}
	return cnt;
}


-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [delegate pickerField:self titleForRow:row forComponent:component];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSString* string = [delegate pickerField:self titleForRow:row forComponent:component];
	[componentStrings replaceObjectAtIndex:component withObject:string];
	
	if (component == 0){
		if (delegate && [delegate respondsToSelector:@selector(pickerField:keyForRow:forComponent:)]){
			_key = [componentKeys objectAtIndex:row];	
		} 
	}
    
	self.text = [NSString stringWithFormat:formatString array:componentStrings];
	
    if (self.hidden == NO){
		[delegate pickerFieldDidEndEditing:self];
	}	
}


-(void)titleFromkey:(NSString *)keyData{
	if (delegate && [delegate respondsToSelector:@selector(pickerField:keyForRow:forComponent:)]){
		for (int i=0; i<[componentKeys count]; i++){
#if _DEBUG_
			NSLog(@"keyData[%@] indexofData[%@] index[%d]",keyData, [componentKeys objectAtIndex:i], i);	
#endif
			if ([[componentKeys objectAtIndex:i] isEqualToString:keyData]){
				[self pickerView:pickerView didSelectRow:i inComponent:0];		
				break;
			}
		}	
	}
}


-(void)reloadData {
	self.text = @"";
    //	self.key = @"";
	[pickerView reloadAllComponents];
}

#pragma mark -
#pragma mark NWPickerView delegate
-(void)closedPickerViewInPickerField:(NWPickerField *)pickerField {
    
    //NSLog(@"NWPickerField closedPickerViewInPickerField .......................................");
    
    // NWPickerView Delegate - closedPickerView
    if (delegate && [delegate respondsToSelector:@selector(closedPickerViewInPickerField:)])
        [delegate closedPickerViewInPickerField:self];
    
    return;
}




@end
