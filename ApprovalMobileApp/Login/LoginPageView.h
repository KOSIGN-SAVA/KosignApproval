//
//  LoginPageView.h
//  ApprovalMobileApp
//
//  Created by Lay Bunnavitou on 11/29/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"
#import "WebStyleViewController.h" 

#import "AllUtils.h"
#import "Constants.h"
#import "SessionManager.h"
#import "SecurityManager.h"
#import "JSON.h"


@interface LoginPageView : WCViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    int CheckAutoLogin;
    
    NSString *URL_Resgister;
    NSString *URL_Id_Forget;
    NSString *URL_PW_Forget;
}
@property (strong, nonatomic) IBOutlet UIImageView *launchImageV;

@property (strong, nonatomic) IBOutlet UIView *MainView;
@property (strong, nonatomic) IBOutlet UIButton *AutoLoginBtProperty;
@property (strong, nonatomic) IBOutlet UITextField *TxtId;
@property (strong, nonatomic) IBOutlet UITextField *TxtPassword;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TopLogoBizplay;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ButtomResister;


@end
