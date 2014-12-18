//
//  ProfileHeaderView.m
//  Bizplay
//
//  Created by Lov Sam Ann on 11/3/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "ProfileHeaderView.h"

@implementation ProfileHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    
    if (self) {
        NSArray *nib =  [[NSBundle mainBundle]loadNibNamed:@"ProfileHeaderView" owner:self options:nil];
        self         = [nib lastObject];
    }
    
    return self;
}

@end
