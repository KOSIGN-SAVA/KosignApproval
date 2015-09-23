    //
//  GateViewCtrl.m
//  OfficeWB
//
//  Created by donghwan kim on 11. 2. 10..
//  Copyright 2011 webcash. All rights reserved.
//

#import "GateViewCtrl.h"
#import "SysUtils.h"
#import "Constants.h"
#import "SecurityManager.h"
#import "SessionManager.h"
#import "UserSettings.h"
#import "AppUtils.h"
#import "JSON.h"

@implementation GateViewCtrl

@synthesize waitingSplash = _waitingSplash;

static const NSInteger kTagWaitingView					= 5001;
static const NSInteger kTagActivityAlert                = 4444;


#pragma mark -
#pragma mark Notificaiton Method
#pragma mark -
- (void)showWaitingSplash:(NSNotification *)note {
	if ([SysUtils isNull:_waitingSplash] == YES) {
		_waitingSplash		= [[WaitingSplashView alloc] init];
		_waitingSplash.tag	= kTagWaitingView;
	}

	[self.view addSubview:_waitingSplash];

	[_waitingSplash show];
    
	self.view.userInteractionEnabled = NO;
}


- (void)closeWaitingSplash:(NSNotification *)note {
	if ([SysUtils isNull:_waitingSplash] == YES)
		return;
	
	[_waitingSplash close];

	
	UIView *viewCurrentSplash = [self.view viewWithTag:kTagWaitingView];
	
	if ([SysUtils isNull:viewCurrentSplash] == NO)
		[viewCurrentSplash removeFromSuperview];
	
	self.view.userInteractionEnabled = YES;
}


- (void)callMenu:(NSNotification *)note { 
    self.navigationBar.hidden = NO;

	if ([SysUtils isNull:note] == YES)
		return;

	
	if ([[SecurityManager sharedSecurityManager] isCanCancel]) {
		[[SecurityManager sharedSecurityManager] cancelTransaction];
	}
	
	NSInteger menuIndex = [[[note userInfo] objectForKey:kParamItemTargetData] intValue];
	NSDictionary* dicMenuInfo	= [[SessionManager sharedSessionManager].menuArray objectAtIndex:menuIndex];

	
	
	if ([SysUtils isNull:dicMenuInfo] == YES)
		return;

//	if ([[dicMenuInfo objectForKey:@"c_available_service"] boolValue] == NO){
//		[SysUtils showMessage:@"실행 할수 없는 메뉴 입니다."];
//		return;
//	}
	
	NSString *menuNm = [dicMenuInfo objectForKey:@"c_menu_url"];
	
	if ([SysUtils isNull:menuNm]) {
		return;
	}
	
    NSString *menuseq = [dicMenuInfo objectForKey:@"c_menu_seq"];

    if ([menuseq isEqualToString:@"7"]) {
        menuseq = @"WebStyleViewController";
        UIViewController *temp = [SysUtils openWithStringAndDictionary:menuseq
                                                                          action:@selector(initWithParams:)
                                                                         dicData:dicMenuInfo];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNaviBarHiddenNotification object:self userInfo:nil];

        
        if (temp){
            [self pushViewController:temp animated:YES];
            [temp release];
        }

    }else{
        UIViewController *temp = [SysUtils openWithString:menuNm action:nil paramCount:0];
        if (temp){
            [self pushViewController:temp animated:YES];
            [temp release];
        }

    }
    


	
	return;	
}

- (void)sesstionLogout:(NSNotification *)note {

    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:@"" forKey:@"savePWDString"];
    [userD setObject:@"" forKey:@"selectChildDic"];
    [userD synchronize];
    [SessionManager sharedSessionManager].menuArray = nil;
    [SessionManager sharedSessionManager].userID = nil;

    [[NSNotificationCenter defaultCenter] postNotificationName:kSegueOut object:self userInfo:nil];

}

- (void)executeErrorAction:(NSNotification *)note {
	if ([SysUtils isNull:note] == YES)
		return;
	
	NSString* sActionCode	= [[note userInfo] objectForKey:kKeyOfErrorAction];
	if ([sActionCode isEqualToString:kErrorActionCodeGoToFirstPage]) {
		//Error_action 1001 화면 첫페이지로 이동 사용안함.
		
	} else if ([sActionCode isEqualToString:kErrorActionCodeGoToHomeAfterLogout]) {
		//Error_action 1002 로그아웃 홈으로 여기서는 홈이 로그인 창으로 보면 됩니다.
		[self.navigationController dismissViewControllerAnimated:NO completion:nil];
		[self.navigationController popToRootViewControllerAnimated:NO];
        //		[self showloginView];
        [SessionManager sharedSessionManager].menuArray = nil;
        [SessionManager sharedSessionManager].userID = nil;

        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        [userD setObject:@"" forKey:@"savePWDString"];
        [userD setObject:@"" forKey:@"selectChildDic"];
        [userD synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSegueOut object:self userInfo:nil];
        
	} else if ([sActionCode isEqualToString:kErrorActionCodeGoToSpecifiedPage]) {
		//Error_action 특정페이지로 이동 1003 사용안함.
        
	} else if ([sActionCode isEqualToString:kErrorActionCodeGoToHome]) {
		//Error_action 1004 홈으로 분기
		[self.navigationController dismissViewControllerAnimated:NO completion:nil];
		[self.navigationController popToRootViewControllerAnimated:YES];
	} else if ([sActionCode isEqualToString:@"5101"]) {
		[self.navigationController popToRootViewControllerAnimated:NO];
        [SessionManager sharedSessionManager].menuArray = nil;
        [SessionManager sharedSessionManager].userID = nil;

        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        [userD setObject:@"" forKey:@"savePWDString"];
        [userD setObject:@"" forKey:@"selectChildDic"];
        [userD synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSegueOut object:self userInfo:nil];

	} else if ([sActionCode isEqualToString:kErrorActionCodeQuit]) {
		//Error_action 9999 프로그램 종료
		exit(0);
	}
}
// 하단 탭 메뉴클릭
- (void)extraCallMenu:(NSNotification *)note {
    if ([SysUtils isNull:note] == YES) 
		return;
	
	UIAlertView *alertView =nil;
	
	UIViewController *temp = nil;
	switch ([[[note userInfo] objectForKey:kParamItemTargetData] intValue]) {
		case 0: //홈으로 이동
			[self popToRootViewControllerAnimated:YES];
			break;
			
		case 1: //직원조회
			temp = [SysUtils openWithString:@"ContactSearch" action:nil paramCount:0];
			break;
			
		case 2: //메일함
			temp = [SysUtils openWithString:@"MailboxListCtl" action:nil paramCount:0];
			break;
			
		case 3: //수신결재문서
			temp = [SysUtils openWithString:@"DocMenuCtl" action:nil paramCount:0];
			break;
			
		case 4: //종료
			alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"프로그램을 종료 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
			alertView.tag =9999;
			[alertView show];
            [alertView release];
			
			break;
	}

	
	if ([[[note userInfo] objectForKey:kParamItemTargetData] intValue] == 4) {
		return;
	} 
	
	if (temp){
		[self popToRootViewControllerAnimated:NO];
		[self pushViewController:temp animated:YES];
		[temp release];
	}
}


- (void)callMyPush:(NSNotification *)note {
    UIViewController *temp = [SysUtils openWithString:@"CfMyPushRegCtrl" action:nil paramCount:0];
    
    if (temp) {
		[self pushViewController:temp animated:YES];
		[temp release];
	}
}

- (void)NaviBarHidden:(NSNotification *)note {
    self.navigationBar.hidden = YES;
}

- (void)NaviBarShow:(NSNotification *)note {
    self.navigationBar.hidden = NO;

}

- (void)NaviRootPop:(NSNotification *)note {
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)DayLogoutNotification:(NSNotification *)note {
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    GateViewCtrl* navigation = [[GateViewCtrl alloc] initWithRootViewController:rootController];
    [self presentViewController:navigation animated:NO completion:nil];
}

#pragma mark -
#pragma mark UIViewController LifeCycle Method
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([SessionManager sharedSessionManager].isFirstSetUp == false) {
//        [SessionManager sharedSessionManager].isFirstSetUp = true;
//    }else{
//        return;
//    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
#ifdef IS_IOS_7_OR_LATER
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      RGB(255, 255, 255), NSForegroundColorAttributeName,
      [UIFont fontWithName:kBoldStyleFontName size:18.0], NSFontAttributeName,nil]];
#else
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
            RGB(255, 255, 255),UITextAttributeTextColor,
            [UIFont fontWithName:kBoldStyleFontName size:18.0], UITextAttributeFont,nil]];
#endif
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6)
    {
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }else
    {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callMenu:) name:kCallMenuNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWaitingSplash:) name:kShowWaitingViewNotification object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWaitingSplash:) name:kCloseWaitingViewNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callMyPush:) name:kCallCfMyPushRegNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NaviBarHidden:) name:kNaviBarHiddenNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NaviBarShow:) name:kNaviBarShowNotification object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeErrorAction:) name:kExecuteErrorActionNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NaviRootPop:) name:kNaviRootPop object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sesstionLogout:) name:ksesstionLogout object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DayLogoutNotification:) name:kDayLogoutNotification object:nil];
    
    if ([[SessionManager sharedSessionManager].userID isEqualToString:@""]){
        
    }
//    CNPL *entity = [NSEntityDescription insertNewObjectForEntityForName:@"TestEntity" inManagedObjectContext:self.context];
//    entity.when = [NSDate date];
//    entity.what = @"Test Record";
//    entity.done = [NSNumber numberWithBool:NO];
//    
//    NSError *error = nil;
//    if ([self.context save:&error] == NO) {
//        NSLog(@"Failed to add entity: %@", [error description]);
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	
    [super dealloc];
}



#pragma mark -
#pragma mark UIAlertViewDelegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case 9999:
			if (buttonIndex == 1) {
				//프로그램 종료
				exit(0);
			}
			break;

		case 9997:
			if (buttonIndex == 1) {
				NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:kErrorActionCodeGoToHomeAfterLogout, kKeyOfErrorAction, nil];
				[[NSNotificationCenter defaultCenter] postNotificationName:kExecuteErrorActionNotification object:self userInfo:tempDic];
			}
			break;
	}
}


@end
