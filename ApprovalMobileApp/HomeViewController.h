//
//  HomeViewController.h
//  ApprovalMobileApp
//
//  Created by knm on 2014. 12. 10..
//  Copyright (c) 2014년 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"

@interface HomeViewController : WCViewController <UIWebViewDelegate> {
    
    __weak IBOutlet UIWebView *mainWebView;
    
    // Constraints
    __weak IBOutlet NSLayoutConstraint *webViewLeftConstraint;
    __weak IBOutlet NSLayoutConstraint *webViewRightConstraint;
    __weak IBOutlet NSLayoutConstraint *tabViewLeftConstraint;
    __weak IBOutlet NSLayoutConstraint *tabViewRightConstraint;
}

@end
