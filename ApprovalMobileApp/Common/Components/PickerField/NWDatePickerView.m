//
//  NWDatePickerView.m
//  CheckBreakdownOfDealing
//
//  Created by coocon dev on 10. 4. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NWDatePickerView.h"
#import "NWDatePickerField.h"

@interface NWDatePickerField(PickerViewExtension)
// call in our picker field to now if control was hidden or not. Used
// to toggle indicator in the field.
-(void) pickerViewHidden:(BOOL)wasHidden;

@end

@implementation NWDatePickerView

@synthesize hiddenFrame;
@synthesize visibleFrame;
@synthesize field;

-(id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		tool = nil;
	}
	
	return self; 
}

-(void) dealloc {
    field = nil;
	[tool release];
    [super dealloc];
}

-(BOOL)resignFirstResponder {
	// when we resign the first responder we want to hide our selves.
    if (!self.hidden)
		[self toggle];
	
    // do what ever the control needs to do normally.
	return [super resignFirstResponder];
}

-(BOOL) canBecomeFirstResponder {
	// we need to allow this control to become the first responder
    // this allows us to hide what ever keyboards are up and allows us
    // to get a resign when we lose focus.
    return YES;
} 

-(void) sendNotification:(NSString*) notificationName {
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[NSValue valueWithCGRect:self.bounds] forKey:UIDatePickerViewBoundsUserInfoKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self.field userInfo:userInfo];
}

- (void)actionDone:(id)sender
{
	// this will toggle the indicator.
	[field pickerViewHidden:YES];
	
	// send our notification that we are about to hide.
	[self sendNotification:UIDatePickerViewWillHideNotification];
	
	// setup our animation
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.25];
	[self setFrame:hiddenFrame];	
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideOutAnimationDidStop:finished:context:)];
	[UIView commitAnimations];
	
	tool.hidden = YES;
}

-(void) toggle {
	if (self.hidden) {
		self.hidden = NO;
		
        // this will toggle the indicator.
        [field pickerViewHidden:NO];
        
        // send the notification that we are about to show.
		[self sendNotification:UIDatePickerViewWillShownNotification];
		
        // set up our animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:.25];
		[self setFrame:visibleFrame];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(slideInAnimationDidStop:finished:context:)];
		[UIView commitAnimations];
		
		
		if (!tool) {
			CGRect toolFrame = CGRectMake(0, visibleFrame.origin.y -40, 320, 40);
			
			tool = [[UIToolbar alloc] initWithFrame:toolFrame];
			tool.barStyle = UIBarStyleBlackTranslucent;
			tool.hidden = YES;
			
			UIBarButtonItem *systemItem = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
										   target:self action:@selector(actionDone:)];
			
			UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			
			//object를 삽입하자.
			NSArray *arrObject = [NSArray arrayWithObjects:spaceItem, systemItem, nil];
			[systemItem release];
			[spaceItem release];
			
			[tool setItems:arrObject animated:YES];
			[[self superview]addSubview:tool];
		}
		
        // become the first responder.
		[self becomeFirstResponder];
	}
	else {
		// this will toggle the indicator.
        [field pickerViewHidden:YES];
        
        // send our notification that we are about to hide.
		[self sendNotification:UIDatePickerViewWillHideNotification];
		
        // setup our animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:.25];
		[self setFrame:hiddenFrame];	
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(slideOutAnimationDidStop:finished:context:)];
		[UIView commitAnimations];
	}
}

- (void)slideOutAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.hidden = YES;
	tool.hidden = YES;
    [self sendNotification:UIDatePickerViewDidHideNotification];
}

- (void)slideInAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	tool.hidden =NO;
	[self sendNotification:UIDatePickerViewDidShowNotification];
}


@end
