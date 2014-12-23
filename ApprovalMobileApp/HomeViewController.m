//
//  HomeViewController.m
//  ApprovalMobileApp
//
//  Created by knm on 2014. 12. 10..
//  Copyright (c) 2014년 webcash. All rights reserved.
//

#import "HomeViewController.h"
#import "AllUtils.h"
#import "Constants.h"
#import "SessionManager.h"
#import "GateViewCtrl.h"
#import "WebStyleViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

// 전문 전송 부 - 결재함 알림 건수 조회(APPR_ALAM_R101)
- (void)sendTranData:(NSString *)trCode {
    
    [AppUtils showWaitingSplash];
    self.view.userInteractionEnabled = NO;
    super.navigationController.view.userInteractionEnabled = NO;
    
    
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    
    
    // 콜라보 알림 건수 조회
    if ([trCode isEqualToString:@"APPR_ALAM_R101"]) {
        
        [reqData setObject:[SessionManager sharedSessionManager].userID forKey:@"USER_ID"]; //사용자ID
        [reqData setObject:[[SessionManager sharedSessionManager].loginDataDic objectForKey:@"DVSN_CD"] forKey:@"DVSN_CD"]; //부서코드
        
    }
    
    
    [super sendTransaction:trCode requestDictionary:reqData];
    
}


// 전문결과 처리 부
- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success {
    
#if _DEBUG_
    NSLog(@"%@ 전문번호[%@]\n 전문Data[%@]", (success?@"success":@"fail"), transCode, responseArray);
#endif
    
    
    [AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled = YES;
    super.navigationController.view.userInteractionEnabled = YES;
    
    
    if (success) {
        
        if ([transCode isEqualToString:@"APPR_ALAM_R101"]) { // 결재함 알림 건수 조회
            
            // for alarm count sync.
            UIButton *pNewCount = (UIButton *)[self.view viewWithTag:2001];
            UIButton *dNewCount = (UIButton *)[self.view viewWithTag:2002];
            UIButton *aNewCount = (UIButton *)[self.view viewWithTag:2003];
            
            
            if ([[[responseArray objectAtIndex:0] objectForKey:@"PERS_ALAM_CNT"] integerValue] > 0) {
                
                pNewCount.hidden = NO;
                [pNewCount setTitle:[[responseArray objectAtIndex:0] objectForKey:@"PERS_ALAM_CNT"] forState:UIControlStateNormal];
                
            } else {
                
                pNewCount.hidden = YES;
                [pNewCount setTitle:@"" forState:UIControlStateNormal];
                
            }
            if ([[[responseArray objectAtIndex:0] objectForKey:@"DEPT_ALAM_CNT"] integerValue] > 0) {
                
                dNewCount.hidden = NO;
                [dNewCount setTitle:[[responseArray objectAtIndex:0] objectForKey:@"DEPT_ALAM_CNT"] forState:UIControlStateNormal];
                
            } else {
                
                dNewCount.hidden = YES;
                [dNewCount setTitle:@"" forState:UIControlStateNormal];
                
            }
            if ([[[responseArray objectAtIndex:0] objectForKey:@"ACPT_ALAM_CNT"] integerValue] > 0) {
                
                aNewCount.hidden = NO;
                [aNewCount setTitle:[[responseArray objectAtIndex:0] objectForKey:@"ACPT_ALAM_CNT"] forState:UIControlStateNormal];
                
            } else {
                
                aNewCount.hidden = YES;
                [aNewCount setTitle:@"" forState:UIControlStateNormal];
                
            }
            
        }
        
    }
    
}


// 탭바 버튼 클릭시(개인결재함, 부서결재함, 접수결재함)
- (IBAction)btnTabClicked:(id)sender {
    
    NSString *strUrl = @"";
    
    switch ([sender tag]) {
            
        case 1001: // 개인결재함
            strUrl = @"APPROVAL_101.act";
            
            break;
        case 1002: // 부서결재함
            strUrl = @"APPROVAL_102.act";
            
            break;
        case 1003: // 접수결재함
            strUrl = @"APPROVAL_103.act";
            
            break;
            
    }
    
    
    WebStyleViewController *webView = [[WebStyleViewController alloc] initWithURL:[NSString stringWithFormat:@"%@/%@", [SessionManager sharedSessionManager].gateWayUrl, strUrl]];
    [self.navigationController pushViewController:webView animated:YES];
    
}


// ...(더보기 메뉴) 버튼 클릭시
- (void)btnMoreMenuClicked:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"moreMenuShowSegue" sender:nil];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // Constraints
    if ([SysUtils getOSVersion] >= 80000) {
        
        webViewLeftConstraint.constant    = -16.0f;
        webViewRightConstraint.constant   = -16.0f;
        
        tabViewLeftConstraint.constant   = -16.0f;
        tabViewRightConstraint.constant  = -16.0f;
        
        // 아이폰 6 플러스
        if ([[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f) {
            
            webViewLeftConstraint.constant    = -20.0f;
            webViewRightConstraint.constant   = -20.0f;
            
            tabViewLeftConstraint.constant   = -20.0f;
            tabViewRightConstraint.constant  = -20.0f;
            
        }
        
    } else {
        
        webViewLeftConstraint.constant    = 0.0f;
        webViewRightConstraint.constant   = 0.0f;
        
        tabViewLeftConstraint.constant   = 0.0f;
        tabViewRightConstraint.constant  = 0.0f;
        
    }
    
    
    self.title = @"결재함";
    
    [AppUtils settingRightButton:self action:@selector(btnMoreMenuClicked:) normalImageCode:@"top_more_btn.png" highlightImageCode:@"top_more_btn_p.png"];
    
    
    mainWebView.scrollView.bounces = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LogoutGo:) name:kLogoutGo object:nil];
    
}


- (void)LogoutGo:(NSNotification *)note {
    
    UIViewController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    GateViewCtrl *navigation = [[GateViewCtrl alloc] initWithRootViewController:rootController];
    [self presentViewController:navigation animated:NO completion:nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    if ([[SessionManager sharedSessionManager].userID isEqualToString:@""]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutGo object:self userInfo:nil];
        
    } else {
        
        // URL Open
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/APPROVAL_MAIN_101.act", [SessionManager sharedSessionManager].gateWayUrl]]];
        
        [mainWebView loadRequest:req];
        
        
        // 결재함 알림 건수 조회 전문 전송
        [self sendTranData:@"APPR_ALAM_R101"];
        
    }
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
