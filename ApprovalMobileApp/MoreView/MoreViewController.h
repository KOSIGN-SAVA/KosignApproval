//
//  MoreViewController.h
//  ApprovalMobileApp
//
//  Created by Lov Sam Ann on 12/1/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "WCViewController.h"

@interface MoreViewController : WCViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
