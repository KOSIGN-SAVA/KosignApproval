
#import "CustomUnwindSegue.h"

@implementation CustomUnwindSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    // Add view to super view temporarily
    [sourceViewController.view.superview insertSubview:destinationViewController.view atIndex:0];
    
    CGPoint originalCenter = destinationViewController.view.center;

    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         // Shrink!
                         sourceViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                         destinationViewController.view.center = originalCenter;
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [sourceViewController dismissViewControllerAnimated:NO completion:NULL]; // dismiss VC
                     }];
    
    
}

@end
