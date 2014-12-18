//
//  AppDelegate.h
//  ApprovalMobileApp
//
//  Created by smart on 2014. 11. 27..
//  Copyright (c) 2014년 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecurityManager.h"
#if _PUSH_
#import "WCPushService.h"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate, SecurityManagerDelegate
#if _PUSH_
, WCPushServiceDelegate
#endif
> {
    
}

@property (strong, nonatomic) UIWindow *window;

@end

