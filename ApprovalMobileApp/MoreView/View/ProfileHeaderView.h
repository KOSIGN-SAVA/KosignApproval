//
//  ProfileHeaderView.h
//  Bizplay
//
//  Created by Lov Sam Ann on 11/3/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@interface ProfileHeaderView : UIView

@property (weak, nonatomic) IBOutlet Circle *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UILabel *spaceLine;

@end
