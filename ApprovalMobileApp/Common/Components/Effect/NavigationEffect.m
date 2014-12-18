//                                  #Lighter r,g,b,a                    #Darker r,g,b,a
#define MAIN_COLOR_COMPONENTS       { 0.153, 0.306, 0.553, 1.0, 0.122, 0.247, 0.482, 1.0 }
#define LIGHT_COLOR_COMPONENTS      { 0.478, 0.573, 0.725, 1.0, 0.216, 0.357, 0.584, 1.0 }
#import <UIKit/UIKit.h>


@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
	// emulate the tint colored bar
//	CGContextRef context			= UIGraphicsGetCurrentContext();
//	CGFloat locations[2]			= {0.0, 1.0};
//	CGColorSpaceRef myColorspace	= CGColorSpaceCreateDeviceRGB();
//
//	// Top Background 
//	CGFloat topComponents[8]	= LIGHT_COLOR_COMPONENTS;
//	CGGradientRef topGradient	= CGGradientCreateWithColorComponents(myColorspace, topComponents, locations, 2);
//	CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, 0), CGPointMake(0,self.frame.size.height/2), 0);
//	CGGradientRelease(topGradient);
//
//	// Bottom Background 
//	CGFloat botComponents[8]	= MAIN_COLOR_COMPONENTS;
//	CGGradientRef botGradient	= CGGradientCreateWithColorComponents(myColorspace, botComponents, locations, 2);
//	CGContextDrawLinearGradient(context, botGradient,
//	CGPointMake(0,self.frame.size.height/2), CGPointMake(0, self.frame.size.height), 0);
//
//	CGGradientRelease(botGradient);
//	CGColorSpaceRelease(myColorspace);
//
//	// top Line 
//	CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
//	CGContextMoveToPoint(context, 0, 0);
//	CGContextAddLineToPoint(context, self.frame.size.width, 0);
//	CGContextStrokePath(context);
//

//	// bottom line
//	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
//	CGContextMoveToPoint(context, 0, self.frame.size.height);
//	CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
//	CGContextStrokePath(context);

//	UIImage *img = [UIImage imageNamed:@"z05700_a.png"];
//	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

