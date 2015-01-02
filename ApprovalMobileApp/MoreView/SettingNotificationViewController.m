//
//  SettingNotificationViewController.m
//  ApprovalMobileApp
//
//  Created by Lov Sam Ann on 12/1/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "SettingNotificationViewController.h"

#import "Constants.h"
#import "AllUtils.h"
#import "SessionManager.h"

static NSString *SOUND_NOTIFI = @"SOUND_NOTIFI";
static NSString *VIBRATION_NOTIFI = @"VIBRATION_NOTIFI";

static NSString *API_KEY      = @"APPR_SET_C101";

@interface SettingNotificationViewController ()

@property (nonatomic,strong) NSArray *cellTitle;
@property (nonatomic,strong) NSString *apiKey;

@end

@implementation SettingNotificationViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#if _DEBUG_
    NSLog(@"--> push %@", self.responsePushDictionary);
#endif

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([self.responsePushDictionary[@"PUSH_ALAM_USE_YN"]isEqualToString:@"N"]) {
        [userDefaults setObject:@"N" forKey:SOUND_NOTIFI];
        [userDefaults setObject:@"N" forKey:VIBRATION_NOTIFI];
    }
    
    
    [userDefaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.textColor  = RGB(80.0, 80.0, 80.0);
    cell.textLabel.font       = [UIFont systemFontOfSize:15.0];
    cell.textLabel.text       = self.cellTitle[indexPath.row];
    
    UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accessoryButton.frame     = CGRectMake(.0, .0, 48.0, 29.0);
    [accessoryButton setBackgroundImage:[UIImage imageNamed:@"toggle_off.png"] forState:UIControlStateNormal];
    [accessoryButton setBackgroundImage:[UIImage imageNamed:@"toggle_on.png"] forState:UIControlStateSelected];
    [accessoryButton addTarget:self action:@selector(handleButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    accessoryButton.tag       = [[NSString stringWithFormat:@"19%ld%ld",(long)indexPath.section,(long)indexPath.row]integerValue];
    
    BOOL value = [self.responsePushDictionary[@"PUSH_ALAM_USE_YN"] isEqualToString:@"Y"] ? YES : NO;
    [self configureButton:accessoryButton withBooleanValue:value];
   
    cell.accessoryView        = accessoryButton;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitle.count;
}

#pragma mark - Lazy instantiation

- (NSDictionary *)responsePushDictionary{
    if (!_responsePushDictionary) {
        _responsePushDictionary = [[NSDictionary alloc]init];
    }
    
    return _responsePushDictionary;
}

- (NSArray *)cellTitle{
    if (!_cellTitle) {
        _cellTitle = [NSArray arrayWithObjects:@"알림 수신",@"소리 알림",@"진동 알림", nil];
    }
    
    return _cellTitle;
}

#pragma mark - private methods

- (void)sendJSONDataWithAPIKey:(NSString *) api forDictionary:(NSDictionary *)reqDic {
    
    [AppUtils showWaitingSplash];
    self.view.userInteractionEnabled = NO;
    super.navigationController.view.userInteractionEnabled = NO;
#if _DEBUG_
    NSLog(@"send ---> %@",reqDic);
#endif
    [super sendTransaction:api requestDictionary:reqDic];
}

- (void)configureButton:(UIButton *)button withBooleanValue:(BOOL) value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    switch (button.tag) {
        case 1900:
            button.selected = value;
            break;
        case 1901:
            NSLog(@"cell confi %@ ---> value %@",[userDefaults objectForKey:SOUND_NOTIFI], value ? @"Y" : @"N");
            button.selected = [[userDefaults objectForKey:SOUND_NOTIFI] isEqualToString:@"Y"] ? YES : NO;
            button.enabled  = value;
            break;
        default:{
            button.selected = [[userDefaults objectForKey:VIBRATION_NOTIFI] isEqualToString:@"Y"] ? YES : NO;
            button.enabled  = value;
        }
            break;
    }
}

- (void)setNavigationBar{
    //left nav
    UIImage *image       = [UIImage imageNamed:@"top_back_btn.png"];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:
                            CGRectMake(.0, .0, image.size.width / 2, image.size.height /2)];
    
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];

    
    [leftButton addTarget:self action:@selector(handleNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag          = 1900;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

#pragma mark - handle events

- (void)handleButtonActions:(UIButton *) sender{
    sender.selected    = sender.selected ? NO : YES;

    UIButton *soundButton       = (UIButton *)[self.view viewWithTag:1901];
    UIButton *vibrationButton   = (UIButton *)[self.view viewWithTag:1902];
    
    switch (sender.tag) {
        case 1900:
            soundButton.selected    = sender.selected;
            soundButton.enabled     = sender.selected;
            vibrationButton.selected= sender.selected;
            vibrationButton.enabled = sender.selected;
            break;
        case 1901:
            soundButton.selected    = sender.selected;
            break;
        default:
            vibrationButton.selected = sender.selected;
            break;
    }
    

    
}

- (void)handleNavigationBarAction:(UIButton *) sender{
    UIButton *pushButton  = (UIButton *) [self.view viewWithTag:1900];
    UIButton *soundButton = (UIButton *) [self.view viewWithTag:1901];
    UIButton *vibrationBtn= (UIButton *) [self.view viewWithTag:1902];
    
    NSLog(@"sound button %@", soundButton.selected ? @"Y" : @"N");
    NSLog(@"vib button %@", vibrationBtn.selected ? @"Y" : @"N");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:soundButton.selected ? @"Y" : @"N" forKey:SOUND_NOTIFI];
    [userDefaults setObject:vibrationBtn.selected ? @"Y": @"N" forKey:VIBRATION_NOTIFI];
    [userDefaults synchronize];
    
    self.apiKey = API_KEY;
    
#if _DEBUG_
    NSLog(@"token %@",[[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken]);
    NSLog(@"os version %@",[NSString stringWithFormat:@"%ld",(long)[SysUtils getOSVersion]]);
    NSLog(@"udid --> %@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
#endif
    
    NSDictionary *subChildDic = @{@"USER_ID"            : [SessionManager sharedSessionManager].userID,
                                  @"PUSH_ALAM_USE_YN"   : pushButton.selected ? @"Y" : @"N",
                                  @"PUSHSERVER_KIND"    : @"APNS",
                                  @"APP_ID"             : [[NSBundle mainBundle]bundleIdentifier],
                                  @"PUSH_ID"            : [SysUtils isNull:[[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken]] ? @"" : [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken],
                                  @"MODEL_NAME"         : @"iPhone",
                                  @"OS"                 : [NSString stringWithFormat:@"%ld",(long)[SysUtils getOSVersion]],
                                  @"DEVICE_ID"          : [[[UIDevice currentDevice] identifierForVendor] UUIDString]
                                };
    [self sendJSONDataWithAPIKey:self.apiKey forDictionary:subChildDic];

}

- (void)returnTrans:(NSString *)transCode responseArray:(NSArray *)responseArray success:(BOOL)success{
    
    [AppUtils closeWaitingSplash];
    self.view.userInteractionEnabled = YES;
    super.navigationController.view.userInteractionEnabled = YES;
    
#if _DEBUG_
    NSLog(@"result --> %@",responseArray);
#endif
    
    if (success) {
        if ([self.apiKey isEqualToString:API_KEY])
            [self.navigationController popViewControllerAnimated:NO];
    }
    
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
