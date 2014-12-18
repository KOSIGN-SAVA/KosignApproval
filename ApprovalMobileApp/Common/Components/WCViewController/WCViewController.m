//
//  WCViewController.m
//
//  Created by donghwan kim on 11. 3. 25..
//  Copyright 2011 webcash. All rights reserved.
//

#import "WCViewController.h"
#import "AllUtils.h"
#import "AllEffects.h"
#import "Constants.h"
#import "JSON.h"
#import "SessionManager.h"


@implementation WCViewController
@synthesize navigationHidden		= _navigationHidden;
@synthesize navigationType			= _navigationType;
@synthesize titleAlignment			= _titleAlignment;
@synthesize defaultLeftButton		= _defaultLeftButton;
@synthesize defaultRightButton      = _defaultRightButton;
@synthesize	waitSplashEnabled       = _waitSplashEnabled;
@synthesize numberPadDoneEnabled	= _numberPadDoneEnabled;
@synthesize navigationBizType		= _navigationBizType;
@synthesize isShowKeypad			= _isShowKeypad;
@synthesize swipeEnabled            = _swipeEnabled;

static NSInteger kIndicatorSize = 32; 

#pragma mark -
#pragma mark Public Event Method
//keyboard Close 처리
- (void)closeKeyboard {
	[[self.view window] findAndResignFirstResonder];
}


- (void)leftButtonClicked:(UIButton *)sender {
    if ([[SecurityManager sharedSecurityManager] isCanCancel]) {
        [[SecurityManager sharedSecurityManager] cancelTransaction];
        [self privateCloseIndicator];
    }
    
	if (self.navigationController) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}


- (void)rightButtonClicked:(UIButton *)sender {
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"rightButton Clicked");
#endif
    [self.navigationController popToRootViewControllerAnimated:YES];
	
}


- (void)numberPadDoneHidden:(BOOL)hidden {
	if (_numberPadDoneEnabled) {
		if ([SysUtils isNull:_btnKeyboardDone] == NO) {
			_btnKeyboardDone.hidden = hidden;
		}
	}
}


- (void)sendTransaction:(NSString *)transCode requestDictionary:(NSDictionary *)requestDictionary{
	[SecurityManager sharedSecurityManager].delegate = self;
	
	NSMutableDictionary *reqDocument = [[NSMutableDictionary alloc] init];
	[reqDocument setObject:transCode forKey:kTransCode];
    [reqDocument setObject:kAuthenticationKey forKey:@"CNTS_CRTC_KEY"];
	[reqDocument setObject:requestDictionary forKey:kTransRequestData];
	
#if _DEBUG_
	NSLog(@"Request Trans[%@]", [reqDocument JSONRepresentation]);
#endif
	
	if (![[SecurityManager sharedSecurityManager] willConnect:nil query:[reqDocument JSONRepresentation] method:TRANS_METHOD_POST]) {
		[SysUtils showMessage:@"통신 처리중입니다. 잠시후 다시 시도 하여 주십시요."];
		[reqDocument release];
		return;
	}
	[reqDocument release];
	
	if (_waitSplashEnabled){
		if ([[[self.navigationController description] uppercaseString] hasPrefix:@"<GATE"]) {
//			[AppUtils showWaitingSplash];
		} else {
			
		}
	}
}


- (void)sendTransactionNew:(NSString *)transCode requestDictionary:(NSDictionary *)requestDictionary{
	[SecurityManager sharedSecurityManager].delegate = self;
	
	NSMutableDictionary *reqDocument = [[NSMutableDictionary alloc] init];
	[reqDocument setObject:transCode forKey:@"KEY"];
    
	[reqDocument setObject:[NSArray arrayWithObject:requestDictionary] forKey:@"REQ_DATA"];
	
#if _DEBUG_
	NSLog(@"Request Trans[%@]", [reqDocument JSONRepresentation]);
#endif
	
	if (![[SecurityManager sharedSecurityManager] willConnect:nil query:[reqDocument JSONRepresentation] method:TRANS_METHOD_POST]) {
		[SysUtils showMessage:@"통신 처리중입니다. 잠시후 다시 시도 하여 주십시요."];
		[reqDocument release];
		return;
	}
	[reqDocument release];
	
	if (_waitSplashEnabled){
		if ([[[self.navigationController description] uppercaseString] hasPrefix:@"<GATE"]) {
			[AppUtils showWaitingSplash];
		} else {
			
		}
	}
}


- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success {

}


- (void)privateShowIndicator {
    [SessionManager sharedSessionManager].isNetworkStuts = YES;
	self.view.userInteractionEnabled = NO;
	UIActivityIndicatorView *indicator  = (UIActivityIndicatorView *)[self.view viewWithTag:220000];

	if ([SysUtils isNull:indicator]) {
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)UIActivityIndicatorViewStyleGray];
	}
	indicator.frame	= CGRectMake(self.view.frame.size.width/2 - kIndicatorSize/2, self.view.frame.size.height/2 - kIndicatorSize/2, kIndicatorSize, kIndicatorSize);
	indicator.tag = 220000;
	indicator.hidesWhenStopped = YES;
	
	[self.view addSubview:indicator];
	[indicator startAnimating];
//	[indicator release];
}


- (void)privateCloseIndicator {
    [SessionManager sharedSessionManager].isNetworkStuts = NO;

	self.view.userInteractionEnabled = YES;
	
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:220000];
	if ([SysUtils isNull:indicator] == NO) {
		[indicator removeFromSuperview];
	}
}


//// GestureHandler
//- (void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
//    // swipe right : back button Clicked 
//    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
//        [self leftButtonClicked:nil];
//    }
//}
//
//// GestureRecognizer
//- (void)initGestureRecognizer {
//    UISwipeGestureRecognizer *swipeRecognizer;
//    
//    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
//    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRecognizer];
//    [swipeRecognizer release];


#pragma mark -
#pragma mark Private Event Method
- (void)logView:(NSArray *)array depth:(NSInteger)depth{
#if TARGET_IPHONE_SIMULATOR
	for (UIView *temp in array) {
		NSLog(@"depth[%d] [%@]", depth, [temp description]);
		if ([temp subviews] > 0) {
			[self logView:[temp subviews] depth:depth++];
		}
	}
//}

#endif	
}


- (void)titleClicked:(UIButton *)sender {
    
    
    
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"title Clicked - %@", [[self class] description]);
#endif
	if (self.navigationController) {
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}


- (void)subTitleClicked:(UIButton *)sender {
    
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"Subtitle Clicked - %@", [[self class] description]);
#endif
    
}



#pragma mark -
#pragma mark Notificaiton Method
- (void)keyboardDidShowNotification:(NSNotification *)notification {
	// Locate non-UIWindow.
	UIWindow *keyboardWindow = nil;
	
	for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
		if ([[testWindow class] isEqual:[UIWindow class]] == NO) {
			keyboardWindow = testWindow;
			break;
		}
	}
	
	if ([SysUtils isNull:keyboardWindow] == YES) 
		return;
    
    
    // Locate UIKeyboard.
	UIView *foundKeyboard = nil;
	
	for (UIView *possibleKeyboard in [keyboardWindow subviews]) {
		// iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
		if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            
            // iOS6 에서 확인버튼 처리 - 2012-10-26
            possibleKeyboard = [[possibleKeyboard subviews] lastObject];
		}
		
		if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
			foundKeyboard = possibleKeyboard;
			break;
		}
	}
	
	if ([SysUtils isNull:foundKeyboard] == NO) {
		if ([SysUtils isNull:_btnKeyboardDone.superview] == NO)
			[_btnKeyboardDone removeFromSuperview];

		//remove before button end
		[foundKeyboard addSubview:_btnKeyboardDone]; 
	}
}


- (void)keyboardWillHideNotification:(NSNotification *)notification {
	if(_btnKeyboardDone.superview)
		[_btnKeyboardDone removeFromSuperview];
}




#pragma mark -
#pragma mark UIViewController Override
- (id)init {
//	self = [super init];
	
	if ([SysUtils isNull:self] == NO) {

	}
	return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setTitle:(NSString *)aTitle {
	[super setTitle:aTitle];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor =[UIColor whiteColor];
//    label.font = [UIFont boldSystemFontOfSize:18];
//    label.text=self.title;
//    self.navigationItem.titleView = label;
    [AppUtils settingNavigationBarTitle:self title:aTitle];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}



#pragma mark -
#pragma mark LifeCycle Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
//		_isPortrait = YES;
//		_btnKeyboardDone.frame = CGRectMake(0.0f, 163.0f, 106.0f, 53.0f);
//		[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneUp_port.png"] forState:UIControlStateNormal];
//		[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneDown_port.png"] forState:UIControlStateHighlighted];
//		
//	} else {
//		_isPortrait = NO;
//		_btnKeyboardDone.frame = CGRectMake(0.0f, 124.0f, 157.0f, 38.0f);
//		[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneUp_land.png"] forState:UIControlStateNormal];
//		[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneDown_land.png"] forState:UIControlStateHighlighted];
//	}
//	
//	return _isShowKeypad;	
    return NO;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//기본 backButton 처리.
	if (_defaultLeftButton) {
		if ([SysUtils isNull:self.navigationController] == NO) {
//			if ([self.navigationController.viewControllers count] > 1)
//                [AppUtils settingLeftButton:self action:@selector(leftButtonClicked:) normalImageCode:@"Top_back.png" highlightImageCode:@"Top_back.png"];
		}
	}
    
    if (_defaultRightButton) {
        if ([SysUtils isNull:self.navigationController] == NO) {
            if ([self.navigationController.viewControllers count] > 1) {
//                [AppUtils settingRightButton:self action:@selector(rightButtonClicked:) normalImageCode:@"top_home.png" highlightImageCode:@"top_home_sel.png"];
            }
        }
    }
    
	//네비게이션바의 Hidden 처리
	if (_navigationHidden) {
        if ([SysUtils isNull:self.navigationController] == NO) {
            [self.navigationController setNavigationBarHidden:_navigationHidden animated:NO];
        }
	}
	
	if (_numberPadDoneEnabled) {
		_btnKeyboardDone = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//		if (_isPortrait == YES) {
			_btnKeyboardDone.frame = CGRectMake(0.0f, 163.0f, 106.0f, 53.0f);
			[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneUp_port.png"] forState:UIControlStateNormal];
			[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneDown_port.png"] forState:UIControlStateHighlighted];
//		} else {
//			_btnKeyboardDone.frame = CGRectMake(0.0f, 124.0f, 157.0f, 38.0f);
//			[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneUp_land.png"] forState:UIControlStateNormal];
//			[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneDown_land.png"] forState:UIControlStateHighlighted];
//		}
		
		_btnKeyboardDone.adjustsImageWhenHighlighted = NO;
		_btnKeyboardDone.tag = 9191;
		
//		if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"3"]) {
//			[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
//			[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
//		} else {        
//			[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
//			[_btnKeyboardDone setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
//		}
        
		[_btnKeyboardDone addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
		
		
		//키보드의 제어를 위한 Notificaiton
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
	}
	
	
    // 네비게이션바 배경 이미지 
	if ([SysUtils isNull:self.navigationController] ==  NO) {
        if ([SessionManager sharedSessionManager].bIsLogin == YES) {
            self.navigationController.navigationBar.frame = CGRectMake(0.0f, 20.0f, 320.0f, 44.0f);

        }

//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"bg_title.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:43] forBarMetrics:UIBarMetricsDefault];
//

        UIImage *imgNav = [[UIImage imageNamed:[SysUtils imageCodeToFileName:@"bg_title.png"]] imageScale:2];
        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:imgNav];
        
        
	}
    
    if (_swipeEnabled) {
//        [self initGestureRecognizer];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	if ([SysUtils isNull:_btnKeyboardDone] == NO) {
		_btnKeyboardDone.hidden = YES;
	}
	
	[self closeKeyboard];
	
	//키보드의 제어를 위한 Notificaiton 제거
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

}


- (void)viewDidLoad {
    [super viewDidLoad];

//    [self init];
    _navigationHidden		= NO;
    _defaultLeftButton		= YES;
    _defaultRightButton     = YES;
    _titleAlignment			= UITextAlignmentLeft;
    _numberPadDoneEnabled	= NO;
    _btnKeyboardDone		= nil;
    _waitSplashEnabled		= NO;
    _navigationType			= UINavigationLeftRightBG;
    _navigationBizType		= UINavigationBIZ;
    _isShowKeypad			= NO;
    _isPortrait				= YES;
    _swipeEnabled           = YES;
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = RGB(55,81,160);
        self.navigationController.navigationBar.translucent = NO;
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom;
        
    }else {
        self.navigationController.navigationBar.tintColor = RGB(55,81,160);

    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	if ([SysUtils isNull:_btnKeyboardDone] == YES) {
		if(_btnKeyboardDone.superview)
			[_btnKeyboardDone removeFromSuperview];

		[_btnKeyboardDone release];
	}
    
	
	[super dealloc];
}



#pragma mark -
#pragma mark SecurityManagerDelegate implementation
- (void) returnResult:(NSString *)returnResult errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage {
	[SecurityManager sharedSecurityManager].delegate = nil;

	if (_waitSplashEnabled){
		if ([[[self.navigationController description] uppercaseString] hasPrefix:@"<GATE"]) {
			[AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled = YES;		
		} else {

		}
	}
    [SessionManager sharedSessionManager].isNetworkStuts = NO;

	if (errorCode == 0) {
		NSDictionary *docDic		= [returnResult JSONValue];
		NSString *transCode			= [docDic objectForKey:kTransCode];
        NSString *transCodeMG		= @"";

        if ([SysUtils isNull:transCode]) {
            transCodeMG			= [docDic objectForKey:@"_tran_cd"];

        }
        
        NSArray *transResponses		= nil;
		NSDictionary *transResponse	= nil;
		NSString *actionCode		= nil;
		NSString *recvErrorCode		= nil;
		NSString *recvErrorMessage	= nil;
		NSString *retErrorMessage	= nil;
        
        
        transResponses		= [docDic objectForKey:kTransResponseData];
        
        if ([transCodeMG isEqualToString:@"APPR_MM0001"]){
            transResponses		= [docDic objectForKey:@"_tran_res_data"];

        }
        if ([transResponses count] > 0) {
            transResponse		= [transResponses objectAtIndex:0];
            actionCode			= [transResponse objectForKey:kResponseErrorAction];
            recvErrorCode		= [transResponse objectForKey:kResponseErrorCode];
            recvErrorMessage	= [transResponse objectForKey:kResponseErrorMsg];
        }else{
            actionCode			= [docDic objectForKey:kResponseErrorAction];
            recvErrorCode		= [docDic objectForKey:kResponseErrorCode];
            recvErrorMessage	= [docDic objectForKey:kResponseErrorMsg];
        }
        
        if (([recvErrorCode isEqualToString:@"0001"] || [recvErrorCode isEqualToString:@"1004"]) && [[SessionManager sharedSessionManager].userID isEqualToString:@""] == NO)
        {
            [AppUtils closeWaitingSplash];
            self.view.userInteractionEnabled = YES;
            [SessionManager sharedSessionManager].userID = @"";
            [SessionManager sharedSessionManager].sessionOutString = @"Y";
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
            
        }
        
		// action code 또는 return error code에 값이 있다면 오류이다.
		if (((actionCode != nil) && ([actionCode isEqualToString:@""] == NO)) || ((recvErrorCode != nil) && ([recvErrorCode isEqualToString:@""] == NO))) {
            [SessionManager sharedSessionManager].userID = @"";
            [SessionManager sharedSessionManager].sessionOutString = @"Y";
            
			if ([recvErrorCode isEqualToString:@"100"]) {
				retErrorMessage = recvErrorMessage;
			} else
				retErrorMessage = [NSString stringWithFormat:@"[%@]\n%@", recvErrorCode, recvErrorMessage];
			
            //전문의 실패 처리.
            if ([recvErrorCode isEqualToString:kSecondFailedLoginErrorCode] == YES || [recvErrorCode isEqualToString:kSecondFailedCorpLoginErrorCode] == YES) {
                [self returnTrans:transCode responseArray:[NSArray arrayWithObject:recvErrorCode] success:NO];
            } else {
                [self returnTrans:transCode responseArray:nil success:NO];
            }

			if ([SysUtils isNull:actionCode] == NO) {
				if ([actionCode isEqualToString:kErrorActionCodeQuit]) {
					NSDictionary* dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:actionCode, kKeyOfErrorAction, retErrorMessage, kKeyOfErrorMessage, nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:kExecuteErrorActionNotification object:nil userInfo:dicUserInfo];
					return;
				} else {
					NSDictionary* dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:actionCode, kKeyOfErrorAction, nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:kExecuteErrorActionNotification object:nil userInfo:dicUserInfo];
				}
            }
            if ([[SessionManager sharedSessionManager].latestVersion isEqualToString:@""]) {
                UIAlertView* alertexit	= [[UIAlertView alloc] initWithTitle:@"안내"
                                                                       message:retErrorMessage delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                
                alertexit.tag = 1010;
                [alertexit show];
            }else{
                [SysUtils showMessage:retErrorMessage];

            }
            
            
			return;
		}
		//전문의 성공 처리.
		[self returnTrans:transCode responseArray:transResponses success:YES];
	} else {
		//전문의 실패 처리.
		[self returnTrans:@"" responseArray:nil success:NO];

		[SysUtils showMessage:errorMessage];

		if (errorCode >= 1000) {
			NSDictionary* dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", errorCode], kKeyOfErrorAction, nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:kExecuteErrorActionNotification object:nil userInfo:dicUserInfo];
		}
	}
}



//#pragma mark-
//#pragma mark UIAlertView delegate implementation
//#pragma mark-
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    switch (alertView.tag) {
//        case 9998:
//            exit(0);
//            break;
//            
//        default:
//            break;
//    }
//}



@end
