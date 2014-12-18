//
//  SettingNotificationViewController.m
//  ApprovalMobileApp
//
//  Created by Lov Sam Ann on 12/1/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "SettingNotificationViewController.h"

#import "Constants.h"

@interface SettingNotificationViewController ()

@property (nonatomic,strong) NSArray *cellTitle;

@end

@implementation SettingNotificationViewController

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
    accessoryButton.tag       = [[NSString stringWithFormat:@"19%ld%ld",indexPath.section,indexPath.row]integerValue];
    
    cell.accessoryView        = accessoryButton;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitle.count;
}

#pragma mark - Lazy instantiation

- (NSArray *)cellTitle{
    if (!_cellTitle) {
        _cellTitle = [NSArray arrayWithObjects:@"알림 수신",@"소리 알림",@"진동 알림", nil];
    }
    
    return _cellTitle;
}

#pragma mark - private methods

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
}

- (void)handleNavigationBarAction:(UIButton *) sender{
    [self.navigationController popViewControllerAnimated:NO];
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
