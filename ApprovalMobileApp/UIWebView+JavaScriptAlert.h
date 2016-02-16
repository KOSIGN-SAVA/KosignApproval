//
//  UIWebView+JavaScriptAlert.h
//  bizcard
//
//  Created by Jongil Kim on 2015. 8. 3..
//  Copyright (c) 2015년 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

- (NSString *)webView:(UIWebView *)sender runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(id)frame;

@end