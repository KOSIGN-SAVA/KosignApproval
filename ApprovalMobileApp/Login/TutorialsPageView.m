//
//  TutorialsPageView.m
//  ApprovalMobileApp
//
//  Created by Lay Bunnavitou on 11/29/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "TutorialsPageView.h"

#define RGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation TutorialsPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[UIScreen mainScreen]bounds].size.height == 480){
        _BtnLoginDown.constant=15;
        return;
    }
}

#pragma mark - Action Event
#pragma mark --------------------------------------------
- (IBAction)LoginActionShare:(id)sender {
    NSDictionary *senderDic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)[sender tag]],@"tagValue", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialsPageView" object:self userInfo:senderDic];
   
}

@end
