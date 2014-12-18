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


#import "Constants.h"
#import "AllUtils.h"
#import "SessionManager.h"

@interface MoreViewController ()

@property (nonatomic,strong) NSArray *cellTitle;
@property (nonatomic,strong) ProfileHeaderView *profileView;
@property (nonatomic,strong) FooterView *footerView;
@property (nonatomic,strong) NSArray *imageName;
@end

@implementation MoreViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    
    self.tableView.backgroundColor = [UIColor redColor];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.textColor  = RGB(80.0, 80.0, 80.0);
    cell.textLabel.font       = [UIFont systemFontOfSize:15.0];
    cell.textLabel.text       = self.cellTitle[indexPath.row];
    
    UIImage *image              = [UIImage imageNamed:self.imageName[indexPath.row]];
    cell.imageView.transform    = CGAffineTransformMakeScale(image.size.width / 90.0, image.size.height / 90.0);
    cell.imageView.image        = image;
    
    image                  = [UIImage imageNamed:@"more_list_next.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:
                              CGRectMake(0.0, 0.0, image.size.width / 2, image.size.height / 2)];
    imageView.image        = [UIImage imageNamed:@"more_list_next.png"];
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
        case 0:
            [self performSegueWithIdentifier:@"settingSegueForward" sender:nil];
            break;
        default:
            [self performSegueWithIdentifier:@"customerCenterSegueForward" sender:nil];
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
    CGFloat profileHeight = [self tableView:self.tableView heightForHeaderInSection:section];
    CGFloat cellHeight    = [self.tableView rowHeight];
    
    return self.tableView.frame.size.height - (cellHeight * self.cellTitle.count) - profileHeight;
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

        if (!userInfo) {
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
        
        if (avaiableApps.count == 0) return _footerView;

        [self setAppAvaible:avaiableApps inView:_footerView];
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
                                        CGRectMake(.0, .0, 54.0 , 15.0)];
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
    sessionManager.loginDataDic = nil;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
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

- (void)executedAppAtIndex:(NSInteger)index forURLString:(NSString *)url{
    NSArray *appArr = [SessionManager sharedSessionManager].appInfoDataArr;
    
    if (index < 0) return;
    
    BOOL isAvailable = [appArr[index][@"c_available"]isEqualToString:@"true"];
    if (isAvailable) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",
                               [appArr[index][@"c_app_id"]substringWithRange:NSMakeRange(12, [appArr[index][@"c_app_id"]length] - 12)],@"://"];
        BOOL isExecuted = [SysUtils canExecuteApplication:urlString];
        
        [SysUtils applicationExecute: isExecuted ? urlString : url ];
        
    }else{
        [SysUtils showMessage:appArr[index][@"c_reason"]];
    }
}

-(void)setAppAvaible:(NSArray *)apps inView:(FooterView *) footerView{
    
    int index = 0;
    NSArray *colorImageName    = @[@"more_schedule_icon_color.png",
                                   @"more_gm_icon_color.png",
                                   @""];
    NSArray *bulrImageName     = @[@"more_schedule_icon_grey.png",
                                   @"more_gm_icon_grey.png",
                                   @""];
    UIImageView *iconImage     = nil;
    UILabel *appName           = nil;
    
    for (NSDictionary *dic in apps) {
        appName         = (UILabel *) _footerView.appNameLabel[index];
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
    switch (sender.tag) {
        case 0:
            [self executedAppAtIndex:sender.tag forURLString:@""];
            break;
        case 1:
            [self executedAppAtIndex:sender.tag forURLString:@"https://itunes.apple.com/us/app/geulinmesiji/id903283980?mt=8"];
            break;
        case 2:
            [self executedAppAtIndex:sender.tag forURLString:@""];
            break;
        case 3:
            [self executedAppAtIndex:sender.tag forURLString:@""];
            break;
    }
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
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
