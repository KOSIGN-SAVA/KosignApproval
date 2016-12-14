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
#import <AudioToolbox/AudioServices.h>

@interface AppDelegate ()

@property (strong, nonatomic) UIView *bannerView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#if _PUSH_
    // Delegate를 먼저 설정 해주자.
    [[WCPushService sharedPushService] startPushService:launchOptions serverAddress:kPushServerAddress types:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    [WCPushService sharedPushService].delegate = self;    
    
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
    
    if ([SysUtils isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"autoTimer"]] == NO && [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoTimer"] isEqualToString:@""] == NO) {
        NSDate *todayDate = [[NSDate date] copy];
        if ([[todayDate dateToString:@"yyyyMMdd" localeIdentifier:@"ko_kr"] integerValue] > [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoTimer"] integerValue]) {
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            [userD setObject:@"" forKey:@"savePassword"];
            [userD setObject:@"N" forKey:@"isAutoLogin"];
            [userD setObject:@"" forKey:@"autoTimer"];
            [userD synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDayLogoutNotification object:self userInfo:nil];
        }
    }
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

- (UIView *)bannerView{

    if (!_bannerView) {
        UIApplication *application = [UIApplication sharedApplication];
        [application setStatusBarStyle:UIStatusBarStyleDefault animated:true];
        CGFloat barHeight = CGRectGetHeight(application.statusBarFrame);

        _bannerView = [[UIView alloc]initWithFrame:CGRectMake(0, -(barHeight + 46.0), CGRectGetWidth(self.window.frame), barHeight + 46.0)];
        _bannerView.backgroundColor = RGB(51, 81, 160);


        UIImageView *appImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, barHeight + 6.0 , 32, 32)];
        appImageView.image = [UIImage imageNamed:@"approval_app_icon_ios_87"];
        [_bannerView addSubview:appImageView];


        UILabel *appLabel = [[UILabel alloc]initWithFrame:CGRectMake(51, barHeight + 5.0 , 200 , 20)];
        appLabel.tag = 20001;
        appLabel.font = [UIFont systemFontOfSize:14.0];
        appLabel.backgroundColor = [UIColor clearColor];
        appLabel.textColor = [UIColor whiteColor];
        NSString *appTitle = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
        appLabel.text = appTitle;
        [_bannerView addSubview:appLabel];


        UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(51, barHeight + 20, CGRectGetWidth(self.window.frame) - 51, 20)];
        alertLabel.font = [UIFont systemFontOfSize:12.0];
        alertLabel.backgroundColor = [UIColor clearColor];
        alertLabel.textColor = [UIColor whiteColor];
        alertLabel.tag = 20002;
        [_bannerView addSubview:alertLabel];
    }
    
    return _bannerView;
}

- (void)banner:(NSDictionary *) userInfo {
    
    
    if (self.bannerView.superview) {
        [self deleteBanner];
    }
    
    CGFloat bannerHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 46.0;
//
//    self.bannerView = [[UIView alloc]initWithFrame:CGRectMake(0, -barHeight, CGRectGetWidth(self.window.frame), bannerHeight)];
    
    NSString *message = userInfo[@"aps"][@"alert"];
    UILabel *alertText = (UILabel *)[self.bannerView viewWithTag:20002];
    alertText.text = message;
    
    
    [self.window addSubview:self.bannerView];
    [self.window bringSubviewToFront:self.bannerView];
    
    [UIView beginAnimations:@"bannerAnimating" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopAnimatingBanner:finished:)];
    
    CGRect newRect = CGRectMake(0, 0, CGRectGetWidth(self.window.frame), bannerHeight);
    self.bannerView.frame = newRect;
    [UIView commitAnimations];
    
}

-(void)stopAnimatingBanner:(NSString *)animateID finished:(BOOL) finished {
    if ([animateID  isEqualToString: @"bannerAnimating"]) {
        [self performSelector:@selector(hideBanner) withObject:nil afterDelay:3.0];
    }else if ([animateID isEqualToString:@"bannerAnimated"]) {
        [self deleteBanner];
    }
}

-(void)hideBanner{
    
    [UIView beginAnimations:@"bannerAnimated" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopAnimatingBanner:finished:)];
    self.bannerView.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)deleteBanner {
    if (self.bannerView.superview) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBanner) object:nil];
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
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
//                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"didReceiveRemoteNotification" message:[returnAPN.notificationAPN description] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//                [alertView show];
//                
////                [[[NSBundle mainBundle]localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"]
//                UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"didReceiveRemoteNotification" message:[NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//                [alertView1 show];
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                    AudioServicesPlaySystemSound(1002);
                    [self banner:returnAPN.notificationAPN];
                }
                
                
                
                //                [self fireLocalNotification];
//                [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
            }
            break;
            
        case WCPUSH_STATUS_ERROR: // Push 설정 및 관련 오류가 넘어온다.
//            [SysUtils showMessage:@"PUSH 서버와의 통신이 원할하지 않습니다. 원할한 서비스 이용을 위하여 재 로그인하여 주시기 바랍니다."];
            
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
