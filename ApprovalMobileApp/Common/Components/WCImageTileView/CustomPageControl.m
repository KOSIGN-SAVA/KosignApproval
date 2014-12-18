#import "CustomPageControl.h"

@implementation CustomPageControl
@synthesize inactiveImage;
@synthesize activeImage;

- (void)layoutSubviews{
	[super layoutSubviews];

}

- (void)setCurrentPage:(int)index{
    [super setCurrentPage:index];
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dotView = [self.subviews objectAtIndex:i];
        UIImageView* dot = nil;
        
        for (UIView* subview in dotView.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView*)subview;
                break;
            }
        }
        
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dotView.frame.size.width, dotView.frame.size.height)];
            [dotView addSubview:dot];
        }
        
        if (i == self.currentPage)
        {
            if(self.activeImage)
                dot.image = activeImage;
        }
        else
        {
            if (self.inactiveImage)
                dot.image = inactiveImage;
        }
    }
}

@end