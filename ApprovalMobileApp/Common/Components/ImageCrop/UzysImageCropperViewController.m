//
//  UzysImageCropperViewController.m
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#import "UzysImageCropperViewController.h"
#import "UIImage-Extension.h"

@implementation UzysImageCropperViewController
@synthesize cropperView,delegate;
- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    self.navigationController.navigationBar.hidden = NO;

}

- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize
{
    self = [super init];
	
	if (self) {
        
        if(newImage.size.width <= cropSize.width || newImage.size.height <= cropSize.height)
        {
//            NSLog(@"Image Size is smaller than cropSize");
            newImage = [newImage resizedImageToFitInSize:CGSizeMake(cropSize.width*1.3, cropSize.height*1.3) scaleIfSmaller:YES];
//            NSLog(@"newImage Size %@",NSStringFromCGSize(newImage.size));
        }
        self.view.backgroundColor = [UIColor blackColor];
        cropperView = [[UzysImageCropper alloc] 
                       initWithImage:newImage 
                       andframeSize:frameSize
                       andcropSize:cropSize];
        
        [self.view addSubview:cropperView];
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
        [navigationBar setBarStyle:UIBarStyleBlack];
        [navigationBar setTranslucent:YES];
        
        UINavigationItem *aNavigationItem = [[UINavigationItem alloc] initWithTitle:@"편집하기"];
        UIImage* imgNormalRight					= [UIImage imageNamed:[SysUtils imageCodeToFileName:@"pic_close.png"]];
        UIButton* btnRightBt				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgNormalRight.size.width/2, imgNormalRight.size.height/2)];
        
        [btnRightBt setTag:kRightButtonTag];
        [btnRightBt setBackgroundImage:imgNormalRight forState:UIControlStateNormal];
        
        [btnRightBt setBackgroundImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"pic_close.png"]] forState:UIControlStateHighlighted];
        [btnRightBt addTarget:self action:@selector(cancelCropping) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* btnNewBarRight						= [[UIBarButtonItem alloc] initWithCustomView:btnRightBt];
        [aNavigationItem setRightBarButtonItem:btnNewBarRight];
        
        UIImage* imgNormal					= [UIImage imageNamed:[SysUtils imageCodeToFileName:@"pic_trance.png"]];
        UIButton* btnleftBt				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgNormal.size.width/2, imgNormal.size.height/2)];
        
        [btnleftBt setTag:kRightButtonTag];
        [btnleftBt setBackgroundImage:imgNormal forState:UIControlStateNormal];
        
        [btnleftBt setBackgroundImage:[UIImage imageNamed:[SysUtils imageCodeToFileName:@"pic_trance.png"]] forState:UIControlStateHighlighted];
        [btnleftBt addTarget:self action:@selector(actionRotation:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* btnNewBarLeft						= [[UIBarButtonItem alloc] initWithCustomView:btnleftBt];
        [aNavigationItem setLeftBarButtonItem:btnNewBarLeft];
        
        [navigationBar setItems:[NSArray arrayWithObject:aNavigationItem]];
        
        [aNavigationItem release];
        [[self view] addSubview:navigationBar];

        [navigationBar release];
        
        UIImageView *bottomBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, cropperView.frame.size.height - 75, 320, 75)];
        bottomBgImageView.backgroundColor = [UIColor blackColor];
        bottomBgImageView.userInteractionEnabled = YES;
        [self.view addSubview:bottomBgImageView];
        
        UIButton *btn_rotation = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_rotation setFrame:CGRectMake(48 , 15 , 224, 45)];
        [btn_rotation addTarget:self action:@selector(finishCropping) forControlEvents:UIControlEventTouchUpInside];
        [btn_rotation setImage:[UIImage imageNamed:@"pic_use.png"] forState:UIControlStateNormal];
        [btn_rotation setImage:[UIImage imageNamed:@"pic_use.png"] forState:UIControlStateHighlighted];
        [bottomBgImageView addSubview:btn_rotation];
    }
    
    return self;
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void) actionRestore:(id) senders
{
    [cropperView actionRestore];
}
-(void) actionRotation:(id) senders
{
    [cropperView actionRotate];
}
- (void)cancelCropping
{
	[delegate imageCropperDidCancel:self]; 
}

- (void)finishCropping
{
	//NSLog(@"%@",@"ImageCropper finish cropping end");
    UIImage *cropped =[cropperView getCroppedImage];
	[delegate imageCropper:self didFinishCroppingWithImage:cropped];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
// 
//
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.cropperView = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [cropperView release];
    [super ah_dealloc];
}
@end
