//
//  LoginPageView.m
//  ApprovalMobileApp
//
//  Created by Lay Bunnavitou on 11/29/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "LoginPageView.h"
#import "TutorialsPageView.h"

@implementation LoginPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[UIScreen mainScreen] bounds].size.height<500){
        _TopLogoBizplay.constant=30;
        _ButtomResister.constant=15;
    }
    //======Auto Login Background ImageView
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *autoLogin      = [defaults objectForKey:@"isAutoLogin"];
    if([autoLogin isEqualToString:@"Y"]){
        if([_TxtPassword.text isEqualToString:@""]){
             _launchImageV.hidden   = NO;
            [[self navigationController]setNavigationBarHidden:YES];
        }else{
            _launchImageV.hidden    = YES;
        }
        return;
    }
    //=========== Check for Tutorial Page
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Tutorail"] isEqualToString:@"OK"]) {
        ///=======Nothing to View just check to view Tutorail Page
    }else{
        NSUserDefaults *defaults        = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"OK" forKey:@"Tutorail"];
        [defaults synchronize];
        TutorialsPageView *PageTutor    = [[TutorialsPageView alloc]initWithNibName:@"TutorialsPageView" bundle:nil];
        [self.navigationController presentViewController:PageTutor animated:NO completion:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DimissLoginAction:) name:@"TutorialsPageView" object:nil];

    }
   
    UITapGestureRecognizer *tap         = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardAction:)];
    [self.view addGestureRecognizer:tap];
    
    [self menuGate];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *autoLogin      = [defaults objectForKey:@"isAutoLogin"];
    _TxtId.text              = [defaults objectForKey:@"saveId"];
    _TxtPassword.text        = [defaults objectForKey:@"savePassword"];
    
    if([autoLogin isEqualToString:@"Y"]){
        [_AutoLoginBtProperty setBackgroundImage:[UIImage imageNamed:@"login_checkbox_select.png"] forState:UIControlStateNormal];
        
        CheckAutoLogin++;
        
        NSMutableDictionary *reqData = [[NSMutableDictionary alloc] init];
        
        [reqData setObject:[SessionManager sharedSessionManager].portalID   forKey:@"PTL_ID"];
        [reqData setObject:[SessionManager sharedSessionManager].channelID  forKey:@"CHNL_ID"];
        [reqData setObject:_TxtId.text          forKey:@"USER_ID"];
        [reqData setObject:_TxtPassword.text    forKey:@"PWD"];
        
        if(_TxtPassword.text.length > 0){
             NSLog(@"Auto Login");
            [AppUtils showWaitingSplash];
            [super sendTransaction:@"APPR_LOGIN_R001" requestDictionary:reqData];
        }
    }else{
        NSLog(@"Loign Again ");
        _TxtPassword.text   = @"";
        CheckAutoLogin      = nil;
        [_AutoLoginBtProperty setBackgroundImage:[UIImage imageNamed:@"login_checkbox_default.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - AppInfo Request
#pragma mark -----------------------------------------------------------
-(void)menuGate{
    _TxtId.text=[[NSUserDefaults standardUserDefaults] stringForKey:@"saveId"];
//    NSMutableDictionary *sendDictionary=[[NSMutableDictionary alloc]init];
//    [sendDictionary setValue:@"I_BA_G_1" forKey:@"_master_id"];
//    I_BC_G_1
    
    [super sendTransaction:@"APPR_MM0001" requestDictionary:nil];
}

#pragma mark - Server return result
#pragma mark -----------------------------------------------------------
- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success {
    [AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled                        = YES;
    super.navigationController.view.userInteractionEnabled  = YES;
    if (success) {
        NSLog(@"URL Name : %@",transCode);
        NSLog(@"Reponse  : %@",responseArray);
        if([transCode isEqualToString:@"APPR_LOGIN_R001"]){
            NSLog(@"%@",responseArray);
            NSUserDefaults *defaults                            = [NSUserDefaults standardUserDefaults];
            [SessionManager sharedSessionManager].userID        = _TxtId.text;
            [SessionManager sharedSessionManager].loginDataDic  = [NSMutableDictionary dictionaryWithDictionary:responseArray[0]];
            
            [defaults setObject:_TxtId.text         forKey:@"saveId"];
            [defaults setObject:_TxtPassword.text   forKey:@"savePassword"];
            [defaults synchronize];
    
            [self dismissViewControllerAnimated:NO completion:^{}];
            _launchImageV.hidden=YES;
        }else{
            if(responseArray == nil){
                return;
            }
            [SessionManager sharedSessionManager].appInfoDataArr = [responseArray valueForKey:@"_app_info"][0];
            
            [SessionManager sharedSessionManager].gateWayUrl    = [responseArray valueForKey:@"c_bizplay_url"][0];
            [SessionManager sharedSessionManager].channelID     = [responseArray valueForKey:@"c_channel_id"][0];
            [SessionManager sharedSessionManager].portalID      = [responseArray valueForKey:@"c_portal_id"][0];
            
            URL_Resgister   = [[responseArray valueForKey:@"_menu_info"] valueForKey:@"c_member_url"][0];
            URL_Id_Forget   = [[responseArray valueForKey:@"_menu_info"] valueForKey:@"c_forget_id_url"][0];
            URL_PW_Forget   = [[responseArray valueForKey:@"_menu_info"] valueForKey:@"c_forget_pw_url"][0];
            
    
            
    
            if([[responseArray valueForKey:@"c_available_service"][0] boolValue] !=true || responseArray==nil){
                UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:[responseArray valueForKey:@"c_act"][0] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
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
                UIAlertController *alert=[[UIAlertController alloc]init];
                alert.title=@"";
                alert.message=c_update_actString;
                UIAlertAction* update = [UIAlertAction actionWithTitle:@"Update"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                                             [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[SessionManager sharedSessionManager].appUrl]];
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                         }];
                [alert addAction:update];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            //alert to update
            if([SysUtils versionToInteger:[SessionManager sharedSessionManager].latestVersion]>[SysUtils versionToInteger:appVersionString]){
                UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:c_update_actString delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소",nil];
                Alert.tag      = 1020;
                Alert.delegate = self;
                [Alert show];
                
            }
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1010){
//        exit(0);
    }else if(alertView.tag == 1020){
        if(buttonIndex==0){
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[SessionManager sharedSessionManager].appUrl]];
        }
    }
}
#pragma mark - TextField Delegate
#pragma mark ---------------------------------------------------------
- (void)setViewMoveUp:(BOOL)move withTextField:(UITextField *) txtField{
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _TxtId ){
        [self setViewMoveUp:YES withTextField:_TxtId];
    }else if(textField == _TxtPassword ){
        [self setViewMoveUp:YES withTextField:_TxtPassword];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _TxtId){
        [self setViewMoveUp:NO withTextField:_TxtId];
    }else if(textField == _TxtPassword ){
        [self setViewMoveUp:NO withTextField:_TxtPassword];
    }
}
#pragma mark - Action Button
#pragma mark -----------------------------------------------------------
//==========Dismiss Action when click on view=============//
-(void)dismissKeyboardAction:(id)sender{
    [_TxtId resignFirstResponder];
    [_TxtPassword resignFirstResponder];
}
-(void)DimissLoginAction:(NSNotification *)note {
    if ([[[note userInfo] objectForKey:@"tagValue"] integerValue] == 100) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}
//==========Login Button Event ================//
- (IBAction)LoginAction:(id)sender {
    [self.view endEditing:YES];
    if(_TxtId.text.length<=0){
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:@"아이디를 입력해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [Alert show];
        return;
    }
    if(_TxtPassword.text.length<=0){
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:@"비밀번호를 입력해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
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
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(CheckAutoLogin>0){
        [defaults setObject:@"Y" forKey:@"isAutoLogin"];
    }else{
        [defaults setObject:@"N" forKey:@"isAutoLogin"];
    }
    [defaults synchronize];
    
    [super sendTransaction:@"APPR_LOGIN_R001" requestDictionary:reqData];
}
//==========AutoLogin Button Click =============//
- (IBAction)AutoLoginAction:(id)sender {
    if(CheckAutoLogin==(int)nil){
        CheckAutoLogin++;
        [_AutoLoginBtProperty setBackgroundImage:[UIImage imageNamed:@"login_checkbox_select.png"] forState:UIControlStateNormal];
    }else{
        CheckAutoLogin=(int)nil;
        [_AutoLoginBtProperty setBackgroundImage:[UIImage imageNamed:@"login_checkbox_default.png"] forState:UIControlStateNormal];
    }
}
//==========Resgister Button       - 가입하기==============//
- (IBAction)ResgisterAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"savePassword"];
    [defaults synchronize];
    
    if([URL_Resgister isEqualToString:@""]){
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:@"모바일 회원가입이 준비중입니다.\n 모바일 회원가입 오픈 전 까지 웹사이트에서 회원가입을 하실 수 있습니다.\n www.bizplay.co.kr" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [Alert show];
        return;
    }
    
    WebStyleViewController *WebC    = [[WebStyleViewController alloc]init];
    WebC.menuURL                    = URL_Resgister;
    [self.navigationController pushViewController:WebC animated:YES];

}
//==========ID And Password Button - 아이디 찾기 ==============//
- (IBAction)IdAndPasswordAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"savePassword"];
    [defaults synchronize];
    
    if([URL_Id_Forget isEqualToString:@""]){
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:@"모바일 회원가입이 준비중입니다.\n 모바일 회원가입 오픈 전 까지 웹사이트에서 회원가입을 하실 수 있습니다.\n www.bizplay.co.kr" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [Alert show];
        return;
    }

    WebStyleViewController *WebC    = [[WebStyleViewController alloc]init];
    WebC.menuURL                    = URL_Id_Forget;
    [self.navigationController pushViewController:WebC animated:YES];
}

@end
