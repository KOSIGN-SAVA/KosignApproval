//
//  CustomerCenterViewController.m
//  ApprovalMobileApp
//
//  Created by Lov Sam Ann on 12/1/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "CustomerCenterViewController.h"
#import "WebStyleViewController.h"

#import "Constants.h"

@interface CustomerCenterViewController ()
@property (nonatomic,strong) NSArray *cellTitle;
@end

@implementation CustomerCenterViewController

#pragma mark - view life cycle

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text   = self.cellTitle[indexPath.row];
    
    UIImage* image                  = [UIImage imageNamed:@"more_list_next.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:
                              CGRectMake(0.0, 0.0, image.size.width / 2, image.size.height / 2)];
    imageView.image        = [UIImage imageNamed:@"more_list_next.png"];
    cell.accessoryView     = imageView;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitle.count;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView setSeparatorColor: RGBA(220.0, 220.0, 220.0, 1.0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:{
            [self pushWebViewWithURL:@""];
        }
            break;
        case 1:{
            [self pushWebViewWithURL:@""];
        }
            break;
        case 2:{
            [self pushWebViewWithURL:@""];
        }
            break;
        default:{
            [self pushWebViewWithURL:@""];
        }
            break;
    }
    
}

#pragma mark - lazy instantiation

- (NSArray *)cellTitle{
    if (!_cellTitle) {
        _cellTitle = [NSArray arrayWithObjects:@"공지사항",@"문의하기",@"도움말",@"이용약관", nil];
    }
    
    return _cellTitle;
}

#pragma mark - private methods

- (void)setNavigationBar{
    //left nav
    UIImage*image =[UIImage imageNamed:@"top_back_btn.png"];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:
                            CGRectMake(.0, .0,image.size.width / 2, image.size.height / 2)];
    
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(handleNavigationBarAction:)  forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag          = 1900;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)pushWebViewWithURL:(NSString *)urlString{
    if ([urlString isEqualToString:@""]) return;
    
    WebStyleViewController *webVC = [[WebStyleViewController alloc]initWithURL:urlString];
    [self.navigationController pushViewController:webVC animated:NO];
}

#pragma mark - handle events

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
