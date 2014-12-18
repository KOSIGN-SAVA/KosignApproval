//
//  CustomPageControl.h
//
//  Created by germonick on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomPageControl : UIPageControl {
    
    UIImage* inactiveImage;
    UIImage* activeImage;
}

@property (nonatomic, readwrite, retain) UIImage* inactiveImage;
@property (nonatomic, readwrite, retain) UIImage* activeImage;

@end
