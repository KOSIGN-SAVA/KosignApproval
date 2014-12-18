//
//  FooterView.h
//  Bizplay
//
//  Created by Lov Sam Ann on 11/3/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterView : UIView

//tag 1900 - 1907 - containerViews
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerView;

//tag 2900 - 2905 - icon views
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconImageView;

//tag 3900 - 3905 - download icons
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *downloadImageView;

//tag 4900 - 4905 - labels
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *appNameLabel;

//tag 0 - 5 - buttons
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonActions;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end
