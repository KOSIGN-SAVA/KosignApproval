//
//  MoreViewController.m
//  ApprovalMobileApp
//
//  Created by Lov Sam Ann on 12/1/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "MoreViewController.h"
#import "ProfileHeaderView.h"
#import "FooterView.h"
#import "CustomTableViewCell.h"
#import "SettingNotificationViewController.h"

#import "Constants.h"
#import "AllUtils.h"
#import "SessionManager.h"
#import "GateViewCtrl.h"

static NSString * APPR_SET_R101 = @"APPR_SET_R101";

@interface MoreViewController ()

@property (nonatomic,strong) NSArray *cellTitle;
@property (nonatomic,strong) ProfileHeaderView *profileView;
@property (nonatomic,strong) FooterView *footerView;
@property (nonatomic,strong) NSArray *imageName;
@property (nonatomic,strong) NSString *apiKey;
@end

@implementation MoreViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.txtLabel.text        = self.cellTitle[indexPath.row];
    
    UIImage *image              = [UIImage imageNamed:self.imageName[indexPath.row]];
    cell.imgView.image          = image;
    
    image                  = [UIImage imageNamed:@"more_list_next.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:
                              CGRectMake(0.0, 0.0, image.size.width / 2, image.size.height / 2)];
    imageView.image        = image;
    cell.accessoryView     = imageView;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitle.count;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:{
            self.apiKey = APPR_SET_R101;
            NSDictionary *subChildDic = @{ @"USER_ID" : [SessionManager sharedSessionManager].userID };
            [self sendJSONWithAPI:self.apiKey forDictionary:subChildDic];
        }
            break;
        default:{
            //            [self performSegueWithIdentifier:@"customerCenterSegueForward" sender:nil];
            NSString *urlString = @"https://docs.google.com/forms/d/1rvL2Hr7BHc_1P-zcVbPhf34wYZMWhiBsFmO0Jw5Sy8Q/viewform";
            [SysUtils applicationExecute:urlString];
        }
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView setSeparatorColor: RGBA(220.0, 220.0, 220.0, 1.0)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.profileView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat profileHeight = [self tableView:tableView heightForHeaderInSection:section];
    CGFloat cellHeight    = [self.tableView rowHeight];
    
#if _DEBUG_
    NSLog(@"hieght of tableveiw %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"height %f",self.tableView.frame.size.height - (cellHeight * self.cellTitle.count) - profileHeight);
#endif
    
    if (self.view.frame.size.height > 416){
        return self.tableView.frame.size.height - (cellHeight * self.cellTitle.count) - profileHeight;
    }
    else{   // for iPhone 4s
        return 180.0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footerView;
}


#pragma mark -  lazy instantiation

-(NSArray *)imageName{
    if (!_imageName) {
        _imageName = [NSArray arrayWithObjects:@"alarm_icon.png",@"more_cscenter_icon.png", nil];
    }
    return _imageName;
}

- (NSArray *)cellTitle{
    if (!_cellTitle) {
        _cellTitle = [NSArray arrayWithObjects:@"알림 설정",@"고객 센터", nil];
    }
    return _cellTitle;
}

-(ProfileHeaderView *)profileView{
    if (!_profileView) {
        _profileView = [[ProfileHeaderView alloc]init];
        
        CGFloat profileHeight = [self tableView:self.tableView heightForHeaderInSection:1];
        UIView *line          = [[UIView alloc]initWithFrame:
                                        CGRectMake(.0, profileHeight, self.tableView.frame.size.width, 1.0)];
        line.backgroundColor = RGB(71.0, 103.0, 176.0);
        [_profileView addSubview:line];
    
        
        NSDictionary *userInfo = [SessionManager sharedSessionManager].loginDataDic;
      
#if _DEBUG_
        NSLog(@"user info %@", userInfo);
#endif

        if (userInfo) {
            _profileView.userNamelabel.text     = userInfo[@"USER_NM"];     // user name
            _profileView.companyNameLabel.text  = userInfo[@"BSNN_NM"];     // company name
            
            //department
            if ([userInfo[@"DVSN_NM"]isEqualToString:@""]) {
                _profileView.spaceLine.hidden       = YES;
                _profileView.departmentLabel.hidden = YES;
            }else{
                _profileView.departmentLabel.text   = userInfo[@"DVSN_NM"];
            }
            
            //moblie phone
            NSString *mobilePhone   = userInfo[@"CLPH_NO"];
            _profileView.label1.text= [self getHyphenPhonNumber:mobilePhone];
            _profileView.label3.text= userInfo[@"EML"];
            
            //profile image
            if (![userInfo[@"PRFL_PHTG"]isEqualToString:@""]) {
                NSString *urlString = userInfo[@"PRFL_PHTG"];
                NSURL *url          = [NSURL URLWithString:urlString];
                NSData *data        = [NSData dataWithContentsOfURL:url];
                
                _profileView.profileImageView.image = [UIImage imageWithData:data];
            }
        }
    }
    
    return _profileView;
}

-(FooterView *)footerView{
    if (!_footerView) {
        _footerView = [[FooterView alloc]init];
    
        UIView *line            = [[UIView alloc]initWithFrame:
                                    CGRectMake(0.0, -1.0, self.tableView.frame.size.width, 1.0)];
        line.backgroundColor    = RGB(80.0,80.0,80.0);
        [_footerView addSubview:line];
        
        NSArray *avaiableApps   = [SessionManager sharedSessionManager].appInfoDataArr;
        
#if _DEBUG_
        NSLog(@"avaiableApps --- > %@",avaiableApps);
#endif
        
        
        if (avaiableApps.count == 0) return _footerView;

        [self setAppAvaible:avaiableApps inView:_footerView];
        
        CGFloat versionViewHeight;
        
        versionViewHeight = (self.tableView.frame.size.height > 416) ? 40.0 : 25.0;
        
        CGFloat height = [self tableView:self.tableView heightForFooterInSection:1];
        //NSLog(@"height %f", height);
        
        UIView *versionView = [[UIView alloc]initWithFrame:CGRectMake(.0, height - versionViewHeight, self.tableView.frame.size.width, versionViewHeight)];
        versionView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.0];
        
        [_footerView addSubview:versionView];
        
        UIImageView *icon   = [[UIImageView alloc]initWithFrame:
                               CGRectMake(0, 0, 16.0 , 16.0)];
        icon.image          = [UIImage imageNamed:@"version_icon.png"];
        
        
        UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 , 0, 70.0, 15)];
        versionLabel.textColor= [UIColor colorWithRed:180 / 255.0 green:180 / 255.0 blue:180 / 255.0 alpha:1.0];
        versionLabel.font     = [UIFont systemFontOfSize:12.0];
        
        versionLabel.text     = [NSString stringWithFormat:@"버전 %@",[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"]];
        
        
        UIView *centerView  = [[UIView alloc]initWithFrame:CGRectMake( (versionView.frame.size.width / 2) - 37.5 , versionViewHeight == 40.0 ? 13 : 7, 75, 16)];
        [centerView addSubview:icon];
        [centerView addSubview:versionLabel];
        
        [versionView addSubview:centerView];
        
    }
    
    return _footerView;
}

#pragma mark - private methods

- (void)setNavigationBar{
    
    //left nav
    UIImage *image = [UIImage imageNamed:@"top_back_btn.png"];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:
                                            CGRectMake(.0, .0, image.size.width / 2, image.size.height / 2)];
    
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(handleNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag          = 1900;

    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    //right nav
    UIImage *rightImage    = [UIImage imageNamed:@"top_logout_btn.png"];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:
                                        CGRectMake(.0, .0, 54.0 , 18.0)];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"top_logout_btn_p.png"] forState:UIControlStateSelected];
    
    [rightButton addTarget:self action:@selector(handleNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag             = 1901;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;

}

- (void)popToRootViewController{
    SessionManager *sessionManager = [SessionManager sharedSessionManager];
    sessionManager.userID = @"";
    sessionManager.sessionOutString = @"Y";
    sessionManager.loginDataDic = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"N" forKey:@"isAutoLogin"];
    [defaults synchronize];
    
    UIViewController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    GateViewCtrl *navigation = [[GateViewCtrl alloc] initWithRootViewController:rootController];
    [self presentViewController:navigation animated:NO completion:nil];
}

- (NSString *)getHyphenPhonNumber:(NSString *)sender {
    
    if ([sender length] <= 4) {
        //너무 짧은 스트링은 내뱉는다.
        
        return sender;
    }
    
    sender = [sender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    sender = [sender stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([[sender substringToIndex:2] isEqualToString:@"02"]) {
        //서울
        
        if ([[sender substringFromIndex:2] length] == 8) {
            
            NSRange range = {2,4};
            
            return [NSString stringWithFormat:@"%@-%@-%@", [sender substringToIndex:2], [sender substringWithRange:range], [sender substringFromIndex:6]];
            
        } else if ([[sender substringFromIndex:2] length] == 7) {
            
            NSRange range = {2,3};
            
            return [NSString stringWithFormat:@"%@-%@-%@", [sender substringToIndex:2], [sender substringWithRange:range], [sender substringFromIndex:5]];
            
        } else {
            
            return [NSString stringWithFormat:@"%@-%@", [sender substringToIndex:2], [sender substringFromIndex:2]];
            
        }
        
    } else {
        //그외 지역 및 핸드폰 번호
        
        if ([[sender substringFromIndex:3] length] == 8) {
            
            NSRange range = {3,4};
            
            return [NSString stringWithFormat:@"%@-%@-%@", [sender substringToIndex:3], [sender substringWithRange:range], [sender substringFromIndex:7]];
            
        } else if ([[sender substringFromIndex:3] length] == 7) {
            
            NSRange range = {3,3};
            
            return [NSString stringWithFormat:@"%@-%@-%@", [sender substringToIndex:3], [sender substringWithRange:range], [sender substringFromIndex:6]];
            
        } else {
            
            if ([sender length] == 8) {
                //1577 등 8자리로 된 전화번호 처리
                
                return [NSString stringWithFormat:@"%@-%@", [sender substringToIndex:4], [sender substringFromIndex:4]];
                
            } else {
                
                return [NSString stringWithFormat:@"%@-%@", [sender substringToIndex:3], [sender substringFromIndex:3]];
                
            }
            
        }
        
    }
    
    return sender;
    
}

- (void)sendJSONWithAPI:(NSString *) apiKey forDictionary:(NSDictionary *) reqDic{
    [AppUtils showWaitingSplash];
    self.view.userInteractionEnabled = NO;
    super.navigationController.view.userInteractionEnabled = NO;
    
    [super sendTransaction:apiKey requestDictionary:reqDic];
}

- (void)executedAppAtIndex:(NSInteger)index{
    NSArray *appArr = [SessionManager sharedSessionManager].appInfoDataArr;
    
    if (index < 0) return;
    
    BOOL isAvailable = [appArr[index][@"c_available"]isEqualToString:@"true"];
    if (isAvailable) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", appArr[index][@"c_app_id"], @"://"];
        NSString *url = appArr[index][@"c_app_url"];
        BOOL isExecuted = [SysUtils canExecuteApplication:urlString];
        
        [SysUtils applicationExecute: isExecuted ? urlString : url ];
        
    }else{
        [SysUtils showMessage:appArr[index][@"c_reason"]];
    }
}

-(void)setAppAvaible:(NSArray *)apps inView:(FooterView *) footerView{
    
    [_footerView.containerView[5] setHidden:YES];
    [_footerView.appNameLabel[5] setHidden:YES];
    
    [_footerView.containerView[4] setHidden:YES];
    [_footerView.appNameLabel[4] setHidden:YES];
    
    
    int index = 0;
    NSArray *colorImageName    = @[@"more_schedule_icon_color.png",
                                   @"more_gm_icon_color.png",
                                   @"more_collabo_icon_color.png",
                                   @"more_memo_icon_colory.png"];
    NSArray *bulrImageName     = @[@"more_schedule_icon_grey.png",
                                   @"more_gm_icon_grey.png",
                                   @"more_collabo_icon_grey.png",
                                   @"more_memo_icon_grey.png"];
    
    UIImageView *iconImage     = nil;
    UILabel *appName           = nil;
    
    
    for (NSDictionary *dic in apps) {
        appName         = (UILabel *) _footerView.appNameLabel[index];
        
#if _DEBUG_
    NSLog(@"app name : %@", dic[@"c_name"]);
    NSLog(@"index %d",index);
#endif
        appName.text    = dic[@"c_name"];
        
        
        
        iconImage       = (UIImageView *) footerView.iconImageView[index];
        if ([dic[@"c_available"]isEqualToString:@"true"]) {
            iconImage.image = [UIImage imageNamed:colorImageName[index]];       //colorful image
            [footerView.downloadImageView[index] setHidden:YES];
        }else{
            iconImage.image = [UIImage imageNamed:bulrImageName[index]];        //blur image
        }
        
        UIButton *button = (UIButton *) footerView.buttonActions[index];
        [button addTarget:self action:@selector(handleButtonActions:) forControlEvents:UIControlEventTouchUpInside];
        index++;
    }
}

#pragma mark - handle events

- (void)handleButtonActions:(UIButton *)sender{
    [self executedAppAtIndex:sender.tag];
}

- (void)handleNavigationBarAction:(UIButton *) sender{
    switch (sender.tag) {
        case 1900:
            [self.navigationController popViewControllerAnimated:NO];
            break;
        default:{
            if ([SysUtils getOSVersion] < 80000) { // ios7
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                                   message:@"로그아웃 하시겟습니까?"
                                                                  delegate:self
                                                         cancelButtonTitle:@"아니오"
                                                         otherButtonTitles:@"네", nil];
                [alertView show];
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                         message:@"로그아웃 하시겟습니까?"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"아니오"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *action){
                                                                         
                                                                     }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"네"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action){
                                                                     //dispose of any resource
                                                                     [self popToRootViewController];
                                                                 }];
        
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:NO completion:NULL];
            }
        }
            break;
    }
}

// alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self popToRootViewController];
    }
}

#pragma mark - WCViewController (Override)

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
    
    [AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled = YES;
    super.navigationController.view.userInteractionEnabled = YES;
    
#if _DEBUG_
    NSLog(@"result --> %@", responseArray);
#endif

    if (success) {
        if ([self.apiKey isEqualToString:APPR_SET_R101])
            [self performSegueWithIdentifier:@"settingSegueForward" sender:responseArray[0]];
    }

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"settingSegueForward"]) {
        SettingNotificationViewController *settingVC = segue.destinationViewController;
        settingVC.responsePushDictionary             = (NSDictionary *) sender;
    }
    
}


@end
