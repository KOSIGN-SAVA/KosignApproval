//
//  UIView_Effect.m
//
//  Created by donghwan kim on 11. 3. 24..
//  Copyright 2011 webcash. All rights reserved.
//

#import "UIView+Effect.h"


@implementation UIView (Effect) 

- (BOOL)findAndResignFirstResonder{
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResonder])
            return YES;
    }
    return NO;
}


@end
