//
//  AppDelegate.m
//  ApprovalMobileApp
//
//  Created by smart on 2014. 11. 27..
//  Copyright (c) 2014년 webcash. All rights reserved.
//

#import "AppDelegate.h"
#import "AllUtils.h"
#import "Constants.h"
#import "SessionManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#if _PUSH_
    // Delegate를 먼저 설정 해주자.
    [WCPushService sharedPushService].delegate = self;
    [[WCPushService sharedPushService] startPushService:launchOptions serverAddress:kPushServerAddress types:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushStartNotification:) name:kPushStartNotification object:nil];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)PushStartNotification:(NSNotificationCenter *)note {
    
#if _PUSH_
    [[WCPushService sharedPushService] registerAPNKey:[SessionManager sharedSessionManager].userID companyID:@"bizplay"];
#endif
    
}


#if _PUSH_

#pragma mark -
#pragma mark WCPushDelegate
-(void) returnAPN:(WCPushService *)returnAPN statusCode:(WCPushStatus)statusCode errorCode:(WCPushError)errorCode errorMessage:(NSString *)errorMessage{
    switch (statusCode) {
        case WCPUSH_STATUS_MESSAGE: // Push Message 인 RemoteMessage Local Message가 넘어 온다.
            if (errorCode == WCPUSH_ERROR_NONE) {
                // notificationAPN 는 해당 Push 메세지를 담고 있는  NSDictionary 이다.
                NSLog(@"WCPush APN Message[%@]", returnAPN.notificationAPN);
                //                [self fireLocalNotification];
//                [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
            }
            break;
            
        case WCPUSH_STATUS_ERROR: // Push 설정 및 관련 오류가 넘어온다.
            [SysUtils showMessage:@"PUSH 서버와의 통신이 원할하지 않습니다. 원할한 서비스 이용을 위하여 재 로그인하여 주시기 바랍니다."];
            
            switch (errorCode) {
                case WCPUSH_ERROR_NONE:
                    //					NSLog(@"WCPush Error None");
                    break;
                case WCPUSH_ERROR_TURNOFFPUSH:
                    //					NSLog(@"WCPush Error Message[%@]", errorMessage);
                    break;
                default:
                    
                    //					NSLog(@"WCPush Error Message[%@]", errorMessage);
                    break;
            }
            break;
            
        case WCPUSH_STATUS_INFO: // 정보성 로그가 넘어온다.
            NSLog(@"Log Message[%@]", errorMessage);
            break;
            
        case WCPUSH_STATUS_GET_TOKENDEVICE: // 디바이스 토큰을 획득 했을 경우 넘어온다.
            NSLog(@"토큰 획득 및 처리 [%@]", returnAPN.deviceTokken);
            if ([returnAPN.deviceTokken isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken]]) {
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:returnAPN.deviceTokken forKey:kDeviceToken];
                
            }
            
            //            [self.viewController setDeviceTokenField:returnAPN.deviceTokken];
            break;
            
        case WCPUSH_STATUS_SET_REGISTERSERVER: // 운영서버의 정보를 활당 성공 후 전달 되어진다.
            NSLog(@"서버등록 성공 ");
            break;
            
        case WCPUSH_STATUS_SET_UNREGISTERSERVER:
            NSLog(@"서버해지 성공 ");
            break;
    }
}
#endif

@end
