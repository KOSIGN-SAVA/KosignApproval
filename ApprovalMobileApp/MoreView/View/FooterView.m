//
//  FooterView.m
//  Bizplay
//
//  Created by Lov Sam Ann on 11/3/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

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
        NSArray *nib =  [[NSBundle mainBundle]loadNibNamed:@"FooterView" owner:self options:nil];
        self         = [nib lastObject];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
