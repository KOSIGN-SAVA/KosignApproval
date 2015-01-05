//
//  LoginPageView.m
//  ApprovalMobileApp
//
//  Created by Lay Bunnavitou on 11/29/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "LoginPageView.h"
#import "TutorialsPageView.h"
#import "GateViewCtrl.h"

@implementation LoginPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[UIScreen mainScreen] bounds].size.height < 500){
        _TopLogoBizplay.constant = 30;
        _ButtomResister.constant = 15;
    }
    
    NSString *isAutoLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAutoLogin"];
    if([isAutoLogin isEqualToString:@"Y"]){
        _AutoLoginBtProperty.selected = YES;
    }else{
        _AutoLoginBtProperty.selected = NO;
    }
    
    //======Auto Login Background ImageView
    if([isAutoLogin isEqualToString:@"Y"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLogin"] isEqualToString:@"Y"] && [SysUtils isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"savePassword"]] == NO){
        _launchImageV.hidden   = NO;
        [[self navigationController] setNavigationBarHidden:YES];
    }else{
        _launchImageV.hidden   = YES;
        [[self navigationController] setNavigationBarHidden:NO];
    }
    
    //=========== Check for Tutorial Page
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLogin"] isEqualToString:@"Y"]){
        
    }else{
        TutorialsPageView *PageTutor    = [[TutorialsPageView alloc]initWithNibName:@"TutorialsPageView" bundle:nil];
        [self.navigationController presentViewController:PageTutor animated:NO completion:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DimissLoginAction:) name:@"TutorialsPageView" object:nil];
    }
    
    UITapGestureRecognizer *tap         = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardAction:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLogin"] isEqualToString:@"Y"]){
        [self menuGate];
    }
    
    _TxtId.text              = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveId"];
    
    NSString *isAutoLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAutoLogin"];
    if([isAutoLogin isEqualToString:@"Y"] && [SysUtils isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"savePassword"]] == NO){
        _TxtPassword.text        = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savePassword"] decryptAlgorithmFromKey:0 key:@"BizplayKey"];
    }
    
}

#pragma mark - AppInfo Request
#pragma mark -----------------------------------------------------------
- (void)menuGate {
    [AppUtils showWaitingSplash];
    self.view.userInteractionEnabled                        = NO;
    super.navigationController.view.userInteractionEnabled  = NO;
    
//    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc] init];
//    [sendDictionary setValue:@"I_BA_G_1" forKey:@"_master_id"];
    
    [super sendTransaction:@"APPR_MM0001" requestDictionary:nil];
    
}

#pragma mark - Server return result
#pragma mark -----------------------------------------------------------
- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success {
    [AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled                        = YES;
    super.navigationController.view.userInteractionEnabled  = YES;
    
    if (success) {
        if([transCode isEqualToString:@"APPR_LOGIN_R001"]){
            if(responseArray == nil)
                return;
            
            [SessionManager sharedSessionManager].userID        = _TxtId.text;
            [SessionManager sharedSessionManager].loginDataDic  = [NSMutableDictionary dictionaryWithDictionary:responseArray[0]];
            [SessionManager sharedSessionManager].sessionOutString = @"N";
            
            [[NSUserDefaults standardUserDefaults] setObject:_TxtId.text forKey:@"saveId"];
            
            //자동 로그인
            NSString *isAutoLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAutoLogin"];
            if([isAutoLogin isEqualToString:@"Y"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[_TxtPassword.text encryptAlgorithmFromKey:0 key:@"BizplayKey"] forKey:@"savePassword"];
                
                //30days
                NSDate *nextDate;
                NSString *autoTimer = [[NSUserDefaults standardUserDefaults] objectForKey:@"autoTimer"];
                if([autoTimer isEqualToString:@""] || [SysUtils isNull:autoTimer]){
                    [[NSUserDefaults standardUserDefaults] setObject:[[nextDate addDay:30] dateToString:@"yyyyMMdd" localeIdentifier:@"ko_kr"] forKey:@"autoTimer"];
                }
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //push register
            [[NSNotificationCenter defaultCenter] postNotificationName:kPushStartNotification object:self userInfo:nil];
            
            //go main page
            UIViewController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeViewController"];
            GateViewCtrl *navigation = [[GateViewCtrl alloc] initWithRootViewController:rootController];
            [self presentViewController:navigation animated:NO completion:nil];
            
        }else{
            if(responseArray == nil)
                return;
            
            [SessionManager sharedSessionManager].appInfoDataArr = [responseArray valueForKey:@"_app_info"][0];
            
            [SessionManager sharedSessionManager].gateWayUrl    = [responseArray valueForKey:@"c_bizplay_url"][0];
            [SessionManager sharedSessionManager].channelID     = [responseArray valueForKey:@"c_channel_id"][0];
            [SessionManager sharedSessionManager].portalID      = [responseArray valueForKey:@"c_portal_id"][0];
            
            URL_Resgister   = [[responseArray valueForKey:@"_menu_info"] valueForKey:@"c_member_url"][0][0];
            URL_Id_Forget   = [[responseArray valueForKey:@"_menu_info"] valueForKey:@"c_forget_id_url"][0][0];
            URL_PW_Forget   = [[responseArray valueForKey:@"_menu_info"] valueForKey:@"c_forget_pw_url"][0][0];
            
            //서비스 가능 여부
            if([[responseArray valueForKey:@"c_available_service"][0] boolValue] != true){
                UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"" message:[responseArray valueForKey:@"c_act"][0] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                Alert.tag       = 1010;
                Alert.delegate  = self;
                [Alert show];
                return;
            }
            
            [SessionManager sharedSessionManager].latestVersion = [responseArray valueForKey:@"c_program_ver"][0];
            [SessionManager sharedSessionManager].appUrl        = [responseArray valueForKey:@"c_appstore_url"][0];

            NSString *appVersionString      = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
            NSString *minimum_verString     = [responseArray valueForKey:@"c_minimum_ver"][0];
            NSString *c_update_actString    = [responseArray valueForKey:@"c_update_act"][0];
            
            //force to update
            if([SysUtils versionToInteger:minimum_verString] < [SysUtils versionToInteger:appVersionString]){
                
                //action sheet
                if([SysUtils getOSVersion] >= 80000){
                    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:c_update_actString preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *update = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action){
                                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[SessionManager sharedSessionManager].appUrl]];
                                                                     [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                                                 }];
                    
                    [actionSheet addAction:update];
                    
                    [self presentViewController:actionSheet animated:YES completion:nil];
                    
                }else{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:c_update_actString delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Update", nil];
                    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                    
                    [actionSheet showInView:self.view];
                    
                }
            }
            
            //alert to update
            if([SysUtils versionToInteger:[SessionManager sharedSessionManager].latestVersion] > [SysUtils versionToInteger:appVersionString]){
                UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:c_update_actString delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil];
                Alert.tag      = 1020;
                Alert.delegate = self;
                [Alert show];
            }
            
            //자동 로그인
            NSString *isAutoLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAutoLogin"];
            if([isAutoLogin isEqualToString:@"Y"] && [SysUtils isNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"savePassword"]] == NO){
                
                [AppUtils showWaitingSplash];
                self.view.userInteractionEnabled                        = NO;
                super.navigationController.view.userInteractionEnabled  = NO;
                
                NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
                
                [reqData setObject:[SessionManager sharedSessionManager].portalID   forKey:@"PTL_ID"];
                [reqData setObject:[SessionManager sharedSessionManager].channelID  forKey:@"CHNL_ID"];
                [reqData setObject:_TxtId.text          forKey:@"USER_ID"];
                [reqData setObject:_TxtPassword.text    forKey:@"PWD"];
                
                [super sendTransaction:@"APPR_LOGIN_R001" requestDictionary:reqData];
            }
            
        }
        
    } else {
        _TxtPassword.text   = @"";
        _launchImageV.hidden = YES;
        [[self navigationController] setNavigationBarHidden:NO];
        
    }
    
}

#pragma mark - UIActionSheet Delegate
#pragma mark -----------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch(buttonIndex){
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[SessionManager sharedSessionManager].appUrl]];
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1010){
        exit(0);
    }else if(alertView.tag == 1020){
        if(buttonIndex == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[SessionManager sharedSessionManager].appUrl]];
        }
    }
    
}

#pragma mark - TextField Delegate
#pragma mark -----------------------------------------------------------
- (void)setViewMoveUp:(BOOL)move withTextField:(UITextField *) txtField {
    if([[UIScreen mainScreen] bounds].size.width>320){
        return;
    }
    [UIView beginAnimations      :nil context:NULL];
    [UIView setAnimationDelegate : self];
    [UIView setAnimationDuration : 0.2f];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect rect = self.view.frame;
    if( move ){
        if( txtField == _TxtId)
            rect.origin.y   -= 65.0f;
        else if( txtField == _TxtPassword)
            rect.origin.y   -= 65.0f;
    }else{
        if( txtField == _TxtId)
            rect.origin.y   += 65.0f;
        else if( txtField == _TxtPassword)
            rect.origin.y   += 65.0f;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == _TxtId ){
        [self setViewMoveUp:YES withTextField:_TxtId];
    }else if(textField == _TxtPassword ){
        [self setViewMoveUp:YES withTextField:_TxtPassword];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == _TxtId){
        [self setViewMoveUp:NO withTextField:_TxtId];
    }else if(textField == _TxtPassword ){
        [self setViewMoveUp:NO withTextField:_TxtPassword];
    }
    
}

#pragma mark - Action Button
#pragma mark -----------------------------------------------------------
//==========Dismiss Action when click on view=============//
- (void)dismissKeyboardAction:(id)sender {
    [_TxtId resignFirstResponder];
    [_TxtPassword resignFirstResponder];
    
}

- (void)DimissLoginAction:(NSNotification *)note {
    if ([[[note userInfo] objectForKey:@"tagValue"] integerValue] == 100) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"isFirstLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

//==========Login Button Event ================//
- (IBAction)LoginAction:(id)sender {
    [self.view endEditing:YES];
    
    if(_TxtId.text.length <= 0){
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"" message:@"아이디를 입력해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [Alert show];
        return;
    }
    if(_TxtPassword.text.length <= 0){
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"" message:@"비밀번호를 입력해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [Alert show];
        return;
    }
    
    [AppUtils showWaitingSplash];
    self.view.userInteractionEnabled                        = NO;
    super.navigationController.view.userInteractionEnabled  = NO;
    
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
    
    [reqData setObject:[SessionManager sharedSessionManager].portalID   forKey:@"PTL_ID"];
    [reqData setObject:[SessionManager sharedSessionManager].channelID  forKey:@"CHNL_ID"];
    [reqData setObject:_TxtId.text          forKey:@"USER_ID"];
    [reqData setObject:_TxtPassword.text    forKey:@"PWD"];
    
    [super sendTransaction:@"APPR_LOGIN_R001" requestDictionary:reqData];
    
}

//==========AutoLogin Button Click =============//
- (IBAction)AutoLoginAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"autoTimer"];
    
    if(_AutoLoginBtProperty.selected == YES){
        _AutoLoginBtProperty.selected = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"isAutoLogin"];
        
    }else{
        _AutoLoginBtProperty.selected = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"isAutoLogin"];
        
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//==========Resgister Button - 가입하기==============//
- (IBAction)ResgisterAction:(id)sender {
    if([URL_Resgister isEqualToString:@""] || [SysUtils isNull:URL_Resgister]){
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"" message:@"모바일 회원가입이 준비중입니다.\n 모바일 회원가입 오픈 전 까지 웹사이트에서 회원가입을 하실 수 있습니다.\n www.bizplay.co.kr" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [Alert show];
        return;
    }
    
    WebStyleViewController *WebC    = [[WebStyleViewController alloc] init];
    WebC.menuURL                    = URL_Resgister;
    [self.navigationController pushViewController:WebC animated:YES];
    
}

//==========ID Button - 아이디 찾기 ==============//
- (IBAction)IdAndPasswordAction:(id)sender {
    if([URL_Id_Forget isEqualToString:@""] || [SysUtils isNull:URL_Id_Forget]){
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"" message:@"모바일 회원가입이 준비중입니다.\n 모바일 회원가입 오픈 전 까지 웹사이트에서 회원가입을 하실 수 있습니다.\n www.bizplay.co.kr" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [Alert show];
        return;
    }

    WebStyleViewController *WebC    = [[WebStyleViewController alloc] init];
    WebC.menuURL                    = URL_Id_Forget;
    [self.navigationController pushViewController:WebC animated:YES];
    
}

//==========Password Button - 비밀번호 찾기 ==============//
- (IBAction)PasswordFindAction:(id)sender {
    if([URL_PW_Forget isEqualToString:@""] || [SysUtils isNull:URL_PW_Forget]){
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"" message:@"모바일 회원가입이 준비중입니다.\n 모바일 회원가입 오픈 전 까지 웹사이트에서 회원가입을 하실 수 있습니다.\n www.bizplay.co.kr" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [Alert show];
        return;
    }
    
    WebStyleViewController *WebC    = [[WebStyleViewController alloc] init];
    WebC.menuURL                    = URL_PW_Forget;
    [self.navigationController pushViewController:WebC animated:YES];
    
}

@end
