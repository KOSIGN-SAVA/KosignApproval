//
//  Circle.m
//  Bizplay
//
//  Created by Lov Sam Ann on 10/14/14.
//  Copyright (c) 2014 webcash. All rights reserved.
//

#import "Circle.h"


@interface Circle()

@end

@implementation Circle

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.masksToBounds= YES;
    self.layer.borderWidth  = 0.0;
    
}

@end
