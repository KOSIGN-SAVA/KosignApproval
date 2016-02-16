//
//  UIWebView+JavaScriptAlert.m
//  bizcard
//
//  Created by Jongil Kim on 2015. 8. 3..
//  Copyright (c) 2015년 webcash. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"
#import "JSON.h"
#import "SysUtils.h"
#import "Constants.h"
#import "WebStyleViewController.h"
#import "AppUtils.h"

@implementation UIWebView(JavaScriptAlert)

static BOOL diagStat = NO; //예,아니오 버튼의 상태를 저장할 임시 변수

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    
    [AppUtils closeWaitingSplash];
    UIAlertView *_customAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
    [_customAlert show];
    
}


- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    confirmDiag.tag = 4503;
    [confirmDiag show];
    //버튼 누르기전까지 지연.
    BOOL isWaiting = YES;
    
    do {
        
        isWaiting = NO;
        
        if (confirmDiag.hidden == NO && confirmDiag.visible == YES) {
            isWaiting = YES;
        }
        
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
        
    } while (isWaiting);
    
    return diagStat;
}

- (NSString *)webView:(UIWebView *)sender runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(id)frame {
    
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:@"알림"
                                                          message:prompt
                                                         delegate:self
                                                cancelButtonTitle:@"취소"
                                                otherButtonTitles:@"확인", nil];
    
    confirmDiag.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField       = [confirmDiag textFieldAtIndex:0];
    textField.text               = defaultText;
    
    [confirmDiag show];
    
    
    while (confirmDiag.hidden == NO && confirmDiag.visible == YES)
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    
    if (diagStat == YES) {
        return [[confirmDiag textFieldAtIndex:0] text];
    } else {
        return nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //index 0 : NO , 1 : Yes
    
    if (buttonIndex == 0){
        
        diagStat = NO;
        
    } else if (buttonIndex == 1) {
        
        diagStat = YES;
    }
}

@end